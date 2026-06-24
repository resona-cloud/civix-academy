import Link from "next/link";
import type { ReactNode } from "react";

const navigation = [
  ["Overview", "/"],
  ["Training", "/training"],
  ["Study Center", "/study"],
  ["Certifications", "/certifications"],
  ["Fieldbook", "/reference"],
  ["Labs", "/labs"],
  ["Instructor", "/instructor"],
  ["Reviews", "/reviews"],
  ["People", "/people"],
  ["Reports", "/reports"],
  ["Admin", "/admin"],
  ["Settings", "/settings"],
] as const;

export function AppShell({ children }: { children: ReactNode }) {
  return (
    <div className="min-h-screen lg:grid lg:grid-cols-[16rem_1fr]">
      <aside className="border-b border-slate-800 bg-slate-950 px-5 py-5 text-white lg:min-h-screen lg:border-b-0 lg:border-r">
        <Link className="block" href="/">
          <span className="text-xs font-semibold uppercase tracking-[0.2em] text-sky-400">CIVIX</span>
          <span className="block text-lg font-semibold">Academy Console</span>
        </Link>
        <nav aria-label="Primary navigation" className="mt-6 flex gap-2 overflow-x-auto pb-1 lg:grid">
          {navigation.map(([label, href]) => (
            <Link className="whitespace-nowrap rounded-md px-3 py-2 text-sm text-slate-300 hover:bg-slate-800 hover:text-white" href={href} key={href}>
              {label}
            </Link>
          ))}
        </nav>
      </aside>
      <div>
        <header className="flex h-16 items-center justify-between border-b border-slate-200 bg-white px-6">
          <span className="text-sm text-slate-500">GovCon Procurement Agent Platform</span>
          <Link aria-label="Account" className="flex h-8 w-8 items-center justify-center rounded-full bg-slate-200 text-xs font-semibold text-slate-600" href="/account">EB</Link>
        </header>
        <main className="mx-auto max-w-7xl p-6 lg:p-10">{children}</main>
      </div>
    </div>
  );
}
