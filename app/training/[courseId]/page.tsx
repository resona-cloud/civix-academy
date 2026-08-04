import Link from "next/link";
import { notFound } from "next/navigation";
import { PageHeader } from "@/components/page-header";
import { getCourseDetail, getLessonProgressStatuses } from "@/lib/training/queries";

type Props = { params: Promise<{ courseId: string }> };

export default async function CourseDetailPage({ params }: Props) {
  const { courseId } = await params;
  const { data, source } = await getCourseDetail(courseId);
  if (!data) notFound();

  const { course, modules } = data;

  // Sequential lock: lesson N requires lesson N-1 (in course-wide module ->
  // lesson order) to be completed. Mock mode has no real progress tracking
  // to enforce this against, so every lesson stays unlocked there.
  const orderedLessonIds = modules.flatMap((module_) => module_.lessons.map((lesson) => lesson.id));
  const progressByLesson = source === "supabase" ? await getLessonProgressStatuses(orderedLessonIds) : {};
  const unlockedLessonIds = new Set<string>();
  let priorCompleted = true;
  for (const lessonId of orderedLessonIds) {
    if (source !== "supabase" || priorCompleted) unlockedLessonIds.add(lessonId);
    priorCompleted = progressByLesson[lessonId] === "completed";
  }

  return (
    <>
      <PageHeader title={course.title} description={course.description} />
      {source === "mock" && <p className="mb-4 text-xs font-semibold uppercase tracking-wider text-amber-700">Local mock catalog</p>}
      <div className="grid gap-4">
        {modules.map((module_) => (
          <section className="rounded-xl border border-slate-200 bg-white p-6" key={module_.id}>
            <p className="text-sm font-medium text-sky-700">Module {module_.position} - {module_.title}</p>
            <ul className="mt-3 grid gap-2">
              {module_.lessons.map((lesson) => {
                const unlocked = unlockedLessonIds.has(lesson.id);
                const completed = progressByLesson[lesson.id] === "completed";
                return (
                  <li key={lesson.id}>
                    {unlocked ? (
                      <Link className="flex items-center justify-between rounded-lg px-3 py-2 text-sm hover:bg-slate-50" href={`/training/${course.id}/lessons/${lesson.id}`}>
                        <span className={completed ? "text-slate-400 line-through" : undefined}>{lesson.title}</span>
                        <span className="text-slate-500">{completed ? "Completed" : `${lesson.estimated_minutes ?? "?"} min`}</span>
                      </Link>
                    ) : (
                      <span aria-disabled="true" className="flex items-center justify-between rounded-lg px-3 py-2 text-sm text-slate-400">
                        <span>{lesson.title}</span>
                        <span>Locked</span>
                      </span>
                    )}
                  </li>
                );
              })}
            </ul>
          </section>
        ))}
      </div>
    </>
  );
}
