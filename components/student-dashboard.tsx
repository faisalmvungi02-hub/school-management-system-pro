"use client";

import Link from "next/link";
import { CSSProperties, useEffect, useMemo, useState } from "react";
import {
  backgroundCatalog,
  defaultPreferences,
  getStoredPreferences,
  presetCatalog,
  type DashboardPreferences,
} from "@/lib/preferences";

const studentData = {
  classes: [
    { code: "ENG-210", title: "Engineering Design Studio", room: "A-14", time: "08:30 - 10:00" },
    { code: "MAT-201", title: "Materials and Structures", room: "B-04", time: "10:15 - 11:45" },
    { code: "ELE-180", title: "Digital Systems", room: "C-10", time: "12:30 - 14:00" },
    { code: "RES-101", title: "Research Methods", room: "D-02", time: "15:00 - 16:30" },
  ],
  assignments: [
    { title: "Bridge Load Analysis Draft", due: "2026-03-05", status: "In progress", link: "/assignments/bridge-load-analysis" },
    { title: "Circuit Lab Reflection", due: "2026-03-06", status: "Needs review", link: "/assignments/circuit-lab-reflection" },
    { title: "Material Properties Portfolio", due: "2026-03-08", status: "Submitted", link: "/assignments/material-properties-portfolio" },
  ],
  assessments: [
    { title: "Structural Systems Quiz", date: "2026-03-07" },
    { title: "Digital Systems Lab Test", date: "2026-03-10" },
  ],
  results: [
    { subject: "Engineering Design Studio", grade: "A-", date: "2026-02-18" },
    { subject: "Materials and Structures", grade: "B+", date: "2026-02-25" },
    { subject: "Digital Systems", grade: "A", date: "2026-03-03" },
  ],
  timetable: [
    { day: "Monday", slot: "08:30 - 10:00", title: "Engineering Design Studio" },
    { day: "Monday", slot: "10:15 - 11:45", title: "Materials and Structures" },
    { day: "Tuesday", slot: "12:30 - 14:00", title: "Digital Systems" },
    { day: "Wednesday", slot: "15:00 - 16:30", title: "Research Methods" },
  ],
  announcements: [
    { title: "Library access update", body: "The engineering library remains open until 18:00 for project review and model preparation.", date: "2026-03-02" },
    { title: "Lab safety briefing", body: "All students must sign the digital safety checklist before the workshop session on Thursday.", date: "2026-03-03" },
  ],
};

function formatDate(dateString: string) {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat("en", { month: "short", day: "numeric", year: "numeric" }).format(date);
}

function getGreeting() {
  const hour = new Date().getHours();
  if (hour < 12) return "Good morning";
  if (hour < 18) return "Good afternoon";
  return "Good evening";
}

