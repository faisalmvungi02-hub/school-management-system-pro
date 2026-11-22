"use client";

import { useEffect, useMemo, useState } from "react";
import type { CSSProperties, FormEvent } from "react";
import Link from "next/link";
import { createClient, type User } from "@supabase/supabase-js";

type Membership = {
  school_id: string;
  status: string;
  schools: { id: string; name: string; slug: string; status: string } | null;
};

export default function SchoolOnboardingPage() {
  const supabase = useMemo(() => {
    const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
    return url && key ? createClient(url, key) : null;
  }, []);
  const [user, setUser] = useState<User | null>(null);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [schoolName, setSchoolName] = useState("");
  const [slug, setSlug] = useState("");
  const [memberships, setMemberships] = useState<Membership[]>([]);
  const [busy, setBusy] = useState(false);
  const [notice, setNotice] = useState("");
  const [error, setError] = useState("");

  async function loadMemberships(currentUser: User) {
    if (!supabase) return;
    const { data, error: queryError } = await supabase
      .from("school_memberships")
      .select("school_id,status,schools(id,name,slug,status)")
      .eq("user_id", currentUser.id)
      .order("created_at", { ascending: false });
    if (queryError) throw queryError;
    setMemberships((data ?? []) as unknown as Membership[]);
  }

  useEffect(() => {
    let active = true;
    if (supabase) void supabase.auth.getUser().then(async ({ data, error: authError }) => {
      if (!active || authError || !data.user) return;
      setUser(data.user);
      try {
        const { data: rows, error: queryError } = await supabase.from("school_memberships").select("school_id,status,schools(id,name,slug,status)").eq("user_id", data.user.id).order("created_at", { ascending: false });
        if (queryError) throw queryError;
        if (active) setMemberships((rows ?? []) as unknown as Membership[]);
      } catch (cause) { if (active) setError(cause instanceof Error ? cause.message : "Imeshindwa kupakia shule zako."); }
    });
    return () => { active = false; };
  }, [supabase]);

  async function signIn(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setBusy(true); setError(""); setNotice("");
    try {
      if (!supabase) throw new Error("Supabase environment variables hazijawekwa.");
      const { data, error: authError } = await supabase.auth.signInWithPassword({ email: email.trim(), password });
      if (authError || !data.user) throw authError ?? new Error("Imeshindikana kuthibitisha akaunti.");
      setUser(data.user);
      await loadMemberships(data.user);
      setNotice("Umeingia salama. Sasa unaweza kuendelea na usajili wa shule au kutumia mwaliko uliotumwa kwako.");
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "Imeshindikana kuingia.");
    } finally { setBusy(false); }
  }

  async function createSchool(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setBusy(true); setError(""); setNotice("");
    try {
      if (!supabase || !user) throw new Error("Ingia kwanza kwa akaunti yako.");
      const cleanName = schoolName.trim();
      if (cleanName.length < 2) throw new Error("Jina la shule lazima liwe na angalau herufi 2.");
      const cleanSlug = slug.trim().toLowerCase();
      if (cleanSlug && !/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(cleanSlug)) {
        throw new Error("School URL slug itumie herufi ndogo, namba na hyphen pekee.");
      }
      const { data, error: rpcError } = await supabase.rpc("bootstrap_school", {
        p_name: cleanName,
        p_slug: cleanSlug || null,
      });
      if (rpcError) throw rpcError;
      if (typeof data !== "string") throw new Error("Shule imeundwa lakini server haikurudisha school ID inayotarajiwa.");
      await loadMemberships(user);
      setSchoolName(""); setSlug("");
      setNotice(`Shule imeundwa. School ID: ${data}. Akaunti yako imepewa role ya School Owner kupitia database transaction.`);
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "Imeshindikana kuunda shule.");
    } finally { setBusy(false); }
  }

  async function signOut() {
    if (!supabase) return;
    await supabase.auth.signOut();
    setUser(null); setMemberships([]); setNotice("Umetoka kwenye akaunti.");
  }

  return (
    <main style={page}>
      <section style={shell}>
        <Link href="/" style={mutedLink}>← PLUS OS</Link>
        <p style={eyebrow}>SCHOOL WORKSPACE SETUP</p>
        <h1 style={heading}>Anza kutumia PLUS OS</h1>
        <p style={copy}>Tumia akaunti yako kuthibitisha utambulisho, kisha sajili shule. PLUS OS itaunda workspace, membership na role ya School Owner kupitia RPC yenye ulinzi wa database.</p>

        {!user ? (
          <form onSubmit={signIn} style={form}>
            <h2 style={subheading}>Ingia kwenye akaunti</h2>
            <label style={label}>Email<input style={field} type="email" required autoComplete="username" value={email} onChange={e => setEmail(e.target.value)} /></label>
            <label style={label}>Password<input style={field} type="password" required minLength={8} autoComplete="current-password" value={password} onChange={e => setPassword(e.target.value)} /></label>
            <button disabled={busy} style={primary}>{busy ? "Inathibitisha..." : "Ingia salama"}</button>
            <p style={small}>Usajili wa akaunti mpya na uthibitishaji wa email hufanyika kupitia Supabase Auth. Kwa sasa tumia akaunti iliyothibitishwa.</p>
          </form>
        ) : (
          <div style={form}>
            <div style={identity}>
              <div><span style={eyebrow}>SIGNED IN AS</span><strong>{user.email}</strong></div>
              <button type="button" onClick={signOut} style={secondary}>Toka</button>
            </div>
            <h2 style={subheading}>Shule zako</h2>
            {memberships.length ? memberships.map(item => (
              <article key={item.school_id} style={schoolCard}>
                <strong>{item.schools?.name ?? "School workspace"}</strong>
                <span style={small}>{item.schools?.slug ?? item.school_id} · {item.status}</span>
              </article>
            )) : <p style={small}>Akaunti hii bado haina school membership inayoonekana.</p>}
            <form onSubmit={createSchool} style={form}>
              <h2 style={subheading}>Sajili shule mpya</h2>
              <label style={label}>Jina kamili la shule<input style={field} required minLength={2} value={schoolName} onChange={e => setSchoolName(e.target.value)} placeholder="Mfano: Umoja Secondary School" /></label>
              <label style={label}>Workspace address (hiari)<input style={field} value={slug} onChange={e => setSlug(e.target.value)} placeholder="umoja-secondary" /></label>
              <button disabled={busy} style={primary}>{busy ? "Inaunda workspace..." : "Unda school workspace"}</button>
              <p style={small}>Database inaruhusu bootstrap ya shule kwa akaunti isiyo na active school membership. Ikiwa tayari ni mwanachama wa shule, omba School Owner akutumie invitation badala ya kuunda membership ya pili kwa njia hii.</p>
            </form>
            <Link href="/school/members/invite" style={mutedLink}>Simamia members na utume invitation →</Link>
            <Link href="/school/invitations/accept" style={mutedLink}>Una invitation? Kubali mwaliko wa shule →</Link>
          </div>
        )}
        {notice && <p role="status" style={success}>{notice}</p>}
        {error && <p role="alert" style={danger}>{error}</p>}
        <p style={footer}>PLUS OS · Progressive Learning and Unified School Operating System</p>
      </section>
    </main>
  );
}

