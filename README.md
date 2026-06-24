# CIVIX Academy Console

Internal training, certification, Fieldbook, and lab administration platform for GovCon Procurement Agents.

## Included

- Next.js App Router and TypeScript
- Tailwind CSS application shell
- Reusable layout and placeholder components
- Supabase-compatible PostgreSQL migration and seed SQL
- Architecture, database, and development notes in `docs/`

## Local setup

Packages are intentionally not installed by this scaffold.

1. Copy `.env.example` to `.env.local` and provide project credentials, or leave them blank to use mock mode.
2. Run `npm install` when you are ready to install dependencies.
3. Apply files in `database/migrations/` in filename order using the Supabase SQL editor or the team database workflow.
4. Run `npm run dev`.

## Routes

| Route | Purpose |
| --- | --- |
| `/` | Console overview |
| `/training` | Training content management |
| `/certifications` | Certification management |
| `/reference` | Fieldbook management |
| `/labs` | Lab and scenario management |
| `/people` | Agent and access management |
| `/reports` | Reporting |
| `/settings` | Console settings |
| `/api/health` | Basic health response |

See [docs/routes.md](docs/routes.md) for routes, [docs/supabase-setup.md](docs/supabase-setup.md) for environment setup, [docs/migration-application-checklist.md](docs/migration-application-checklist.md) before applying SQL, [docs/database-types.md](docs/database-types.md) for generated types, and [docs/first-production-validation.md](docs/first-production-validation.md) for initial admin and authentication validation.

## Current scope

This repository is a scaffold only. Authentication, Supabase clients, authorization, queries, forms, validation, tests, and deployment configuration are not implemented.

No Supabase CLI or Vercel CLI workflow is required by this scaffold.
