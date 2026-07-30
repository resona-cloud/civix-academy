import type { LessonModule } from "@/lib/lesson-reader/types";

export type TrainingSource = "supabase" | "mock";

export type TrainingResult<T> = {
  data: T;
  source: TrainingSource;
};

export type CourseSummary = {
  id: string;
  slug: string;
  title: string;
  description: string;
  status: "draft" | "published" | "archived";
  position: number;
  estimated_minutes: number | null;
};

export type CourseDetail = {
  course: CourseSummary;
  modules: LessonModule[];
};
