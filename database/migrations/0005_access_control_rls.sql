begin;

create or replace function public.has_role(required_role public.app_role)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.profile_roles
    where user_id = auth.uid() and role = required_role
  );
$$;

create or replace function public.is_cohort_member(target_cohort_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.cohort_members
    where cohort_id = target_cohort_id and user_id = auth.uid()
  );
$$;

create or replace function public.instructor_can_access_learner(target_learner_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select public.has_role('instructor') and exists (
    select 1
    from public.cohort_members instructor_membership
    join public.cohort_members learner_membership
      on learner_membership.cohort_id = instructor_membership.cohort_id
    where instructor_membership.user_id = auth.uid()
      and instructor_membership.member_type = 'instructor'
      and learner_membership.user_id = target_learner_id
      and learner_membership.member_type = 'trainee'
  );
$$;

create or replace function public.can_access_course(target_course_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    public.has_role('admin')
    or public.has_role('instructor')
    or public.has_role('reviewer')
    or public.has_role('certified_agent')
    or exists (
      select 1 from public.enrollments
      where user_id = auth.uid()
        and course_id = target_course_id
        and status in ('assigned', 'in_progress', 'completed')
    );
$$;

alter table public.profiles enable row level security;
alter table public.profile_roles enable row level security;
alter table public.cohorts enable row level security;
alter table public.cohort_members enable row level security;
alter table public.enrollments enable row level security;
alter table public.notes enable row level security;
alter table public.bookmarks enable row level security;
alter table public.risk_flags enable row level security;
alter table public.audit_events enable row level security;

create policy "Users read their own profile"
  on public.profiles for select to authenticated
  using (id = auth.uid());

create policy "Instructors read assigned cohort learners"
  on public.profiles for select to authenticated
  using (public.instructor_can_access_learner(id));

create policy "Users read their own roles"
  on public.profile_roles for select to authenticated
  using (user_id = auth.uid());

create policy "Members read their cohorts"
  on public.cohorts for select to authenticated
  using (public.is_cohort_member(id));

create policy "Members read cohort membership"
  on public.cohort_members for select to authenticated
  using (public.is_cohort_member(cohort_id));

create policy "Users read their enrollments"
  on public.enrollments for select to authenticated
  using (user_id = auth.uid());

create policy "Instructors read assigned learner enrollments"
  on public.enrollments for select to authenticated
  using (public.instructor_can_access_learner(user_id));

create policy "Users manage their own notes"
  on public.notes for all to authenticated
  using (author_id = auth.uid())
  with check (author_id = auth.uid());

create policy "Users manage their own bookmarks"
  on public.bookmarks for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "Learners read their risk flags"
  on public.risk_flags for select to authenticated
  using (learner_id = auth.uid());

create policy "Instructors read assigned learner risk flags"
  on public.risk_flags for select to authenticated
  using (public.instructor_can_access_learner(learner_id));

create policy "Instructors create assigned learner risk flags"
  on public.risk_flags for insert to authenticated
  with check (
    created_by = auth.uid()
    and public.instructor_can_access_learner(learner_id)
  );

create policy "Instructors update assigned learner risk flags"
  on public.risk_flags for update to authenticated
  using (public.instructor_can_access_learner(learner_id))
  with check (public.instructor_can_access_learner(learner_id));

create policy "Reviewers read assigned lab submissions"
  on public.lab_submissions for select to authenticated
  using (
    public.has_role('reviewer')
    and evaluated_by = auth.uid()
  );

-- Replace the broad authenticated course policy with enrollment/role-aware access.
drop policy if exists "Authenticated users can read published courses" on public.courses;
create policy "Authorized users read published courses"
  on public.courses for select to authenticated
  using (status = 'published' and public.can_access_course(id));

drop policy if exists "Authenticated users can read published course modules" on public.modules;
create policy "Authorized users read published course modules"
  on public.modules for select to authenticated
  using (
    exists (
      select 1 from public.courses
      where courses.id = modules.course_id
        and courses.status = 'published'
        and public.can_access_course(courses.id)
    )
  );

drop policy if exists "Authenticated users can read published course lessons" on public.lessons;
create policy "Authorized users read published course lessons"
  on public.lessons for select to authenticated
  using (
    exists (
      select 1 from public.modules
      join public.courses on courses.id = modules.course_id
      where modules.id = lessons.module_id
        and courses.status = 'published'
        and public.can_access_course(courses.id)
    )
  );

drop policy if exists "Authenticated users can read published lesson pages" on public.lesson_pages;
create policy "Authorized users read published lesson pages"
  on public.lesson_pages for select to authenticated
  using (
    exists (
      select 1 from public.lessons
      join public.modules on modules.id = lessons.module_id
      join public.courses on courses.id = modules.course_id
      where lessons.id = lesson_pages.lesson_id
        and courses.status = 'published'
        and public.can_access_course(courses.id)
    )
  );

drop policy if exists "Authenticated users can read published content blocks" on public.content_blocks;
create policy "Authorized users read published content blocks"
  on public.content_blocks for select to authenticated
  using (
    exists (
      select 1 from public.fieldbook_articles
      where fieldbook_articles.id = content_blocks.fieldbook_article_id
        and fieldbook_articles.status = 'published'
    )
    or exists (
      select 1 from public.lesson_pages
      join public.lessons on lessons.id = lesson_pages.lesson_id
      join public.modules on modules.id = lessons.module_id
      join public.courses on courses.id = modules.course_id
      where lesson_pages.id = content_blocks.lesson_page_id
        and courses.status = 'published'
        and public.can_access_course(courses.id)
    )
  );

-- Admins receive full access to all current application tables. Keep this list
-- updated when new RLS-enabled tables are introduced.
do $$
declare
  target_table text;
begin
  foreach target_table in array array[
    'certifications', 'courses', 'modules', 'lessons', 'lesson_pages',
    'content_blocks', 'fieldbook_articles', 'glossary_terms', 'user_progress',
    'activity_attempts', 'lab_scenarios', 'lab_submissions', 'certificates',
    'profiles', 'profile_roles', 'cohorts', 'cohort_members', 'enrollments',
    'notes', 'bookmarks', 'risk_flags', 'audit_events'
  ]
  loop
    execute format(
      'create policy %I on public.%I for all to authenticated using (public.has_role(''admin'')) with check (public.has_role(''admin''))',
      'Admins manage ' || target_table,
      target_table
    );
  end loop;
end;
$$;

-- TODO: add reviewer policies for assessment/short-response review tables after
-- those tables gain reviewer_id assignment columns.
-- TODO: add instructor note visibility policies after note-sharing rules are
-- finalized; current users can manage only notes they authored.

commit;
