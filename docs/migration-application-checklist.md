# Migration application checklist

Do not apply these migrations automatically from the application or a production deployment. Use a non-production Supabase project first and choose one initial application workflow: SQL Editor or Supabase CLI.

## Audited migration order

| Order | File | Depends on |
| --- | --- | --- |
| 1 | `0001_content_schema.sql` | Supabase `auth` schema; `pgcrypto` extension |
| 2 | `0002_learning_and_labs.sql` | Content, certification, course, lesson, page, and block tables from `0001` |
| 3 | `0003_row_level_security.sql` | All tables from `0001` and `0002` |
| 4 | `0004_identity_and_operations.sql` | Courses and lesson pages from `0001`; shared timestamp trigger from `0001`; Supabase `auth.users` |
| 5 | `0005_access_control_rls.sql` | Tables and role enums from `0004`; learning/lab tables from `0001`-`0002`; baseline policies from `0003` |
| 6 | `0006_notes_and_page_progress.sql` | Notes from `0004`; Fieldbook articles from `0001`; user progress from `0002` |

Audit results:

- Six migration files are present and non-empty.
- Filename ordering matches dependency ordering.
- Fifteen enum definitions are unique.
- Twenty-two table definitions are unique.
- Every `public` foreign key references a table created earlier or earlier in the same migration.
- `auth.users` references target the Supabase-managed auth schema.
- Notes, bookmarks, and progress columns match the current persistence API and type scaffold after `0006`.
- No migration has been applied or executed by this audit.

Live PostgreSQL syntax, trigger, and policy behavior still requires execution in a disposable Supabase project. Local `psql` was unavailable during the repository audit.

## Before either workflow

- [ ] Create or select a non-production Supabase project.
- [ ] Record the project reference and region.
- [ ] Confirm the target project does not already contain conflicting application enums or tables.
- [ ] Export or back up any existing target data.
- [ ] Review every migration, especially security-definer functions and RLS policies.
- [ ] Confirm all six files are committed and unchanged after review.
- [ ] Choose exactly one initial migration-history workflow below.

## Browser workflow: Supabase SQL Editor

Use this when no CLI is available and the team accepts manually tracking the initial application.

1. Open the Supabase dashboard for the non-production project.
2. Open **SQL Editor** and create a new query.
3. Open `database/migrations/0001_content_schema.sql` locally.
4. Paste the entire file, including `begin;` and `commit;`, into the query.
5. Run it once and confirm the editor reports success.
6. Repeat steps 3-5 for `0002` through `0006`, strictly in filename order. Use a new SQL Editor query for each file.
7. Stop immediately on any error. Do not continue to later files or rerun a partially successful sequence without inspecting the target schema.
8. Run the verification queries below.
9. Test sign-in, automatic profile creation, role lookup, and each RLS role using dedicated test accounts.
10. Record the project, date, operator, commit SHA, and applied filenames in the deployment record.

The SQL Editor does not automatically make these repository files part of the Supabase CLI migration ledger. Do not later run `db push` for the same migrations unless their CLI versions are explicitly marked applied with `migration repair`.

## Windows workflow: Supabase CLI

The CLI is not currently installed by this project. On Windows, use the local npm package and `.cmd` shims to avoid PowerShell execution-policy issues. Docker is required only for local Supabase services, not for linking and pushing to a hosted project.

```powershell
npm.cmd install --save-dev supabase
npx.cmd supabase init
New-Item -ItemType Directory -Force supabase\migrations
Copy-Item database\migrations\0001_content_schema.sql supabase\migrations\20260624000100_content_schema.sql
Copy-Item database\migrations\0002_learning_and_labs.sql supabase\migrations\20260624000200_learning_and_labs.sql
Copy-Item database\migrations\0003_row_level_security.sql supabase\migrations\20260624000300_row_level_security.sql
Copy-Item database\migrations\0004_identity_and_operations.sql supabase\migrations\20260624000400_identity_and_operations.sql
Copy-Item database\migrations\0005_access_control_rls.sql supabase\migrations\20260624000500_access_control_rls.sql
Copy-Item database\migrations\0006_notes_and_page_progress.sql supabase\migrations\20260624000600_notes_and_page_progress.sql
npx.cmd supabase login
npx.cmd supabase link --project-ref <PROJECT_REF>
npx.cmd supabase db push --dry-run
npx.cmd supabase db push
npx.cmd supabase migration list
```

The timestamped files under `supabase/migrations/` become the CLI migration source of truth. Do not maintain two editable copies indefinitely; after adopting CLI, document and enforce which directory is canonical.

If the same SQL was already applied manually, stage the timestamped files but mark each version applied before any `db push`:

```powershell
npx.cmd supabase migration repair 20260624000100 --status applied
npx.cmd supabase migration repair 20260624000200 --status applied
npx.cmd supabase migration repair 20260624000300 --status applied
npx.cmd supabase migration repair 20260624000400 --status applied
npx.cmd supabase migration repair 20260624000500 --status applied
npx.cmd supabase migration repair 20260624000600 --status applied
npx.cmd supabase migration list
```

Inspect the migration list before pushing anything else. Supabase CLI guidance: [CLI getting started](https://supabase.com/docs/guides/local-development/cli/getting-started) and [database migrations](https://supabase.com/docs/guides/deployment/database-migrations).

## Verification queries

Run these in SQL Editor after all six migrations succeed:

```sql
select table_name
from information_schema.tables
where table_schema = 'public'
order by table_name;

select typname
from pg_type
where typnamespace = 'public'::regnamespace
  and typtype = 'e'
order by typname;

select schemaname, tablename, policyname, cmd
from pg_policies
where schemaname = 'public'
order by tablename, policyname;

select event_object_table, trigger_name
from information_schema.triggers
where trigger_schema in ('public', 'auth')
order by event_object_table, trigger_name;
```

- [ ] Required tables exist.
- [ ] RLS is enabled on every application table.
- [ ] Baseline and access-control policies exist without duplicate names.
- [ ] Creating an Auth user creates a profile and default trainee role.
- [ ] A trainee can access only enrolled published course content.
- [ ] Notes, bookmarks, and progress ownership policies reject cross-user access.
- [ ] Instructor cohort access and reviewer assignment access behave as documented.
- [ ] Admin policies work using an explicitly assigned admin test role.
- [ ] Service-role keys remain server-only.
