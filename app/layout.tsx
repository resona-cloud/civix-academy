import type { Metadata } from "next";
import type { ReactNode } from "react";
import { AppShell } from "@/components/app-shell";
import { getCurrentProfile } from "@/lib/auth/session";
import "./globals.css";

export const metadata: Metadata = {
  title: "CIVIX Academy Console",
  description: "Administration console for CIVIX Academy",
};

export default async function RootLayout({ children }: Readonly<{ children: ReactNode }>) {
  const currentUser = await getCurrentProfile();

  return (
    <html lang="en">
      <body><AppShell currentUser={currentUser}>{children}</AppShell></body>
    </html>
  );
}
