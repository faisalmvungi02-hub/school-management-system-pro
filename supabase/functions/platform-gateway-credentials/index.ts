import { createClient } from "npm:@supabase/supabase-js@2.119.2";

const corsHeaders = {
  "Access-Control-Allow-Origin": Deno.env.get("PLUS_OS_ALLOWED_ORIGIN") ?? "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Vary": "Origin",
};
const respond = (body: Record<string, unknown>, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json", "Cache-Control": "no-store" },
  });

function readDefaultKey(jsonEnvName: string, legacyEnvNames: string[]): string {
  const raw = Deno.env.get(jsonEnvName);
  if (raw) {
    try {
      const parsed = JSON.parse(raw) as Record<string, unknown>;
      if (typeof parsed.default === "string" && parsed.default.length > 0) {
        return parsed.default;
      }
    } catch {
      throw new Error("Supabase API key environment is not valid JSON.");
    }
  }
  for (const name of legacyEnvNames) {
    const value = Deno.env.get(name);
    if (value) return value;
  }
  return "";
}

const url = Deno.env.get("SUPABASE_URL");
const anonKey = readDefaultKey("SUPABASE_PUBLISHABLE_KEYS", [
  "SUPABASE_PUBLISHABLE_KEY",
  "SUPABASE_ANON_KEY",
]);
const serviceKey = readDefaultKey("SUPABASE_SECRET_KEYS", [
  "SUPABASE_SECRET_KEY",
  "SUPABASE_SERVICE_ROLE_KEY",
]);
if (!url || !anonKey || !serviceKey) throw new Error("Supabase server configuration is incomplete.");

const admin = createClient(url, serviceKey, { auth: { persistSession: false, autoRefreshToken: false } });
const allowed = new Set([
  "selcom_api_key", "selcom_api_secret", "selcom_vendor_id", "selcom_base_url",
  "snippe_api_key", "snippe_webhook_secret",
]);
const encoder = new TextEncoder();

async function authorize(req: Request) {
  const header = req.headers.get("Authorization") ?? "";
  const token = header.match(/^Bearer\s+(.+)$/i)?.[1];
  if (!token) return null;
  const userClient = createClient(url!, anonKey!, {
    global: { headers: { Authorization: "Bearer " + token } },
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data, error } = await userClient.auth.getUser(token);
  if (error || !data.user || data.user.app_metadata?.platform_admin !== true) return null;
  return data.user;
}

function base64(bytes: Uint8Array) {
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary);
}
async function digest(secret: string, value: string) {
  const key = await crypto.subtle.importKey(
    "raw", encoder.encode(secret), { name: "HMAC", hash: "SHA-256" }, false, ["sign"]
  );
  return base64(new Uint8Array(await crypto.subtle.sign("HMAC", key, encoder.encode(value))));
}

async function testSelcom() {
  const { data: cfg, error } = await admin.rpc("selcom_get_gateway_config");
  if (error || !cfg?.api_key || !cfg?.api_secret || !cfg?.base_url || !cfg?.vendor_id) {
    return { ok: false, message: "Selcom credentials are incomplete. Fill API Key, API Secret, Vendor ID and Base URL first." };
  }

  // Query today's order list: a read-only operation that does not invent an order ID or trigger a payment.
  const dateParts = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Dar_es_Salaam",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(new Date());
  const dateValues = Object.fromEntries(dateParts.map((part) => [part.type, part.value]));
  const today = dateValues.year + "-" + dateValues.month + "-" + dateValues.day;
  const fields = ["fromdate", "todate"];
  const params = { fromdate: today, todate: today };
  const timestamp = new Date().toISOString().replace(/\\.\\d{3}Z$/, "+00:00");
  const signingString = "timestamp=" + timestamp + "&fromdate=" + today + "&todate=" + today;
  const signature = await digest(String(cfg.api_secret), signingString);
  const apiKey = base64(encoder.encode(String(cfg.api_key)));
  const endpoint = new URL("/v1/checkout/list-orders", String(cfg.base_url));
  endpoint.searchParams.set("fromdate", params.fromdate);
  endpoint.searchParams.set("todate", params.todate);

  const response = await fetch(endpoint, {
    method: "GET",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: "SELCOM " + apiKey,
      "Digest-Method": "HS256",
      Digest: signature,
      Timestamp: timestamp,
      "Signed-Fields": fields.join(","),
    },
    signal: AbortSignal.timeout(12000),
  });
  const payload = await response.json().catch(() => ({}));
  const resultCode = String(payload?.resultcode ?? "");
  const result = String(payload?.result ?? "").toUpperCase();

  if (response.status === 401 || response.status === 403 || resultCode === "401" || resultCode === "403") {
    return { ok: false, message: "Selcom imekataa uthibitishaji. Kagua API Key, API Secret na merchant access." };
  }
  if (!response.ok) {
    return { ok: false, message: "Selcom API haikujibu vizuri (HTTP " + response.status + "). Kagua Base URL na merchant configuration." };
  }
  if (resultCode === "000" && result === "SUCCESS") {
    return {
      ok: true,
      message: "Selcom imekubali signed read-only request ya orodha ya oda za leo (" + today + ").",
      details: "Hakuna order, USSD push au malipo yaliyoundwa. Jaribio limethibitisha API access pekee, si settlement au live payment.",
    };
  }
  return {
    ok: false,
    message: "Selcom haikuthibitisha list-orders request. Kagua API credentials, vendor access na ruhusa za merchant.",
  };
}

