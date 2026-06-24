# Development

## Conventions

- Use TypeScript in strict mode.
- Prefer Server Components for data loading.
- Keep secrets server-only; only variables prefixed with `NEXT_PUBLIC_` may reach the browser.
- Add database changes as new numbered migrations instead of editing an applied migration.
- Add tests alongside features when behavior is introduced.
- Use Tailwind utilities for application styling; keep global CSS limited to shared defaults.

## Deferred from this scaffold

- Sign-up, password recovery, MFA, and administrative identity workflows
- Generated Supabase database types
- Production authorization policies
- Form handling and validation
- Testing and deployment configuration
- Tenant model and production row-level security policies

Mock mode remains supported when Supabase environment variables are absent. Feature mocks should be replaced incrementally rather than through a single global switch.
