# Supabase Edge Functions

These source files are exact snapshots fetched from the active PLUS OS Supabase project on 2026-11-22.

| Function | Captured deployed version | Responsibility |
|---|---:|---|
| `selcom-gateway` | 7 | Selcom checkout, signed webhook verification and payment reconciliation |
| `snippe-gateway` | 3 | Snippe checkout, callback verification and payment reconciliation |
| `platform-gateway-credentials` | 9 | Platform-admin credential management using Supabase Vault |

## Deployment safeguards

- Source snapshots are tracked here, but GitHub source and deployed Supabase function versions can drift. Check the live function inventory before deployment.
- Runtime provider credentials, Supabase server keys and Vault secrets are not stored in Git.
- Never expose a service-role or secret key through a browser bundle or a `NEXT_PUBLIC_*` variable.
- The `verify_jwt = false` configuration is preserved from the deployed project. Each function must enforce its own authentication and/or provider-signature checks. Review its handler before changing this setting.
- Deploy only after reviewing the source diff, confirming required runtime secrets, and testing against provider sandbox endpoints.
