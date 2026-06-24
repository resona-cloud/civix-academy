"use client";

import { useState, type FormEvent } from "react";
import { useRouter } from "next/navigation";
import { createBrowserSupabaseClient, isBrowserSupabaseConfigured } from "@/lib/supabase/browser";

export function LoginForm({ nextPath = "/account" }: { nextPath?: string }) {
  const router = useRouter();
  const configured = isBrowserSupabaseConfigured();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!configured) {
      setMessage("Mock mode: sign-in UI accepted the request without creating a session.");
      return;
    }

    const client = createBrowserSupabaseClient();
    if (!client) return;
    setSubmitting(true);
    const { error } = await client.auth.signInWithPassword({ email, password });
    setMessage(error ? error.message : "Signed in. Redirecting...");
    setSubmitting(false);
    if (!error) { router.replace(nextPath); router.refresh(); }
  }

  return <form className="mt-6 grid gap-4" onSubmit={submit}><label className="text-sm font-medium">Email<input autoComplete="email" className="mt-2 block w-full rounded-lg border border-slate-300 px-4 py-3 font-normal" onChange={(event) => setEmail(event.target.value)} required type="email" value={email} /></label><label className="text-sm font-medium">Password<input autoComplete="current-password" className="mt-2 block w-full rounded-lg border border-slate-300 px-4 py-3 font-normal" minLength={6} onChange={(event) => setPassword(event.target.value)} required type="password" value={password} /></label><button className="rounded-lg bg-slate-900 px-4 py-3 text-sm font-semibold text-white disabled:opacity-50" disabled={submitting} type="submit">{submitting ? "Signing in..." : "Sign in"}</button>{message ? <p className="rounded-lg bg-sky-50 p-3 text-sm leading-6 text-sky-900">{message}</p> : null}<p className="text-xs text-slate-400">Mode: {configured ? "Supabase browser auth available" : "mock fallback - Supabase env vars missing"}</p></form>;
}
