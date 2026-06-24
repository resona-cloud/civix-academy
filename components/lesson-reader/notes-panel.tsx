type Props = {
  pageTitle: string;
  note: string;
  onChange: (note: string) => void;
  onSave: () => void | Promise<void>;
  saving: boolean;
  persistenceMode: "supabase" | "local";
};

export function NotesPanel({ pageTitle, note, onChange, onSave, saving, persistenceMode }: Props) {
  return (
    <aside className="border-t border-slate-200 bg-amber-50/40 p-5 xl:border-l xl:border-t-0">
      <p className="text-xs font-semibold uppercase tracking-wider text-amber-800">My notes</p>
      <p className="mt-2 text-xs text-slate-500">Notes for &quot;{pageTitle}&quot;</p>
      <textarea aria-label={`Notes for ${pageTitle}`} className="mt-4 min-h-56 w-full resize-y rounded-lg border border-amber-200 bg-white p-3 text-sm leading-6 outline-none focus:border-amber-500 focus:ring-2 focus:ring-amber-100" onChange={(event) => onChange(event.target.value)} placeholder="Capture a takeaway or question..." value={note} />
      <button className="mt-3 w-full rounded-lg bg-amber-700 px-4 py-2 text-sm font-medium text-white disabled:opacity-50" disabled={saving} onClick={onSave} type="button">{saving ? "Saving..." : note.trim() ? "Save note" : "Delete saved note"}</button>
      <p className="mt-2 text-xs text-slate-400">Storage: {persistenceMode === "supabase" ? "Supabase" : "local mock fallback"}</p>
    </aside>
  );
}
