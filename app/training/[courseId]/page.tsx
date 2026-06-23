import Link from "next/link";
import { PageHeader } from "@/components/page-header";
import { mockLesson } from "@/lib/lesson-reader/mock-data";

export default function CourseDetailPage() {
  return <><PageHeader title={mockLesson.course.title} description="Mock course detail for the lesson reader scaffold." /><section className="rounded-xl border border-slate-200 bg-white p-6"><p className="text-sm font-medium text-sky-700">Module 1 - Foundations</p><h2 className="mt-2 text-xl font-semibold">{mockLesson.lesson.title}</h2><p className="mt-2 text-sm text-slate-500">{mockLesson.pages.length} lesson pages - {mockLesson.lesson.estimated_minutes} minutes</p><Link className="mt-5 inline-block rounded-lg bg-slate-900 px-4 py-2 text-sm font-medium text-white" href={`/training/${mockLesson.course.id}/lessons/${mockLesson.lesson.id}`}>Open lesson reader</Link></section></>;
}
