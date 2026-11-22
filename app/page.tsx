import Link from "next/link";

export default function HomePage(){
  return <main className="auth-page"><section className="auth-card">
    <div className="auth-brand">＋ PLUS OS</div><p className="auth-kicker">PROGRESSIVE LEARNING AND UNIFIED SCHOOL OPERATING SYSTEM</p>
    <h1>One system. Every school community.</h1>
    <p className="auth-copy">PLUS OS inaunganisha wanafunzi, walimu, wazazi na uongozi wa shule kwenye mfumo mmoja. Ingia au fungua akaunti; database itatambua role na ruhusa zako.</p>
    <div className="workspace-actions"><Link className="auth-primary auth-button-link" href="/login">Ingia kwenye akaunti</Link><Link className="auth-secondary auth-button-link" href="/register">Fungua akaunti mpya</Link></div>
    <p className="auth-foot"><Link href="/school/onboarding">Mmiliki wa shule? Anza kusajili shule yako</Link></p>
  </section></main>;
}
