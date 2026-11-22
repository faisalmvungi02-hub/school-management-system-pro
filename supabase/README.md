# Supabase project assets

This directory contains the tracked database and server-function assets for PLUS OS.

## Directory structure

- `baseline/` — catalog-derived schema snapshot and recovery references.
- `functions/` — source snapshots of the three deployed Edge Functions.
- `migrations/` — exact applied migration inventory and safe migration workflow notes.
- `tests/` — required database acceptance scenarios.
- `config.toml` — local CLI project configuration and deployed Edge Function JWT verification settings.

## Production source of truth

The active production project is `pfpjlenbhajynfgrdltd` in `eu-west-1`, PostgreSQL 17. The live database has 43 applied migrations, but the historical SQL bodies were not available in GitHub at synchronization time.

The migration manifest is not executable SQL. Do not run `supabase db reset` or try to rebuild a new database from the manifest.

## Migration discipline

1. Inspect live schema objects and dependencies first.
2. Create a migration using `supabase migration new <descriptive_name>`.
3. Review SQL, RLS, grants, function security modes, indexes, triggers and rollback implications.
4. Test against a disposable Supabase project or branch.
5. Run database advisors and acceptance tests.
6. Apply to production only after review and explicit release approval.
7. Record the applied migration and refresh generated TypeScript database types.

## Edge Functions

Tracked source is under `functions/`. These files represent deployed snapshots captured on 2026-11-22. Runtime secrets are not stored in Git. Check live deployed versions before deploying any source snapshot.
