import "server-only";

import { mockLesson } from "@/lib/lesson-reader/mock-data";
import type { ContentBlock, LessonModule, LessonNavItem, LessonPage, LessonReaderData } from "@/lib/lesson-reader/types";
import { createServerSupabaseClient, isServerSupabaseConfigured } from "@/lib/supabase/server";
import { mockCourseCatalog, mockCourseDetail } from "./mock-data";
import type { CourseDetail, CourseSummary, TrainingResult } from "./types";

function sortByPosition<T extends { position: number }>(items: readonly T[] | null | undefined): T[] {
  return [...(items ?? [])].sort((a, b) => a.position - b.position);
}

export async function listPublishedCourses(): Promise<TrainingResult<CourseSummary[]>> {
  if (!isServerSupabaseConfigured()) return { data: mockCourseCatalog, source: "mock" };

  const client = await createServerSupabaseClient();
  if (!client) return { data: [], source: "supabase" };

  const { data, error } = await client
    .from("courses")
    .select("id, slug, title, description, status, position, estimated_minutes")
    .order("position", { ascending: true });

  if (error || !data) return { data: [], source: "supabase" };
  return { data: data as CourseSummary[], source: "supabase" };
}

type RawCourseDetailRow = {
  id: string;
  slug: string;
  title: string;
  description: string;
  status: CourseSummary["status"];
  position: number;
  estimated_minutes: number | null;
  modules: {
    id: string;
    course_id: string;
    title: string;
    position: number;
    lessons: LessonNavItem[];
  }[];
};

export async function getCourseDetail(courseId: string): Promise<TrainingResult<CourseDetail | null>> {
  if (!isServerSupabaseConfigured()) {
    if (mockCourseDetail.course.id !== courseId) return { data: null, source: "mock" };
    return { data: mockCourseDetail, source: "mock" };
  }

  const client = await createServerSupabaseClient();
  if (!client) return { data: null, source: "supabase" };

  const { data, error } = await client
    .from("courses")
    .select(`
      id, slug, title, description, status, position, estimated_minutes,
      modules ( id, course_id, title, position,
        lessons ( id, module_id, title, position, estimated_minutes, is_check )
      )
    `)
    .eq("id", courseId)
    .maybeSingle();

  if (error || !data) return { data: null, source: "supabase" };

  const row = data as unknown as RawCourseDetailRow;
  const modules: LessonModule[] = sortByPosition(row.modules).map((module_) => ({
    id: module_.id,
    course_id: module_.course_id,
    title: module_.title,
    position: module_.position,
    lessons: sortByPosition(module_.lessons),
  }));

  const course: CourseSummary = {
    id: row.id,
    slug: row.slug,
    title: row.title,
    description: row.description,
    status: row.status,
    position: row.position,
    estimated_minutes: row.estimated_minutes,
  };

  return { data: { course, modules }, source: "supabase" };
}

type RawLessonWithPagesRow = {
  id: string;
  module_id: string;
  title: string;
  position: number;
  estimated_minutes: number | null;
  is_check: boolean;
  lesson_pages: {
    id: string;
    lesson_id: string;
    title: string;
    position: number;
    content_blocks: ContentBlock[];
  }[];
};

export async function getLessonReaderData(courseId: string, lessonId: string): Promise<TrainingResult<LessonReaderData | null>> {
  if (!isServerSupabaseConfigured()) {
    if (mockLesson.course.id !== courseId || mockLesson.lesson.id !== lessonId) return { data: null, source: "mock" };
    return { data: mockLesson, source: "mock" };
  }

  const client = await createServerSupabaseClient();
  if (!client) return { data: null, source: "supabase" };

  const [courseDetailResult, lessonResult] = await Promise.all([
    getCourseDetail(courseId),
    client
      .from("lessons")
      .select(`
        id, module_id, title, position, estimated_minutes, is_check,
        modules!inner ( course_id ),
        lesson_pages (
          id, lesson_id, title, position,
          content_blocks ( id, lesson_page_id, fieldbook_article_id, block_type, position, content )
        )
      `)
      .eq("id", lessonId)
      .eq("modules.course_id", courseId)
      .maybeSingle(),
  ]);

  if (!courseDetailResult.data) return { data: null, source: "supabase" };
  if (lessonResult.error || !lessonResult.data) return { data: null, source: "supabase" };

  const row = lessonResult.data as unknown as RawLessonWithPagesRow;

  const lesson: LessonNavItem = {
    id: row.id,
    module_id: row.module_id,
    title: row.title,
    position: row.position,
    estimated_minutes: row.estimated_minutes,
    is_check: row.is_check,
  };

  const pages: LessonPage[] = sortByPosition(row.lesson_pages).map((page) => ({
    id: page.id,
    lesson_id: page.lesson_id,
    title: page.title,
    position: page.position,
    content_blocks: sortByPosition(page.content_blocks),
  }));

  return {
    data: {
      course: {
        id: courseDetailResult.data.course.id,
        slug: courseDetailResult.data.course.slug,
        title: courseDetailResult.data.course.title,
      },
      lesson,
      modules: courseDetailResult.data.modules,
      pages,
    },
    source: "supabase",
  };
}
