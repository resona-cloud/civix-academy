# Data model

This is the proposed baseline model. The SQL migrations are the executable source of truth after they have been reviewed and applied.

## Identity

- `auth.users`: Supabase-managed identity referenced by learner-owned records

## Training

- `certifications`: credential definition, passing score, and validity period
- `courses`: top-level training offering, optionally associated with a certification
- `modules`: ordered groups within a course
- `lessons`: ordered units within a module
- `lesson_pages`: ordered pages within a lesson
- `content_blocks`: ordered structured content belonging to one lesson page or Fieldbook article
- `user_progress`: learner progress and last page for a lesson
- `activity_attempts`: learner submissions for activity content blocks

## Certification

- `certificates`: issued, expiring, or revoked learner credentials

## Fieldbook

- `fieldbook_articles`: searchable operational articles and job aids
- `glossary_terms`: published procurement vocabulary and definitions

## Labs

- `lab_scenarios`: scenario, rubric, publishing state, and passing score
- `lab_submissions`: learner response, evaluator feedback, and score

## Deferred decisions

- Organization or tenant boundaries
- Exact staff and agent role matrix
- Course-to-certification requirement mapping
- Reference content versioning and attachments
- Lab rubric and evaluator model
- Audit history and retention requirements
- Production RLS policies
