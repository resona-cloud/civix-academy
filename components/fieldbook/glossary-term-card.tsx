import type { GlossaryTerm } from "@/lib/fieldbook/types";

export function GlossaryTermCard({ term }: { term: GlossaryTerm }) {
  return <article className="rounded-xl border border-slate-200 bg-white p-5"><p className="text-xs font-semibold uppercase tracking-wider text-violet-600">Glossary</p><h3 className="mt-2 font-semibold">{term.term}</h3><p className="mt-2 text-sm leading-6 text-slate-600">{term.definition}</p></article>;
}
