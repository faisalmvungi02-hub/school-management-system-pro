# Database acceptance tests

These are required verification scenarios for a disposable test project. Do not execute destructive tests against production.

## School identity and tenant isolation

1. Create two verified test users, User A and User B.
2. User A bootstraps School A. Verify exactly one school, one active membership and one School Owner role are created atomically.
3. User B bootstraps School B.
4. Confirm User A cannot read School B's private records, memberships, invitations, invoices, student records or files through the Data API.
5. Confirm unauthenticated and unrelated authenticated users cannot read protected school records.
6. Confirm changing a client-supplied `school_id` cannot bypass RLS.

## Invitations

1. School A's owner issues an invitation for a new verified email with the teacher role.
2. Verify only the SHA-256 token hash is stored.
3. Verify a different email cannot accept the invitation.
4. Verify an invitation can be accepted only once (or safely idempotently, as specified by the database function).
5. Verify expired, revoked, malformed and reused invitations are rejected.
6. Verify an inviter without `members.manage` cannot create an invitation.
7. Verify role escalation to `school_owner` or `school_admin` is rejected unless the database owner-approval policy permits it.

## Payment isolation and reconciliation

1. Use provider sandbox credentials only.
2. Verify checkout requires authenticated payer access to the invoice and the school's selected active gateway.
3. Verify duplicate idempotency keys do not create duplicate checkout intents.
4. Verify invalid callback signatures, timestamps, amounts, currencies, references and order IDs are rejected.
5. Verify only a server-verified provider status can post a payment ledger entry.
6. Verify webhook retries do not double-credit an invoice.

## Backup restore

1. Restore the canonical CLI schema dump into a disposable Supabase project.
2. Verify schema object counts and generated TypeScript types.
3. Verify RLS flags and policy definitions on all exposed application tables.
4. Verify Edge Functions, Vault, Auth configuration, Storage files and Realtime settings are restored separately.
5. Save evidence and mark the dump restore-verified only after all critical checks pass.
