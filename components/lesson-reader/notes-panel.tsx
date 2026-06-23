type Props = {
  pageTitle: string;
  note: string;
  onChange: (note: string) => void;
};

export function NotesPanel({ pageTitle, note, onChange }: Props) {
  return (
    <aside className="border-t border-slate-200 bg-amber-50/40 p-5 xl:border-l xl:border-t-0">
      <p className="text-xs font-semibold uppercase tracking-wider text-amber-800">My notes</p>
      <p className="mt-2 text-xs text-slate-500">Notes for “{pageTitle}”</p>
      <textarea aria-label={`Notes for ${pageTitle}`} className="mt-4 min-h-56 w-full resize-y rounded-lg border border-amber-200 bg-white p-3 text-sm leading-6 outline-none focus:border-amber-500 focus:ring-2 focus:ring-amber-100" onChange={(event) => onChange(event.target.value)} placeholder="Capture a takeaway or question…" value={note} />
      <p className="mt-2 text-xs text-slate-400">Saved locally for this session.</p>
    </aside>
  );
}
