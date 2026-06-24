# Row-level security strategy

RLS is enabled on all application tables. Migration `0005_access_control_rls.sql` adds role and cohort helper functions plus the initial access policies.

## Current policy intent

- Users can read their own profile and roles.
- Users can manage notes they authored and their own bookmarks.
- Users can read their own enrollments and risk flags.
- Instructors can read learners, enrollments, and risk flags for cohorts where they are instructor members.
- Instructors can create and update risk flags for assigned learners.
- Reviewers can read lab submissions assigned through `evaluated_by`.
- Admins can read and write every current RLS-enabled application table.
- Published course content requires an active/completed enrollment or an authorized staff/certified role.
- Published Fieldbook, glossary, certification, and lab catalog content remains available to authenticated users under the earlier baseline policies.

Security-definer helper functions use an empty search path and return booleans only. The service-role key bypasses RLS and must be restricted to small, audited server-side operations.

## Deferred policies

- Assessment and short-response review access requires persistent review-assignment tables.
- Instructor/reviewer visibility into shared notes requires a finalized note-sharing model.
- Certification issuance needs server-controlled eligibility policies.
- Audit-event insertion should occur through trusted server functions rather than direct browser writes.
- Tenant/organization boundaries must be added before supporting multiple customer organizations.

Review every policy against real user journeys in a non-production project before enabling feature persistence.
