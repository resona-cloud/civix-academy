# Build log

Checkpoint record of completed work, for tracking builds and merge points.

## 2026-07-29

- Added `organizations` table, seeded with Resona; added `org_id` tenancy
  columns to `profiles`, `cohorts`, `certifications`, `enrollments`, and
  `certificates` (migration `0007_organizations.sql`).
- Replaced the generic training-platform role vocabulary
  (`instructor`/`reviewer`/`certified_agent`) with Resona's real org roles:
  `zone_manager`, `sales_rep`, `sourcing_operator`, `developer`, `founder`
  (`admin` and `trainee` unchanged). `zone_manager` now holds the
  cohort-lead and lab-review capabilities (migrations `0008_org_roles.sql`,
  `0009_org_roles_policies.sql`).
- Fixed the account header avatar rendering a hardcoded "EB" regardless of
  the signed-in user; it now shows the real current user's initials.
- Genericized mock course/certification/lab/fieldbook catalog content and
  demo users (Elena Brooks et al. -> Admin User / Learner A-D / Team Lead
  A-B) to remove the inherited GovCon/procurement framing. Deep lesson/lab
  body prose intentionally left for a later real-content pass.
- Confirmed via diagnostics: no domain has been cut over from mock data to
  real Supabase queries yet (only auth/session, notes/bookmarks/progress,
  and admin diagnostics are Supabase-backed). Courses, certifications,
  labs, fieldbook, admin user management, and instructor-ops remain
  mock-data-driven.
