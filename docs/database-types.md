# Database type generation

`lib/database.types.ts` is currently a hand-authored compatibility scaffold. It types the Supabase clients and the tables queried by auth, admin-foundation, notes, bookmarks, and progress code.

After migrations are applied, replace the entire file with generated types. Do not merge generated output into the scaffold manually.

## Generate on Windows

With a linked CLI project:

```powershell
npx.cmd supabase gen types typescript --linked --schema public | Set-Content -Encoding utf8 lib\database.types.ts
npm.cmd run typecheck
npm.cmd run build
```

Or generate directly from a project reference:

```powershell
$env:SUPABASE_PROJECT_REF = '<PROJECT_REF>'
npx.cmd supabase gen types typescript --project-id $env:SUPABASE_PROJECT_REF --schema public | Set-Content -Encoding utf8 lib\database.types.ts
npm.cmd run typecheck
```

Review the diff before committing. Generated `Insert` and `Update` types are stricter than the temporary scaffold and may expose missing required fields or nullable-column assumptions. Supabase reference: [generating TypeScript types](https://supabase.com/docs/guides/api/rest/generating-types).
