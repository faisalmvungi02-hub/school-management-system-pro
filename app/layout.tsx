import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "PLUS OS Student Dashboard",
  description: "Student dashboard and settings experience for PLUS OS.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
