"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser";

export default function ConfirmedPage(){
  const [status,setStatus]=useState("Inathibitisha session yako...");
  useEffect(()=>{
    let active=true;
    let unsubscribe=()=>{};
    void (async()=>{
      try{
        await Promise.resolve();
        const supabase=getSupabaseBrowserClient();
        const {data:{subscription}}=supabase.auth.onAuthStateChange((_event,session)=>{
          if(active&&session)setStatus("Email imethibitishwa. Utambulisho wako umepokelewa na PLUS OS.");
        });
        unsubscribe=()=>subscription.unsubscribe();
        const {data,error}=await supabase.auth.getUser();
        if(active)setStatus(data.user?"Email imethibitishwa. Utambulisho wako umepokelewa na PLUS OS.":(error?.message??"Hakuna session iliyopatikana. Jaribu kuingia baada ya kuthibitisha email."));
      }catch(cause){if(active)setStatus(cause instanceof Error?cause.message:"Imeshindikana kuthibitisha session.");}
    })();
    return ()=>{active=false;unsubscribe();};
  },[]);
  return <main className="auth-page"><section className="auth-card">
    <Link className="auth-brand" href="/">＋ PLUS OS</Link><p className="auth-kicker">EMAIL VERIFICATION</p><h1>Uthibitishaji wa akaunti</h1>
    <p className="auth-copy" role="status">{status}</p><Link className="auth-primary auth-button-link" href="/workspace">Endelea kwenye workspace</Link>
    <p className="auth-foot"><Link href="/login">Ingia kwenye akaunti</Link></p>
  </section></main>;
}
