# PLUS OS Supabase

Database source-control documentation for PLUS OS.

- [migrations/manifest.json](./migrations/manifest.json): exact migration versions and names recorded by the connected production project.
- [migrations/README.md](./migrations/README.md): safe workflow for future migrations.

Historical SQL bodies were not present in GitHub during this synchronization. The manifest is deliberately non-executable and does not fabricate SQL. All future schema changes must be reviewed SQL migration files committed here.


## Recovery baseline

- [Application schema snapshot](./baseline/2026-11-22-application-schema-snapshot.sql)
- [Baseline scope and restore-validation checklist](./baseline/README.md)

The snapshot is catalog-derived and is not restore-verified. Follow the baseline README before using it for recovery.

## School onboarding

See [Phase 2 implementation and acceptance tests](../docs/phase-2-school-onboarding.md).
