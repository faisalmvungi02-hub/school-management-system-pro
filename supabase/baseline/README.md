# PLUS OS database recovery baseline

## Current artifact

- `2026-11-22-application-schema-snapshot.sql` is a catalog-derived snapshot of the live application's `public` and `private` schemas.
- It currently contains 75 application tables, 69 functions/procedures, 189 RLS policies and 114 non-internal triggers.
- It includes table columns/defaults, constraints, indexes, RLS flags, functions, views, policies and triggers.
- It contains no production rows or secrets.

## Important recovery status

**This file is not yet a verified, standalone restore artifact.** It was generated through database catalog introspection because the original SQL bodies for the 43 historical migrations were not present in the repository. It is not a replacement for `pg_dump --schema-only`.

The snapshot intentionally does not include:
- Supabase-managed `auth`, `storage`, `vault`, `extensions`, `realtime`, or `graphql` schemas;
- table/schema grants and ownership, custom database roles, publication/replication settings;
- extension installation/configuration, Auth settings, Edge Functions, Vault secret values or Storage object bytes;
- application seed/catalog rows such as roles, permissions and role-permission mappings;
- any school, student, staff, payment or other production data.

The live project currently has these extensions: `pg_cron`, `pg_net`, `pg_stat_statements`, `pgcrypto`, `plpgsql`, `supabase_vault`, and `uuid-ossp`. Provision required extensions through the target Supabase project's supported extension controls before testing a restore. Do not copy Vault secret values into Git.

## Required validation before production recovery

1. Obtain a real schema-only dump from the Supabase Dashboard or Supabase CLI using an authorized database connection. Keep the connection string/password out of Git and chat.
2. Restore the dump into a disposable, newly created Supabase project (never over production).
3. Recreate Supabase-specific settings and Edge Functions separately.
4. Verify object counts, constraints, indexes, grants, RLS policies, triggers, functions, extension versions and critical RPC behaviour.
5. Compare generated TypeScript database types with the restored schema.
6. Only after the restore test passes, label the artifact **restore-verified** and document the exact CLI/tool version and validation results.

## Historical migration history

`../migrations/manifest.json` preserves the exact 43 migration versions/names observed in the live project's migration history. It is an inventory, not executable SQL. Do not fabricate historical migration bodies or replay this manifest as SQL.

## Source of truth

The live Supabase project remains the current production source of truth until a complete, tested baseline and a controlled migration workflow are established.
