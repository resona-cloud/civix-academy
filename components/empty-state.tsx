export function EmptyState({ title, description = "This area will be implemented in a later phase." }: { title: string; description?: string }) {
  return <section className="rounded-xl border border-dashed border-slate-300 bg-white px-6 py-12 text-center"><h2 className="text-lg font-semibold">{title}</h2><p className="mt-2 text-sm text-slate-500">{description}</p></section>;
}