async function testSnippe() {
  const { data: cfg, error } = await admin.rpc("snippe_get_gateway_config");
  if (error || !cfg?.api_key || !cfg?.webhook_secret) {
    return { ok: false, message: "Snippe credentials hazijakamilika. Weka API Key na Webhook Secret kwanza." };
  }
  const response = await fetch("https://api.snippe.sh/v1/payments?limit=1&offset=0", {
    method: "GET",
    headers: { Accept: "application/json", Authorization: "Bearer " + String(cfg.api_key) },
    signal: AbortSignal.timeout(12000),
  });
  const payload = await response.json().catch(() => ({}));
  if (response.status === 401) {
    return { ok: false, message: "Snippe imekataa API Key. Tengeneza au kagua API Key kwenye Snippe Dashboard." };
  }
  if (response.status === 403) {
    return { ok: false, message: "API Key imetambuliwa lakini haina scope ya collection:read inayohitajika kwa read-only status checks." };
  }
  if (!response.ok || String(payload?.status ?? "").toLowerCase() !== "success") {
    return { ok: false, message: "Snippe API test haikufanikiwa (HTTP " + response.status + "). Kagua mazingira na API access." };
  }
  return {
    ok: true,
    message: "Snippe API Key imekubaliwa na read-only request. Hakuna malipo yaliyoundwa.",
    details: "Webhook Secret imehifadhiwa; jaribio hili halijathibitisha webhook signature. Hakikisha webhook imewekwa kwenye Snippe Dashboard.",
  };
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "GET" && req.method !== "POST") return respond({ error: "Method not allowed." }, 405);
  try {
    const user = await authorize(req);
    if (!user) return respond({ error: "Platform administrator access is required." }, 403);

    if (req.method === "GET") {
      const { data, error } = await admin.rpc("platform_manage_payment_gateway_secrets");
      if (error) throw new Error("Could not read gateway credential status.");
      return respond({ ok: true, configured: data });
    }

    const body = await req.json().catch(() => null);
    if (!body || typeof body !== "object" || Array.isArray(body)) {
      return respond({ error: "Provide a valid request body." }, 400);
    }
    if (body.action === "test") {
      if (body.provider !== "selcom" && body.provider !== "snippe") {
        return respond({ error: "Unsupported payment provider." }, 400);
      }
      const result = body.provider === "selcom" ? await testSelcom() : await testSnippe();
      return respond({ ok: result.ok, provider: body.provider, result });
    }

    const credentials = body.credentials;
    if (!credentials || typeof credentials !== "object" || Array.isArray(credentials)) {
      return respond({ error: "Provide a credentials object." }, 400);
    }
    const entries = Object.entries(credentials as Record<string, unknown>);
    if (!entries.length) return respond({ error: "Enter at least one credential." }, 400);
    if (entries.some(([key, value]) => !allowed.has(key) || typeof value !== "string" || value.length > 4096)) {
      return respond({ error: "Credential fields are invalid." }, 400);
    }
    const normalizedCredentials = Object.fromEntries(
      entries.map(([key, value]) => [key, (value as string).trim()])
    );
    const { data, error } = await admin.rpc("platform_manage_payment_gateway_secrets", {
      p_secrets: normalizedCredentials,
    });
    if (error) throw new Error("Credentials could not be stored securely. Check the supplied values.");
    return respond({ ok: true, configured: data, message: "Credentials saved securely in Supabase Vault." });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Request could not be completed.";
    return respond({ error: message }, 400);
  }
});
