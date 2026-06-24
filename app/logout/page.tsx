import Link from "next/link";
import { LogoutPanel } from "@/components/auth/logout-panel";

export default function LogoutPage() {
  return <div className="mx-auto max-w-md rounded-2xl border border-slate-200 bg-white p-7 shadow-sm"><p className="text-xs font-semibold uppercase tracking-[0.18em] text-sky-700">Session</p><h1 className="mt-2 text-3xl font-semibold">Sign out</h1><p className="mt-2 text-sm leading-6 text-slate-600">This clears the cookie-backed Supabase browser session when configured. Mock mode remains a no-op.</p><LogoutPanel /><Link className="mt-5 block text-center text-sm font-medium text-sky-700" href="/login">Return to sign in</Link></div>;
}
