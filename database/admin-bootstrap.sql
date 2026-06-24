-- CIVIX Academy first-admin bootstrap
--
-- Run this script manually in the Supabase SQL Editor after migrations 0001-0006.
-- Replace the placeholder email below with the email of an EXISTING auth user.
-- This is an operational bootstrap script, not a migration. Run it only for an
-- explicitly approved administrator.

do $$
declare
  -- STEP 1: Replace this value before running the script.
  target_email constant text := 'REPLACE_WITH_ADMIN_EMAIL@example.com';
  target_user_id uuid;
  target_display_name text;
begin
  if target_email = 'REPLACE_WITH_ADMIN_EMAIL@example.com' then
    raise exception 'Replace target_email before running admin-bootstrap.sql';
  end if;

  -- STEP 2: Locate the existing Supabase Auth user by normalized email.
  select
    users.id,
    coalesce(
      nullif(users.raw_user_meta_data ->> 'display_name', ''),
      split_part(coalesce(users.email, 'CIVIX Admin'), '@', 1)
    )
  into target_user_id, target_display_name
  from auth.users as users
  where lower(users.email) = lower(target_email)
  order by users.created_at
  limit 1;

  if target_user_id is null then
    raise exception 'No auth.users record found for email %', target_email;
  end if;

  -- STEP 3: Upsert the public profile using the columns in the generated
  -- Database type: id, display_name, classification, status, timestamps.
  -- Existing non-empty names/classifications are preserved.
  insert into public.profiles (
    id,
    display_name,
    classification,
    status
  )
  values (
    target_user_id,
    target_display_name,
    'Platform Administrator',
    'active'
  )
  on conflict (id) do update
  set
    display_name = coalesce(nullif(public.profiles.display_name, ''), excluded.display_name),
    classification = coalesce(public.profiles.classification, excluded.classification),
    status = 'active',
    updated_at = now();

  -- STEP 4: Assign the admin role. The (user_id, role) primary key plus
  -- ON CONFLICT prevents duplicate role assignments on repeated runs.
  insert into public.profile_roles (
    user_id,
    role,
    granted_by
  )
  values (
    target_user_id,
    'admin',
    target_user_id
  )
  on conflict (user_id, role) do nothing;

  raise notice 'Admin role verified for user % (%)', target_user_id, target_email;
end;
$$;

-- STEP 5: Verification query. Expect exactly one row with role = admin and an
-- active profile. Replace the email here with the same address used above.
select
  users.id as auth_user_id,
  users.email,
  profiles.display_name,
  profiles.classification,
  profiles.status as profile_status,
  roles.role,
  roles.granted_at,
  roles.granted_by
from auth.users as users
join public.profiles as profiles on profiles.id = users.id
join public.profile_roles as roles on roles.user_id = users.id
where lower(users.email) = lower('REPLACE_WITH_ADMIN_EMAIL@example.com')
order by roles.role;

-- STEP 6: Duplicate check. Expect admin_role_count = 1.
select
  users.email,
  count(*) filter (where roles.role = 'admin') as admin_role_count
from auth.users as users
left join public.profile_roles as roles on roles.user_id = users.id
where lower(users.email) = lower('REPLACE_WITH_ADMIN_EMAIL@example.com')
group by users.email;
