"use client";

import Link from "next/link";
import { CSSProperties, useEffect, useMemo, useState } from "react";
import {
  backgroundCatalog,
  defaultPreferences,
  fetchPreferencesFromServer,
  getStoredPreferences,
  persistPreferences,
  presetCatalog,
  type DashboardPreferences,
} from "@/lib/preferences";

function getGreeting() {
  const hour = new Date().getHours();
  if (hour < 12) return "Good morning";
  if (hour < 18) return "Good afternoon";
  return "Good evening";
}

export default function StudentDashboardPage() {
  const [prefs, setPrefs] = useState<DashboardPreferences>(defaultPreferences);

  useEffect(() => {
    let mounted = true;
    (async () => {
      const server = await fetchPreferencesFromServer();
      if (server && mounted) {
        setPrefs(server);
        persistPreferences(server);
        return;
      }

      const stored = getStoredPreferences();
      if (mounted) setPrefs(stored);
    })();
    return () => {
      mounted = false;
    };
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

  // NOTE: This component currently shows limited data until an authentication system is integrated.
  // It reads preferences from the server when available and falls back to localStorage.

  return (
    <div className="dashboard-app" style={shellStyle}>
      <div className="dashboard-shell">
        <aside className="sidebar glass-panel">
          <div className="brand-row">
            <img src="/assets/logo.png" alt="PLUS OS" style={{ width: 120, height: 'auto', objectFit: 'contain' }} />
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
                {/* Real assignment data should come from a protected API; remove hardcoded data when hooked up. */}
                <div className="row-item assignment-row">
                  <div>
                    <div className="label-row">
                      <strong>Bridge Load Analysis Draft</strong>
                      <span className={`status-chip`}>In progress</span>
                    </div>
                    <div className="meta-row">Due 2026-03-05</div>
                  </div>
                  <Link href="/assignments/bridge-load-analysis" className="text-link">
                    Open
                  </Link>
                </div>

                <div className="row-item assignment-row">
                  <div>
                    <div className="label-row">
                      <strong>Circuit Lab Reflection</strong>
                      <span className={`status-chip`}>Needs review</span>
                    </div>
                    <div className="meta-row">Due 2026-03-06</div>
                  </div>
                  <Link href="/assignments/circuit-lab-reflection" className="text-link">
                    Open
                  </Link>
                </div>

                <div className="row-item assignment-row">
                  <div>
                    <div className="label-row">
                      <strong>Material Properties Portfolio</strong>
                      <span className={`status-chip`}>Submitted</span>
                    </div>
                    <div className="meta-row">Due 2026-03-08</div>
                  </div>
                  <Link href="/assignments/material-properties-portfolio" className="text-link">
                    Open
                  </Link>
                </div>
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
                <div className="row-item timetable-row">
                  <div className="time-block">08:30 - 10:00</div>
                  <div>
                    <strong>Engineering Design Studio</strong>
                    <div className="meta-row">Monday</div>
                  </div>
                  <span className="live-badge">Live</span>
                </div>

                <div className="row-item timetable-row">
                  <div className="time-block">10:15 - 11:45</div>
                  <div>
                    <strong>Materials and Structures</strong>
                    <div className="meta-row">Monday</div>
                  </div>
                </div>

                <div className="row-item timetable-row">
                  <div className="time-block">12:30 - 14:00</div>
                  <div>
                    <strong>Digital Systems</strong>
                    <div className="meta-row">Tuesday</div>
                  </div>
                </div>
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
                <div className="result-row row-item">
                  <div>
                    <strong>Engineering Design Studio</strong>
                    <div className="meta-row">Feb 18, 2026</div>
                  </div>
                  <span className="grade-pill">A-</span>
                </div>

                <div className="result-row row-item">
                  <div>
                    <strong>Materials and Structures</strong>
                    <div className="meta-row">Feb 25, 2026</div>
                  </div>
                  <span className="grade-pill">B+</span>
                </div>

                <div className="result-row row-item">
                  <div>
                    <strong>Digital Systems</strong>
                    <div className="meta-row">Mar 03, 2026</div>
                  </div>
                  <span className="grade-pill">A</span>
                </div>
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
                <div className="announcement-item row-item">
                  <div className="announcement-head">
                    <strong>Library access update</strong>
                    <span className="meta-row">Mar 02, 2026</span>
                  </div>
                  <p>The engineering library remains open until 18:00 for project review and model preparation.</p>
                </div>

                <div className="announcement-item row-item">
                  <div className="announcement-head">
                    <strong>Lab safety briefing</strong>
                    <span className="meta-row">Mar 03, 2026</span>
                  </div>
                  <p>All students must sign the digital safety checklist before the workshop session on Thursday.</p>
                </div>
              </div>
            </article>
          </section>
        </main>
      </div>
    </div>
  );
}
