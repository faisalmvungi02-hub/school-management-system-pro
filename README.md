# PLUS OS

**Progressive Learning and Unified School Operating System**

PLUS OS is a multi-school education operating system built around role-specific workspaces for students, teachers, school leadership, finance and operations.

## Repository structure

```text
app/                         Next.js routes, layouts and page entry points
src/
  components/                Shared React UI components
  lib/                       Shared client-side utilities and domain helpers
supabase/
  baseline/                   Database schema snapshots and recovery references
  functions/                  Tracked Supabase Edge Function source
  migrations/                 Migration inventory and safe migration workflow
  tests/                      Database security and acceptance scenarios
docs/
  architecture/               Architecture and source-of-truth records
  implementation/             Phase delivery records
  operations/                 Payment, deployment and recovery runbooks
.github/workflows/            CI and manual database backup workflows
```

## Local development

Requirements: Node.js 24+, npm, and local environment values.

```bash
cp .env.example .env.local
npm install
npm run dev
```

Set the Supabase URL and publishable key in `.env.local`. Never place service-role/secret keys in `NEXT_PUBLIC_*` variables or browser code.

## Quality checks

```bash
npm run lint
npm run typecheck
npm run build
```

GitHub Actions runs these checks for pushes and pull requests. Merge only after all required checks pass.

## Current implementation status

- Platform administration and payment-gateway credential management exist in the current application routes.
- Selcom, Snippe and platform credential Edge Function source snapshots are tracked under `supabase/functions/`.
- School onboarding, member invitations and invitation acceptance UI are present under `app/school/`; see the [Phase 2 delivery record](docs/implementation/phase-2-school-onboarding.md).
- The student dashboard and settings are still an early UI shell containing sample content. They are not fully connected to school academic records and must not be treated as production data.
- Payment providers remain unconfigured until valid credentials are securely provisioned in Supabase Vault. No live payment is enabled by this documentation.

## Database recovery

Read the [database recovery runbook](docs/operations/database-recovery.md) before any backup or restore.

The historical 43 migration SQL bodies were not present in GitHub. The manifest is an inventory, not executable migration history. The catalog-derived schema snapshot is not restore-verified. A canonical Supabase CLI dump and successful restore test in a disposable project are still required.

A manual [schema backup workflow](.github/workflows/database-schema-backup.yml) is available. It requires the GitHub Actions secret `SUPABASE_DATABASE_URL`; the generated dump is retained as a short-lived workflow artifact and is not committed to this public repository.

## Project documentation

- [Database architecture and source of truth](docs/architecture/database-source-of-truth.md)
- [School role and permission model](docs/architecture/role-permission-model.md)
- [Database recovery runbook](docs/operations/database-recovery.md)
- [Payment gateway setup](docs/operations/platform-payment-gateway-setup.md)
- [Phase 2 — School Onboarding](docs/implementation/phase-2-school-onboarding.md)
- [Supabase Edge Functions](supabase/functions/README.md)
- [Database acceptance tests](supabase/tests/README.md)

## Security rules

- Enforce school tenant isolation with Supabase Row Level Security.
- Keep provider secrets and privileged operations on trusted server-side functions.
- Never commit database URLs, passwords, API keys, student data or financial records.
- Require reviewed migrations, successful CI and test-project verification before production deployment.
