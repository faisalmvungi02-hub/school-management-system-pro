# PLUS OS database source of truth

## Connected project

- Supabase project ref: `pfpjlenbhajynfgrdltd`
- Region: `eu-west-1`
- Git repository: `faisalmvungi02-hub/school-management-system-pro`
- Default branch: `main`

## Current inventory

The connected database reports 43 applied migrations. The ordered list is maintained in [supabase/migrations/manifest.json](../supabase/migrations/manifest.json).

The TypeScript database contract is generated from the live schema at [lib/supabase/database.types.ts](../lib/supabase/database.types.ts). Regenerate it after approved schema changes.

## Source-control limitation

Original SQL bodies for the historical migrations were not present in the repository. The manifest preserves exact version/name history but does not reconstruct SQL. A verified schema-only baseline must be obtained and tested before claiming that a fresh database can be rebuilt from this repository.

## Safety rules

- Never change production schema by guesswork.
- Keep new SQL migrations in `supabase/migrations/`.
- Do not commit credentials, secrets, Vault contents, or real student data.
- Keep service-role and secret keys server-side.
- Review RLS and grants for exposed tables.
- Run Supabase advisors after each schema migration.
