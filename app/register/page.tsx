"use client";

import Link from "next/link";
import { useState, type FormEvent } from "react";
import { useRouter } from "next/navigation";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser";

export default function RegisterPage() {
  const router=useRouter();
  const [fullName,setFullName]=useState("");
  const [email,setEmail]=useState("");
  const [password,setPassword]=useState("");
  const [confirmPassword,setConfirmPassword]=useState("");
  const [busy,setBusy]=useState(false);
  const [message,setMessage]=useState("");
  const [error,setError]=useState("");

  async function submit(event:FormEvent<HTMLFormElement>){
    event.preventDefault();setBusy(true);setError("");setMessage("");
    try{
      if(password.length<10)throw new Error("Password iwe na angalau herufi 10.");
      if(password!==confirmPassword)throw new Error("Password ulizoweka hazifanani.");
      const invitationToken=window.location.hash.startsWith("#")?decodeURIComponent(window.location.hash.slice(1)):"";
      const confirmationPath=invitationToken.length>=32?"/school/invitations/accept#"+encodeURIComponent(invitationToken):"/auth/confirmed";
      const {data,error:signUpError}=await getSupabaseBrowserClient().auth.signUp({
        email:email.trim().toLowerCase(),password,
        options:{data:{full_name:fullName.trim()},emailRedirectTo:window.location.origin+confirmationPath},
      });
      if(signUpError)throw signUpError;
      if(data.session&&data.user){router.replace(invitationToken.length>=32?"/school/invitations/accept#"+encodeURIComponent(invitationToken):"/workspace");router.refresh();return;}
      setMessage("Akaunti imepokelewa. Fungua email yako na uthibitishe anuani kabla ya kuingia. Angalia pia Spam/Junk.");
    }catch(cause){setError(cause instanceof Error?cause.message:"Imeshindikana kutengeneza akaunti.");}
    finally{setBusy(false);}
  }

  return <main className="auth-page"><section className="auth-card">
    <Link className="auth-brand" href="/">＋ PLUS OS</Link><p className="auth-kicker">CREATE YOUR IDENTITY</p>
    <h1>Fungua akaunti</h1>
    <p className="auth-copy">Akaunti moja itakutambulisha kwenye PLUS OS. Role ya shule haitachaguliwa hapa; itatolewa na School Owner kupitia invitation au mchakato rasmi.</p>
    <form className="auth-form" onSubmit={submit}>
      <label>Jina kamili<input autoComplete="name" required minLength={2} value={fullName} onChange={e=>setFullName(e.target.value)} placeholder="Majina yako kamili"/></label>
      <label>Email address<input type="email" autoComplete="email" required value={email} onChange={e=>setEmail(e.target.value)} placeholder="jina@example.com"/></label>
      <label>Password<input type="password" autoComplete="new-password" required minLength={10} value={password} onChange={e=>setPassword(e.target.value)} placeholder="Angalau herufi 10"/></label>
      <label>Thibitisha password<input type="password" autoComplete="new-password" required minLength={10} value={confirmPassword} onChange={e=>setConfirmPassword(e.target.value)} placeholder="Rudia password"/></label>
      <button className="auth-primary" type="submit" disabled={busy}>{busy?"Inatengeneza akaunti...":"Tengeneza akaunti"}</button>
    </form>
    {message&&<p className="auth-success" role="status">{message}</p>}{error&&<p className="auth-error" role="alert">{error}</p>}
    <p className="auth-foot">Tayari una akaunti? <Link href="/login">Ingia</Link></p>
  </section></main>;
}
