"use client";

import { useEffect, useMemo, useState } from "react";
import type { CSSProperties, FormEvent } from "react";
import Link from "next/link";
import { createClient } from "@supabase/supabase-js";

export default function AcceptSchoolInvitationPage() {
  const supabase = useMemo(() => {
    const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
    return url && key ? createClient(url, key) : null;
  }, []);
  const [email,setEmail]=useState("");
  const [password,setPassword]=useState("");
  const [token,setToken]=useState("");
  const [signedIn,setSignedIn]=useState(false);
  const [busy,setBusy]=useState(false);
  const [message,setMessage]=useState("");
  const [error,setError]=useState("");

  useEffect(() => {
    let active = true;
    if (supabase) void supabase.auth.getUser().then(({ data, error: authError }) => {
      if (active && !authError && data.user) setSignedIn(true);
    });
    return () => { active = false; };
  }, [supabase]);

  useEffect(() => {
    const incomingToken = window.location.hash.startsWith("#") ? decodeURIComponent(window.location.hash.slice(1)) : "";
    if (incomingToken) {
      window.history.replaceState({}, "", window.location.pathname);
      queueMicrotask(() => setToken(incomingToken));
    }
  }, []);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setError(""); setMessage("");
    try {
      if (!supabase) throw new Error("Supabase environment variables hazijawekwa.");
      let authenticated = signedIn;
      if (!authenticated) {
        const {data,error:loginError}=await supabase.auth.signInWithPassword({email:email.trim(),password});
        if(loginError || !data.user) throw loginError ?? new Error("Imeshindikana kuingia.");
        authenticated=true; setSignedIn(true);
      }
      const cleanToken=token.trim();
      if(cleanToken.length<32) throw new Error("Invitation token haijakamilika. Tumia token yote uliyopewa.");
      const {data,error:rpcError}=await supabase.rpc("accept_school_invitation",{p_token:cleanToken});
      if(rpcError) throw rpcError;
      if(typeof data!=="string") throw new Error("Invitation imewasilishwa lakini server haikurudisha school ID inayotarajiwa.");
      setMessage(`Invitation imekubaliwa kikamilifu. School ID: ${data}. Ruhusa zako zimetolewa kulingana na role iliyowekwa na shule.`);
      setToken("");
    } catch(cause) {
      setError(cause instanceof Error ? cause.message : "Imeshindikana kukubali invitation.");
    } finally { setBusy(false); }
  }

  return (
    <main style={page}>
      <section style={shell}>
        <Link href="/school/onboarding" style={link}>← Rudi kwenye School Onboarding</Link>
        <p style={eyebrow}>SECURE SCHOOL INVITATION</p>
        <h1 style={heading}>Jiunge na shule</h1>
        <p style={copy}>Ingia kwa email ileile iliyopokea mwaliko. Database itathibitisha email, token hash, muda wa mwisho wa mwaliko na role kabla ya kuunda au kuamsha membership.</p>
        <form onSubmit={handleSubmit} style={form}>
          {!signedIn && <>
            <label style={label}>Email<input required type="email" autoComplete="username" value={email} onChange={e=>setEmail(e.target.value)} style={field}/></label>
            <label style={label}>Password<input required type="password" autoComplete="current-password" value={password} onChange={e=>setPassword(e.target.value)} style={field}/></label>
          </>}
          <label style={label}>Invitation token<textarea required minLength={32} rows={4} value={token} onChange={e=>setToken(e.target.value)} style={{...field,resize:"vertical"}} placeholder="Bandika token kamili ya mwaliko hapa"/></label>
          <button type="submit" disabled={busy} style={primary}>{busy?"Inathibitisha invitation...":signedIn?"Kubali mwaliko":"Ingia na ukubali mwaliko"}</button>
        </form>
        {!signedIn && token.length>=32 && <p style={small}>Huna akaunti bado? <Link href={"/register#"+encodeURIComponent(token)} style={link}>Jisajili kwa kutumia mwaliko huu</Link>. Baada ya kuthibitisha email, utarudishwa hapa kukamilisha kujiunga na shule.</p>}
        {!signedIn && token.length>=32 && <p style={small}>Tayari una akaunti? <Link href={"/login?next="+encodeURIComponent("/school/invitations/accept#"+token)} style={link}>Ingia kwanza</Link>, kisha rudi kwenye mwaliko.</p>}
        {message&&<p role="status" style={success}>{message}</p>}
        {error&&<p role="alert" style={danger}>{error}</p>}
        <p style={small}>Mialiko iliyokwisha muda wake, iliyotumika, iliyofutwa au iliyotumwa kwa email tofauti itakataliwa na database.</p>
      </section>
    </main>
  );
}
const page:CSSProperties={minHeight:"100vh",display:"grid",placeItems:"center",padding:24,background:"#101010",color:"#f5f5f5",fontFamily:"Arial,sans-serif"};
const shell:CSSProperties={width:"min(100%,560px)",padding:"clamp(24px,5vw,42px)",border:"1px solid #343434",borderRadius:22,background:"rgba(255,255,255,.035)",boxShadow:"0 24px 70px rgba(0,0,0,.28)"};
const eyebrow:CSSProperties={color:"#929292",fontSize:11,letterSpacing:2,margin:"28px 0 10px"};
const heading:CSSProperties={fontSize:"clamp(28px,5vw,38px)",letterSpacing:-1,margin:"8px 0 12px"};
const copy:CSSProperties={color:"#aaa",fontSize:14,lineHeight:1.7,marginBottom:26};
const form:CSSProperties={display:"grid",gap:16};
const label:CSSProperties={display:"grid",gap:8,color:"#ccc",fontSize:13};
const field:CSSProperties={width:"100%",boxSizing:"border-box",padding:13,border:"1px solid #414141",borderRadius:10,background:"#171717",color:"#fff",fontSize:14};
const primary:CSSProperties={padding:14,border:"1px solid #eee",borderRadius:10,background:"#eee",color:"#111",fontWeight:700,cursor:"pointer"};
const link:CSSProperties={color:"#bbb",textDecoration:"none",fontSize:13};
const small:CSSProperties={marginTop:20,color:"#888",fontSize:12,lineHeight:1.6};
const success:CSSProperties={padding:12,border:"1px solid #555",borderRadius:10,color:"#ddd",fontSize:13,lineHeight:1.6};
const danger:CSSProperties={padding:12,border:"1px solid #744",borderRadius:10,color:"#ffd0d0",fontSize:13};
