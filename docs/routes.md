# Routes

| Route | Responsibility |
| --- | --- |
| `/` | Operational overview |
| `/training` | Training catalog management |
| `/training/[courseId]` | Mock course detail and lesson-reader entry point |
| `/training/[courseId]/lessons/[lessonId]` | Interactive lesson reader using mock data |
| `/certifications` | Certification management |
| `/certifications/[certificationId]` | Certification editor placeholder |
| `/reference` | Fieldbook article library |
| `/reference/[articleId]` | Fieldbook editor placeholder |
| `/labs` | Lab and scenario management |
| `/labs/[scenarioId]` | Lab scenario editor placeholder |
| `/people` | Agent profiles, roles, and enrollment |
| `/reports` | Readiness and completion reporting |
| `/settings` | Platform settings |
| `/api/health` | Basic service health response |

Authentication and authorization are intentionally not implemented in this phase.
