import { NextRequest, NextResponse } from "next/server";
import { getPersistenceContext } from "@/lib/persistence/server-auth";
import type { ProgressStatus, SaveProgressInput } from "@/lib/persistence/types";
import { createServiceRoleSupabaseClient } from "@/lib/supabase/service-role";

const statuses: ProgressStatus[] = ["not_started", "in_progress", "completed"];

type PersistenceContext = Awaited<ReturnType<typeof getPersistenceContext>>;

// Nothing else in the codebase rolls per-lesson progress up to the
// enrollment -- this is the only place a lesson completion is observed, so
// it's the only place that can notice a course just became fully complete.
// Runs only when this save just completed the lesson (course completion
// can't newly become true otherwise), and only writes once (skips if the
// enrollment is already completed) so revisiting a finished lesson doesn't
// keep resetting next_quick_review_due_at.
async function rollupCourseCompletion(context: NonNullable<PersistenceContext>, lessonId: string) {
  const lesson = await context.client
    .from("lessons")
    .select("modules(course_id)")
    .eq("id", lessonId)
    .maybeSingle();
  const courseId = (lesson.data?.modules as { course_id: string } | null)?.course_id;
  if (!courseId) return;

  const { data: isComplete } = await context.client.rpc("has_completed_course", { p_course_id: courseId });
  if (!isComplete) return;

  const enrollment = await context.client
    .from("enrollments")
    .select("id, status, courses(initial_review_interval_days)")
    .eq("user_id", context.user.id)
    .eq("course_id", courseId)
    .maybeSingle();
  if (!enrollment.data || enrollment.data.status === "completed") return;

  const intervalDays = (enrollment.data.courses as { initial_review_interval_days: number } | null)?.initial_review_interval_days ?? 30;
  const serviceClient = createServiceRoleSupabaseClient();
  if (!serviceClient) return;

  const now = new Date();
  const dueAt = new Date(now.getTime() + intervalDays * 24 * 60 * 60 * 1000);
  await serviceClient
    .from("enrollments")
    .update({ status: "completed", completed_at: now.toISOString(), next_quick_review_due_at: dueAt.toISOString() })
    .eq("id", enrollment.data.id);
}

export async function GET(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const lessonId = request.nextUrl.searchParams.get("lesson_id");
  if (!lessonId) return NextResponse.json({ error: "Missing lesson id" }, { status: 400 });
  const { data, error } = await context.client.from("user_progress").select("id, user_id, lesson_id, last_page_id, status, progress_percent, visited_page_ids, completed_page_ids, started_at, completed_at, updated_at").eq("user_id", context.user.id).eq("lesson_id", lessonId).maybeSingle();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json({ data });
}

export async function POST(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const input = await request.json() as SaveProgressInput;
  if (!input.lesson_id || !input.last_page_id || !statuses.includes(input.status) || !Array.isArray(input.visited_page_ids) || !Array.isArray(input.completed_page_ids) || !Number.isFinite(input.progress_percent)) return NextResponse.json({ error: "Invalid progress input" }, { status: 400 });
  const progressPercent = Math.min(100, Math.max(0, input.progress_percent));
  const existing = await context.client.from("user_progress").select("started_at").eq("user_id", context.user.id).eq("lesson_id", input.lesson_id).maybeSingle();
  if (existing.error) return NextResponse.json({ error: existing.error.message }, { status: 400 });
  const values = { user_id: context.user.id, lesson_id: input.lesson_id, last_page_id: input.last_page_id, status: input.status, progress_percent: progressPercent, visited_page_ids: Array.from(new Set(input.visited_page_ids)), completed_page_ids: Array.from(new Set(input.completed_page_ids)), started_at: existing.data?.started_at ?? new Date().toISOString(), completed_at: input.status === "completed" ? new Date().toISOString() : null };
  const { data, error } = await context.client.from("user_progress").upsert(values, { onConflict: "user_id,lesson_id" }).select("id, user_id, lesson_id, last_page_id, status, progress_percent, visited_page_ids, completed_page_ids, started_at, completed_at, updated_at").single();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  if (input.status === "completed") await rollupCourseCompletion(context, input.lesson_id);
  return NextResponse.json({ data });
}
