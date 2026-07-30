import Link from "next/link";
import { PageHeader } from "@/components/page-header";
import { listPublishedCourses } from "@/lib/training/queries";

export default async function TrainingPage() {
  const { data: courses, source } = await listPublishedCourses();

  return (
    <>
      <PageHeader title="Training" description="Manage curricula, courses, modules, and lessons." />
      {source === "mock" && <p className="mb-4 text-xs font-semibold uppercase tracking-wider text-amber-700">Local mock catalog</p>}
      {courses.length === 0 ? (
        <section className="rounded-xl border border-slate-200 bg-white p-6"><p className="text-sm text-slate-500">No courses are available yet.</p></section>
      ) : (
        <div className="grid gap-4">
          {courses.map((course) => (
            <section className="rounded-xl border border-slate-200 bg-white p-6" key={course.id}>
              <h2 className="text-xl font-semibold">{course.title}</h2>
              <p className="mt-2 max-w-2xl text-sm leading-6 text-slate-500">{course.description}</p>
              <Link className="mt-5 inline-block text-sm font-semibold text-sky-700" href={`/training/${course.id}`}>View course -&gt;</Link>
            </section>
          ))}
        </div>
      )}
    </>
  );
}
