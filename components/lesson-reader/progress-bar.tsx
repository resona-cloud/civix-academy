export function ProgressBar({ completed, total }: { completed: number; total: number }) {
  const percent = total === 0 ? 0 : Math.round((completed / total) * 100);

  return (
    <div aria-label={`Lesson progress: ${percent}%`}>
      <div className="mb-2 flex items-center justify-between text-xs font-medium text-slate-600">
        <span>Lesson progress</span><span>{percent}%</span>
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-slate-200">
        <div className="h-full rounded-full bg-sky-600 transition-[width]" style={{ width: `${percent}%` }} />
      </div>
    </div>
  );
}
