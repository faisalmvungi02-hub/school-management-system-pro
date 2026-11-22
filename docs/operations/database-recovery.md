# PLUS OS database backup and recovery runbook

## Current recovery status

The production project is Supabase project `pfpjlenbhajynfgrdltd` (PostgreSQL 17). The repository's catalog-derived SQL snapshot is for inspection, not the canonical recovery dump.

The original SQL bodies for the 43 historical migrations were not available in GitHub. `supabase/migrations/manifest.json` records their exact versions and names, but is not executable migration history. Do not fabricate migration SQL or replay the manifest.

## Generate a canonical schema dump

Supabase's supported CLI `db dump` command runs a Supabase-filtered `pg_dump` and excludes Supabase-managed schemas. It requires Docker and an authorized database connection string.

1. Install Docker and the Supabase CLI; verify with `supabase --version`.
2. Copy the production database connection string from Supabase Dashboard → Connect. Keep it private.
3. In a secure terminal, set `DATABASE_URL` without pasting it into Git, source files or chat.
4. Generate the schema-only dump:

```bash
supabase db dump --db-url "$DATABASE_URL" -f supabase/baseline/plus-os-schema.sql
```

5. If custom PostgreSQL roles must be exported, generate them separately:

```bash
supabase db dump --db-url "$DATABASE_URL" --role-only -f supabase/baseline/plus-os-roles.sql
```

6. Keep production data dumps outside this public repository. They may contain personal, student or financial information.
7. Review any dump for sensitive information before sharing it.

## Automated artifact workflow

The manual workflow `.github/workflows/database-schema-backup.yml` requires an Actions secret named `SUPABASE_DATABASE_URL`. A repository maintainer must add it under GitHub Settings → Secrets and variables → Actions. The workflow writes a schema dump and SHA-256 checksum as a short-lived artifact (14 days); it does not commit the dump to the public repository.

## Restore validation

Never use the live production project as a restore-test target.

1. Use a disposable Supabase test project. Creating projects may incur charges; confirm the cost before creating one.
2. Provision the required extensions and project settings. Recheck the live extension inventory before restore.
3. Restore the canonical schema and any separately approved role definitions using the supported Supabase/Postgres procedure.
4. Recreate Edge Functions, Auth settings, API keys, Vault secrets, Storage objects and Realtime publication settings separately where required.
5. Compare tables, constraints, indexes, triggers, functions, RLS policies and grants. Regenerate and compare TypeScript database types.
6. Run the scenarios in `supabase/tests/README.md`.
7. Record the test project reference, dump checksum, CLI version, restore date, evidence and known gaps. Only then mark the backup **restore-verified**.

## What the catalog snapshot does not guarantee

The catalog-derived snapshot does not contain table data, managed schemas, Auth configuration, Edge Function deployments, Vault secret values, Storage object bytes, all grants/ownership/default privileges, or a proven dependency-correct restore order. Do not use it alone for disaster recovery.

## Operational safeguards

- Never commit database URLs, passwords, API secrets, service-role keys, provider credentials or production data.
- Never run `supabase db reset` against production.
- Never apply unreviewed migrations to production.
- Keep schema, role and data backups separated.
- Retain encrypted off-site backups under a documented retention policy.
