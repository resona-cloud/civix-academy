import { mockLesson } from "@/lib/lesson-reader/mock-data";
import type { CourseDetail, CourseSummary } from "./types";

const totalEstimatedMinutes = mockLesson.modules.reduce(
  (total, module_) => total + module_.lessons.reduce((moduleTotal, lesson) => moduleTotal + (lesson.estimated_minutes ?? 0), 0),
  0,
);

export const mockCourseSummary: CourseSummary = {
  id: mockLesson.course.id,
  slug: mockLesson.course.slug,
  title: mockLesson.course.title,
  description: "Preview the lesson-reader experience with local mock content.",
  status: "published",
  position: 1,
  estimated_minutes: totalEstimatedMinutes,
};

export const mockCourseCatalog: CourseSummary[] = [mockCourseSummary];

export const mockCourseDetail: CourseDetail = {
  course: mockCourseSummary,
  modules: mockLesson.modules,
};
