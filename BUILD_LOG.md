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
- Authored the Procurement Foundations course (migration
  `0018_procurement_foundations_course.sql`, requires `0017`; **applied live**) from the eight source modules under
  `Courses/Procurement Foundations/`: 8 modules, 30 lessons, 8 module-check
  lessons (`is_check`), a 12-question cumulative review (`exam`, 80% to pass)
  plus a `quick_review` row that draws 7 of the 12 questions, and 74
  `glossary_terms` (scoped to this course via `course_id`, see `0017`). Decisions made with the
  user up front: every activity gates at 100% like Foundations (the source's
  80% module-check pass mark was a placeholder, so each check question is
  its own gating block); the source's open-ended retrieval prompts became
  one gated multiple-choice question per lesson, since the activity engine
  can only grade MCQs; **no auto-enrollment** -- enrollments are assigned
  manually, and `can_access_course()` still requires Foundations to be
  complete first (admin/zone_manager bypass unchanged); seeded as
  `published`. The course is titled "Procurement Foundations" (the source
  files say "Procurement Essentials"). Source tables are flattened into
  `rich_text` entries (no table/list renderer), the eight mermaid diagrams
  are hand-authored static SVGs, and each module's glossary table is not
  rendered as a page -- those terms went to `glossary_terms` instead. Check
  and review answer positions were rebalanced across A-D (the source skewed
  to B/C). Verified first against a stub of the content schema in PGlite
  (constraints, positions, one correct option per question, image data
  URIs).
  **Before relying on the content, re-verify** (the lessons label these as
  illustrative or "as of", but they go stale): Module 3 threshold
  illustrations (E&I Dec 2024, ELGL) and the "roughly 80%" / months-to-years
  figures; the named cooperatives in 3.4 (NASPO ValuePoint, Sourcewell,
  U.S. Communities); the sole-source/emergency, T&M, unit-price and BPA
  descriptions, which the source author flagged as not drawn from a fetched
  source; Module 6 is conduct guidance, not legal advice, and the source
  asks for counsel review of 6.3 and 6.4 plus confirmation that "offer
  nothing of value" matches company gift policy; Module 7's $15,000 /
  $350,000 thresholds (as of Oct. 1, 2025), small-business goals (CRS, July
  2026) and FAR Overhaul status. Known limits: the 12-question review pool means Quick Review repeats
  questions quickly (the source suggests growing it further), and several
  review questions closely echo module-check questions; `normalized_term`
  is still globally unique, so two courses can't define the same term;
  Study Center's "current course" logic picks the first non-completed
  enrollment, so a user enrolled in both courses sees Procurement only
  after finishing Foundations.
- Added `glossary_terms.course_id` (migration `0017_glossary_terms_course_id.sql`,
  **applied live**), closing the gap flagged under `0016`. Nullable: null
  means a shared term (Fieldbook), a set value scopes the term to a course.
  Backfills the 17 Foundations terms from `0016` by category. The read
  policy now requires `can_access_course(course_id)` for scoped terms, so
  the flashcard deck (`getFlashcards`, unchanged) only shows a course's
  terms to people who can open that course -- enforced by RLS, not the
  query. Updated `lib/database.types.ts` and `docs/data-model.md` by hand;
  `tsc --noEmit` clean.
- Applied `0017` and `0018` to the live Civix project. The project had been
  paused (INACTIVE) and was restored first. `0018` is 209 KB, too large for
  one MCP call, so it went in as nine migrations (course + Module 1, then
  one per module 2-8, then the review + glossary), each its own transaction
  and generated from the same data as the repo file. The repo keeps the
  single `0018` file as the source of truth; the live migration history has
  the nine parts instead (history was empty before, so earlier migrations
  were never tracked there either). Verified live: per-module content hashes
  (block count + md5 of every block, in order) matched the single-file run
  locally for all 8 modules, as did the assessments, questions, glossary and
  course row; 74 Procurement and 17 Foundations terms scoped, none shared;
  80 gated activities all well-formed. RLS simulated with real JWT claims
  (rolled back): a learner mid-Foundations sees 17 Foundations terms and no
  Procurement terms or course; a user who finished Foundations but isn't
  enrolled in Procurement sees none; admin sees all 74. No enrollments in
  Procurement exist yet (manual enrollment, as decided).
