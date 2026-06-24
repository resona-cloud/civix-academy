# Authentication and roles

Authentication UI is available at `/login`, `/logout`, and `/account`. Email/password sign-in uses cookie-backed Supabase SSR clients when configured. Middleware enforces sessions on operational routes. Password recovery and broader identity lifecycle screens are not active yet.

New Supabase users receive a `profiles` row and the `trainee` role through the `handle_new_user` database trigger.

## Role matrix

| Capability | Admin | Instructor | Reviewer | Trainee | Certified agent |
| --- | --- | --- | --- | --- | --- |
| Platform and user administration | Yes | No | No | No | No |
| Learning-content management | Yes | Yes | No | No | No |
| Cohort management | Yes | Yes | No | No | No |
| Assigned learner visibility | Yes | Yes | No | No | No |
| Submission review | Yes | No | Yes | No | No |
| Operational reports | Yes | Yes | Yes | No | No |
| Learning, Fieldbook, and labs | Yes | Yes | Yes | Yes | Yes |
| Own account/profile | Yes | Yes | Yes | Yes | Yes |

Application roles and permission mappings live under `lib/auth/`. UI guards improve presentation but are not a security boundary; database RLS and server authorization must enforce access.

The current mock account is Elena Brooks with `admin`, `instructor`, and `reviewer` roles so the admin-only mock screens remain testable without Supabase configuration.

Server helpers in `lib/auth/session.ts` expose `getCurrentSession`, `getCurrentProfile`, `getCurrentUserRoles`, `requireAuth`, and `requireRole`. Reusable `AuthGate`, `RoleGate`, and `PermissionNotice` components provide presentation-level route shells.
