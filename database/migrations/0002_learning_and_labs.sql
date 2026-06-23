begin;

create type public.progress_status as enum ('not_started', 'in_progress', 'completed');
create type public.attempt_status as enum ('started', 'submitted', 'passed', 'failed');
create type public.submission_status as enum ('draft', 'submitted', 'reviewed', 'passed', 'failed');
create type public.certificate_status as enum ('active', 'expired', 'revoked');

create table public.user_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  last_page_id uuid,
  status public.progress_status not null default 'not_started',
  progress_percent numeric(5,2) not null default 0 check (progress_percent between 0 and 100),
  started_at timestamptz,
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  unique (user_id, lesson_id),
  foreign key (last_page_id, lesson_id)
    references public.lesson_pages(id, lesson_id) on delete set null (last_page_id),
  constraint completed_progress_has_timestamp check (
    status <> 'completed' or completed_at is not null
  )
);

create table public.activity_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  content_block_id uuid not null references public.content_blocks(id) on delete cascade,
  attempt_number integer not null check (attempt_number > 0),
  status public.attempt_status not null default 'started',
  response jsonb not null default '{}'::jsonb,
  score numeric(8,2),
  max_score numeric(8,2) check (max_score is null or max_score >= 0),
  started_at timestamptz not null default now(),
  submitted_at timestamptz,
  unique (user_id, content_block_id, attempt_number),
  constraint activity_score_valid check (
    score is null or (score >= 0 and max_score is not null and score <= max_score)
  )
);

create table public.lab_scenarios (
  id uuid primary key default gen_random_uuid(),
  course_id uuid references public.courses(id) on delete set null,
  certification_id uuid references public.certifications(id) on delete set null,
  slug text not null unique,
  title text not null,
  description text not null default '',
  instructions jsonb not null default '{}'::jsonb,
  rubric jsonb not null default '{}'::jsonb,
  status public.content_status not null default 'draft',
  passing_score numeric(5,2) check (passing_score between 0 and 100),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.lab_submissions (
  id uuid primary key default gen_random_uuid(),
  lab_scenario_id uuid not null references public.lab_scenarios(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  attempt_number integer not null check (attempt_number > 0),
  status public.submission_status not null default 'draft',
  submission jsonb not null default '{}'::jsonb,
  evaluator_feedback jsonb,
  score numeric(5,2) check (score is null or score between 0 and 100),
  evaluated_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  submitted_at timestamptz,
  evaluated_at timestamptz,
  updated_at timestamptz not null default now(),
  unique (lab_scenario_id, user_id, attempt_number)
);

create table public.certificates (
  id uuid primary key default gen_random_uuid(),
  certification_id uuid not null references public.certifications(id) on delete restrict,
  user_id uuid not null references auth.users(id) on delete cascade,
  source_lab_submission_id uuid references public.lab_submissions(id) on delete set null,
  certificate_number text not null unique,
  status public.certificate_status not null default 'active',
  issued_at timestamptz not null default now(),
  expires_at timestamptz,
  revoked_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint certificate_dates_valid check (
    (expires_at is null or expires_at > issued_at)
    and (revoked_at is null or revoked_at >= issued_at)
  )
);

create index user_progress_user_id_idx on public.user_progress (user_id);
create index activity_attempts_user_id_idx on public.activity_attempts (user_id);
create index lab_scenarios_course_id_idx on public.lab_scenarios (course_id);
create index lab_scenarios_certification_id_idx on public.lab_scenarios (certification_id);
create index lab_submissions_user_id_idx on public.lab_submissions (user_id);
create index certificates_user_id_idx on public.certificates (user_id);
create index certificates_certification_id_idx on public.certificates (certification_id);

create trigger user_progress_set_updated_at before update on public.user_progress
  for each row execute function public.set_updated_at();
create trigger lab_scenarios_set_updated_at before update on public.lab_scenarios
  for each row execute function public.set_updated_at();
create trigger lab_submissions_set_updated_at before update on public.lab_submissions
  for each row execute function public.set_updated_at();
create trigger certificates_set_updated_at before update on public.certificates
  for each row execute function public.set_updated_at();

commit;
