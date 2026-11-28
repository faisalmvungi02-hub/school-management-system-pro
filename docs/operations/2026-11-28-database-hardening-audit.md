# PLUS OS production database hardening — 2026-11-28

## Scope
Live Supabase project: `pfpjlenbhajynfgrdltd` (PostgreSQL 17.11, eu-west-1).
Repository: `faisalmvungi02-hub/school-management-system-pro`.

This is an evidence-based audit. PASS is used only where directly verified. NOT VERIFIED is not a pass.

## Verified production facts
- 43 migrations are recorded in the live Supabase migration history.
- 73 public application tables were returned by the live catalog check; all 75 public/private application tables inspected had RLS enabled.
- 189 RLS policies were counted in the inspected application schemas.
- 164 unique indexes were counted.
- `pg_stat_statements` 1.11, `pg_cron` 1.6.4, `pg_net` 0.20.4 and Vault are installed.
- PgBouncer logs show backend connections being opened and TLS 1.3 established through the pooler.
- Two scheduled payment reconciliation jobs are present.
- Payment gateway reconciliation functions and audit capture functions exist; the reconciliation RPCs are SECURITY DEFINER and must remain tightly permissioned.
- Supabase health advisor returned no health lints.
- `ANALYZE;` was executed successfully to refresh planner statistics.
- Most PLUS OS business tables currently have zero estimated live rows. Roles (15), permissions (59), role_permissions (252) and profiles (1) contain the current notable live rows.

## Findings and honest status

| Area | Status | Evidence / action |
|---|---|---|
| Index inventory | REVIEW | 99 unused-index advisor notices. Most business tables are empty; do not drop these indexes before real workload measurements. |
| Slow-query visibility | PASS (instrumentation) | pg_stat_statements is installed. Current top query load is largely Supabase catalog introspection; application workload is too small to establish production latency. |
| Query planner stats | PASS | ANALYZE completed. |
| Connection pooling | PASS (database pooler) | PgBouncer logs show pooled server connections and TLS 1.3. Application runtime connection-string usage still requires repository/runtime verification. |
| Cache | NOT VERIFIED | No confirmed application cache layer found in this audit. |
| Rate limiting | NOT VERIFIED | No confirmed end-to-end API rate-limit tests. |
| Background queue | NOT VERIFIED | pgmq is available in the extension catalogue but is not installed; no production queue consumer was verified. |
| Partitioning | NOT REQUIRED YET / NOT IMPLEMENTED | Application tables have negligible live data. Partitioning now would add complexity without a measurable benefit. Reassess at growth thresholds. |
| Read replicas | NOT VERIFIED | No replica configuration/traffic routing evidence was available. |
| Transactions | PARTIAL PASS | Transactional onboarding and payment reconciliation routines exist; acceptance tests are still required. |
| Idempotency | PARTIAL PASS | Unique constraints and checkout/reconciliation safeguards exist; duplicate callback/retry tests are still required. |
| Audit logs | PASS (objects exist) | Audit tables and capture functions exist. Retention and immutable audit tests remain. |
| Backup restore | NOT VERIFIED | A catalog-derived schema snapshot exists, but is not a canonical dump and has not been restored. |
| Migration reproducibility | FAIL | The live database has 43 historical migration records; repository has the manifest and schema snapshot, not the original executable SQL bodies. |

## Safe action completed
- Ran `ANALYZE;` on the live database. No schema or user rows were changed.
- No indexes were dropped.
- No partitioning was introduced because the current data volume does not justify it.
- No production credentials, secrets, or student/financial data were exported.

## Required release gates
1. Create a Supabase development branch (hourly charge applies), restore/validate a canonical schema dump, and run acceptance tests there.
2. Add `SUPABASE_DATABASE_URL` as a GitHub Actions secret; run the existing schema-backup workflow and verify its artifact/checksum.
3. Export a canonical Supabase-filtered schema dump using the Supabase CLI. Keep it as a restricted artifact, not in the public repository.
4. Recover the historical SQL migration bodies from the original trusted source if available. Do not fabricate SQL from names or treat the catalog snapshot as the original migration history.
5. Add and test app-layer caching and rate limiting in the API/Edge Functions; introduce a queue only with a real worker and retry/dead-letter handling.
6. Reassess partitioning and read replicas using measured table growth, p95/p99 latency, connection pressure and query plans.

## Decision
The live database is not declared fully production-hardened. This report deliberately does not label unimplemented or unverified capabilities as PASS.
