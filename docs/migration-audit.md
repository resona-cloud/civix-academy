# Migration readiness audit

Audit date: 2026-06-24.

The ordered files in `database/migrations/` are structurally ready for execution testing. The audit found no empty files, duplicate enum definitions, duplicate table definitions, or forward foreign-key references.

## Persistence alignment

| Adapter/query | Required database fields | Migration source |
| --- | --- | --- |
| Notes | author, lesson-page or Fieldbook target, body, visibility, timestamps | `0004`, extended by `0006` |
| Bookmarks | user, target type, target UUID, label, created timestamp | `0004` |
| User progress | user, lesson, last page, status, percentage, visited/completed pages, timestamps | `0002`, extended by `0006` |
| Current profile | display name, classification, status | `0004` |
| Current roles | user and `app_role` assignment | `0004` |

The temporary `lib/database.types.ts` scaffold models this active query surface. It does not claim to model every content, certification, or lab table.

## Runtime verification still required

- Execute all migrations in a disposable Supabase project.
- Confirm the target PostgreSQL version accepts the composite foreign-key delete action used by `user_progress`.
- Exercise the auth-user trigger and all security-definer helpers.
- Test RLS with distinct users rather than SQL Editor's elevated context.
- Confirm policy composition after `0005` replaces baseline course-content policies.
