# SSR authentication shell

The application uses `@supabase/ssr` for cookie-backed browser and App Router server clients. Middleware refreshes expired sessions and protects selected route prefixes.

## Auth flow

1. `/login` creates a browser client and calls `signInWithPassword`.
2. The SSR browser client writes the Supabase session to cookies.
3. Middleware calls `auth.getUser()` on application requests, refreshing cookies when required.
4. Protected routes redirect unauthenticated users to `/login?next=<original-path>`.
5. Server Components load the verified user, profile, and roles through `lib/auth/session.ts`.
6. `/logout` calls browser `signOut()`, clears the cookie-backed session, and returns to `/login`.

The service-role key is not involved in login, middleware, profile loading, or route protection.

## Protected routes

- `/account`
- `/instructor`
- `/reviews` and nested review routes
- `/people` and nested profile routes
- `/reports`
- `/settings`

The following remain public for this phase: `/`, `/login`, `/training`, `/study`, `/certifications`, `/reference`, and `/labs`.

Middleware enforces authentication only. `RoleGate` components apply the current UI role matrix inside protected operational pages. RLS remains the data-security boundary.

## Mock mode

If either public Supabase environment variable is missing:

- middleware does not redirect;
- protected routes remain accessible for local development;
- profile helpers return the typed mock instructor/reviewer;
- login and logout clearly report mock behavior;
- existing local persistence fallback continues to work.

Mock fallback is enabled only by missing configuration, not by an invalid or expired session. When Supabase is configured, an absent session redirects protected routes to login.

## Testing with Supabase

1. Apply migrations `0001` through `0006` in order to a non-production project.
2. Configure `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` in `.env.local` and the deployment environment.
3. Create a test user from the Supabase dashboard. The auth trigger should create its profile and default `trainee` role.
4. Assign additional roles directly in `profile_roles` using a trusted administrative workflow.
5. Start the app and sign in at `/login`.
6. Verify `/account` loads the database profile and roles.
7. Open each protected route with trainee, instructor, reviewer, and admin test accounts and confirm the UI gate.
8. Remove or expire the session and verify middleware redirects while preserving the `next` path.
9. Confirm public learning routes remain accessible.
10. Run the RLS test plan in `docs/rls-strategy.md` separately; UI route protection is not a substitute.

For remote deployments, configure the same public variables in Vercel and ensure the Supabase project allows the deployment URL in its auth URL settings.

## Known limitations

- Sign-up, password recovery, MFA, OAuth, and email-confirmation UX are not implemented.
- Middleware checks authentication but not database roles.
- Role gates are presentation controls; server mutations still require explicit authorization and RLS.
- The app header initials remain a static shell; the account page is the authoritative current-user display.
- Profile and role edits do not yet have an administrative UI.
- No generated Supabase `Database` type is wired into clients yet.
- Mock users and feature datasets are not replaced by SSR authentication.
- Next.js may emit an Edge-runtime compatibility warning from the current Supabase dependency bundle during middleware builds; the middleware build succeeds and uses the supported public `@supabase/ssr` API.
