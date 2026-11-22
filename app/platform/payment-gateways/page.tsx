"use client";

import { FormEvent, useCallback, useEffect, useMemo, useState } from "react";
import { createClient, SupabaseClient } from "@supabase/supabase-js";

type Status = { selcom: boolean; snippe: boolean };
type CredentialKey =
  | "selcom_api_key"
  | "selcom_api_secret"
  | "selcom_vendor_id"
  | "selcom_base_url"
  | "snippe_api_key"
  | "snippe_webhook_secret";

const fields: { key: CredentialKey; label: string; provider: "selcom" | "snippe"; hint: string; secret?: boolean }[] = [
  { key: "selcom_api_key", label: "API Key", provider: "selcom", hint: "Selcom merchant API key", secret: true },
  { key: "selcom_api_secret", label: "API Secret", provider: "selcom", hint: "Selcom signing secret", secret: true },
  { key: "selcom_vendor_id", label: "Vendor ID", provider: "selcom", hint: "Vendor identifier supplied by Selcom" },
  { key: "selcom_base_url", label: "API Base URL", provider: "selcom", hint: "HTTPS URL supplied by Selcom" },
  { key: "snippe_api_key", label: "API Key", provider: "snippe", hint: "Snippe Dashboard → Settings → API Keys", secret: true },
  { key: "snippe_webhook_secret", label: "Webhook Signing Secret", provider: "snippe", hint: "Snippe Dashboard → Settings → Webhook Secret", secret: true },
];

const inputStyle: React.CSSProperties = {
  width: "100%", boxSizing: "border-box", border: "1px solid #3c3c3c", borderRadius: 10,
  padding: "13px 14px", background: "rgba(255,255,255,.035)", color: "#f5f5f5",
  outline: "none", fontSize: 14,
};
const cardStyle: React.CSSProperties = {
  border: "1px solid rgba(255,255,255,.13)", borderRadius: 18, padding: 22,
  background: "rgba(255,255,255,.045)", boxShadow: "0 16px 42px rgba(0,0,0,.16)",
};

