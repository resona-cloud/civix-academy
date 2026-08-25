begin;

-- Study Center domain schema: assessments (exam + quick_review), their
-- questions, and attempt records; plus the columns needed to schedule Quick
-- Review due dates and to let the flashcard panel read from glossary_terms.
--
-- Quick-review sampling: quick_review-type assessments do NOT own their own
-- assessment_questions rows. Every question belongs to the course's single
-- exam-type assessment (enforced below by a trigger); a quick_review attempt
-- samples `question_count` random rows from that pool at attempt time. This
-- avoids a join table and matches "no separately authored quick-review
-- question set" from the handoff.
--
-- assessments.status reuses content_status (draft/published/archived) --
-- the same authoring lifecycle already used for lab_scenarios, which is the
-- closest existing analog (an assessable content type, not a lesson).

create type public.assessment_type as enum ('exam', 'quick_review');
create type public.question_type as enum (
  'multiple_choice', 'multiple_select', 'true_false', 'matching', 'ordering', 'fill_blank', 'short_response'
);

create table public.assessments (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  assessment_type public.assessment_type not null,
  title text not null,
  passing_score numeric(5,2) check (passing_score is null or passing_score between 0 and 100),
  question_count integer not null default 5 check (question_count > 0),
  status public.content_status not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  -- Standing rule: course exams pass at 80+, and must declare a threshold.
  -- Quick reviews are ungated, so passing_score is left null for them.
  constraint exam_requires_passing_score check (
    assessment_type <> 'exam' or passing_score is not null
  ),
  unique (course_id, assessment_type)
);

create table public.assessment_questions (
  id uuid primary key default gen_random_uuid(),
  assessment_id uuid not null references public.assessments(id) on delete cascade,
  question_type public.question_type not null,
  prompt text not null,
  explanation text not null default '',
  points integer not null default 1 check (points > 0),
  position integer not null check (position > 0),
  -- Type-specific fields (options/correct_option_id, correct_option_ids,
  -- correct_answer, pairs, items/correct_order, accepted_answers/
  -- case_sensitive, sample_answer/scoring_keywords) live here, mirroring the
  -- AssessmentQuestion union in lib/learning-engine/types.ts exactly -- same
  -- polymorphic-jsonb approach already used for content_blocks.content.
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (assessment_id, position),
  constraint assessment_questions_data_shape check (
    case question_type
      when 'multiple_choice' then data ? 'options' and data ? 'correct_option_id'
      when 'multiple_select' then data ? 'options' and data ? 'correct_option_ids'
      when 'true_false' then data ? 'correct_answer'
      when 'matching' then data ? 'pairs'
      when 'ordering' then data ? 'items' and data ? 'correct_order'
      when 'fill_blank' then data ? 'accepted_answers' and data ? 'case_sensitive'
      when 'short_response' then data ? 'sample_answer' and data ? 'scoring_keywords'
      else false
    end
  )
);

create or replace function public.enforce_questions_on_exam_assessments()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if (select assessment_type from public.assessments where id = new.assessment_id) <> 'exam' then
    raise exception 'assessment_questions.assessment_id must reference an exam-type assessment -- quick_review assessments sample from the course''s exam question pool rather than owning questions';
  end if;
  return new;
end;
$$;

create trigger assessment_questions_require_exam_parent
  before insert or update of assessment_id on public.assessment_questions
  for each row execute function public.enforce_questions_on_exam_assessments();

create table public.assessment_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  assessment_id uuid not null references public.assessments(id) on delete cascade,
  attempt_number integer not null check (attempt_number > 0),
  responses jsonb not null default '{}'::jsonb,
  score numeric(5,2) check (score is null or score between 0 and 100),
  -- Exam attempts: gated at 80%+ (passed derived from assessments.passing_score).
  -- Quick review attempts: ungated -- passed is left null; the value is the
  -- retrieval attempt itself, not the score.
  passed boolean,
  started_at timestamptz not null default now(),
  submitted_at timestamptz,
  unique (user_id, assessment_id, attempt_number)
);

