import type { ReactNode } from "react";

export function StudyPanel({ eyebrow, title, children }: { eyebrow: string; title: string; children: ReactNode }) {
  return <section className="rounded-xl border border-slate-200 bg-white p-6"><p className="text-xs font-semibold uppercase tracking-wider text-violet-700">{eyebrow}</p><h2 className="mt-1 text-xl font-semibold">{title}</h2><div className="mt-5">{children}</div></section>;
}
