# Admin role management model

Admin screens are available at `/admin`, `/admin/users`, and `/admin/users/[userId]`. They use isolated mock data and do not mutate Supabase.

The UI models:

- profile identity and active/inactive/suspended status;
- multiple `app_role` assignments per profile;
- cohort membership as instructor or trainee;
- effective permission and protected-area summaries;
- audit event previews for access changes.

All routes require an authenticated user and an admin `RoleGate`. In mock mode, the mock Elena Brooks identity includes the admin role so the screens can be evaluated.

## Future mutation boundary

Real role changes must not write directly from a browser client. Implement a server-only administrative action that:

1. verifies the caller with `requireRole(['admin'])`;
2. validates that at least one platform admin remains;
3. inserts or deletes `profile_roles` rows in a transaction;
4. records an immutable `audit_events` entry;
5. applies explicit cohort-membership changes separately;
6. returns the refreshed profile and effective permissions.

The service-role client should be used only if the operation cannot be expressed safely through admin RLS or a security-definer database function.

## First administrator

Use `database/admin-bootstrap.sql` once an Auth user exists. Follow `docs/first-production-validation.md`; the script is idempotent for the admin role and includes verification queries.
