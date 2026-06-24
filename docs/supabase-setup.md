# Supabase setup

The application now includes Supabase client factories, but feature data remains mock-backed.

## Environment variables

Copy `.env.example` to `.env.local` and provide:

| Variable | Exposure | Purpose |
| --- | --- | --- |
| `NEXT_PUBLIC_SUPABASE_URL` | Browser and server | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Browser and server | RLS-constrained anonymous/publishable access |
| `SUPABASE_SERVICE_ROLE_KEY` | Server only | Administrative operations that intentionally bypass RLS |

Never prefix the service-role key with `NEXT_PUBLIC_`, commit it, log it, or import `lib/supabase/service-role.ts` into a Client Component.

## Client utilities

- `lib/supabase/browser.ts`: singleton cookie-aware SSR browser client; returns `null` when public variables are absent
- `lib/supabase/server.ts`: cookie-aware App Router server client; returns `null` when public variables are absent
- `lib/supabase/service-role.ts`: server-only administrative client; returns `null` unless URL and service key are present

`middleware.ts` refreshes cookie sessions and protects operational routes. See `docs/ssr-auth.md` for the complete flow.

## Applying SQL

Apply files in `database/migrations/` in filename order through the Supabase SQL Editor or an explicitly adopted CLI workflow. Follow `docs/migration-application-checklist.md`; do not mix manual and CLI history without migration repair.

## Mock mode

When public Supabase variables are missing:

- client factories return `null`;
- middleware allows protected routes instead of redirecting;
- the login and logout interfaces report mock mode instead of failing;
- `/account` displays the typed mock current user;
- all existing feature areas continue using isolated mock datasets.

Adding environment variables does not automatically replace feature mocks.

Notes, bookmarks, and lesson progress are the first adapter-backed slice. See `docs/persistence-slice.md` for its authenticated API boundary and local fallback behavior.

For first-production admin and session validation, follow `docs/first-production-validation.md` and use the read-only `/admin/diagnostics` page.