- Tone and copy pass on both live courses, following
  `Courses/CIVIX_Academy_Style_Guide.md` (voice, sentence rhythm, contractions
  in explanation but not in compliance lines, machine tells removed, bold and
  cross-references trimmed, takeaways and callouts as full sentences with a
  reason). Facts, legal cautions, source flags, fictional-example labels and
  correct-answer concepts were not changed.
  - **Procurement Foundations.** The eight modules were rewritten into
    `Courses/Procurement Foundations/Revised/` (originals untouched). The
    generator now reads `Revised/`, so `0018_procurement_foundations_course.sql`
    was regenerated from it and is still the single source of truth for a
    fresh install. Live: nobody was enrolled and no attempts or progress
    existed, so the course was deleted and re-seeded in nine parts (same
    structure: 8 modules, 38 lessons, 125 pages, 316 blocks, 80 gated
    activities, exam 12 / Quick Review 7, 74 scoped terms). Per-module content
    hashes match the local single-file run. The 30 per-lesson retrieval
    questions were rewritten (correct answer no longer the longest option,
    explanations give the reason), the three-column tables now flatten to
    "Label: value" lines instead of " -- ", and key positions are spread
    A to D (21/19/21/19). Table-derived lines read as reference text because
    `rich_text` has no table or list support.
  - **Resona Foundations** (4 enrolled, 2 completed, 22 activity attempts).
    `0019_foundations_copy_style_pass.sql`, applied live, is text-only and
    locates content by position or question id, so it also applies to a fresh
    seed. Block, option and term ids, page order, gating and correct answers
    are unchanged on any question a learner has answered. On the 21
    unanswered lesson questions and on the cumulative review (no attempts) the
    correct option was moved to a different letter, because 36 of 38 lesson
    answers were B; the live distribution is now a:7 b:19 c:6 d:6, still B-heavy
    because the 17 answered questions were left as they were. Glossary
    definitions were rewritten to start with the kind of thing the term is.
    The two true/false review questions are both "false" and were left alone
    because changing that means rewriting the claims.
  - **Not done.** Sales Essentials (`Courses/Sales Essentials/`) is not in
    Civix, so it was not touched. Module-check and review explanations are
    still the stub "Correct answer: ..." text; the source has no explanations.
    The style guide is Sales-specific in places (customer callout, Lena/Marco/
    Jordan, 8 questions per check, "Procurement in Practice" numbering) and
    contradicts itself in a few spots; Procurement and Foundations followed
    its voice rules and kept their own structure.
- Added the **Sales Essentials** course (migration `0020_sales_essentials_course.sql`,
  **applied live**). Source: the eight drafts in `Courses/Sales Essentials/`, rewritten
  with the style guide into `Courses/Sales Essentials/Revised/` (originals untouched; the
  generator reads `Revised/`). Same model and decisions as Procurement Foundations: 8
  modules, 40 lessons (32 lessons + 8 `is_check` module checks), 220 pages, 483 blocks,
  96 gated activities (32 per-lesson retrieval MCQs + 64 check questions, correct answers
  spread A to D evenly), one SVG (the buyer's journey), a 12-question Course-End Review
  as the exam and a 7-question Quick Review. 89 glossary terms scoped to the course. The
  course row is `published`, position 3, 293 estimated minutes. No auto-enrollment, so no
  learner can see it until someone is enrolled (and has finished Resona Foundations).
  Applied as nine migrations (`sales_essentials_part1_course_and_module1` through
  `part9_review_and_glossary`); per-module content hashes match the local single-file run.
  - **Glossary collision.** "Discovery" already exists as a Resona Foundations term and
    `normalized_term` is globally unique, so the Sales definition was skipped (89 of 90
    inserted). Sales learners see the Foundations definition of "Discovery" in the
    flashcards only if they can open Foundations, which they must have completed.
  - **Content gate.** The drafts are internal-training copy with no financial sequencing
    or competitive standing; the fixed-pricing, 365-day data and escalation rules are
    carried through verbatim in meaning and still worded as firm rules.
  - **Open items before enrolling anyone** (all from the source author's notes): a named
    role for non-standard requests; a written contact policy for calls, texts and email;
    an approved-claims list and a reviews/testimonials policy; published plan and
    promotion names; approved referrals for poor-fit customers and any referral reward
    program; and counsel review of 2.2 (privacy and retention), 3.4, 5.3, 7.3 and 8.1 to
    8.3. Several legal summaries rest on single law-firm or vendor pages and are labeled
    that way in the lessons (Cooling-Off Rule thresholds, ROSCA and click-to-cancel
    status, the 2024 reviews rule, TSR and TCPA status). The Close, Rework, HubSpot,
    DNC.com and Think Insights links were written from research notes and have not been
    checked to resolve.
  - **Known limits.** Module-check and review explanations are the stub "Correct answer:
    ..." text (the source has none). The 12-question review pool is small for a Quick
    Review of 7. `Courses/Sales Essentials/` references a "Resona Product Demo" course
    that does not exist yet (Lesson 5.4 says so).
