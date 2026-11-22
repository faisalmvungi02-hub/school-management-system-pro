# Phase 2 — School Onboarding & Identity Management

## Implemented in GitHub

- `app/school/onboarding/page.tsx`
  - Signs in an existing Supabase Auth user.
  - Lists that user's active school memberships through RLS.
  - Calls the existing `public.bootstrap_school(p_name, p_slug)` RPC; the database transaction creates the school, first membership, `school_owner` role and default school settings.
- `app/school/members/invite/page.tsx`
  - Lists the current user's active school memberships and database-defined roles.
  - Generates a cryptographically random one-time token in the browser and stores only its SHA-256 hash in `public.school_invitations`.
  - Uses the existing INSERT RLS policy requiring `members.manage`, correct inviter identity, pending status, future expiry and owner approval for elevated roles.
  - Creates a seven-day invitation link. The token is placed in the URL fragment (not query string) and is not persisted in the database in plaintext.
- `app/school/invitations/accept/page.tsx`
  - Reads a shared token from the URL fragment and removes it from browser history.
  - Requires sign-in and calls `public.accept_school_invitation(p_token)`.
  - The existing database function checks verified email, token hash, expiry, pending status and email match before atomically creating/reactivating membership and assigning the invited role.

## Verified database foundations

The live database already has the required core entities and RLS:
`schools`, `school_memberships`, `membership_roles`, `school_invitations`, `profiles`, `roles`, `permissions`, `role_permissions`, `districts` and `district_memberships`.

Relevant verified policies:
- Membership reads are restricted to the current user or users with `members.read`.
- School reads are restricted to members or users with `schools.read`.
- Invitation insertion requires `members.manage`; assigning `school_owner` or `school_admin` additionally requires an existing school-owner role.
- Roles are readable by authenticated users.
- The invitation acceptance implementation requires an authenticated user with a confirmed email and matches the invitation email.

No production database tables, policies, or functions were changed for this UI phase.

## Boundaries / remaining work

- Account creation and email verification remain in Supabase Auth; these pages currently sign in existing accounts rather than exposing public self-signup.
- Invitation delivery is manual: an authorized member copies the generated link and sends it using an approved channel. Automated email/WhatsApp delivery requires a configured provider and server-side delivery function.
- The existing `bootstrap_school` implementation rejects accounts that already have an active school membership. Users who already belong to a school should be invited by another school owner rather than trying to bootstrap a second school.
- The UI has been committed to GitHub but has not yet been built or exercised against a real school-owner account. Do not treat the UI flow as production-tested until typecheck/build and an end-to-end test with two test users and two test schools pass.
- The current Vercel project is not connected to GitHub auto-deploy. These commits do not automatically update the live deployment.

## Mandatory acceptance tests before production rollout

1. New verified user signs in and bootstraps a school; verify exactly one school, active membership, owner role and default settings are created.
2. A user without `members.manage` cannot issue an invitation, even if they manipulate the client.
3. A permitted owner issues a teacher invitation; only the hash is stored.
4. A different verified email cannot accept the invitation.
5. Expired, revoked, reused and malformed tokens are rejected.
6. The invited user receives only the assigned role's permissions.
7. A user from School A cannot read School B's memberships, invitations or school data.
8. Confirm no role escalation is possible by changing request payloads from the browser.
