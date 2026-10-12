"use client";

import Link from "next/link";
import { CSSProperties, useEffect, useState } from "react";
import {
  backgroundCatalog,
  defaultPreferences,
  getStoredPreferences,
  persistPreferences,
  presetCatalog,
  type DashboardPreferences,
} from "@/lib/preferences";

export default function StudentSettingsPage() {
  const [preferences, setPreferences] = useState<DashboardPreferences>(defaultPreferences);
  const [draft, setDraft] = useState<DashboardPreferences>(defaultPreferences);

  useEffect(() => {
    const stored = getStoredPreferences();
    setPreferences(stored);
    setDraft(stored);
  }, []);

  const selectedBackground = backgroundCatalog.find((background) => background.id === draft.backgroundId) ?? backgroundCatalog[0];
  const selectedPreset = presetCatalog.find((preset) => preset.id === draft.glassPreset) ?? presetCatalog[0];

  useEffect(() => {
    const root = document.documentElement;
    root.style.setProperty("--dashboard-bg-image", `url(${selectedBackground.url})`);
    root.style.setProperty("--glass-opacity", selectedPreset.opacity);
    root.style.setProperty("--glass-blur", selectedPreset.blur);
    root.style.setProperty("--glass-border", selectedPreset.border);
    root.style.setProperty("--glass-shadow", selectedPreset.shadow);
  }, [selectedBackground, selectedPreset]);

  const handleApply = () => {
    persistPreferences(draft);
    setPreferences(draft);
  };

  const handleReset = () => {
    const reset = defaultPreferences;
    setDraft(reset);
    persistPreferences(reset);
    setPreferences(reset);
  };

  const handleCancel = () => {
    setDraft(preferences);
  };

  const previewStyle = {
    ["--dashboard-bg-image" as any]: `url(${selectedBackground.url})`,
    ["--glass-opacity" as any]: selectedPreset.opacity,
    ["--glass-blur" as any]: selectedPreset.blur,
    ["--glass-border" as any]: selectedPreset.border,
    ["--glass-shadow" as any]: selectedPreset.shadow,
  } as CSSProperties;

  return (
    <div className="settings-page dashboard-app settings-preview-mode" style={previewStyle}>
      <div className="dashboard-shell settings-shell">
        <aside className="sidebar glass-panel">
          <div className="brand-row">
            <div className="brand-mark">P</div>
            <div>
              <div className="brand-title">PLUS OS</div>
              <div className="brand-subtitle">Student</div>
            </div>
          </div>

          <nav aria-label="Student navigation" className="nav-stack">
            <Link href="/" className="nav-link">Dashboard</Link>
            <Link href="/settings" className="nav-link active" aria-current="page">Settings</Link>
          </nav>
        </aside>

        <main className="main-panel settings-main">
          <header className="topbar settings-header">
            <div>
              <div className="eyebrow">Preferences</div>
              <h1>Dashboard personalization</h1>
            </div>
            <div className="settings-actions">
              <button type="button" className="secondary-button" onClick={handleCancel}>
                Cancel
              </button>
              <button type="button" className="secondary-button" onClick={handleReset}>
                Reset to default
              </button>
              <button type="button" className="primary-button" onClick={handleApply}>
                Apply
              </button>
            </div>
          </header>

          <section className="settings-grid">
            <div className="glass-panel settings-section">
              <div className="panel-header">
                <div>
                  <div className="eyebrow">Backgrounds</div>
                  <h2>Study environment images</h2>
                </div>
              </div>
              <div className="theme-grid">
                {backgroundCatalog.map((background) => (
                  <button
                    key={background.id}
                    type="button"
                    className={`theme-card ${draft.backgroundId === background.id ? "selected" : ""}`}
                    onClick={() => setDraft((current) => ({ ...current, backgroundId: background.id }))}
                    aria-pressed={draft.backgroundId === background.id}
                  >
                    <img src={background.url} alt={background.label} loading="lazy" />
                    <span>{background.label}</span>
                  </button>
                ))}
              </div>
            </div>

            <div className="glass-panel settings-section">
              <div className="panel-header">
                <div>
                  <div className="eyebrow">Glass</div>
                  <h2>Appearance presets</h2>
                </div>
              </div>
              <div className="preset-list">
                {presetCatalog.map((preset) => (
                  <button
                    key={preset.id}
                    type="button"
                    className={`preset-item ${draft.glassPreset === preset.id ? "selected" : ""}`}
                    onClick={() => setDraft((current) => ({ ...current, glassPreset: preset.id }))}
                    aria-pressed={draft.glassPreset === preset.id}
                  >
                    <div className="preset-swatch">
                      <div className="swatch-panel" />
                    </div>
                    <div>
                      <strong>{preset.label}</strong>
                      <div className="meta-row">{preset.description}</div>
                    </div>
                  </button>
                ))}
              </div>
            </div>

            <div className="glass-panel settings-section preview-section">
              <div className="panel-header">
                <div>
                  <div className="eyebrow">Live preview</div>
                  <h2>Display preferences</h2>
                </div>
              </div>

              <div className="preview-surface glass-panel" style={{ backgroundImage: `linear-gradient(rgba(0,0,0,0.30), rgba(0,0,0,0.38)), url(${selectedBackground.url})` }}>
                <div className="mini-sidebar glass-panel">Dashboard</div>
                <div className="mini-main">
                  <div className="mini-header glass-panel">
                    <span>Good morning</span>
                    <span>View</span>
                  </div>
                  <div className="mini-cards">
                    <div className="mini-card glass-panel" />
                    <div className="mini-card glass-panel" />
                    <div className="mini-card glass-panel" />
                  </div>
                </div>
              </div>
            </div>
          </section>
        </main>
      </div>
    </div>
  );
}
