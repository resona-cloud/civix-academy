import type { CourseProgress } from "@/lib/learning-engine/types";

function ProgressBar({ value }: { value: number }) {
  return <div className="h-2 overflow-hidden rounded-full bg-slate-200"><div className="h-full rounded-full bg-sky-600" style={{ width: `${value}%` }} /></div>;
}

export function ProgressTracker({ progress }: { progress: CourseProgress }) {
  return (
    <section className="rounded-xl border border-slate-200 bg-white p-6">
      <div className="flex items-end justify-between gap-4"><div><p className="text-xs font-semibold uppercase tracking-wider text-sky-700">Course progress</p><h2 className="mt-1 text-xl font-semibold">{progress.title}</h2></div><strong className="text-2xl">{progress.progress_percent}%</strong></div>
      <div className="mt-4"><ProgressBar value={progress.progress_percent} /></div>
      <div className="mt-6 grid gap-4 lg:grid-cols-2">{progress.modules.map((module) => <article className="rounded-lg border border-slate-200 p-4" key={module.module_id}><div className="flex justify-between gap-3"><h3 className="font-semibold">{module.title}</h3><span className="text-sm text-slate-500">{module.progress_percent}%</span></div><div className="mt-3"><ProgressBar value={module.progress_percent} /></div><ul className="mt-4 space-y-2">{module.lessons.map((lesson) => <li className="flex items-center justify-between gap-3 text-sm" key={lesson.lesson_id}><span className="text-slate-600">{lesson.title}</span><span className={`rounded-full px-2 py-0.5 text-xs ${lesson.status === "completed" ? "bg-emerald-50 text-emerald-700" : lesson.status === "in_progress" ? "bg-sky-50 text-sky-700" : "bg-slate-100 text-slate-500"}`}>{lesson.status.replaceAll("_", " ")}</span></li>)}</ul></article>)}</div>
      <div className="mt-6 border-t border-slate-200 pt-5"><h3 className="text-sm font-semibold">Assessment status</h3><div className="mt-3 grid gap-2">{progress.assessments.map((assessment) => <div className="flex items-center justify-between gap-3 rounded-lg bg-slate-50 px-4 py-3 text-sm" key={assessment.assessment_id}><span>{assessment.title}</span><span className="font-medium capitalize text-slate-600">{assessment.status.replaceAll("_", " ")}{assessment.score !== null ? ` - ${assessment.score}%` : ""}</span></div>)}</div></div>
    </section>
  );
}
