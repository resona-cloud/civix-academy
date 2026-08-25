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

## 2026-08-24

- Corrected Resona Foundations Lessons 1.1, 1.4, and 2.1, plus Module 1
  Check's Q1, per a re-audit of the handoff content against the live
  resonabrands.com site (migration `0012_resona_foundations_v2_corrections.sql`).
  Lesson 1.1's process narrative moved from the retired 3-phase shorthand
  (Strategy -> Architecture -> Execution) to the real 4-phase process
  (Discovery -> Architecture -> Brand & Execution -> Systemize), with the
  mission quote, diagram, and retrieval question updated to match; Lesson
  1.4 got a new product-failure-rate stats callout and a corrected "3x"
  stat (time-to-market, not decision speed); Lesson 2.1 and the Module 1
  Check question were brought in line with the same 4-phase process.
  Applied as `UPDATE`s against already-live rows (course=1, lessons=15,
  content_blocks=92, 4 enrolled users) rather than a fresh seed --
  `0011_resona_foundations_content.sql` was confirmed live in production,
  not merely present as a local file.
- Study Center domain schema (migration `0013_study_center_schema.sql`):
  new `assessments` (exam | quick_review), `assessment_questions`, and
  `assessment_attempts` tables; `courses.initial_review_interval_days` /
  `repeat_review_interval_days`; `enrollments.next_quick_review_due_at`;
  `glossary_terms.category`. Quick-review questions are sampled at attempt
  time from the course's single exam-type assessment's question pool --
  quick_review assessments own no questions of their own, enforced by a
  trigger on `assessment_questions`. `assessment_attempts` RLS mirrors the
  existing `activity_attempts` pattern: clients can insert a started
  attempt but can never self-report `score`/`passed`; grading happens
  server-side. Regenerated `lib/database.types.ts` from the live schema;
  `tsc --noEmit` is clean. Schema + RLS only -- no domain queries (progress
  aggregation, quick-review sampling, due-date recalculation) or UI wiring
  yet; Study Center's five panels are still fully mock-data-driven. The
  Resona Foundations course-end cumulative review is now unblocked as a
  real `assessments` row but was not authored in this pass (content
  authoring is out of scope for a schema handoff).
- Study Center domain queries + UI wiring: added `lib/study-center/queries.ts`
  (mirrors `lib/training/queries.ts`'s mock-fallback pattern) covering course
  progress aggregation, recommended-lesson lookup, quick-reviews-due, saved
  bookmarks (real 3-hop join for `lesson_page` targets; `fieldbook_article`/
  `lab_scenario` targets fall back to the bookmark's own label since those
  domains have no Supabase query layer built yet), flashcards from
  `glossary_terms`, and assessment display (with quick-review question
  sampling). Added `app/api/persistence/assessment-attempts/route.ts`,
  mirroring `activity-attempts`'s pattern exactly: the client echoes which
  question ids it answered, the server re-fetches and grades them, and the
  graded row is written via the service-role client (RLS blocks a client
  from ever self-reporting `score`/`passed`). Wired `/study` and
  `/study/assessments/[id]` to real data; `AssessmentRenderer` now persists
  attempts on submit.
  Filled a real gap found during this work: nothing previously rolled
  per-lesson `user_progress` completion up to `enrollments` -- added that
  rollup to `app/api/persistence/progress/route.ts` (via the existing
  `has_completed_course()` RPC), since Quick Review's `next_quick_review_due_at`
  has no trigger point without it.
  Verified: `tsc --noEmit` clean; migration/RLS behavior confirmed live
  against the real project by simulating an authenticated session in SQL
  (`set local request.jwt.claims`) -- read access, the RLS block on
  client-set `score`/`passed`, and the bookmark join all confirmed correct
  against real rows, using temporary test data that was deleted afterward.
  **Not verified**: the actual Next.js route handlers end-to-end, because
  `SUPABASE_SERVICE_ROLE_KEY` is absent from this machine's `.env.local` --
  `createServiceRoleSupabaseClient()` returns null locally, which would also
  block the pre-existing `activity-attempts` grading route the same way.
  This needs a real service-role key in the environment before the
  write/grading paths can be considered live-tested.
- `SUPABASE_SERVICE_ROLE_KEY` added to `.env.local`, unblocking the write
  paths above. Verified end-to-end through the real dev server against a
  temporary test user (removed afterward, alongside temporary test
  assessments and scratch scripts): lesson completion correctly rolls the
  enrollment to `completed` and sets `next_quick_review_due_at` at +30
  days; exam attempts grade correctly server-side (mixed-correctness
  attempt -> `score: 83.33, passed: true`, matching the hand-computed
  expected value); quick-review attempts sample from the exam's pool,
  stay ungated (`passed: null`), and reschedule the due date to +90 days,
  correctly overwriting the completion rollup's value. Also untracked
  `tsconfig.tsbuildinfo` (TypeScript's incremental-compile cache -- churns
  on every `tsc` run regardless of code changes, doesn't belong in git)
  and reverted an unrelated local `package-lock.json` lockfile-format diff
  (no dependency actually changed, just a different local npm version's
  serialization).
- Dropped "IO" from every "Resona IO" reference in the live Resona
  Foundations course, per user request (migration
  `0014_resona_io_to_resona.sql`): the course description, Module 2's
  title, and six `content_blocks` across Lessons 2.1/2.2 -- including the
  text baked into one lesson's SVG diagram. Confirmed via `ilike` sweep
  across every content table that nothing else in the live course
  mentions "Resona IO"; zero hits remain after the migration. Left the
  original v1 handoff doc under `Courses/Resona Foundations Course/`
  untouched -- it's a historical planning record, not live content.
- Authored the Resona Foundations course-end cumulative review (migration
  `0015_resona_foundations_cumulative_review.sql`), per Decision 4 from
  the Study Center handoff -- a real `exam`-type `assessments` row (80%
  to pass, 12 freshly-worded questions spanning all four modules, 13
  points) plus a `quick_review`-type row that samples 5 questions from
  that same pool at attempt time and owns none of its own. Content stays
  within the standing gate (no internal financial/competitive detail).
  Verified live: both rows and all 12 questions are readable by an
  enrolled user under real RLS. Study Center's exam/quick-review panels
  now have real content to show; flashcards still have none, since
  `glossary_terms` has zero published rows.
- Seeded 17 `glossary_terms` (migration
  `0016_resona_foundations_glossary_terms.sql`) so the flashcard panel
  has real content, grouped by category (Methodology, Values, Company &
  Products, Culture, Growth) for the panel's client-side filter. Flagged
  before seeding: `glossary_terms` has no `course_id` column -- it's a
  single shared terminology source of truth across Fieldbook and Study
  Center by design, not structurally scoped per course -- so these terms
  are course-specific in content only (drawn directly from what
  Foundations teaches), not enforced at the schema level. Worth a
  revisit if/when a second course needs its own distinct glossary.
  Verified live (17 rows, correct category counts) after retrying once
  past a transient 502 from the MCP proxy.
