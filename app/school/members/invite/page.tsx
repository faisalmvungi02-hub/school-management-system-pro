"use client";

import { useEffect, useMemo, useState } from "react";
import type { CSSProperties, FormEvent } from "react";
import Link from "next/link";
import { createClient, type User } from "@supabase/supabase-js";

type SchoolMembership = { school_id: string; schools: { name: string; slug: string } | null };
type Role = { code: string; name: string };

export default function InviteSchoolMemberPage() {
  const supabase=useMemo(()=>{
    const url=process.env.NEXT_PUBLIC_SUPABASE_URL;
    const key=process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY??process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
    return url&&key?createClient(url,key):null;
  },[]);
  const [email,setEmail]=useState("");
  const [password,setPassword]=useState("");
  const [user,setUser]=useState<User|null>(null);
  const [schools,setSchools]=useState<SchoolMembership[]>([]);
  const [roles,setRoles]=useState<Role[]>([]);
  const [schoolId,setSchoolId]=useState("");
  const [roleCode,setRoleCode]=useState("");
  const [inviteEmail,setInviteEmail]=useState("");
  const [inviteUrl,setInviteUrl]=useState("");
  const [busy,setBusy]=useState(false);
  const [error,setError]=useState("");
  const [message,setMessage]=useState("");

  async function loadContext(current:User) {
    if(!supabase)return;
    const [membershipResult,roleResult]=await Promise.all([
      supabase.from("school_memberships").select("school_id,schools(name,slug)").eq("user_id",current.id).eq("status","active"),
      supabase.from("roles").select("code,name").order("name")
    ]);
    if(membershipResult.error)throw membershipResult.error;
    if(roleResult.error)throw roleResult.error;
    const schoolRows=(membershipResult.data??[]) as unknown as SchoolMembership[];
    const roleRows=(roleResult.data??[]) as Role[];
    setSchools(schoolRows);setRoles(roleRows);
    if(schoolRows.length)setSchoolId(schoolRows[0].school_id);
    if(roleRows.length)setRoleCode(roleRows.find(r=>r.code==="teacher")?.code??roleRows[0].code);
  }

  useEffect(() => {
    let active = true;
    if (supabase) void supabase.auth.getUser().then(async ({ data, error: authError }) => {
      if (!active || authError || !data.user) return;
      setUser(data.user);
      try {
        const [membershipResult, roleResult] = await Promise.all([
          supabase.from("school_memberships").select("school_id,schools(name,slug)").eq("user_id", data.user.id).eq("status", "active"),
          supabase.from("roles").select("code,name").order("name")
        ]);
        if (membershipResult.error) throw membershipResult.error;
        if (roleResult.error) throw roleResult.error;
        if (active) {
          const schoolRows = (membershipResult.data ?? []) as unknown as SchoolMembership[];
          const roleRows = (roleResult.data ?? []) as Role[];
          setSchools(schoolRows); setRoles(roleRows);
          if (schoolRows.length) setSchoolId(schoolRows[0].school_id);
          if (roleRows.length) setRoleCode(roleRows.find(r => r.code === "teacher")?.code ?? roleRows[0].code);
        }
      } catch (cause) { if (active) setError(cause instanceof Error ? cause.message : "Imeshindwa kupakia taarifa za shule."); }
    });
    return () => { active = false; };
  }, [supabase]);

  async function signIn(event:FormEvent<HTMLFormElement>) {
    event.preventDefault();setBusy(true);setError("");setMessage("");
    try{
      if(!supabase)throw new Error("Supabase environment variables hazijawekwa.");
      const {data,error:authError}=await supabase.auth.signInWithPassword({email:email.trim(),password});
      if(authError||!data.user)throw authError??new Error("Imeshindikana kuingia.");
      setUser(data.user);await loadContext(data.user);
    }catch(cause){setError(cause instanceof Error?cause.message:"Imeshindikana kuingia.");}
    finally{setBusy(false);}
  }

  async function createInvitation(event:FormEvent<HTMLFormElement>) {
    event.preventDefault();setBusy(true);setError("");setMessage("");setInviteUrl("");
    try{
      if(!supabase||!user)throw new Error("Ingia kwanza.");
      if(!schoolId||!roleCode)throw new Error("Chagua shule na role.");
      const cleanEmail=inviteEmail.trim().toLowerCase();
      if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(cleanEmail))throw new Error("Weka email sahihi ya mwaliko.");
      const randomBytes=crypto.getRandomValues(new Uint8Array(32));
      const token=Array.from(randomBytes).map(v=>v.toString(16).padStart(2,"0")).join("");
      const digest=await crypto.subtle.digest("SHA-256",new TextEncoder().encode(token));
      const tokenHash=Array.from(new Uint8Array(digest)).map(v=>v.toString(16).padStart(2,"0")).join("");
      const expiresAt=new Date(Date.now()+7*24*60*60*1000).toISOString();
      const {error:insertError}=await supabase.from("school_invitations").insert({
        school_id:schoolId,email:cleanEmail,role_code:roleCode,token_hash:tokenHash,
        status:"pending",invited_by:user.id,expires_at:expiresAt
      });
      if(insertError)throw insertError;
      const url=new URL("/school/invitations/accept",window.location.origin);
      url.hash=token;
      setInviteUrl(url.toString());
      setInviteEmail("");
      setMessage("Mwaliko umetengenezwa na token hash pekee ndiyo iliyohifadhiwa kwenye database. Nakili link hii na umtumie mtu husika kupitia njia salama.");
    }catch(cause){setError(cause instanceof Error?cause.message:"Imeshindikana kutengeneza mwaliko.");}
    finally{setBusy(false);}
  }

  async function copyInvite(){
    try{await navigator.clipboard.writeText(inviteUrl);setMessage("Invitation link imenakiliwa.");}
    catch{setError("Imeshindikana kunakili link. Chagua na unakili maandishi ya link mwenyewe.");}
  }

  return <main style={page}><section style={shell}>
    <Link href="/school/onboarding" style={link}>← School Onboarding</Link>
    <p style={eyebrow}>MEMBER ACCESS CONTROL</p><h1 style={heading}>Alika mwanachama</h1>
    <p style={copy}>Tengeneza invitation ya siku 7 kwa email na role maalumu. Token ya matumizi ya mara moja inazalishwa kwa cryptographic randomness; database inahifadhi SHA-256 hash yake pekee.</p>
    {!user?<form onSubmit={signIn} style={form}>
      <label style={label}>Email<input style={field} type="email" required value={email} onChange={e=>setEmail(e.target.value)}/></label>
      <label style={label}>Password<input style={field} type="password" required value={password} onChange={e=>setPassword(e.target.value)}/></label>
      <button disabled={busy} style={primary}>{busy?"Inathibitisha...":"Ingia"}</button>
    </form>:schools.length===0?<p style={small}>Akaunti hii haina active school membership. Sajili shule au kubali invitation kwanza.</p>:<form onSubmit={createInvitation} style={form}>
      <label style={label}>Shule<select style={field} required value={schoolId} onChange={e=>setSchoolId(e.target.value)}>{schools.map(s=><option key={s.school_id} value={s.school_id}>{s.schools?.name??s.school_id}</option>)}</select></label>
      <label style={label}>Email ya mtu unayemwalika<input style={field} type="email" required value={inviteEmail} onChange={e=>setInviteEmail(e.target.value)} placeholder="teacher@example.com"/></label>
      <label style={label}>Role<select style={field} required value={roleCode} onChange={e=>setRoleCode(e.target.value)}>{roles.map(r=><option key={r.code} value={r.code}>{r.name}</option>)}</select></label>
      <button disabled={busy} style={primary}>{busy?"Inatengeneza...":"Tengeneza invitation link"}</button>
      <p style={small}>RLS ya database ndiyo yenye uamuzi wa mwisho: lazima uwe na ruhusa ya members.manage. Kuweka role ya School Owner au School Administrator kunahitaji pia uthibitisho wa role ya School Owner.</p>
    </form>}
    {inviteUrl&&<div style={result}><strong>Invitation link — nakili na utume kwa email sahihi</strong><textarea readOnly rows={4} value={inviteUrl} style={{...field,resize:"vertical"}}/><button type="button" onClick={copyInvite} style={secondary}>Nakili link</button></div>}
    {message&&<p role="status" style={success}>{message}</p>}{error&&<p role="alert" style={danger}>{error}</p>}
    <p style={small}>PLUS OS haitumi email moja kwa moja katika hatua hii; tuma link mwenyewe. Usiiweke token kwenye public group. Link ikishakubaliwa au ku-expire haiwezi kutumika tena.</p>
  </section></main>;
}
const page:CSSProperties={minHeight:"100vh",display:"grid",placeItems:"center",padding:24,background:"#101010",color:"#f5f5f5",fontFamily:"Arial,sans-serif"};
const shell:CSSProperties={width:"min(100%,620px)",padding:"clamp(24px,5vw,42px)",border:"1px solid #343434",borderRadius:22,background:"rgba(255,255,255,.035)",boxShadow:"0 24px 70px rgba(0,0,0,.28)"};
const eyebrow:CSSProperties={color:"#929292",fontSize:11,letterSpacing:2,margin:"28px 0 10px"};
const heading:CSSProperties={fontSize:"clamp(28px,5vw,38px)",letterSpacing:-1,margin:"8px 0 12px"};
const copy:CSSProperties={color:"#aaa",fontSize:14,lineHeight:1.7,marginBottom:26};
const form:CSSProperties={display:"grid",gap:16};
const label:CSSProperties={display:"grid",gap:8,color:"#ccc",fontSize:13};
const field:CSSProperties={width:"100%",boxSizing:"border-box",padding:13,border:"1px solid #414141",borderRadius:10,background:"#171717",color:"#fff",fontSize:14};
const primary:CSSProperties={padding:14,border:"1px solid #eee",borderRadius:10,background:"#eee",color:"#111",fontWeight:700,cursor:"pointer"};
const secondary:CSSProperties={padding:12,border:"1px solid #555",borderRadius:10,background:"transparent",color:"#eee",cursor:"pointer"};
const link:CSSProperties={color:"#bbb",textDecoration:"none",fontSize:13};
const small:CSSProperties={marginTop:18,color:"#888",fontSize:12,lineHeight:1.6};
const success:CSSProperties={padding:12,border:"1px solid #555",borderRadius:10,color:"#ddd",fontSize:13,lineHeight:1.6};
const danger:CSSProperties={padding:12,border:"1px solid #744",borderRadius:10,color:"#ffd0d0",fontSize:13};
const result:CSSProperties={display:"grid",gap:10,marginTop:20,padding:14,border:"1px solid #444",borderRadius:12};
