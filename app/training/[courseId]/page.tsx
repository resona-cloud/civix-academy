import Link from "next/link";
import { notFound } from "next/navigation";
import { PageHeader } from "@/components/page-header";
import { getCourseDetail } from "@/lib/training/queries";

type Props = { params: Promise<{ courseId: string }> };

export default async function CourseDetailPage({ params }: Props) {
  const { courseId } = await params;
  const { data, source } = await getCourseDetail(courseId);
  if (!data) notFound();

  const { course, modules } = data;

  return (
    <>
      <PageHeader title={course.title} description={course.description} />
      {source === "mock" && <p className="mb-4 text-xs font-semibold uppercase tracking-wider text-amber-700">Local mock catalog</p>}
      <div className="grid gap-4">
        {modules.map((module_) => (
          <section className="rounded-xl border border-slate-200 bg-white p-6" key={module_.id}>
            <p className="text-sm font-medium text-sky-700">Module {module_.position} - {module_.title}</p>
            <ul className="mt-3 grid gap-2">
              {module_.lessons.map((lesson) => (
                <li key={lesson.id}>
                  <Link className="flex items-center justify-between rounded-lg px-3 py-2 text-sm hover:bg-slate-50" href={`/training/${course.id}/lessons/${lesson.id}`}>
                    <span>{lesson.title}</span>
                    <span className="text-slate-500">{lesson.estimated_minutes ?? "?"} min</span>
                  </Link>
                </li>
              ))}
            </ul>
          </section>
        ))}
      </div>
    </>
  );
}
