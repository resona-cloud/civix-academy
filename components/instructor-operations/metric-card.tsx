export function MetricCard({ label, value, detail }: { label: string; value: string | number; detail: string }) {
  return <article className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm"><p className="text-sm text-slate-500">{label}</p><strong className="mt-2 block text-3xl">{value}</strong><p className="mt-2 text-xs text-slate-400">{detail}</p></article>;
}
