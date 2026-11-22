"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { getSupabaseBrowserClient } from "@/lib/supabase/browser";

type Membership={id:string;school_id:string;status:string};
type School={id:string;name:string;slug:string;status:string};
type Role={code:string;name:string};
type DistrictMembership={id:string;district_id:string;role_code:string;status:string};
type District={id:string;name:string;code:string;region_name:string|null};
type Workspace={id:string;name:string;kind:"school"|"district";status:string;roles:Role[];permissions:string[]};

export default function WorkspacePage(){
  const router=useRouter();
  const [email,setEmail]=useState("");
  const [workspaces,setWorkspaces]=useState<Workspace[]>([]);
  const [active,setActive]=useState("");
  const [loading,setLoading]=useState(true);
  const [error,setError]=useState("");

  useEffect(()=>{
    let alive=true;
    async function load(){
      try{
        const supabase=getSupabaseBrowserClient();
        const {data:{user},error:userError}=await supabase.auth.getUser();
        if(userError||!user){router.replace("/login?next=/workspace");return;}
        if(user.app_metadata?.platform_admin===true){router.replace("/platform/payment-gateways");return;}
        if(!alive)return;
        setEmail(user.email??"");
        const {data:memberships,error:membershipError}=await supabase.from("school_memberships").select("id,school_id,status").eq("user_id",user.id).eq("status","active");
        if(membershipError)throw membershipError;
        const schoolMemberships=(memberships??[]) as Membership[];
        const schoolIds=Array.from(new Set(schoolMemberships.map(m=>m.school_id)));
        const membershipIds=schoolMemberships.map(m=>m.id);
        let schoolRows:School[]=[];
        let memberRoles:{membership_id:string;school_id:string;role_code:string}[]=[];
        if(schoolIds.length){
          const [schoolsResult,rolesResult]=await Promise.all([
            supabase.from("schools").select("id,name,slug,status").in("id",schoolIds),
            supabase.from("membership_roles").select("membership_id,school_id,role_code").in("membership_id",membershipIds),
          ]);
          if(schoolsResult.error)throw schoolsResult.error;
          if(rolesResult.error)throw rolesResult.error;
          schoolRows=(schoolsResult.data??[]) as School[];
          memberRoles=(rolesResult.data??[]) as typeof memberRoles;
        }
        const {data:districtRows,error:districtError}=await supabase.from("district_memberships").select("id,district_id,role_code,status").eq("user_id",user.id).eq("status","active");
        if(districtError)throw districtError;
        const districtMemberships=(districtRows??[]) as DistrictMembership[];
        const districtIds=Array.from(new Set(districtMemberships.map(m=>m.district_id)));
        let districts:District[]=[];
        if(districtIds.length){
          const {data,error:districtsError}=await supabase.from("districts").select("id,name,code,region_name").in("id",districtIds);
          if(districtsError)throw districtsError;
          districts=(data??[]) as District[];
        }
        const allRoleCodes=Array.from(new Set([...memberRoles.map(r=>r.role_code),...districtMemberships.map(r=>r.role_code)]));
        let roleNames:Role[]=[];
        let rolePermissions:{role_code:string;permission_code:string}[]=[];
        if(allRoleCodes.length){
          const [namesResult,permissionsResult]=await Promise.all([
            supabase.from("roles").select("code,name").in("code",allRoleCodes),
            supabase.from("role_permissions").select("role_code,permission_code").in("role_code",allRoleCodes),
          ]);
          if(namesResult.error)throw namesResult.error;
          if(permissionsResult.error)throw permissionsResult.error;
          roleNames=(namesResult.data??[]) as Role[];
          rolePermissions=(permissionsResult.data??[]) as typeof rolePermissions;
        }
        const roleMap=new Map(roleNames.map(r=>[r.code,r] as const));
        const permissionMap=new Map<string,string[]>();
        for(const item of rolePermissions){
          const existing=permissionMap.get(item.role_code)??[];
          existing.push(item.permission_code);
          permissionMap.set(item.role_code,existing);
        }
        const schoolWorkspaces:Workspace[]=schoolRows.map(school=>{
          const assignments=memberRoles.filter(r=>r.school_id===school.id);
          const codes=Array.from(new Set(assignments.map(r=>r.role_code)));
          return {id:school.id,name:school.name,kind:"school",status:school.status,roles:codes.map(c=>roleMap.get(c)).filter((r):r is Role=>Boolean(r)),permissions:Array.from(new Set(codes.flatMap(c=>permissionMap.get(c)??[]))).sort()};
        });
        const districtWorkspaces:Workspace[]=districts.map(district=>{
          const assignments=districtMemberships.filter(r=>r.district_id===district.id);
          const codes=Array.from(new Set(assignments.map(r=>r.role_code)));
          return {id:district.id,name:district.name+" · "+district.code,kind:"district",status:"active",roles:codes.map(c=>roleMap.get(c)).filter((r):r is Role=>Boolean(r)),permissions:Array.from(new Set(codes.flatMap(c=>permissionMap.get(c)??[]))).sort()};
        });
        if(alive){
          const result=[...schoolWorkspaces,...districtWorkspaces];
          setWorkspaces(result);
          setActive(result[0]?result[0].kind+":"+result[0].id:"");
        }
      }catch(cause){if(alive)setError(cause instanceof Error?cause.message:"Imeshindikana kupakia workspace kutoka database.");}
      finally{if(alive)setLoading(false);}
    }
    void load();
    return ()=>{alive=false;};
  },[router]);

  async function signOut(){
    await getSupabaseBrowserClient().auth.signOut();
    router.replace("/login");router.refresh();
  }
  const selected=workspaces.find(w=>w.kind+":"+w.id===active);

  return <main className="workspace-page">
    <header className="workspace-top"><Link className="auth-brand" href="/">＋ PLUS OS</Link><div className="workspace-user"><span>{email}</span><button className="auth-secondary" onClick={signOut}>Toka</button></div></header>
    <section className="workspace-wrap">
      <p className="auth-kicker">IDENTITY & ACCESS CONTROL</p><h1>Karibu kwenye PLUS OS</h1>
      <p className="auth-copy">Database imethibitisha session yako. Workspaces na ruhusa zinasomwa kutoka Supabase kwa akaunti hii. Role na ruhusa haziwezi kuongezwa kwa kubadilisha URL au browser.</p>
      {loading?<p className="workspace-muted">Inasoma utambulisho, memberships na roles kutoka database...</p>:error?<p className="auth-error" role="alert">{error}</p>:workspaces.length===0?
        <div className="workspace-empty"><h2>Akaunti imetambuliwa — hakuna workspace bado</h2><p>Umeingia kwa mafanikio, lakini bado hujaunganishwa na shule au wilaya. Sajili shule yako au kubali invitation ya taasisi iliyokualika.</p><div className="workspace-actions"><Link className="auth-primary auth-button-link" href="/school/onboarding">Sajili school workspace</Link><Link className="auth-secondary auth-button-link" href="/school/invitations/accept">Kubali invitation</Link></div></div>:
        <div className="workspace-grid">
          <aside className="workspace-list"><h2>Workspaces zako</h2>{workspaces.map(w=><button key={w.kind+":"+w.id} className={"workspace-choice"+(active===w.kind+":"+w.id?" selected":"")} onClick={()=>setActive(w.kind+":"+w.id)}><strong>{w.name}</strong><span>{w.kind==="school"?"School workspace":"District workspace"}</span><small>{w.roles.map(r=>r.name).join(", ")||"Role haijaainishwa"}</small></button>)}</aside>
          <section className="workspace-detail">{selected?<><div className="workspace-label">{selected.kind.toUpperCase()} WORKSPACE</div><h2>{selected.name}</h2><p className="workspace-muted">Hali: {selected.status}</p><h3>Majukumu yako</h3><div className="workspace-tags">{selected.roles.map(r=><span key={r.code}>{r.name}</span>)}</div><h3>Ruhusa zilizopatikana kutoka database ({selected.permissions.length})</h3>{selected.permissions.length?<div className="permission-grid">{selected.permissions.map(p=><code key={p}>{p}</code>)}</div>:<p className="workspace-muted">Hakuna permission iliyopatikana kwa role hii. Omba administrator akague assignment yako.</p>}</>:<p>Chagua workspace kuendelea.</p>}</section>
        </div>}
      <div className="workspace-links"><Link href="/school/onboarding">School setup</Link><Link href="/school/members/invite">Alika mwanachama</Link><Link href="/school/invitations/accept">Kubali invitation</Link></div>
    </section>
  </main>;
}
