# PLUS OS Platform Payment Gateway Setup

## Route
The Platform Administration credential screen is available at:

`/platform/payment-gateways`

## Frontend environment
Set these variables in the frontend deployment environment:

- `NEXT_PUBLIC_SUPABASE_URL=https://pfpjlenbhajynfgrdltd.supabase.co`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY=<project anon key>` or `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=<project publishable key>`

Never put the Supabase service-role key in any `NEXT_PUBLIC_*` variable or browser code.

## Authorize the first Platform Administrator
The Edge Function verifies the signed-in user's server-controlled Auth `app_metadata.platform_admin` claim. It does not trust user-editable `user_metadata`.

After the intended Platform Administrator has registered and signed in at least once:

1. Open Supabase Dashboard → Authentication → Users.
2. Select the exact intended administrator account.
3. Edit **App Metadata** (not User Metadata).
4. Add the boolean claim `platform_admin: true`.
5. Save, then sign out and sign in again to refresh the access token.
6. Open `/platform/payment-gateways`.

Only an operator with Supabase project Auth administration access should grant this claim. Do not grant it to school administrators.

## Enter provider credentials

- Selcom Pesa: API Key, API Secret, Vendor ID, and the HTTPS API Base URL issued for the merchant account.
- Snippe Pay: API Key and Webhook Signing Secret from the Snippe dashboard.

The screen accepts partial updates: blank fields are left unchanged. Values are written through the server-side Edge Function into Supabase Vault. The browser receives readiness booleans only, never the stored values.

## Readiness
A gateway is marked configured only when all required values are present. This status is not proof of a successful live merchant transaction. Complete provider-side callback/webhook configuration and run a controlled test payment before enabling a gateway for schools.

## Security
- Edge Function: `platform-gateway-credentials`
- Database RPC: `public.platform_manage_payment_gateway_secrets(jsonb)`
- Database RPC execution is restricted to `service_role`.
- Edge Function requires a valid Supabase user session and server-controlled `app_metadata.platform_admin === true`.
- Never send provider keys through chat, email, source code, frontend environment variables, or client logs.