export default function StudentDashboardPage() {
  const [prefs, setPrefs] = useState<DashboardPreferences>(defaultPreferences);

  useEffect(() => {
    const stored = getStoredPreferences();
    setPrefs(stored);
  }, []);

  const selectedBackground = useMemo(
    () => backgroundCatalog.find((item) => item.id === prefs.backgroundId) ?? backgroundCatalog[0],
    [prefs.backgroundId]
  );

  const selectedPreset = useMemo(
    () => presetCatalog.find((item) => item.id === prefs.glassPreset) ?? presetCatalog[0],
    [prefs.glassPreset]
  );

  const shellStyle = {
    ["--dashboard-bg-image" as any]: `url(${selectedBackground.url})`,
    ["--glass-opacity" as any]: selectedPreset.opacity,
    ["--glass-blur" as any]: selectedPreset.blur,
    ["--glass-border" as any]: selectedPreset.border,
    ["--glass-shadow" as any]: selectedPreset.shadow,
  } as CSSProperties;

  return (
    <div className="dashboard-app" style={shellStyle}>
      <div className="dashboard-shell">
        <aside className="sidebar glass-panel">
          <div className="brand-row">
            <div className="brand-mark">P</div>
            <div>
              <div className="brand-title">PLUS OS</div>
              <div className="brand-subtitle">Student</div>
            </div>
          </div>

          <nav aria-label="Student navigation" className="nav-stack">
            <Link href="/" className="nav-link active" aria-current="page">
              Dashboard
            </Link>
            <Link href="/settings" className="nav-link">
              Settings
            </Link>
          </nav>

          <div className="sidebar-footer glass-panel inset-panel">
            <div className="eyebrow">Access</div>
            <strong>Student Portal</strong>
          </div>
        </aside>

        <main className="main-panel">
          <header className="topbar">
            <div>
              <div className="eyebrow">Academic overview</div>
              <h1>{getGreeting()}, student</h1>
            </div>
            <div className="topbar-actions">
              <div className="date-pill">
                {new Intl.DateTimeFormat("en", { weekday: "long", month: "short", day: "numeric" }).format(new Date())}
              </div>
              <button type="button" className="icon-button" aria-label="Notifications">
                🔔
              </button>
              <button type="button" className="avatar-button" aria-label="Profile">
                S
              </button>
            </div>
          </header>

          <section className="stats-grid" aria-label="Academic statistics">
            <article className="glass-panel stat-card">
              <div className="eyebrow">Current classes</div>
              <div className="metric">4</div>
              <div className="metric-note">Enrolled this term</div>
            </article>
            <article className="glass-panel stat-card">
              <div className="eyebrow">Pending work</div>
              <div className="metric">3</div>
              <div className="metric-note">Assignments due soon</div>
            </article>
            <article className="glass-panel stat-card">
              <div className="eyebrow">Upcoming assessments</div>
              <div className="metric">2</div>
              <div className="metric-note">This week</div>
            </article>
            <article className="glass-panel stat-card">
              <div className="eyebrow">Published results</div>
              <div className="metric">3</div>
              <div className="metric-note">Visible to student</div>
            </article>
          </section>

          <section className="content-grid">
            <article className="panel glass-panel span-2">
              <div className="panel-header">
                <div>
                  <div className="eyebrow">Priority</div>
                  <h2>Upcoming assignments</h2>
                </div>
              </div>
              <div className="stack-list">
                {studentData.assignments.map((item) => (
                  <div key={item.title} className="row-item assignment-row">
                    <div>
                      <div className="label-row">
                        <strong>{item.title}</strong>
                        <span className={`status-chip ${item.status.toLowerCase().replace(/\s+/g, "-")}`}>{item.status}</span>
                      </div>
                      <div className="meta-row">Due {formatDate(item.due)}</div>
                    </div>
                    <Link href={item.link} className="text-link">Open</Link>
                  </div>
                ))}
              </div>
            </article>

            <article className="panel glass-panel">
              <div className="panel-header">
                <div>
                  <div className="eyebrow">Schedule</div>
                  <h2>Today’s timetable</h2>
                </div>
              </div>
              <div className="stack-list compact-list">
                {studentData.timetable.map((item, idx) => (
                  <div key={`${item.day}-${item.slot}`} className="row-item timetable-row">
                    <div className="time-block">{item.slot}</div>
                    <div>
                      <strong>{item.title}</strong>
                      <div className="meta-row">{item.day}</div>
                    </div>
                    {idx === 0 && <span className="live-badge">Live</span>}
                  </div>
                ))}
              </div>
            </article>

            <article className="panel glass-panel">
              <div className="panel-header">
                <div>
                  <div className="eyebrow">Results</div>
                  <h2>Recent academic results</h2>
                </div>
              </div>
              <div className="stack-list compact-list">
                {studentData.results.map((item) => (
                  <div key={item.subject} className="result-row row-item">
                    <div>
                      <strong>{item.subject}</strong>
                      <div className="meta-row">{formatDate(item.date)}</div>
                    </div>
                    <span className="grade-pill">{item.grade}</span>
                  </div>
                ))}
              </div>
            </article>

            <article className="panel glass-panel span-2">
              <div className="panel-header">
                <div>
                  <div className="eyebrow">Notices</div>
                  <h2>School announcements</h2>
                </div>
              </div>
              <div className="stack-list">
                {studentData.announcements.map((item) => (
                  <div key={item.title} className="announcement-item row-item">
                    <div className="announcement-head">
                      <strong>{item.title}</strong>
                      <span className="meta-row">{formatDate(item.date)}</span>
                    </div>
                    <p>{item.body}</p>
                  </div>
                ))}
              </div>
            </article>
          </section>
        </main>
      </div>
    </div>
  );
}
