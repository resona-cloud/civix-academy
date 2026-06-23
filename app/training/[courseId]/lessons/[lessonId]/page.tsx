import { LessonReader } from "@/components/lesson-reader/lesson-reader";
import { mockLesson } from "@/lib/lesson-reader/mock-data";

export default function LessonReaderPage() {
  return <LessonReader lesson={mockLesson} />;
}
