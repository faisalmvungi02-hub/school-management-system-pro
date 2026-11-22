import { createClient } from "npm:@supabase/supabase-js@2.119.2";

type Json = Record<string, unknown>;
const enc = new TextEncoder();
const corsHeaders = {
  "Access-Control-Allow-Origin": Deno.env.get("PLUS_OS_ALLOWED_ORIGIN") ?? "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type, idempotency-key",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Vary": "Origin",
};
const json = (body: Json, status = 200) => new Response(JSON.stringify(body), {
  status,
  headers: { ...corsHeaders, "Content-Type": "application/json", "Cache-Control": "no-store" },
});
const clean = (value: unknown, max = 160): string =>
  typeof value === "string" ? value.trim().slice(0, max) : "";
const asObject = (value: unknown): Json =>
  value && typeof value === "object" && !Array.isArray(value) ? value as Json : {};
const amountNumber = (value: unknown): number | null => {
  const n = typeof value === "number" ? value : Number(value);
  return Number.isFinite(n) && Number.isInteger(n) && n >= 500 ? n : null;
};
function safeEqual(a: string, b: string): boolean {
  const aa = enc.encode(a), bb = enc.encode(b);
  if (aa.length !== bb.length) return false;
  let diff = 0;
  for (let i = 0; i < aa.length; i++) diff |= aa[i] ^ bb[i];
  return diff === 0;
}
function normaliseTzPhone(value: string): string | null {
  let digits = value.replace(/[^0-9]/g, "");
  if (digits.startsWith("0")) digits = "255" + digits.slice(1);
  if (digits.startsWith("255") && digits.length === 12) return digits;
  return null;
}
function splitName(fullName: string): { firstname: string; lastname: string } {
  const parts = fullName.trim().split(/\s+/).filter(Boolean);
  return {
    firstname: parts[0] ?? "",
    lastname: parts.slice(1).join(" ") || parts[0] || "",
  };
}
async function hmacHex(secret: string, message: string): Promise<string> {
  const key = await crypto.subtle.importKey(
    "raw", enc.encode(secret), { name: "HMAC", hash: "SHA-256" }, false, ["sign"],
  );
  const bytes = new Uint8Array(await crypto.subtle.sign("HMAC", key, enc.encode(message)));
  return Array.from(bytes).map((b) => b.toString(16).padStart(2, "0")).join("");
}
async function sha256Hex(value: string): Promise<string> {
  const bytes = new Uint8Array(await crypto.subtle.digest("SHA-256", enc.encode(value)));
  return Array.from(bytes).map((b) => b.toString(16).padStart(2, "0")).join("");
}
function freshUnixTimestamp(value: string): boolean {
  if (!/^\d{10,13}$/.test(value)) return false;
  let seconds = Number(value);
  if (seconds > 1e12) seconds = Math.floor(seconds / 1000);
  return Number.isSafeInteger(seconds) && Math.abs(Math.floor(Date.now() / 1000) - seconds) <= 300;
}
function extractPayment(data: Json): Json {
  return asObject(data.data);
}

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const secretKeysRaw = Deno.env.get("SUPABASE_SECRET_KEYS");
const secretKey = secretKeysRaw
  ? clean(asObject(JSON.parse(secretKeysRaw)).default, 500)
  : clean(Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"), 500);
const publishKeysRaw = Deno.env.get("SUPABASE_PUBLISHABLE_KEYS");
const publishKey = publishKeysRaw
  ? clean(asObject(JSON.parse(publishKeysRaw)).default, 500)
  : clean(Deno.env.get("SUPABASE_ANON_KEY"), 500);
if (!supabaseUrl || !secretKey) throw new Error("Supabase server credentials are unavailable.");
const admin = createClient(supabaseUrl, secretKey, {
  auth: { persistSession: false, autoRefreshToken: false },
});

async function getConfig(): Promise<Json> {
  const { data, error } = await admin.rpc("snippe_get_gateway_config");
  if (error) throw new Error("Snippe configuration could not be loaded.");
  const cfg = asObject(data);
  if (cfg.complete !== true || !cfg.api_key || !cfg.webhook_secret || !cfg.base_url) {
    throw new Error("Snippe Pay is not configured. Checkout is disabled until the API key and webhook signing secret are saved in Supabase Vault.");
  }
  const base = new URL(String(cfg.base_url));
  if (base.protocol !== "https:" || base.hostname !== "api.snippe.sh") {
    throw new Error("Snippe API base URL is not an approved HTTPS endpoint.");
  }
  return cfg;
}
async function getAuthenticatedUser(req: Request) {
  const match = (req.headers.get("Authorization") ?? "").match(/^Bearer\s+(.+)$/i);
  if (!match || !publishKey) return null;
  const userClient = createClient(supabaseUrl, publishKey, {
    global: { headers: { Authorization: "Bearer " + match[1] } },
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data, error } = await userClient.auth.getUser(match[1]);
  if (error || !data.user) return null;
  return { user: data.user, client: userClient };
}
async function snippeRequest(cfg: Json, path: string, method: "GET" | "POST", body?: Json, idempotencyKey?: string) {
  const headers: Record<string, string> = {
    "Authorization": "Bearer " + String(cfg.api_key),
    "Accept": "application/json",
    "Content-Type": "application/json",
  };
  if (idempotencyKey) headers["Idempotency-Key"] = idempotencyKey;
  const response = await fetch(new URL(path, String(cfg.base_url)), {
    method,
    headers,
    ...(body ? { body: JSON.stringify(body) } : {}),
    signal: AbortSignal.timeout(15000),
  });
  const result = asObject(await response.json().catch(() => ({})));
  if (!response.ok) {
    throw new Error("Snippe API returned HTTP " + response.status + ".");
  }
  return result;
}
async function getInvoiceBalance(userClient: ReturnType<typeof createClient>, invoiceId: string) {
  return await userClient.rpc("selcom_get_invoice_balance", { p_invoice_id: invoiceId });
}
async function checkout(req: Request) {
  const auth = await getAuthenticatedUser(req);
  if (!auth?.user) return json({ error: "Authentication required." }, 401);

  const body = asObject(await req.json().catch(() => ({})));
  const invoiceId = clean(body.invoice_id, 64);
  const phone = normaliseTzPhone(clean(body.phone, 40));
  const idempotencyKey = clean(req.headers.get("Idempotency-Key") ?? body.idempotency_key, 80);
  const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
  if (!uuidPattern.test(invoiceId) || !uuidPattern.test(idempotencyKey)) {
    return json({ error: "A valid invoice_id and UUID idempotency key are required." }, 400);
  }
  if (!phone) return json({ error: "Enter a valid Tanzania mobile number (0XXXXXXXXX or 255XXXXXXXXX)." }, 400);

  const { data: balance, error: balanceError } = await getInvoiceBalance(auth.client, invoiceId);
  if (balanceError || !balance) return json({ error: "Invoice is unavailable or cannot be paid." }, 403);
  const invoice = asObject(balance);
  const amount = amountNumber(invoice.outstanding_amount);
  if (!amount || invoice.currency_code !== "TZS") {
    return json({ error: "Snippe Pay requires an outstanding invoice balance of at least TZS 500." }, 409);
  }

  const { data: existing, error: existingError } = await admin.from("snippe_checkout_intents")
    .select("id,order_id,status,amount,expires_at,snippe_reference")
    .eq("payer_user_id", auth.user.id)
    .eq("client_idempotency_key", idempotencyKey)
    .maybeSingle();
  if (existingError) return json({ error: "Could not check the previous checkout attempt." }, 500);
  if (existing) {
    if (existing.status === "completed") {
      return json({ ok: true, status: "completed", order_id: existing.order_id, payment_reference: existing.snippe_reference });
    }
    if (["pending","active"].includes(existing.status) && existing.snippe_reference) {
      return json({
        ok: true, status: existing.status, order_id: existing.order_id,
        payment_reference: existing.snippe_reference, amount: existing.amount, currency: "TZS",
        message: "A USSD payment request already exists. Complete it on the payer's phone.",
      });
    }
    return json({
      error: "This checkout attempt is already being reviewed or has ended. Do not start another payment until its status is resolved.",
      order_id: existing.order_id,
      status: existing.status,
    }, 409);
  }

  const { data: activeProvider, error: providerError } = await admin.rpc("get_active_school_payment_gateway", {
    p_school_id: invoice.school_id,
  });
  if (providerError || activeProvider !== "snippe") {
    return json({ error: "Snippe Pay is not the active payment gateway for this school. Select it in school payment settings first." }, 409);
  }

  const cfg = await getConfig();
  const { data: profile } = await admin.from("profiles")
    .select("full_name,phone").eq("id", auth.user.id).maybeSingle();
  const fullName = clean(profile?.full_name, 200) ||
    clean(auth.user.user_metadata?.full_name, 200) ||
    clean(invoice.student_name, 200);
  const email = clean(auth.user.email, 200);
  const customerName = splitName(fullName);
  if (!customerName.firstname || !customerName.lastname || !email) {
    return json({ error: "A valid payer full name and account email are required for Snippe checkout." }, 422);
  }

  const orderId = crypto.randomUUID().replaceAll("-", "").slice(0, 24);
  const providerIdempotencyKey = "PLUSOS" + orderId; // 30 chars maximum, as required by Snippe.
  const { data: intent, error: intentError } = await admin.from("snippe_checkout_intents").insert({
    school_id: invoice.school_id,
    invoice_id: invoice.invoice_id,
    student_id: invoice.student_id,
    payer_user_id: auth.user.id,
    client_idempotency_key: idempotencyKey,
    order_id: orderId,
    amount,
    currency_code: "TZS",
    status: "creating",
    payer_msisdn_last4: phone.slice(-4),
    safe_metadata: { provider_idempotency_key: providerIdempotencyKey },
  }).select("id,order_id").single();
  if (intentError || !intent) {
    return json({ error: "A checkout for this invoice is already open or could not be created safely." }, 409);
  }

  const webhookUrl = supabaseUrl + "/functions/v1/snippe-gateway/webhook";
  const requestBody: Json = {
    payment_type: "mobile",
    details: { amount, currency: "TZS" },
    phone_number: "+" + phone,
    customer: {
      firstname: customerName.firstname,
      lastname: customerName.lastname,
      email,
    },
    webhook_url: webhookUrl,
    metadata: { order_id: orderId },
  };
  try {
    const created = await snippeRequest(cfg, "/v1/payments", "POST", requestBody, providerIdempotencyKey);
    const data = extractPayment(created);
    const reference = clean(data.reference, 160);
    const responseAmount = asObject(data.amount);
    const responseValue = amountNumber(responseAmount.value);
    const responseCurrency = clean(responseAmount.currency, 8);
    const state = clean(data.status, 32).toLowerCase();

    if (created.status !== "success" || !reference ||
        responseValue !== amount || responseCurrency !== "TZS" ||
        !["pending","active"].includes(state)) {
      await admin.from("snippe_checkout_intents").update({
        status: "reconciliation_required",
        error_code: clean(created.error_code, 40) || "SNIPPE_RESPONSE_UNVERIFIED",
        error_message: "Snippe response did not match the locally stored checkout intent. Manual reconciliation is required.",
      }).eq("id", intent.id);
      return json({ error: "Snippe returned an unexpected payment response. The order is held for reconciliation; do not retry it." }, 202);
    }

    const { error: updateError } = await admin.from("snippe_checkout_intents").update({
      status: state,
      snippe_reference: reference,
      safe_metadata: { provider_idempotency_key: providerIdempotencyKey, api_version: clean(data.api_version, 30) },
    }).eq("id", intent.id);
    if (updateError) {
      return json({ error: "Snippe created the payment, but PLUS OS could not save its reference. The order has been held for reconciliation." }, 202);
    }

    return json({
      ok: true,
      provider: "snippe",
      status: state,
      order_id: orderId,
      payment_reference: reference,
      amount,
      currency: "TZS",
      message: "A USSD payment request has been sent. Complete the authorization on the payer's phone.",
    });
  } catch {
    await admin.from("snippe_checkout_intents").update({
      status: "reconciliation_required",
      error_code: "SNIPPE_REQUEST_UNCERTAIN",
      error_message: "Snippe request outcome is uncertain. Do not create another order before manual/provider reconciliation.",
    }).eq("id", intent.id);
    return json({
      error: "The Snippe request outcome is uncertain. PLUS OS has locked this invoice for reconciliation to avoid a duplicate charge.",
      order_id: orderId,
    }, 202);
  }
}
async function verifyWebhook(req: Request, raw: string, cfg: Json): Promise<Json> {
  const timestamp = req.headers.get("X-Webhook-Timestamp") ?? "";
  const signature = (req.headers.get("X-Webhook-Signature") ?? "").toLowerCase();
  if (!freshUnixTimestamp(timestamp)) throw new Error("Snippe webhook timestamp is invalid or expired.");
  if (!/^[0-9a-f]{64}$/.test(signature)) throw new Error("Snippe webhook signature is missing or malformed.");
  const expected = await hmacHex(String(cfg.webhook_secret), timestamp + "." + raw);
  if (!safeEqual(signature, expected)) throw new Error("Snippe webhook signature is invalid.");
  const event = asObject(JSON.parse(raw));
  const headerEvent = clean(req.headers.get("X-Webhook-Event"), 80);
  const eventType = clean(event.type ?? event.event, 80);
  if (!eventType || (headerEvent && headerEvent !== eventType)) {
    throw new Error("Snippe webhook event header does not match the signed body.");
  }
  return event;
}
async function getVerifiedPayment(cfg: Json, reference: string): Promise<Json> {
  const result = await snippeRequest(cfg, "/v1/payments/" + encodeURIComponent(reference), "GET");
  if (result.status !== "success") throw new Error("Snippe payment status lookup did not succeed.");
  return extractPayment(result);
}
async function reconcileCompleted(
  orderId: string, cfg: Json, reference: string,
  callback?: Json, rawHash?: string, providerEventId?: string, signatureVerified = false,
) {
  const { data: intent, error } = await admin.from("snippe_checkout_intents")
    .select("id,order_id,amount,currency_code,status,snippe_reference")
    .eq("order_id", orderId).maybeSingle();
  if (error || !intent) throw new Error("Unknown PLUS OS Snippe order.");
  if (intent.status === "completed") return { duplicate: true, status: "completed" };
  if (intent.snippe_reference && intent.snippe_reference !== reference) {
    throw new Error("Snippe payment reference does not match the local checkout.");
  }

  const payment = await getVerifiedPayment(cfg, reference);
  const paymentAmount = asObject(payment.amount);
  const status = clean(payment.status, 32).toLowerCase();
  const amount = amountNumber(paymentAmount.value);
  const currency = clean(paymentAmount.currency, 8);
  if (clean(payment.reference, 160) !== reference) throw new Error("Snippe status response reference mismatch.");

  if (["failed","voided","expired"].includes(status)) {
    await admin.from("snippe_checkout_intents").update({
      status,
      error_code: status.toUpperCase(),
      error_message: "Snippe confirmed a terminal non-success payment status.",
      processed_at: new Date().toISOString(),
      safe_metadata: { payment_status: status },
    }).eq("order_id", orderId).neq("status", "completed");
    return { duplicate: false, status };
  }
  if (status !== "completed") return { duplicate: false, status: status || "unknown" };
  if (amount !== Number(intent.amount) || currency !== intent.currency_code || currency !== "TZS") {
    throw new Error("Snippe verified amount or currency does not match the stored invoice checkout.");
  }

  if (callback) {
    const callbackAmount = asObject(callback.amount);
    if (clean(callback.reference, 160) !== reference ||
        clean(callback.status, 32).toLowerCase() !== "completed" ||
        amountNumber(callbackAmount.value) !== amount ||
        clean(callbackAmount.currency, 8) !== currency) {
      throw new Error("Signed Snippe webhook does not match the independent payment-status response.");
    }
  }

  const hash = rawHash ?? await sha256Hex(JSON.stringify(payment));
  const eventId = providerEventId ?? ("reconcile:" + reference + ":" + clean(payment.completed_at, 50));
  const channel = asObject(payment.channel);
  const { data: result, error: rpcError } = await admin.rpc("snippe_reconcile_verified_payment", {
    p_order_id: orderId,
    p_reference: reference,
    p_external_reference: clean(payment.external_reference, 100),
    p_amount: amount,
    p_currency_code: currency,
    p_channel: clean(channel.provider ?? channel.type, 40),
    p_payload_hash: hash,
    p_provider_event_id: eventId,
    p_signature_verified: signatureVerified,
  });
  if (rpcError) throw new Error("Verified Snippe payment could not be atomically reconciled.");
  return asObject(result);
}
async function webhook(req: Request) {
  const raw = await req.text();
  if (raw.length > 32768) return json({ error: "Payload too large." }, 413);
  const cfg = await getConfig();
  const event = await verifyWebhook(req, raw, cfg);
  const eventType = clean(event.type ?? event.event, 80);
  if (!["payment.completed","payment.failed","payment.voided","payment.expired"].includes(eventType)) {
    return json({ ok: true, ignored: true });
  }
  const data = asObject(event.data ?? event);
  const metadata = asObject(data.metadata);
  const orderId = clean(metadata.order_id ?? metadata.plus_os_order_id, 80);
  const reference = clean(data.reference, 160);
  if (!reference) throw new Error("Snippe webhook does not contain a payment reference.");

  let resolvedOrderId = orderId;
  if (!resolvedOrderId) {
    const { data: found } = await admin.from("snippe_checkout_intents")
      .select("order_id").eq("snippe_reference", reference).maybeSingle();
    resolvedOrderId = clean(found?.order_id, 80);
  }
  if (!resolvedOrderId) throw new Error("Snippe event does not match a PLUS OS checkout.");

  const rawHash = await sha256Hex(raw);
  const eventId = clean(event.id, 160) || (eventType + ":" + reference);
  if (eventType === "payment.completed") {
    const callbackData = {
      reference,
      status: clean(data.status, 32),
      amount: data.amount,
    };
    const result = await reconcileCompleted(resolvedOrderId, cfg, reference, callbackData, rawHash, eventId, true);
    return json({ ok: true, received: true, status: result.status ?? "completed", duplicate: result.duplicate === true });
  }

  const verified = await getVerifiedPayment(cfg, reference);
  const providerStatus = clean(verified.status, 32).toLowerCase();
  if (clean(verified.reference, 160) !== reference || providerStatus !== eventType.slice("payment.".length)) {
    throw new Error("Signed Snippe event does not match the independent payment-status response.");
  }
  const { data: linkedIntent, error: intentLookupError } = await admin.from("snippe_checkout_intents")
    .select("school_id,status").eq("order_id", resolvedOrderId).single();
  if (intentLookupError || !linkedIntent?.school_id) {
    throw new Error("Snippe event has no valid PLUS OS school association.");
  }
  if (linkedIntent.status === "completed") {
    return json({ ok: true, received: true, status: "completed", duplicate: true });
  }
  const { error } = await admin.from("snippe_checkout_intents").update({
    status: providerStatus,
    error_code: providerStatus.toUpperCase(),
    error_message: "Snippe confirmed a terminal non-success payment status.",
    processed_at: new Date().toISOString(),
    snippe_reference: reference,
    safe_metadata: { payment_status: providerStatus },
  }).eq("order_id", resolvedOrderId).neq("status", "completed");
  if (error) throw new Error("Could not persist the verified Snippe payment status.");
  const amount = asObject(verified.amount);
  const { error: eventError } = await admin.from("payment_gateway_events").insert({
    school_id: linkedIntent.school_id,
    provider: "snippe",
    provider_event_id: eventId,
    provider_reference: reference,
    event_type: eventType,
    processing_status: "processed",
    signature_verified: true,
    payload_hash: rawHash,
    safe_metadata: {
      order_id: resolvedOrderId,
      payment_status: providerStatus,
      verification_source: "signed_callback_and_snippe_payment_status_api",
      amount: amount.value,
      currency: amount.currency,
    },
    processed_at: new Date().toISOString(),
  });
  if (eventError && !String(eventError.code).includes("23505")) {
    throw new Error("Could not persist the Snippe gateway event.");
  }
  return json({ ok: true, received: true, status: providerStatus });
}
async function reconcile(req: Request) {
  const token = req.headers.get("X-PLUS-Reconcile-Token") ?? "";
  const { data: valid, error: tokenError } = await admin.rpc("selcom_reconcile_token_valid", { p_candidate: token });
  if (tokenError || valid !== true) return json({ error: "Unauthorized." }, 401);

  const { data: rows, error: listError } = await admin.from("snippe_checkout_intents")
    .select("order_id,snippe_reference")
    .in("status", ["pending","active","reconciliation_required"])
    .not("snippe_reference", "is", null)
    .lt("created_at", new Date(Date.now() - 3 * 60 * 1000).toISOString())
    .order("created_at", { ascending: true }).limit(50);
  if (listError) return json({ error: "Could not load pending Snippe payments." }, 500);
  if (!rows?.length) return json({ ok: true, checked: 0, completed: 0, pending: 0, failed: 0 });

  const cfg = await getConfig();
  let checked = 0, completed = 0, pending = 0, failed = 0;
  for (const row of rows) {
    checked++;
    try {
      const result = await reconcileCompleted(row.order_id, cfg, row.snippe_reference);
      if (result.status === "completed" || result.duplicate) completed++;
      else if (["failed","voided","expired"].includes(String(result.status))) failed++;
      else pending++;
    } catch {
      failed++;
      await admin.from("snippe_checkout_intents").update({
        status: "reconciliation_required",
        error_message: "Automatic Snippe status reconciliation failed; retry or manual review is required.",
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
    const lower = message.toLowerCase();
    const status = lower.includes("authentication") ? 401 :
      lower.includes("not configured") ? 503 :
      lower.includes("signature") || lower.includes("timestamp") ? 401 : 400;
    return json({ error: message }, status);
  }
});