export default function PlatformPaymentGatewaysPage() {
  const client = useMemo<SupabaseClient | null>(() => {
    const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
    return url && key ? createClient(url, key, { auth: { persistSession: true, autoRefreshToken: true } }) : null;
  }, []);
  const [values, setValues] = useState<Partial<Record<CredentialKey, string>>>({});
  const [status, setStatus] = useState<Status | null>(null);
  const [busy, setBusy] = useState(false);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [sessionReady, setSessionReady] = useState(false);

  const invoke = useCallback(async (method: "GET" | "POST", credentials?: Partial<Record<CredentialKey, string>>) => {
    if (!client) throw new Error("Supabase public environment variables are missing.");
    const { data } = await client.auth.getSession();
    const token = data.session?.access_token;
    if (!token) throw new Error("Ingia kwenye PLUS OS kwanza kwa akaunti ya Platform Administrator.");
    const response = await fetch(
      (process.env.NEXT_PUBLIC_SUPABASE_URL ?? "") + "/functions/v1/platform-gateway-credentials",
      {
        method,
        headers: { Authorization: `Bearer ${token}`, apikey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? "", "Content-Type": "application/json" },
        body: method === "POST" ? JSON.stringify({ credentials }) : undefined,
        cache: "no-store",
      }
    );
    const result = await response.json();
    if (!response.ok) throw new Error(result.error ?? "Ombi halijafanikiwa.");
    setStatus(result.configured ?? null);
    return result;
  }, [client]);

  useEffect(() => {
    let alive = true;
    (async () => {
      try {
        if (client) {
          await invoke("GET");
        }
      } catch (e) {
        if (alive) setError(e instanceof Error ? e.message : "Imeshindikana kusoma hali ya gateways.");
      } finally {
        if (alive) setSessionReady(true);
      }
    })();
    return () => { alive = false; };
  }, [client, invoke]);

  async function save(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setBusy(true); setError(""); setMessage("");
    const credentials = Object.fromEntries(
      Object.entries(values).filter(([, value]) => typeof value === "string" && value.trim().length > 0)
    ) as Partial<Record<CredentialKey, string>>;
    if (!Object.keys(credentials).length) {
      setError("Weka angalau credential moja kabla ya kuhifadhi.");
      setBusy(false);
      return;
    }
    try {
      const result = await invoke("POST", credentials);
      setValues({});
      setMessage(result.message ?? "Credentials zimehifadhiwa salama.");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Imeshindikana kuhifadhi credentials.");
    } finally {
      setBusy(false);
    }
  }

  const providerCard = (provider: "selcom" | "snippe", title: string, subtitle: string) => (
    <section style={cardStyle}>
      <div style={{ display: "flex", justifyContent: "space-between", gap: 12, alignItems: "center", flexWrap: "wrap" }}>
        <div>
          <div style={{ color: "#aaa", fontSize: 11, letterSpacing: 2, textTransform: "uppercase" }}>Payment provider</div>
          <h2 style={{ margin: "7px 0 4px", fontSize: 23, fontWeight: 650 }}>{title}</h2>
          <p style={{ margin: 0, color: "#aaa", fontSize: 13 }}>{subtitle}</p>
        </div>
        <span style={{ border: "1px solid #555", borderRadius: 99, padding: "7px 11px", fontSize: 12, color: status?.[provider] ? "#d9f5df" : "#ddd" }}>
          {status?.[provider] ? "Credentials complete" : "Not configured"}
        </span>
      </div>
      <div style={{ display: "grid", gap: 15, marginTop: 22 }}>
        {fields.filter((field) => field.provider === provider).map((field) => (
          <label key={field.key} style={{ display: "grid", gap: 7, color: "#e8e8e8", fontSize: 13 }}>
            <span>{field.label}</span>
            <input
              style={inputStyle}
              type={field.secret ? "password" : "text"}
              autoComplete="new-password"
              spellCheck={false}
              value={values[field.key] ?? ""}
              placeholder={field.hint}
              onChange={(event) => setValues((current) => ({ ...current, [field.key]: event.target.value }))}
            />
          </label>
        ))}
      </div>
    </section>
  );

  return (
    <main style={{ minHeight: "100vh", background: "#101010", color: "#f7f7f7", padding: "clamp(20px,4vw,54px)", fontFamily: "Arial, sans-serif" }}>
      <div style={{ maxWidth: 1060, margin: "0 auto" }}>
        <a href="/" style={{ color: "#aaa", textDecoration: "none", fontSize: 13 }}>← PLUS OS</a>
        <header style={{ margin: "28px 0 26px" }}>
          <div style={{ color: "#aaa", letterSpacing: 2, fontSize: 11, textTransform: "uppercase" }}>Platform administration</div>
          <h1 style={{ fontSize: "clamp(28px,4vw,42px)", margin: "10px 0", letterSpacing: "-1.2px" }}>Payment gateway credentials</h1>
          <p style={{ maxWidth: 720, color: "#aaa", lineHeight: 1.65, margin: 0 }}>
            Hifadhi credentials za watoa huduma hapa. Siri huhifadhiwa kwenye Supabase Vault; hazionyeshwi tena baada ya kuhifadhiwa na hazitumwi kwenye browser storage.
          </p>
        </header>

        <div style={{ ...cardStyle, marginBottom: 18, padding: 16, display: "flex", alignItems: "center", gap: 12 }}>
          <span style={{ width: 9, height: 9, borderRadius: 20, background: status?.selcom || status?.snippe ? "#a5d6ad" : "#aaa" }} />
          <div style={{ fontSize: 13, color: "#ddd" }}>
            {!sessionReady ? "Inakagua session..." : status ? `Configuration status — Selcom: ${status.selcom ? "Ready" : "Missing"} · Snippe: ${status.snippe ? "Ready" : "Missing"}` : "Hali ya credentials haijapatikana."}
          </div>
        </div>

        <form onSubmit={save} style={{ display: "grid", gap: 18 }}>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit,minmax(min(100%,360px),1fr))", gap: 18 }}>
            {providerCard("selcom", "Selcom Pesa", "Checkout, order status na webhook credentials")}
            {providerCard("snippe", "Snippe Pay", "Mobile money API na webhook signature")}
          </div>

          <div style={{ ...cardStyle, padding: 18 }}>
            <div style={{ fontSize: 13, lineHeight: 1.7, color: "#bdbdbd" }}>
              <strong style={{ color: "#eee" }}>Muhimu:</strong> Unaweza kuhifadhi credentials kwa hatua. Sehemu unayoiacha tupu haitafuta au kubadilisha credential iliyopo. Mfumo hautaruhusu malipo mpaka seti ya credentials ya gateway husika ikamilike.
            </div>
          </div>

          {error && <div role="alert" style={{ color: "#ffd4d4", background: "rgba(160,35,35,.16)", border: "1px solid rgba(220,90,90,.35)", padding: 13, borderRadius: 10, fontSize: 13 }}>{error}</div>}
          {message && <div role="status" style={{ color: "#e0f4e4", background: "rgba(50,120,65,.16)", border: "1px solid rgba(120,190,130,.3)", padding: 13, borderRadius: 10, fontSize: 13 }}>{message}</div>}

          <div style={{ display: "flex", justifyContent: "flex-end", gap: 10, flexWrap: "wrap" }}>
            <button type="button" onClick={() => { setValues({}); setError(""); setMessage(""); }} style={{ border: "1px solid #555", background: "transparent", color: "#ddd", borderRadius: 10, padding: "12px 17px", cursor: "pointer" }}>Clear form</button>
            <button type="submit" disabled={busy} style={{ border: "1px solid #eee", background: "#eee", color: "#111", borderRadius: 10, padding: "12px 20px", fontWeight: 700, cursor: busy ? "wait" : "pointer", opacity: busy ? .65 : 1 }}>
              {busy ? "Inahifadhi..." : "Save credentials securely"}
            </button>
          </div>
        </form>
        <footer style={{ marginTop: 34, borderTop: "1px solid #333", paddingTop: 16, color: "#777", fontSize: 12 }}>
          PLUS OS · Platform-level payment provider configuration · Access restricted to Platform Administrators
        </footer>
      </div>
    </main>
  );
}
