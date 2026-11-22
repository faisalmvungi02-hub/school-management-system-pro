"use client";

import Link from "next/link";
import { useEffect, useState, type FormEvent } from "react";
import { useRouter } from "next/navigation";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser";

export default function LoginPage() {
  const router=useRouter();
  const [email,setEmail]=useState("");
  const [password,setPassword]=useState("");
  const [busy,setBusy]=useState(false);
  const [error,setError]=useState("");

  useEffect(()=>{
    let active=true;
    void (async()=>{
      try{
        await Promise.resolve();
        const {data}=await getSupabaseBrowserClient().auth.getUser();
        if(active&&data.user)router.replace(data.user.app_metadata?.platform_admin===true?"/platform/payment-gateways":"/workspace");
      }catch(cause){if(active)setError(cause instanceof Error?cause.message:"Supabase haijaunganishwa.");}
    })();
    return ()=>{active=false;};
  },[router]);

  async function submit(event:FormEvent<HTMLFormElement>){
    event.preventDefault();setBusy(true);setError("");
    try{
      const {data,error:authError}=await getSupabaseBrowserClient().auth.signInWithPassword({email:email.trim().toLowerCase(),password});
      if(authError)throw authError;
      if(!data.user)throw new Error("Supabase haikurudisha utambulisho wa mtumiaji.");
      if(data.user.app_metadata?.platform_admin===true){router.replace("/platform/payment-gateways");router.refresh();return;}
      const next=new URLSearchParams(window.location.search).get("next");
      router.replace(next&&next.startsWith("/")&&!next.startsWith("//")?next:"/workspace");
      router.refresh();
    }catch(cause){setError(cause instanceof Error?cause.message:"Imeshindikana kuingia. Hakiki taarifa zako.");}
    finally{setBusy(false);}
  }

  return <main className="auth-page"><section className="auth-card">
    <Link className="auth-brand" href="/">＋ PLUS OS</Link><p className="auth-kicker">UNIFIED IDENTITY</p>
    <h1>Ingia kwenye PLUS OS</h1>
    <p className="auth-copy">Akaunti moja kwa wanafunzi, walimu, wazazi na timu za uongozi. Mfumo utasoma nafasi na ruhusa zako kutoka kwenye database.</p>
    <form className="auth-form" onSubmit={submit}>
      <label>Email address<input type="email" autoComplete="username" required value={email} onChange={e=>setEmail(e.target.value)} placeholder="jina@example.com"/></label>
      <label>Password<input type="password" autoComplete="current-password" required value={password} onChange={e=>setPassword(e.target.value)} placeholder="Password yako"/></label>
      <div className="auth-inline"><Link href="/forgot-password">Umesahau password?</Link></div>
      <button className="auth-primary" type="submit" disabled={busy}>{busy?"Inathibitisha...":"Ingia salama"}</button>
    </form>
    {error&&<p className="auth-error" role="alert">{error}</p>}
    <p className="auth-foot">Huna akaunti? <Link href="/register">Jisajili hapa</Link></p>
    <p className="auth-foot"><Link href="/school/onboarding">Sajili school workspace</Link></p>
  </section></main>;
}
