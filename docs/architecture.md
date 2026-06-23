# Architecture

CIVIX Academy Console is an internal administration surface for training, certification, the Fieldbook, and scenario labs used by GovCon Procurement Agents. It uses the Next.js App Router, TypeScript, Tailwind CSS, Supabase, and Vercel.

## Boundaries

- `app/`: pages, layouts, loading/error states, and route handlers
- `components/`: reusable presentational and feature components
- `lib/`: database clients, queries, authorization helpers, and shared utilities
- `database/`: ordered, manually applied Supabase-compatible SQL migrations and development seed data
- `docs/`: decisions, setup instructions, and product notes

## Initial assumptions

- Supabase provides PostgreSQL and authentication. No CLI workflow is assumed.
- Authorization is enforced with database row-level security, not only in the UI.
- Server Components are the default; Client Components should be introduced only for interaction.
- Vercel hosts the application. Deployment configuration is intentionally deferred.

## Product domains

- Training: courses, modules, lessons, enrollment, and progress
- Certification: credential definitions, requirements, awards, and expiration
- Fieldbook: searchable operational guides and job aids
- Labs: procurement scenarios, submissions, evaluation, and scoring
- Administration: people, roles, reporting, and platform settings
