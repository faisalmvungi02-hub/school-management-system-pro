"use client";

import Link from "next/link";
import { useState, type FormEvent } from "react";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser";

export default function ForgotPasswordPage(){
  const [email,setEmail]=useState("");
  const [busy,setBusy]=useState(false);
  const [message,setMessage]=useState("");
  const [error,setError]=useState("");
  async function submit(event:FormEvent<HTMLFormElement>){
    event.preventDefault();setBusy(true);setMessage("");setError("");
    try{
      const {error:resetError}=await getSupabaseBrowserClient().auth.resetPasswordForEmail(email.trim().toLowerCase(),{redirectTo:window.location.origin+"/auth/reset-password"});
      if(resetError)throw resetError;
      setMessage("Ikiwa akaunti ipo kwa email hii, utapokea maelekezo ya kubadilisha password. Angalia Inbox na Spam/Junk.");
    }catch(cause){setError(cause instanceof Error?cause.message:"Imeshindikana kutuma maelekezo.");}
    finally{setBusy(false);}
  }
  return <main className="auth-page"><section className="auth-card">
    <Link className="auth-brand" href="/">＋ PLUS OS</Link><p className="auth-kicker">ACCOUNT RECOVERY</p>
    <h1>Rejesha password</h1><p className="auth-copy">Weka email ya akaunti yako. Tutakuomba uthibitishe kupitia link kabla ya kuweka password mpya.</p>
    <form className="auth-form" onSubmit={submit}><label>Email address<input type="email" required autoComplete="email" value={email} onChange={e=>setEmail(e.target.value)}/></label><button className="auth-primary" disabled={busy}>{busy?"Inatuma...":"Tuma recovery link"}</button></form>
    {message&&<p className="auth-success" role="status">{message}</p>}{error&&<p className="auth-error" role="alert">{error}</p>}
    <p className="auth-foot"><Link href="/login">Rudi kuingia</Link></p>
  </section></main>;
}
