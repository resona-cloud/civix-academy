begin;

create type public.app_role as enum ('admin', 'instructor', 'reviewer', 'trainee', 'certified_agent');
create type public.profile_status as enum ('active', 'inactive', 'suspended');
create type public.cohort_status as enum ('planned', 'active', 'completed', 'archived');
create type public.cohort_member_type as enum ('instructor', 'trainee');
create type public.course_enrollment_status as enum ('assigned', 'in_progress', 'completed', 'withdrawn');
create type public.note_visibility as enum ('private', 'instructors', 'reviewers');
create type public.bookmark_target_type as enum ('lesson_page', 'fieldbook_article', 'lab_scenario');
create type public.risk_severity as enum ('low', 'medium', 'high');
create type public.risk_status as enum ('open', 'monitoring', 'resolved');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null,
  classification text,
  status public.profile_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.profile_roles (
  user_id uuid not null references public.profiles(id) on delete cascade,
  role public.app_role not null,
  granted_by uuid references auth.users(id) on delete set null,
  granted_at timestamptz not null default now(),
  primary key (user_id, role)
);

create table public.cohorts (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  program_title text not null,
  start_date date not null,
  end_date date not null,
  status public.cohort_status not null default 'planned',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint cohort_dates_valid check (end_date >= start_date)
);

create table public.cohort_members (
  cohort_id uuid not null references public.cohorts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  member_type public.cohort_member_type not null,
  joined_at timestamptz not null default now(),
  primary key (cohort_id, user_id)
);

create table public.enrollments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  course_id uuid not null references public.courses(id) on delete cascade,
  cohort_id uuid references public.cohorts(id) on delete set null,
  status public.course_enrollment_status not null default 'assigned',
  assigned_by uuid references auth.users(id) on delete set null,
  enrolled_at timestamptz not null default now(),
  completed_at timestamptz,
  updated_at timestamptz not null default now()
);

create table public.notes (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references public.profiles(id) on delete cascade,
  subject_user_id uuid references public.profiles(id) on delete cascade,
  lesson_page_id uuid references public.lesson_pages(id) on delete cascade,
  body text not null check (length(trim(body)) > 0),
  visibility public.note_visibility not null default 'private',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.bookmarks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  target_type public.bookmark_target_type not null,
  target_id uuid not null,
  label text,
  created_at timestamptz not null default now(),
  unique (user_id, target_type, target_id)
);

create table public.risk_flags (
  id uuid primary key default gen_random_uuid(),
  learner_id uuid not null references public.profiles(id) on delete cascade,
  created_by uuid not null references public.profiles(id) on delete restrict,
  category text not null,
  severity public.risk_severity not null,
  status public.risk_status not null default 'open',
  title text not null,
  description text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  resolved_at timestamptz,
  constraint resolved_risk_has_timestamp check (status <> 'resolved' or resolved_at is not null)
);

create table public.audit_events (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references public.profiles(id) on delete set null,
  event_type text not null,
  entity_type text not null,
  entity_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index profile_roles_role_idx on public.profile_roles (role);
create index cohort_members_user_id_idx on public.cohort_members (user_id);
create index enrollments_user_id_idx on public.enrollments (user_id);
create index enrollments_course_id_idx on public.enrollments (course_id);
create unique index enrollments_with_cohort_unique_idx
  on public.enrollments (user_id, course_id, cohort_id)
  where cohort_id is not null;
create unique index enrollments_without_cohort_unique_idx
  on public.enrollments (user_id, course_id)
  where cohort_id is null;
create index notes_author_id_idx on public.notes (author_id);
create index notes_subject_user_id_idx on public.notes (subject_user_id);
create index bookmarks_user_id_idx on public.bookmarks (user_id);
create index risk_flags_learner_id_idx on public.risk_flags (learner_id);
create index risk_flags_status_idx on public.risk_flags (status);
create index audit_events_actor_id_idx on public.audit_events (actor_id);
create index audit_events_entity_idx on public.audit_events (entity_type, entity_id);

create trigger profiles_set_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();
create trigger cohorts_set_updated_at before update on public.cohorts
  for each row execute function public.set_updated_at();
create trigger enrollments_set_updated_at before update on public.enrollments
  for each row execute function public.set_updated_at();
create trigger notes_set_updated_at before update on public.notes
  for each row execute function public.set_updated_at();
create trigger risk_flags_set_updated_at before update on public.risk_flags
  for each row execute function public.set_updated_at();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data ->> 'display_name', ''), split_part(coalesce(new.email, 'user'), '@', 1))
  );

  insert into public.profile_roles (user_id, role)
  values (new.id, 'trainee');
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

commit;
