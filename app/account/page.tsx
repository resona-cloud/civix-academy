import Link from "next/link";
import { AuthGate } from "@/components/auth/auth-gate";
import { getCurrentProfile } from "@/lib/auth/session";
import { roleLabels, rolePermissions } from "@/lib/auth/roles";

export const dynamic = "force-dynamic";

export default async function AccountPage() {
  const user = await getCurrentProfile();
  if (!user) return <AuthGate user={null}><></></AuthGate>;
  const permissions = Array.from(new Set(user.roles.flatMap((role) => rolePermissions[role])));

  return <AuthGate user={user}><div className="mx-auto max-w-3xl"><header className="rounded-2xl bg-slate-950 p-8 text-white"><p className="text-xs font-semibold uppercase tracking-[0.18em] text-sky-400">Account</p><h1 className="mt-2 text-3xl font-semibold">{user.display_name}</h1><p className="mt-2 text-slate-300">{user.email} - {user.classification}</p><p className="mt-5 text-xs text-slate-400">Current source: {user.source === "supabase" ? "authenticated Supabase profile" : "mock fallback"}</p></header><div className="mt-6 grid gap-6 md:grid-cols-2"><section className="rounded-xl border border-slate-200 bg-white p-6"><p className="text-xs font-semibold uppercase tracking-wider text-sky-700">Roles</p><div className="mt-4 flex flex-wrap gap-2">{user.roles.length ? user.roles.map((role) => <span className="rounded-full bg-sky-50 px-3 py-1 text-sm font-medium text-sky-800" key={role}>{roleLabels[role]}</span>) : <span className="text-sm text-slate-500">No application roles assigned.</span>}</div></section><section className="rounded-xl border border-slate-200 bg-white p-6"><p className="text-xs font-semibold uppercase tracking-wider text-sky-700">Effective permissions</p><ul className="mt-4 grid gap-2 text-sm text-slate-600">{permissions.map((permission) => <li key={permission}>{permission.replaceAll("_", " ")}</li>)}</ul></section></div><div className="mt-6 flex gap-4"><Link className="rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-medium" href="/login">Sign-in page</Link><Link className="rounded-lg bg-slate-900 px-4 py-2 text-sm font-medium text-white" href="/logout">Sign out</Link></div></div></AuthGate>;
}
