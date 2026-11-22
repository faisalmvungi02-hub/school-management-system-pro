"use client";

import { FormEvent, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@supabase/supabase-js";

export default function PlatformAdminLoginPage() {
  const router = useRouter();
  const client = useMemo(() => {
    const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
    return url && key ? createClient(url, key, { auth: { persistSession: true, autoRefreshToken: true } }) : null;
  }, []);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setBusy(true);
    setError("");
    try {
      if (!client) throw new Error("Supabase environment variables hazijawekwa kwenye frontend.");
      const { data, error: authError } = await client.auth.signInWithPassword({ email: email.trim(), password });
      if (authError || !data.user) throw new Error("Email au password si sahihi.");
      if (data.user.app_metadata?.platform_admin !== true) {
        await client.auth.signOut();
        throw new Error("Akaunti hii haina ruhusa ya Platform Administrator. Wasiliana na mmiliki wa PLUS OS.");
      }
      router.replace("/platform/payment-gateways");
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "Imeshindikana kuingia.");
    } finally {
      setBusy(false);
    }
  }

  return (
    <main style={{ minHeight: "100vh", display: "grid", placeItems: "center", background: "#101010", color: "#f4f4f4", padding: 24, fontFamily: "Arial,sans-serif" }}>
      <section style={{ width: "min(100%,440px)", border: "1px solid rgba(255,255,255,.14)", borderRadius: 20, padding: "clamp(24px,5vw,38px)", background: "rgba(255,255,255,.045)", boxShadow: "0 20px 60px rgba(0,0,0,.25)" }}>
        <a href="/" style={{ color: "#999", fontSize: 13, textDecoration: "none" }}>← PLUS OS</a>
        <div style={{ marginTop: 30, color: "#aaa", textTransform: "uppercase", letterSpacing: 2, fontSize: 11 }}>Restricted access</div>
        <h1 style={{ margin: "10px 0", fontSize: 30, letterSpacing: "-.8px" }}>Platform Administration</h1>
        <p style={{ color: "#aaa", fontSize: 14, lineHeight: 1.6, marginBottom: 26 }}>Ingia kwa akaunti ya Platform Administrator ili kusimamia huduma za malipo na credentials za mfumo.</p>
        <form onSubmit={handleSubmit} style={{ display: "grid", gap: 16 }}>
          <label style={{ display: "grid", gap: 8, fontSize: 13, color: "#ddd" }}>
            Email
            <input required type="email" autoComplete="username" value={email} onChange={(event) => setEmail(event.target.value)} style={fieldStyle} />
          </label>
          <label style={{ display: "grid", gap: 8, fontSize: 13, color: "#ddd" }}>
            Password
            <input required type="password" autoComplete="current-password" value={password} onChange={(event) => setPassword(event.target.value)} style={fieldStyle} />
          </label>
          {error && <div role="alert" style={{ padding: 12, border: "1px solid rgba(220,90,90,.35)", borderRadius: 10, color: "#ffd4d4", fontSize: 13, background: "rgba(160,35,35,.16)" }}>{error}</div>}
          <button disabled={busy} type="submit" style={{ border: "1px solid #eee", borderRadius: 10, background: "#eee", color: "#111", padding: 14, fontWeight: 700, cursor: busy ? "wait" : "pointer", opacity: busy ? .65 : 1 }}>
            {busy ? "Inathibitisha..." : "Sign in securely"}
          </button>
        </form>
        <p style={{ borderTop: "1px solid #333", paddingTop: 16, marginTop: 22, color: "#777", fontSize: 12, lineHeight: 1.6 }}>
          Hakuna public sign-up. Akaunti za Platform Administrator huandaliwa na mmiliki wa mfumo kupitia Supabase Authentication.
        </p>
      </section>
    </main>
  );
}

const fieldStyle: React.CSSProperties = {
  width: "100%", boxSizing: "border-box", padding: "13px 14px", borderRadius: 10,
  border: "1px solid #414141", color: "#f5f5f5", background: "rgba(255,255,255,.035)",
  fontSize: 14, outline: "none",
};