const page: CSSProperties = { minHeight: "100vh", display: "grid", placeItems: "center", padding: 24, background: "#101010", color: "#f5f5f5", fontFamily: "Arial,sans-serif" };
const shell: CSSProperties = { width: "min(100%,620px)", padding: "clamp(24px,5vw,42px)", border: "1px solid #343434", borderRadius: 22, background: "rgba(255,255,255,.035)", boxShadow: "0 24px 70px rgba(0,0,0,.28)" };
const eyebrow: CSSProperties = { display: "block", color: "#929292", fontSize: 11, letterSpacing: 2, margin: "24px 0 10px" };
const heading: CSSProperties = { fontSize: "clamp(28px,5vw,40px)", letterSpacing: -1.2, margin: "8px 0 12px" };
const copy: CSSProperties = { color: "#aaa", fontSize: 14, lineHeight: 1.7, marginBottom: 28 };
const form: CSSProperties = { display: "grid", gap: 16 };
const subheading: CSSProperties = { fontSize: 17, margin: "8px 0 2px" };
const label: CSSProperties = { display: "grid", gap: 8, color: "#ccc", fontSize: 13 };
const field: CSSProperties = { width: "100%", boxSizing: "border-box", padding: "13px 14px", border: "1px solid #414141", borderRadius: 10, background: "#171717", color: "#fff", fontSize: 14 };
const primary: CSSProperties = { padding: 14, border: "1px solid #eee", borderRadius: 10, background: "#eee", color: "#111", fontWeight: 700, cursor: "pointer" };
const secondary: CSSProperties = { padding: "8px 12px", border: "1px solid #555", borderRadius: 9, background: "transparent", color: "#eee", cursor: "pointer" };
const mutedLink: CSSProperties = { color: "#bbb", textDecoration: "none", fontSize: 13 };
const small: CSSProperties = { color: "#888", fontSize: 12, lineHeight: 1.6, margin: 0 };
const success: CSSProperties = { marginTop: 18, padding: 12, border: "1px solid #555", borderRadius: 10, color: "#ddd", fontSize: 13, lineHeight: 1.6 };
const danger: CSSProperties = { marginTop: 18, padding: 12, border: "1px solid #744", borderRadius: 10, color: "#ffd0d0", fontSize: 13 };
const footer: CSSProperties = { borderTop: "1px solid #303030", paddingTop: 18, marginTop: 28, color: "#666", fontSize: 11 };
const identity: CSSProperties = { display: "flex", justifyContent: "space-between", alignItems: "center", gap: 16, borderBottom: "1px solid #333", paddingBottom: 16 };
const schoolCard: CSSProperties = { display: "grid", gap: 5, padding: 14, border: "1px solid #3b3b3b", borderRadius: 10, background: "rgba(255,255,255,.025)" };
