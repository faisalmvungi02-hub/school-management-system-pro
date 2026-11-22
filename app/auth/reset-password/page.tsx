"use client";

import Link from "next/link";
import { useEffect, useState, type FormEvent } from "react";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser";

export default function ResetPasswordPage(){
  const [ready,setReady]=useState(false);
  const [password,setPassword]=useState("");
  const [confirm,setConfirm]=useState("");
  const [busy,setBusy]=useState(false);
  const [message,setMessage]=useState("");
  const [error,setError]=useState("");
  useEffect(()=>{
    let active=true;
    try{void getSupabaseBrowserClient().auth.getUser().then(({data,error:authError})=>{
      if(active){setReady(Boolean(data.user));if(authError)setError("Recovery link si halali tena au muda wake umeisha. Omba link mpya.");}
    });}catch(cause){setError(cause instanceof Error?cause.message:"Supabase haijaunganishwa.");}
    return ()=>{active=false;};
  },[]);
  async function submit(event:FormEvent<HTMLFormElement>){
    event.preventDefault();setBusy(true);setError("");setMessage("");
    try{
      if(password.length<10)throw new Error("Password iwe na angalau herufi 10.");
      if(password!==confirm)throw new Error("Password hazifanani.");
      const {error:updateError}=await getSupabaseBrowserClient().auth.updateUser({password});
      if(updateError)throw updateError;
      setMessage("Password imebadilishwa. Sasa unaweza kuingia kwa password mpya.");
    }catch(cause){setError(cause instanceof Error?cause.message:"Imeshindikana kubadilisha password.");}
    finally{setBusy(false);}
  }
  return <main className="auth-page"><section className="auth-card">
    <Link className="auth-brand" href="/">＋ PLUS OS</Link><p className="auth-kicker">SECURE PASSWORD UPDATE</p><h1>Weka password mpya</h1>
    {!ready?<p className="auth-copy">Inathibitisha recovery link...</p>:<form className="auth-form" onSubmit={submit}>
      <label>Password mpya<input type="password" required minLength={10} autoComplete="new-password" value={password} onChange={e=>setPassword(e.target.value)}/></label>
      <label>Thibitisha password<input type="password" required minLength={10} autoComplete="new-password" value={confirm} onChange={e=>setConfirm(e.target.value)}/></label>
      <button className="auth-primary" disabled={busy}>{busy?"Inahifadhi...":"Badilisha password"}</button>
    </form>}
    {message&&<p className="auth-success" role="status">{message}</p>}{error&&<p className="auth-error" role="alert">{error}</p>}
    <p className="auth-foot"><Link href="/login">Rudi kuingia</Link></p>
  </section></main>;
}
