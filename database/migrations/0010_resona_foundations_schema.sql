begin;

-- Module-check lessons are modeled as ordinary lessons (same schema, same nav,
-- same content_blocks) with this flag set, rather than a separate table --
-- avoids fragile position-based inference for "does this lesson gate the
-- next module" and keeps the training query layer untouched in shape.
alter table public.lessons add column is_check boolean not null default false;

-- True iff every lesson in the given course has a 'completed' user_progress
-- row for the current user. Used to gate access to every course other than
-- Resona Foundations until Foundations is fully complete.
create or replace function public.has_completed_course(p_course_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select not exists (
    select 1
    from public.lessons l
    join public.modules m on m.id = l.module_id
    where m.course_id = p_course_id
      and not exists (
        select 1 from public.user_progress up
        where up.lesson_id = l.id
          and up.user_id = auth.uid()
          and up.status = 'completed'
      )
  );
$$;

-- Resona Foundations remains reachable via ordinary enrollment. Every other
-- course additionally requires Foundations to be fully complete first. If
-- Foundations doesn't exist yet (this migration runs before the content seed
-- migration that creates it), the foundations-completed check degrades to
-- "true" and access falls back to plain enrollment -- the same behavior as
-- before this migration, not a new gap.
create or replace function public.can_access_course(target_course_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    public.has_role('admin')
    or public.has_role('zone_manager')
    or (
      exists (
        select 1 from public.enrollments
        where user_id = auth.uid()
          and course_id = target_course_id
          and status in ('assigned', 'in_progress', 'completed')
      )
      and (
        target_course_id = (select id from public.courses where slug = 'resona-foundations')
        or public.has_completed_course((select id from public.courses where slug = 'resona-foundations'))
      )
    );
$$;

-- Auto-enroll every new signup in Resona Foundations. If Foundations doesn't
-- exist yet, this is a no-op guard (foundations_course_id is null) rather
-- than an error -- the content-seed migration backfills existing profiles
-- once the course row exists.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  default_org_id uuid;
  foundations_course_id uuid;
begin
  select id into default_org_id
  from public.organizations
  where slug = 'resona';

  insert into public.profiles (id, org_id, display_name)
  values (
    new.id,
    default_org_id,
    coalesce(nullif(new.raw_user_meta_data ->> 'display_name', ''), split_part(coalesce(new.email, 'user'), '@', 1))
  );

  insert into public.profile_roles (user_id, role)
  values (new.id, 'trainee');

  select id into foundations_course_id
  from public.courses
  where slug = 'resona-foundations';

  if foundations_course_id is not null then
    insert into public.enrollments (user_id, course_id, org_id, status)
    values (new.id, foundations_course_id, default_org_id, 'assigned')
    on conflict do nothing;
  end if;

  return new;
end;
$$;

commit;
