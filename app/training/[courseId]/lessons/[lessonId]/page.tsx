import { notFound } from "next/navigation";
import { LessonReader } from "@/components/lesson-reader/lesson-reader";
import { getLessonReaderData } from "@/lib/training/queries";

type Props = { params: Promise<{ courseId: string; lessonId: string }> };

export default async function LessonReaderPage({ params }: Props) {
  const { courseId, lessonId } = await params;
  const { data, source } = await getLessonReaderData(courseId, lessonId);
  if (!data) notFound();

  return (
    <>
      {source === "mock" && <p className="mb-4 text-xs font-semibold uppercase tracking-wider text-amber-700">Local mock catalog</p>}
      <LessonReader lesson={data} />
    </>
  );
}
