# Phase 3 — Unified Authentication & Role-Aware Workspace Entry

## Implemented in this branch

- One Supabase Auth identity flow for every school and district user.
- /login authenticates with email/password.
- /register creates an Auth identity and sends email confirmation. The user cannot select their own school role. When registration starts from an invitation link, the invitation token is preserved through email verification so the new account can complete acceptance.
- /forgot-password and /auth/reset-password implement password recovery.
- /auth/confirmed checks whether a session is available after email verification.
- /workspace verifies the signed-in user through Supabase Auth, then reads active school memberships, district memberships, assigned roles and permission codes through the user's RLS-scoped client.
- Platform administrators are routed using the server-managed app_metadata.platform_admin claim, separate from school roles.
- The workspace does not grant access based on a role name or browser-supplied user ID. Memberships and role assignments come from the database.
- The old static student dashboard is preserved at /preview/student; the public root route now provides the unified entry point.

## Live database contract checked before implementation

- profiles is linked to auth.users by its primary key.
- The on_auth_user_created_plus_os trigger calls private.handle_new_auth_user() when a new Auth user is created.
- School membership, membership-role, district membership, role, role-permission and permission tables already exist.
- RLS is enabled on these tables. The browser client uses only the public publishable/anon key; no service-role secret is included.
- The live database currently has one Auth user and one profile, but zero schools, school memberships, membership roles and invitations.

## Required Supabase Auth configuration

In Supabase Dashboard → Authentication → URL Configuration:
- Set Site URL to the production application origin.
- Add the production /auth/confirmed and /auth/reset-password URLs to the allowed redirect URLs.
- Add localhost development URLs only if local development is required.
- Confirm email/password sign-up is enabled and email delivery is suitable for the expected user volume.

## Security and rollout boundaries

- The role is never selected at sign-up. A school owner or authorized administrator assigns a role through the invitation flow.
- The browser uses a publishable key only. Never expose service-role keys in NEXT_PUBLIC variables.
- RLS remains the security boundary for all school and district records. Client-side route checks are usability controls, not authorization.
- This branch must pass ESLint, TypeScript and Next.js production build before merge.
- Production deployment must be completed and checked separately; a GitHub merge alone does not update the existing Vercel project because auto-deploy is not connected.
- End-to-end acceptance still requires a new verified test account, a school-owner bootstrap, an invited second account, and a cross-school isolation test.
