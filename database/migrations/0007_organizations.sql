begin;

create table public.organizations (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger organizations_set_updated_at before update on public.organizations
  for each row execute function public.set_updated_at();

insert into public.organizations (slug, name) values ('resona', 'Resona');

alter table public.organizations enable row level security;

create policy "Admins manage organizations"
  on public.organizations for all to authenticated
  using (public.has_role('admin'))
  with check (public.has_role('admin'));

-- profiles already holds a bootstrapped admin row, so the column is added
-- nullable, backfilled to the seeded organization, then locked down.
alter table public.profiles
  add column org_id uuid references public.organizations(id) on delete restrict;

update public.profiles
set org_id = (select id from public.organizations where slug = 'resona')
where org_id is null;

alter table public.profiles
  alter column org_id set not null;

create index profiles_org_id_idx on public.profiles (org_id);

create policy "Members read their organization"
  on public.organizations for select to authenticated
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
        and profiles.org_id = organizations.id
    )
  );

-- cohorts, certifications, enrollments, and certificates hold zero rows
-- today, so the column can be added directly as not null.
alter table public.cohorts
  add column org_id uuid not null references public.organizations(id) on delete restrict;
create index cohorts_org_id_idx on public.cohorts (org_id);

alter table public.certifications
  add column org_id uuid not null references public.organizations(id) on delete restrict;
create index certifications_org_id_idx on public.certifications (org_id);

alter table public.enrollments
  add column org_id uuid not null references public.organizations(id) on delete restrict;
create index enrollments_org_id_idx on public.enrollments (org_id);

alter table public.certificates
  add column org_id uuid not null references public.organizations(id) on delete restrict;
create index certificates_org_id_idx on public.certificates (org_id);

-- Keep new signups tenanted to the seeded organization until a multi-org
-- signup flow assigns org_id explicitly.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  default_org_id uuid;
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
  return new;
end;
$$;

commit;
