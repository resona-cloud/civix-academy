# Database

SQL is managed as ordered files in `database/migrations/`. Apply migrations in filename order using the database workflow selected by the team.

The schema is split across ordered migrations:

- `0001_content_schema.sql`: certification, course, lesson, Fieldbook, glossary, and content hierarchy
- `0002_learning_and_labs.sql`: learner progress, attempts, lab submissions, and issued certificates
- `0003_row_level_security.sql`: baseline authenticated-read and user-owned-record policies
- `0004_identity_and_operations.sql`: profiles, roles, cohorts, enrollment, notes, bookmarks, risks, and audit events
- `0005_access_control_rls.sql`: role helpers, cohort access, enrollment-aware learning access, and admin policies
- `0006_notes_and_page_progress.sql`: Fieldbook note targets and page-level visited/completed progress fields

Row-level security is enabled for every application table. Authenticated users can read published content and their own learning records. Client-side writes are intentionally excluded for scores, evaluations, content authoring, and certificate issuance.

Before production, add trusted staff policies based on verified JWT claims or a server-controlled membership table. Do not authorize staff from user-editable metadata. Service-role credentials must remain server-only and bypass RLS only in tightly scoped operations.

No seed data is included. See `docs/rls-strategy.md` before applying access policies and `docs/persistence-slice.md` for the first adapter-backed feature slice.

Before applying anything, follow `docs/migration-application-checklist.md`. The latest static findings are recorded in `docs/migration-audit.md`.
