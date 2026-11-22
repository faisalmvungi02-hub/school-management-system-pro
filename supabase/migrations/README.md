# Migration history and workflow

## Existing production history

The connected production database reports **43 applied migrations**. Exact versions and names are recorded in [manifest.json](./manifest.json).

**Important:** original SQL bodies for these historical migrations were not present in this repository during synchronization. The manifest is an audited inventory only. It is not executable SQL. Do not recreate SQL from migration names or replay these historical entries.

## Rules for future schema changes

1. Inspect the live schema and migration history before proposing changes.
2. Follow current Supabase documentation and the repository's Supabase security checklist.
3. Develop and test schema changes in a development/branch database where available. Do not make speculative DDL changes directly in production.
4. Create new SQL files with the Supabase CLI workflow: `supabase migration new <descriptive_name>`.
5. Review RLS, grants, SECURITY DEFINER functions, views, triggers, foreign keys, indexes, and data backfills.
6. Apply the reviewed migration to the intended environment and verify with read-only SQL checks.
7. Run Supabase security, performance, and health advisors.
8. Commit the exact SQL migration file to this repository before promoting the same change to production.
9. Never commit service-role keys, secret API keys, Vault values, personal student data, or production exports.

## Re-establishing a reproducible baseline

The live database remains the authority for the existing production schema. Before claiming that an empty database can be rebuilt, obtain a reviewed schema-only dump or verified baseline migration, compare it with the live schema, and test it against an empty development database. The manifest is not a schema dump.
