import Link from "next/link";
import type { ReviewSubmission } from "@/lib/instructor-operations/types";

const priorityStyle = { low: "bg-slate-100 text-slate-600", normal: "bg-sky-50 text-sky-700", high: "bg-amber-50 text-amber-800", urgent: "bg-rose-50 text-rose-800" };

export function ReviewCard({ submission }: { submission: ReviewSubmission }) {
  return <article className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm"><div className="flex flex-wrap items-center justify-between gap-3"><div className="flex gap-2"><span className="rounded bg-indigo-50 px-2 py-1 text-xs font-medium capitalize text-indigo-700">{submission.submission_type.replaceAll("_", " ")}</span><span className={`rounded px-2 py-1 text-xs font-medium capitalize ${priorityStyle[submission.priority]}`}>{submission.priority}</span></div><span className="text-xs font-medium capitalize text-slate-500">{submission.status.replaceAll("_", " ")}</span></div><h2 className="mt-4 text-lg font-semibold">{submission.title}</h2><p className="mt-1 text-sm text-slate-500">{submission.learner_name}</p><p className="mt-3 text-sm leading-6 text-slate-600">{submission.response_summary}</p><div className="mt-4 flex flex-wrap justify-between gap-3 border-t border-slate-100 pt-4 text-xs text-slate-500"><span>Due {submission.due_at.slice(0, 10)}</span><span>{submission.reviewer_name ?? "Unassigned"}</span></div><Link className="mt-4 inline-block text-sm font-semibold text-indigo-700" href={`/reviews/${submission.id}`}>Open review -&gt;</Link></article>;
}
