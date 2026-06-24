# First-production authentication validation

Use this checklist after migrations are applied, generated types are current, and the deployment has Supabase public environment variables.

## Create the first admin

1. In the Supabase dashboard, open **Authentication > Users**.
2. Create or identify the user that will become the first administrator. The bootstrap script does not create Auth users.
3. Confirm the user's email is verified and copy the exact email address.
4. Open `database/admin-bootstrap.sql` locally.
5. Find and replace every occurrence of `REPLACE_WITH_ADMIN_EMAIL@example.com` with the approved email.
6. Review the script. It reads `auth.users`, upserts `public.profiles`, and inserts `public.profile_roles` with `ON CONFLICT DO NOTHING`.
7. Open the Supabase SQL Editor and paste the entire script.
8. Run it once. Confirm the notice identifies the expected UUID and email.
9. Inspect both verification query results. The profile must be active and `admin_role_count` must equal `1`.
10. Keep the edited email out of version control. Restore the placeholder if the repository file was edited directly.

The script is intentionally outside `database/migrations/`. It is an environment-specific operational action and must not be included in migration history.

## Validate the first login

1. Confirm Vercel has `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` for the active environment, then redeploy if either changed.
2. Confirm the deployment URL is allowed by the Supabase Auth URL configuration.
3. Open `/logout` once to clear stale browser cookies.
4. Sign in at `/login` with the bootstrapped Auth user.
5. Confirm redirect to `/account` or the originally requested protected route.
6. On `/account`, verify:
   - the mode banner says `SUPABASE MODE`;
   - user ID matches `auth.users.id`;
   - email and provider are correct;
   - session status is active;
   - profile name/classification are database-backed;
   - Administrator appears in roles.
7. Open `/admin`. The admin RoleGate should allow access.
8. Open `/admin/diagnostics` and run the checks described below.
9. Open a private browser session without signing in and confirm `/admin`, `/account`, `/people`, `/reviews`, `/reports`, and `/settings` redirect to `/login`.
10. Confirm public routes such as `/training`, `/study`, `/reference`, and `/labs` remain available.

## Diagnostics page

`/admin/diagnostics` is protected by middleware, `AuthGate`, and `RoleGate(['admin'])`. It runs read-only queries through the current cookie-backed, RLS-constrained user.

Expected production results:

| Check | Expected result |
| --- | --- |
| Supabase configured | Yes |
| Auth session | Active |
| Current user ID | Auth UUID |
| Database connectivity | Pass |
| Profile lookup | Pass, one matching profile |
| Role lookup | Pass, at least one role including admin |
| Notes adapter | Pass, zero or more owned rows |
| Bookmarks adapter | Pass, zero or more owned rows |
| Progress adapter | Pass, zero or more owned rows |

In local mock mode, configuration says No, session says Mock mode, and database checks are skipped. Diagnostics never use the service-role key and do not write records.

## Common setup failures

### Supabase configured: No

- Public variables are missing from the running environment.
- Vercel variables were added without a new deployment.
- Variable names do not exactly match `.env.example`.

### Login succeeds but protected routes redirect

- Browser cookies are blocked or stale; sign out, clear site data, and sign in again.
- Supabase Auth Site URL or redirect URLs do not include the deployment origin.
- Middleware is not included in the deployed build.

### Profile lookup fails

- `0004_identity_and_operations.sql` was not applied.
- The Auth user predates the profile trigger and the bootstrap script was not run.
- The profile UUID does not match `auth.users.id`.

### Role lookup returns zero roles

- The bootstrap script used the wrong email.
- The admin insert failed or was run against a different project.
- `profile_roles` RLS or the `Users read their own roles` policy is missing.

### Admin page shows Access restricted

- `/account` does not list Administrator.
- The current session belongs to a different Auth user.
- Generated types or application environment point to a different Supabase project.

### Notes, bookmarks, or progress fail

- `0006_notes_and_page_progress.sql` was not applied.
- Earlier RLS migrations are missing.
- The authenticated user lacks a matching profile required by note/bookmark foreign keys.
- The page is testing a record owned by another user.

### Database connectivity fails

- URL or anonymous key targets the wrong project.
- PostgREST cannot see the public schema.
- RLS policy setup is incomplete.
- The Supabase project is paused or unavailable.

After validation, record the deployment URL, project reference, user UUID, date, commit SHA, and diagnostic outcomes in the release record. Do not record passwords, access tokens, or service-role keys.
