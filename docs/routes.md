# Routes

| Route | Responsibility |
| --- | --- |
| `/` | Operational overview |
| `/training` | Training catalog management |
| `/training/[courseId]` | Mock course detail and lesson-reader entry point |
| `/training/[courseId]/lessons/[lessonId]` | Interactive lesson reader using mock data |
| `/study` | Study Center, flashcards, recommendations, and progress |
| `/study/assessments/[assessmentId]` | Reusable mock assessment experience |
| `/certifications` | Certification tracks, levels, eligibility, and progress |
| `/certifications/[certificationId]` | Certification requirements and progress detail |
| `/reference` | Fieldbook article library |
| `/reference/[articleId]` | Fieldbook editor placeholder |
| `/labs` | Agent Lab scenario catalog and completion status |
| `/labs/[scenarioId]` | Scenario workspace, documents, tasks, and evaluation rubric |
| `/instructor` | Cohort, readiness, activity, review, and learner-risk operations |
| `/reviews` | Mixed review queue for labs, assessments, and written responses |
| `/reviews/[submissionId]` | Review assignment, scoring, feedback, and decision workspace |
| `/people` | Learner directory and progress summary |
| `/people/[personId]` | Learner profile, performance, competencies, notes, and risk |
| `/reports` | Training, certification, lab, competency, risk, and workload reporting |
| `/admin` | Admin-only access-control dashboard |
| `/admin/users` | Mock user, role, status, and cohort management |
| `/admin/users/[userId]` | Mock role assignment, cohort assignment, access, and audit detail |
| `/admin/diagnostics` | Admin-only authenticated Supabase and persistence diagnostics |
| `/login` | Cookie-backed Supabase sign-in with mock fallback |
| `/logout` | Cookie-backed browser sign-out with mock fallback |
| `/account` | Authenticated or mock current profile, roles, and permissions |
| `/settings` | Platform settings |
| `/api/health` | Basic service health response |
| `/api/persistence/notes` | Authenticated note load/save/delete boundary |
| `/api/persistence/bookmarks` | Authenticated bookmark read/toggle boundary |
| `/api/persistence/progress` | Authenticated lesson-progress read/upsert boundary |

Authentication and authorization are intentionally not implemented in this phase.
