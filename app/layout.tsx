import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "PLUS OS — Progressive Learning and Unified School Operating System",
  description: "A unified operating system for progressive learning and school operations.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
