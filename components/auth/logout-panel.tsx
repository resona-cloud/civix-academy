"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabaseClient } from "@/lib/supabase/browser";

export function LogoutPanel() {
  const router = useRouter();
  const [message, setMessage] = useState<string | null>(null);

  async function signOut() {
    const client = createBrowserSupabaseClient();
    if (!client) {
      setMessage("Mock mode: no active Supabase session was changed.");
      return;
    }
    const { error } = await client.auth.signOut();
    setMessage(error ? error.message : "Session cleared. Redirecting...");
    if (!error) { router.replace("/login"); router.refresh(); }
  }

  return <div className="mt-6"><button className="w-full rounded-lg bg-slate-900 px-4 py-3 text-sm font-semibold text-white" onClick={signOut} type="button">Sign out</button>{message ? <p className="mt-4 rounded-lg bg-sky-50 p-3 text-sm text-sky-900">{message}</p> : null}</div>;
}
