# PLUS OS

Progressive Learning and Unified School Operating System.

## Platform Administration — Payment Gateways

The restricted Platform Administration entry point is `/platform/login`. After the first Platform Administrator is provisioned in Supabase Auth, the credentials workspace is available at `/platform/payment-gateways`.

The workspace manages Selcom Pesa and Snippe Pay credentials through the server-side `platform-gateway-credentials` Edge Function and Supabase Vault. Provider credentials are never returned to the browser.

Read the setup and first-admin provisioning guide before using the workspace:

- [Platform Payment Gateway Setup](docs/platform-payment-gateway-setup.md)

Connection tests are read-only. A successful test does not replace a controlled live transaction and webhook verification.
