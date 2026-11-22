# PLUS OS application-schema snapshot

`2026-11-22-application-schema-snapshot.sql` is a catalog-derived snapshot of the live application's `public` and `private` schemas. It is retained for inspection and comparison only.

**It is not a canonical Supabase CLI dump and has not been restore-verified.** It may not preserve every PostgreSQL/Supabase object detail, ownership, grants, default privileges, extension setup, managed-schema customization, sequence state or project configuration.

Use the [database recovery runbook](../../docs/operations/database-recovery.md) to generate a canonical Supabase-filtered `supabase db dump` using the authorized database connection. The manual workflow writes a short-lived artifact, not a public commit.

Never place production data, student records, financial records, database passwords, API keys or Vault secrets in this public repository.
