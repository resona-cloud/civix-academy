import Link from "next/link";
import { PageHeader } from "@/components/page-header";
import { mockLesson } from "@/lib/lesson-reader/mock-data";

export default function TrainingPage() {
  return <><PageHeader title="Training" description="Manage curricula, courses, modules, and lessons." /><section className="rounded-xl border border-slate-200 bg-white p-6"><p className="text-xs font-semibold uppercase tracking-wider text-sky-700">Mock course</p><h2 className="mt-2 text-xl font-semibold">{mockLesson.course.title}</h2><p className="mt-2 max-w-2xl text-sm leading-6 text-slate-500">Preview the lesson-reader experience with local mock content.</p><Link className="mt-5 inline-block text-sm font-semibold text-sky-700" href={`/training/${mockLesson.course.id}`}>View course -&gt;</Link></section></>;
}