create index assessments_course_id_idx on public.assessments (course_id);
create index assessment_questions_assessment_id_idx on public.assessment_questions (assessment_id);
create index assessment_attempts_user_id_idx on public.assessment_attempts (user_id);
create index assessment_attempts_assessment_id_idx on public.assessment_attempts (assessment_id);

create trigger assessments_set_updated_at before update on public.assessments
  for each row execute function public.set_updated_at();
create trigger assessment_questions_set_updated_at before update on public.assessment_questions
  for each row execute function public.set_updated_at();

-- ------------------------------------------------------------------------
-- courses: admin-configurable Quick Review scheduling intervals.
-- ------------------------------------------------------------------------

alter table public.courses
  add column initial_review_interval_days integer not null default 30 check (initial_review_interval_days > 0),
  add column repeat_review_interval_days integer not null default 90 check (repeat_review_interval_days > 0);

-- ------------------------------------------------------------------------
-- enrollments: the single scheduling mechanism for Quick Review due dates.
-- Set to completed_at + initial_review_interval_days on course completion;
-- recalculated to (quick_review submission time) + repeat_review_interval_days
-- every time a quick_review assessment_attempt is submitted for that course.
-- Application-layer concern -- no trigger here, since it depends on reading
-- the course's interval columns and the attempt's assessment_type.
-- ------------------------------------------------------------------------

alter table public.enrollments
  add column next_quick_review_due_at timestamptz;

create index enrollments_next_quick_review_due_at_idx
  on public.enrollments (next_quick_review_due_at)
  where next_quick_review_due_at is not null;

-- ------------------------------------------------------------------------
-- glossary_terms: optional category, for the flashcard panel's filter.
-- Nullable text, matching the existing fieldbook_articles.category column
-- shape rather than inventing a new convention.
-- ------------------------------------------------------------------------

alter table public.glossary_terms add column category text;

-- ------------------------------------------------------------------------
-- RLS
-- ------------------------------------------------------------------------

alter table public.assessments enable row level security;
alter table public.assessment_questions enable row level security;
alter table public.assessment_attempts enable row level security;

-- Read access follows the same published + course-access gate already used
-- for content_blocks. Assessment questions (including correct answers) are
-- exposed to an authorized client the same way lesson-activity questions
-- already are via content_blocks -- grading is authoritative server-side
-- regardless (see the assessment_attempts INSERT policy below), so this
-- doesn't introduce a new trust boundary.
create policy "Authorized users read published assessments"
  on public.assessments for select to authenticated
  using (status = 'published' and public.can_access_course(course_id));

create policy "Authorized users read published assessment questions"
  on public.assessment_questions for select to authenticated
  using (
    exists (
      select 1 from public.assessments
      where assessments.id = assessment_questions.assessment_id
        and assessments.status = 'published'
        and public.can_access_course(assessments.course_id)
    )
  );

create policy "Users can read their own assessment attempts"
  on public.assessment_attempts for select to authenticated
  using (auth.uid() = user_id);

-- Mirrors the activity_attempts INSERT policy pattern: a client can start an
-- attempt but can never self-report score/pass/submission -- the graded,
-- submitted row is written by a service-role client from server-computed
-- results, exactly like POST /api/persistence/activity-attempts already does.
create policy "Users can create their own assessment attempts"
  on public.assessment_attempts for insert to authenticated
  with check (
    auth.uid() = user_id
    and score is null
    and passed is null
    and submitted_at is null
  );

-- courses.initial_review_interval_days / repeat_review_interval_days need no
-- new policy -- the existing "Admins manage courses" FOR ALL policy (from
-- the 0005 admin-management loop) already covers every column on the row,
-- and no non-admin UPDATE policy exists on courses for it to leak through.

do $$
declare
  target_table text;
begin
  foreach target_table in array array['assessments', 'assessment_questions', 'assessment_attempts']
  loop
    execute format(
      'create policy %I on public.%I for all to authenticated using (public.has_role(''admin'')) with check (public.has_role(''admin''))',
      'Admins manage ' || target_table,
      target_table
    );
  end loop;
end;
$$;

commit;
