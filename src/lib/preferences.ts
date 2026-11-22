export type BackgroundId = "architectural" | "mechanical" | "civil" | "electrical" | "studio";
export type GlassPresetId = "classic" | "clear" | "minimal";

export type DashboardPreferences = {
  backgroundId: BackgroundId;
  glassPreset: GlassPresetId;
};

export const backgroundCatalog = [
  {
    id: "architectural",
    label: "Architectural engineering",
    url: "https://images.unsplash.com/photo-1511818966892-d7d671e672a2?auto=format&fit=crop&w=1200&q=80",
  },
  {
    id: "mechanical",
    label: "Mechanical engineering",
    url: "https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?auto=format&fit=crop&w=1200&q=80",
  },
  {
    id: "civil",
    label: "Civil engineering",
    url: "https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=1200&q=80",
  },
  {
    id: "electrical",
    label: "Computer and electrical engineering",
    url: "https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80",
  },
  {
    id: "studio",
    label: "Engineering design studio",
    url: "https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=1200&q=80",
  },
] as const;

export const presetCatalog = [
  {
    id: "classic",
    label: "Classic Glass",
    description: "Balanced transparency",
    opacity: "0.72",
    blur: "10px",
    border: "1px solid rgba(255,255,255,0.16)",
    shadow: "0 18px 38px rgba(0,0,0,0.28)",
  },
  {
    id: "clear",
    label: "Clear Glass",
    description: "Higher transparency",
    opacity: "0.82",
    blur: "6px",
    border: "1px solid rgba(255,255,255,0.12)",
    shadow: "0 16px 30px rgba(0,0,0,0.18)",
  },
  {
    id: "minimal",
    label: "Minimal Glass",
    description: "Subtle and understated",
    opacity: "0.68",
    blur: "4px",
    border: "1px solid rgba(255,255,255,0.08)",
    shadow: "0 12px 24px rgba(0,0,0,0.12)",
  },
] as const;

export const defaultPreferences: DashboardPreferences = {
  backgroundId: "architectural",
  glassPreset: "classic",
};

const STORAGE_KEY = "plus-os-student-preferences";

export function getStoredPreferences(): DashboardPreferences {
  if (typeof window === "undefined") {
    return defaultPreferences;
  }

  try {
    const rawValue = window.localStorage.getItem(STORAGE_KEY);
    if (!rawValue) {
      return defaultPreferences;
    }

    const parsed = JSON.parse(rawValue) as Partial<DashboardPreferences>;
    const backgroundExists = backgroundCatalog.some((item) => item.id === parsed.backgroundId);
    const presetExists = presetCatalog.some((item) => item.id === parsed.glassPreset);

    return {
      backgroundId: backgroundExists ? (parsed.backgroundId as BackgroundId) : defaultPreferences.backgroundId,
      glassPreset: presetExists ? (parsed.glassPreset as GlassPresetId) : defaultPreferences.glassPreset,
    };
  } catch {
    return defaultPreferences;
  }
}

export function persistPreferences(preferences: DashboardPreferences) {
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(preferences));
}

/** Server preference sync is not connected yet; the dashboard safely falls back to local preferences. */
export async function fetchPreferencesFromServer(): Promise<DashboardPreferences | null> {
  return null;
}
