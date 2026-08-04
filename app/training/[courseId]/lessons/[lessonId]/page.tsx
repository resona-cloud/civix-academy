import { notFound } from "next/navigation";
import { LessonReader } from "@/components/lesson-reader/lesson-reader";
import { getLessonProgressStatuses, getLessonReaderData } from "@/lib/training/queries";

type Props = { params: Promise<{ courseId: string; lessonId: string }> };

export default async function LessonReaderPage({ params }: Props) {
  const { courseId, lessonId } = await params;
  const { data, source } = await getLessonReaderData(courseId, lessonId);
  if (!data) notFound();

  const orderedLessonIds = data.modules.flatMap((module_) => module_.lessons.map((item) => item.id));
  const progressByLesson = source === "supabase" ? await getLessonProgressStatuses(orderedLessonIds) : {};
  const completedLessonIds = orderedLessonIds.filter((id) => progressByLesson[id] === "completed");

  return (
    <>
      {source === "mock" && <p className="mb-4 text-xs font-semibold uppercase tracking-wider text-amber-700">Local mock catalog</p>}
      <LessonReader completedLessonIds={completedLessonIds} lesson={data} />
    </>
  );
}
