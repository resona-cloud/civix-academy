# Notes, bookmarks, and progress persistence

This is the first incremental feature-persistence slice. It leaves all catalog, assessment, certification, lab, and operations data on mock sources.

## Runtime flow

Client components use typed adapters under `lib/persistence/`:

1. The adapter checks for a configured Supabase browser client and active browser session.
2. When authenticated, it sends the access token to a persistence route handler.
3. The handler verifies the token with Supabase and executes an RLS-constrained query using the anonymous key plus bearer token.
4. If configuration, authentication, or the route request is unavailable, the adapter reads or writes namespaced browser `localStorage` records.

The service-role client is not used by this slice.

## API boundary

| Route | Methods | Responsibility |
| --- | --- | --- |
| `/api/persistence/notes` | `GET`, `POST`, `DELETE` | Load, save, and delete the current user's private notes |
| `/api/persistence/bookmarks` | `GET`, `POST` | Read and toggle a bookmark |
| `/api/persistence/progress` | `GET`, `POST` | Read and upsert lesson progress |

Inputs receive simple runtime checks. Supabase authentication and RLS remain the authorization boundary.

## Table dependencies

- `notes`: private notes targeting a lesson page or Fieldbook article
- `bookmarks`: user-owned polymorphic bookmarks
- `user_progress`: aggregate lesson status, percentage, last page, visited page IDs, and completed page IDs
- `profiles`: required parent record for note and bookmark ownership
- `lesson_pages`, `fieldbook_articles`, `lessons`: content targets

Migration `0006_notes_and_page_progress.sql` adds Fieldbook note targets plus visited/completed page arrays. Arrays are a narrow first-slice design; normalize page events into a dedicated table if analytics, attempt history, or concurrent updates require it.

## Mock fallback

Local records use the `civix:persistence:` browser-storage namespace and the typed mock user ID. Fallback mode is used when:

- public Supabase variables are missing;
- no browser session exists;
- token verification fails;
- the persistence endpoint or required migration is unavailable.

Lesson Reader and Fieldbook display whether the latest operation used Supabase or local fallback. Local data is browser-specific and is not synchronized later automatically.

## Future RLS test plan

Before enabling this slice in production, test with separate admin, instructor, reviewer, trainee, and certified-agent users:

- a user can create, read, update, and delete only their own notes;
- a user can toggle only their own bookmarks;
- a user can read and update only their own progress record;
- a user cannot target unpublished or unauthorized learning content indirectly;
- an instructor cannot mutate a learner's personal notes or bookmarks;
- service-role operations are never reachable from the browser;
- malformed IDs and cross-user record IDs do not bypass ownership filters;
- concurrent progress updates do not lose completed-page state.

SSR cookie authentication is now available. Persistence adapters still send the current browser access token to their API boundary, where it is independently verified; migrating those calls to direct cookie-authenticated server actions is optional future cleanup.
