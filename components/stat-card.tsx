export function StatCard({ label, value }: { label: string; value: string }) {
  return <section className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm"><div className="text-sm text-slate-500">{label}</div><strong className="mt-2 block text-2xl">{value}</strong></section>;
}
