import { createClient } from "npm:@supabase/supabase-js@2.119.2";

type Json = Record<string, unknown>;
const corsHeaders = {
  "Access-Control-Allow-Origin": Deno.env.get("PLUS_OS_ALLOWED_ORIGIN") ?? "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type, idempotency-key",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Vary": "Origin",
};
const json = (body: Json, status = 200) => new Response(JSON.stringify(body), {
  status, headers: { ...corsHeaders, "Content-Type": "application/json", "Cache-Control": "no-store" },
});
const enc = new TextEncoder();
const decoder = new TextDecoder();

function b64(bytes: Uint8Array): string {
  let binary = "";
  for (const b of bytes) binary += String.fromCharCode(b);
  return btoa(binary);
}
function b64text(value: string): string { return b64(enc.encode(value)); }
function safeEqual(a: string, b: string): boolean {
  const aa = enc.encode(a), bb = enc.encode(b);
  if (aa.length !== bb.length) return false;
  let diff = 0;
  for (let i = 0; i < aa.length; i++) diff |= aa[i] ^ bb[i];
  return diff === 0;
}
function validTimestamp(value: string): boolean {
  const time = Date.parse(value);
  return Number.isFinite(time) && Math.abs(Date.now() - time) <= 5 * 60 * 1000;
}
function normaliseTzPhone(value: string): string | null {
  const digits = value.replace(/[^0-9]/g, "");
  let n = digits;
  if (n.startsWith("0")) n = "255" + n.slice(1);
  if (n.startsWith("255") && n.length === 12) return n;
  return null;
}
function clean(value: unknown, max = 160): string {
  return typeof value === "string" ? value.trim().slice(0, max) : "";
}
function asObject(value: unknown): Json {
  return value && typeof value === "object" && !Array.isArray(value) ? value as Json : {};
}
function amountNumber(value: unknown): number | null {
  const n = typeof value === "number" ? value : Number(value);
  return Number.isFinite(n) && n > 0 && Number.isInteger(n) ? n : null;
}
async function hmac(secret: string, message: string): Promise<string> {
  const key = await crypto.subtle.importKey("raw", enc.encode(secret), { name: "HMAC", hash: "SHA-256" }, false, ["sign"]);
  return b64(new Uint8Array(await crypto.subtle.sign("HMAC", key, enc.encode(message))));
}
function signingString(timestamp: string, fields: string[], body: Json): string {
  const pairs = fields.map((field) => {
    if (!(field in body) || body[field] === null || body[field] === undefined) {
      throw new Error("Signed field missing: " + field);
    }
    return field + "=" + String(body[field]);
  });
  return "timestamp=" + timestamp + "&" + pairs.join("&");
}
async function selcomHeaders(apiKey: string, secret: string, fields: string[], body: Json) {
  const timestamp = new Date().toISOString().replace(/\.\d{3}Z$/, "+00:00");
  const digest = await hmac(secret, signingString(timestamp, fields, body));
  return {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "SELCOM " + b64text(apiKey),
    "Digest-Method": "HS256",
    "Digest": digest,
    "Timestamp": timestamp,
    "Signed-Fields": fields.join(","),
  };
}
async function selcomGet(base: string, path: string, params: Json, apiKey: string, secret: string) {
  const fields = Object.keys(params);
  const headers = await selcomHeaders(apiKey, secret, fields, params);
  const url = new URL(path, base);
  for (const [k, v] of Object.entries(params)) url.searchParams.set(k, String(v));
  const response = await fetch(url, { method: "GET", headers, signal: AbortSignal.timeout(12000) });
  const data = await response.json().catch(() => ({}));
  if (!response.ok) throw new Error("Selcom status API returned HTTP " + response.status);
  return asObject(data);
}
async function selcomPost(base: string, path: string, body: Json, fields: string[], apiKey: string, secret: string) {
  const headers = await selcomHeaders(apiKey, secret, fields, body);
  const response = await fetch(new URL(path, base), {
    method: "POST", headers, body: JSON.stringify(body), signal: AbortSignal.timeout(15000),
  });
  const data = await response.json().catch(() => ({}));
  if (!response.ok) throw new Error("Selcom checkout API returned HTTP " + response.status);
  return asObject(data);
}
function resultData(data: Json): Json {
  const d = data.data;
  return Array.isArray(d) ? asObject(d[0]) : asObject(d);
}
const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const secretKeysRaw = Deno.env.get("SUPABASE_SECRET_KEYS");
const secretKey = secretKeysRaw ? clean(asObject(JSON.parse(secretKeysRaw)).default, 500) : clean(Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"), 500);
const publishKeysRaw = Deno.env.get("SUPABASE_PUBLISHABLE_KEYS");
const publishKey = publishKeysRaw ? clean(asObject(JSON.parse(publishKeysRaw)).default, 500) : clean(Deno.env.get("SUPABASE_ANON_KEY"), 500);
if (!supabaseUrl || !secretKey) throw new Error("Supabase server credentials are unavailable.");
const admin = createClient(supabaseUrl, secretKey, { auth: { persistSession: false, autoRefreshToken: false } });

async function getGatewayConfig(): Promise<Json> {
  const { data, error } = await admin.rpc("selcom_get_gateway_config");
  if (error) throw new Error("Gateway configuration could not be loaded.");
  const cfg = asObject(data);
  if (cfg.complete !== true || !cfg.api_key || !cfg.api_secret || !cfg.vendor_id || !cfg.base_url) {
    throw new Error("Selcom is not configured. Checkout remains disabled until credentials are saved in Supabase Vault.");
  }
  const base = new URL(String(cfg.base_url));
  if (base.protocol !== "https:") throw new Error("Selcom API base URL must use HTTPS.");
  return cfg;
}
async function getAuthenticatedUser(req: Request) {
  const auth = req.headers.get("Authorization") ?? "";
  const match = auth.match(/^Bearer\s+(.+)$/i);
  if (!match || !publishKey) return null;
  const userClient = createClient(supabaseUrl, publishKey, {
    global: { headers: { Authorization: "Bearer " + match[1] } },
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data, error } = await userClient.auth.getUser(match[1]);
  return error ? null : { user: data.user, client: userClient };
}
async function checkout(req: Request) {
  const auth = await getAuthenticatedUser(req);
  if (!auth?.user) return json({ error: "Authentication required." }, 401);
  const body = asObject(await req.json().catch(() => ({})));
  const invoiceId = clean(body.invoice_id, 64);
  const phone = normaliseTzPhone(clean(body.phone, 40));
  const idempotencyKey = clean(req.headers.get("Idempotency-Key") ?? body.idempotency_key, 80);
  if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(invoiceId) ||
      !/^[0-9a-f]{8}-[0-9a-f-]{27}$/i.test(idempotencyKey)) {
    return json({ error: "A valid invoice_id and UUID idempotency key are required." }, 400);
  }
  if (!phone) return json({ error: "Enter a valid Tanzania mobile number in 0XXXXXXXXX or 255XXXXXXXXX format." }, 400);

  const { data: balance, error: balanceError } = await auth.client.rpc("selcom_get_invoice_balance", { p_invoice_id: invoiceId });
  if (balanceError || !balance) return json({ error: "Invoice is unavailable or cannot be paid." }, 403);
  const invoice = asObject(balance);
  const amount = amountNumber(invoice.outstanding_amount);
  if (!amount || invoice.currency_code !== "TZS") return json({ error: "Invoice balance is not eligible for Selcom Pesa." }, 409);

  const { data: existing } = await admin.from("selcom_checkout_intents")
    .select("id,order_id,status,amount,expires_at,safe_metadata")
    .eq("payer_user_id", auth.user.id)
    .eq("client_idempotency_key", idempotencyKey)
    .maybeSingle();
  if (existing) {
    if (existing.status === "completed") return json({ ok: true, status: "completed", order_id: existing.order_id });
    if (existing.status === "pending" && new Date(existing.expires_at).getTime() > Date.now()) {
      return json({ ok: true, status: "pending", order_id: existing.order_id, amount: existing.amount, currency: "TZS", checkout_url: clean(asObject(existing.safe_metadata).checkout_url, 2048) || undefined });
    }
    return json({ error: "This idempotency key has already been used. Generate a new key for a new checkout." }, 409);
  }

  const { data: activeProvider, error: providerError } = await admin.rpc("get_active_school_payment_gateway", {
    p_school_id: invoice.school_id,
  });
  if (providerError || activeProvider !== "selcom") {
    return json({ error: "Selcom Pesa is not the active payment gateway for this school. Select the configured active gateway in school payment settings." }, 409);
  }

  const cfg = await getGatewayConfig();
  const { data: profile } = await admin.from("profiles").select("full_name,phone").eq("id", auth.user.id).maybeSingle();
  const fullName = clean(profile?.full_name, 100) || clean(auth.user.user_metadata?.full_name, 100) || clean(invoice.student_name, 100);
  const email = clean(auth.user.email, 160);
  if (!fullName || !email) return json({ error: "A valid payer name and verified account email are required." }, 422);

  const orderId = crypto.randomUUID().replaceAll("-", "").slice(0, 24);
  const merchantTransId = "PLUS" + crypto.randomUUID().replaceAll("-", "").slice(0, 20).toUpperCase();
  const { data: intent, error: intentError } = await admin.from("selcom_checkout_intents").insert({
    school_id: invoice.school_id, invoice_id: invoice.invoice_id, student_id: invoice.student_id,
    payer_user_id: auth.user.id, client_idempotency_key: idempotencyKey,
    order_id: orderId, merchant_trans_id: merchantTransId, amount, currency_code: "TZS",
    status: "creating", payer_msisdn_last4: phone.slice(-4),
  }).select("id,order_id").single();
  if (intentError || !intent) return json({ error: "Could not safely create a checkout intent." }, 409);

  const webhookUrl = supabaseUrl + "/functions/v1/selcom-gateway/webhook";
  const orderBody: Json = {
    vendor: cfg.vendor_id, order_id: orderId, buyer_email: email, buyer_name: fullName,
    buyer_phone: phone, amount, currency: "TZS", payment_methods: "ALL",
    webhook: b64text(webhookUrl), buyer_remarks: "PLUS OS school fees",
    merchant_remarks: clean(invoice.invoice_number, 60), no_of_items: 1, expiry: 30,
  };
  const fields = ["vendor","order_id","buyer_email","buyer_name","buyer_phone","amount","currency","payment_methods","webhook","buyer_remarks","merchant_remarks","no_of_items","expiry"];
  try {
    const created = await selcomPost(String(cfg.base_url), "/v1/checkout/create-order-minimal", orderBody, fields, String(cfg.api_key), String(cfg.api_secret));
    if (created.resultcode !== "000" || String(created.result).toUpperCase() !== "SUCCESS") {
      await admin.from("selcom_checkout_intents").update({ status: "failed", error_code: clean(created.resultcode, 30), error_message: "Selcom did not accept the checkout order." }).eq("id", intent.id);
      return json({ error: "Selcom could not create this payment order. No payment has been recorded." }, 502);
    }
    const d = resultData(created);
    const gatewayUrl = clean(d.payment_gateway_url, 2048);
    if (!gatewayUrl) {
      await admin.from("selcom_checkout_intents").update({ status: "reconciliation_required", error_message: "Order accepted but checkout URL was not returned." }).eq("id", intent.id);
      return json({ error: "Selcom accepted the order but did not return a payment URL. Contact the school finance office; do not retry this order." }, 202);
    }
    const decoded = (() => { try { return atob(gatewayUrl); } catch { return ""; } })();
    const parsed = new URL(decoded);
    if (parsed.protocol !== "https:") throw new Error("Selcom returned an invalid checkout URL.");
    await admin.from("selcom_checkout_intents").update({
      status: "pending", safe_metadata: { gateway_reference: clean(created.reference, 80), checkout_url: parsed.toString() },
    }).eq("id", intent.id);
    return json({ ok: true, status: "pending", order_id: orderId, amount, currency: "TZS", checkout_url: parsed.toString(), expires_in_minutes: 30 });
  } catch (error) {
    await admin.from("selcom_checkout_intents").update({
      status: "reconciliation_required", error_message: "Gateway request outcome is uncertain; status reconciliation is required.",
    }).eq("id", intent.id);
    return json({ error: "The gateway response is uncertain. The order has been held for reconciliation; do not create another payment yet." }, 202);
  }
}
async function verifyCallback(req: Request, raw: string, cfg: Json): Promise<Json> {
  const auth = req.headers.get("Authorization") ?? "";
  const expectedAuth = "SELCOM " + b64text(String(cfg.api_key));
  if (!safeEqual(auth, expectedAuth)) throw new Error("Invalid gateway authorization.");
  const timestamp = req.headers.get("Timestamp") ?? "";
  if (!validTimestamp(timestamp)) throw new Error("Callback timestamp is invalid or expired.");
  const method = req.headers.get("Digest-Method") ?? "";
  if (method !== "HS256") throw new Error("Unsupported callback digest method.");
  const signedFieldsHeader = req.headers.get("Signed-Fields") ?? "";
  const fields = signedFieldsHeader.split(",").map((v) => v.trim()).filter(Boolean);
  const required = ["transid","order_id","reference","result","resultcode","payment_status"];
  if (required.some((v) => !fields.includes(v))) throw new Error("Callback does not sign all required fields.");
  if (new Set(fields).size !== fields.length || fields.some((f) => !/^[a-zA-Z0-9_]+$/.test(f))) {
    throw new Error("Callback signed-field list is invalid.");
  }
  const payload = asObject(JSON.parse(raw));
  const expectedDigest = await hmac(String(cfg.api_secret), signingString(timestamp, fields, payload));
  if (!safeEqual(req.headers.get("Digest") ?? "", expectedDigest)) throw new Error("Callback signature is invalid.");
  return payload;
}
async function reconcileOne(orderId: string, cfg: Json, callback?: Json, rawHash?: string) {
  const { data: intent, error } = await admin.from("selcom_checkout_intents")
    .select("id,order_id,merchant_trans_id,amount,currency_code,status")
    .eq("order_id", orderId).maybeSingle();
  if (error || !intent) throw new Error("Unknown checkout order.");
  if (intent.status === "completed") return { duplicate: true, status: "completed" };
  const status = await selcomGet(String(cfg.base_url), "/v1/checkout/order-status", { order_id: orderId }, String(cfg.api_key), String(cfg.api_secret));
  const d = resultData(status);
  if (status.resultcode !== "000" || String(status.result).toUpperCase() !== "SUCCESS") {
    throw new Error("Selcom order-status query did not succeed.");
  }
  if (clean(d.order_id, 80) !== orderId) throw new Error("Selcom order-status order ID mismatch.");
  const paymentStatus = clean(d.payment_status, 40).toUpperCase();
  if (["CANCELLED","USERCANCELLED","REJECTED","EXPIRED"].includes(paymentStatus)) {
    await admin.from("selcom_checkout_intents").update({
      status: paymentStatus === "EXPIRED" ? "expired" : "failed",
      safe_metadata: { payment_status: paymentStatus },
      error_code: paymentStatus,
      error_message: "Selcom reported a terminal non-success payment status.",
      processed_at: new Date().toISOString(),
    }).eq("order_id", orderId).neq("status", "completed");
    return { duplicate: false, status: paymentStatus };
  }
  if (paymentStatus !== "COMPLETED") return { duplicate: false, status: paymentStatus || "UNKNOWN" };
  const amount = amountNumber(d.amount);
  const transid = clean(d.transid, 120);
  const reference = clean(d.reference, 120);
  if (!amount || !transid || !reference || amount !== Number(intent.amount)) {
    throw new Error("Selcom verified order details do not match the local checkout intent.");
  }
  if (callback) {
    if (clean(callback.order_id, 80) !== orderId ||
        clean(callback.transid, 120) !== transid ||
        clean(callback.reference, 120) !== reference ||
        amountNumber(callback.amount) !== amount ||
        clean(callback.payment_status, 40).toUpperCase() !== "COMPLETED" ||
        clean(callback.result, 30).toUpperCase() !== "SUCCESS" ||
        clean(callback.resultcode, 20) !== "000") {
      throw new Error("Signed callback does not match the independent Selcom order-status response.");
    }
  }
  const msisdn = clean(d.msisdn, 40).replace(/[^0-9]/g, "");
  const last4 = msisdn.length >= 4 ? msisdn.slice(-4) : null;
  const hashBytes = rawHash ? null : new Uint8Array(await crypto.subtle.digest("SHA-256", enc.encode(JSON.stringify(status))));
  const hash = rawHash ?? Array.from(hashBytes!).map((b) => b.toString(16).padStart(2,"0")).join("");
  const { data: result, error: rpcError } = await admin.rpc("selcom_reconcile_verified_payment", {
    p_order_id: orderId, p_transid: transid, p_reference: reference,
    p_amount: amount, p_currency_code: "TZS", p_channel: clean(d.channel, 40),
    p_msisdn_last4: last4, p_payload_hash: hash.toLowerCase(),
  });
  if (rpcError) throw new Error("Verified payment could not be atomically reconciled.");
  return asObject(result);
}
async function webhook(req: Request) {
  const raw = await req.text();
  if (raw.length > 32768) return json({ error: "Payload too large." }, 413);
  const cfg = await getGatewayConfig();
  const payload = await verifyCallback(req, raw, cfg);
  const orderId = clean(payload.order_id, 80);
  if (!orderId) return json({ error: "Missing order ID." }, 400);
  const digest = new Uint8Array(await crypto.subtle.digest("SHA-256", enc.encode(raw)));
  const hash = Array.from(digest).map((b) => b.toString(16).padStart(2,"0")).join("");
  const result = await reconcileOne(orderId, cfg, payload, hash);
  return json({ ok: true, received: true, status: result.status ?? (result.duplicate ? "completed" : "completed") });
}
async function reconcile(req: Request) {
  const token = req.headers.get("X-PLUS-Reconcile-Token") ?? "";
  const { data: valid, error } = await admin.rpc("selcom_reconcile_token_valid", { p_candidate: token });
  if (error || valid !== true) return json({ error: "Unauthorized." }, 401);
  const { data: rows, error: listError } = await admin.from("selcom_checkout_intents")
    .select("order_id").in("status", ["pending","reconciliation_required"])
    .lt("created_at", new Date(Date.now() - 3*60*1000).toISOString())
    .lt("expires_at", new Date(Date.now() + 24*60*60*1000).toISOString())
    .order("created_at", { ascending: true }).limit(50);
  if (listError) return json({ error: "Could not load pending orders." }, 500);
  if (!rows?.length) return json({ ok: true, checked: 0, completed: 0, pending: 0, failed: 0 });
  const cfg = await getGatewayConfig();
  let checked = 0, completed = 0, pending = 0, failed = 0;
  for (const row of rows ?? []) {
    checked++;
    try {
      const result = await reconcileOne(row.order_id, cfg);
      if (result.status === "completed" || result.duplicate) completed++;
      else pending++;
    } catch {
      failed++;
      await admin.from("selcom_checkout_intents").update({
        status: "reconciliation_required",
        error_message: "Automatic reconciliation attempt failed; retry or manual review is required.",
      }).eq("order_id", row.order_id).neq("status", "completed");
    }
  }
  return json({ ok: true, checked, completed, pending, failed });
}
Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ error: "Method not allowed." }, 405);
  const path = new URL(req.url).pathname.replace(/\/$/, "");
  try {
    if (path.endsWith("/webhook")) return await webhook(req);
    if (path.endsWith("/reconcile")) return await reconcile(req);
    return await checkout(req);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Request could not be processed.";
    const status = message.includes("Authentication") ? 401 :
      message.includes("not configured") ? 503 :
      message.includes("signature") || message.includes("authorization") || message.includes("timestamp") ? 401 : 400;
    return json({ error: message }, status);
  }
});
