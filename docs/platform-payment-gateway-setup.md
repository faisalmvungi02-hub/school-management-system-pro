# PLUS OS Platform Payment Gateway Setup

## Route
The Platform Administration credential screen is available at:

`/platform/payment-gateways`

## Frontend environment
The frontend is a Next.js 16 application. Use Node.js 20.9 or newer (CI is set to Node.js 24). Configure these variables in the frontend deployment environment:

- `NEXT_PUBLIC_SUPABASE_URL=https://pfpjlenbhajynfgrdltd.supabase.co`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY=<project anon key>` or `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=<project publishable key>`

Never put the Supabase service-role key in any `NEXT_PUBLIC_*` variable or browser code.

## Authorize the first Platform Administrator
The Edge Function verifies the signed-in user's server-controlled Auth `app_metadata.platform_admin` claim. It does not trust user-editable `user_metadata`.

There is currently no Auth user in this Supabase project, so the initial Platform Administrator account must be created first:

1. Open Supabase Dashboard → Authentication → Users.
2. Choose **Add user** and create the account with the owner's intended email and a strong password (or send an invite).
3. Open the newly created user record.
4. Edit **App Metadata** (not User Metadata).
5. Add the boolean claim `platform_admin: true`.
6. Save, then sign in through `/platform/login` to obtain a fresh access token.
7. Open `/platform/payment-gateways`.

Only an operator with Supabase project Auth administration access should grant this claim. Do not grant it to school administrators.

## Enter provider credentials

- Selcom Pesa: API Key, API Secret, Vendor ID, and the HTTPS API Base URL issued for the merchant account.
- Snippe Pay: API Key and Webhook Signing Secret from the Snippe dashboard.

The screen accepts partial updates: blank fields are left unchanged. Values are written through the server-side Edge Function into Supabase Vault. The browser receives readiness booleans only, never the stored values.

## Test connection

Each provider card includes a **Test connection** action. It sends a read-only API request; it does not initiate a customer payment, create an order, or send a USSD push.

- Selcom: signs and calls `GET /v1/checkout/list-orders?fromdate=YYYY-MM-DD&todate=YYYY-MM-DD` for the current date in Tanzania. This checks API authentication and order-list access. It does not create an order, trigger USSD, or charge a customer, and it does not prove settlement readiness.
- Snippe: calls `GET /v1/payments?limit=1&offset=0`. The API key must have the `collection:read` scope. This checks API authentication and read access only. The Webhook Signing Secret is stored securely but cannot be proven against the provider using this read-only request.

A successful connection test is not a live-payment certification. Confirm the callback/webhook URL in each provider dashboard and perform a controlled test transaction before turning the gateway on for schools.

Provider references:
- Selcom authentication and list orders: https://developers.selcommobile.com/
- Snippe authentication and payment endpoints: https://docs.snippe.sh/docs/2026-01-25/authentication and https://docs.snippe.sh/docs/2026-01-25/payments

## Readiness
A gateway is marked configured only when all required values are present. This status is not proof of a successful live merchant transaction. Complete provider-side callback/webhook configuration and run a controlled test payment before enabling a gateway for schools.

## Build validation
GitHub Actions runs ESLint, TypeScript type-checking and a Next.js production build for pushes and pull requests targeting `main`. The CI job uses an ephemeral npm lockfile for that run; no generated lockfile is committed yet.

## Security
- Edge Function: `platform-gateway-credentials`
- Database RPC: `public.platform_manage_payment_gateway_secrets(jsonb)`
- Database RPC execution is restricted to `service_role`.
- Edge Function requires a valid Supabase user session and server-controlled `app_metadata.platform_admin === true`.
- Never send provider keys through chat, email, source code, frontend environment variables, or client logs.
