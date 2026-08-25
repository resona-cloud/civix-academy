import { NextRequest, NextResponse } from "next/server";
import { mapAssessmentQuestionRow } from "@/lib/study-center/queries";
import { scoreQuestion } from "@/lib/learning-engine/scoring";
import type { QuestionResponse } from "@/lib/learning-engine/types";
import { getPersistenceContext } from "@/lib/persistence/server-auth";
import { createServiceRoleSupabaseClient } from "@/lib/supabase/service-role";

const ATTEMPT_COLUMNS = "id, user_id, assessment_id, attempt_number, responses, score, passed, started_at, submitted_at";

export async function GET(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const assessmentId = request.nextUrl.searchParams.get("assessment_id");
  if (!assessmentId) return NextResponse.json({ error: "Missing assessment_id" }, { status: 400 });

  const { data, error } = await context.client
    .from("assessment_attempts")
    .select(ATTEMPT_COLUMNS)
    .eq("user_id", context.user.id)
    .eq("assessment_id", assessmentId)
    .order("attempt_number", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json({ data });
}

export async function POST(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const input = (await request.json()) as { assessment_id?: string; question_ids?: string[]; responses?: Record<string, QuestionResponse> };
  if (!input.assessment_id || !Array.isArray(input.question_ids) || input.question_ids.length === 0 || typeof input.responses !== "object" || input.responses === null) {
    return NextResponse.json({ error: "Invalid assessment attempt input" }, { status: 400 });
  }

  // Read through the caller's own RLS-scoped client -- confirms the caller
  // can actually see this assessment (published + course access), the same
  // gate the activity-attempts route applies via content_blocks.
  const assessment = await context.client
    .from("assessments")
    .select("id, course_id, assessment_type, passing_score")
    .eq("id", input.assessment_id)
    .eq("status", "published")
    .maybeSingle();
  if (assessment.error || !assessment.data) return NextResponse.json({ error: "Assessment not found" }, { status: 404 });

  // quick_review assessments own no questions of their own (enforced by a
  // trigger on assessment_questions) -- their pool is the course's single
  // exam-type assessment. Resolve that pool before fetching questions.
  let poolAssessmentId = assessment.data.id;
  if (assessment.data.assessment_type === "quick_review") {
    const examAssessment = await context.client.from("assessments").select("id").eq("course_id", assessment.data.course_id).eq("assessment_type", "exam").maybeSingle();
    if (examAssessment.error || !examAssessment.data) return NextResponse.json({ error: "No question pool configured for this course" }, { status: 400 });
    poolAssessmentId = examAssessment.data.id;
  }

  // Grading happens here, server-side, from questions re-fetched by id --
  // the client only ever echoes which question ids it answered (so scoring
  // matches what was actually displayed), never their content or correctness.
  const questionsResult = await context.client
    .from("assessment_questions")
    .select("id, assessment_id, question_type, prompt, explanation, points, position, data")
    .eq("assessment_id", poolAssessmentId)
    .in("id", input.question_ids);
  if (questionsResult.error || !questionsResult.data || questionsResult.data.length === 0) {
    return NextResponse.json({ error: "Questions not found" }, { status: 400 });
  }

  const questions = questionsResult.data.map(mapAssessmentQuestionRow);
  const results = questions.map((question) => scoreQuestion(question, input.responses?.[question.id] ?? null));
  const earned = results.reduce((total, result) => total + result.earned_points, 0);
  const available = results.reduce((total, result) => total + result.available_points, 0);
  const percent = available ? Math.round((earned / available) * 10000) / 100 : 0;
  const passed = assessment.data.assessment_type === "exam" ? percent >= (assessment.data.passing_score ?? 100) : null;

  const previous = await context.client
    .from("assessment_attempts")
    .select("attempt_number")
    .eq("user_id", context.user.id)
    .eq("assessment_id", assessment.data.id)
    .order("attempt_number", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (previous.error) return NextResponse.json({ error: previous.error.message }, { status: 400 });
  const attemptNumber = (previous.data?.attempt_number ?? 0) + 1;

  // assessment_attempts RLS only allows an authenticated INSERT with
  // score/passed/submitted_at forced null -- a client can never self-report
  // a result. The authoritative graded row is written with the service-role
  // client, using only the server-computed result above.
  const serviceClient = createServiceRoleSupabaseClient();
  if (!serviceClient) return NextResponse.json({ error: "Grading is not configured" }, { status: 503 });

  const { data, error } = await serviceClient
    .from("assessment_attempts")
    .insert({
      user_id: context.user.id,
      assessment_id: assessment.data.id,
      attempt_number: attemptNumber,
      responses: input.responses,
      score: percent,
      passed,
      submitted_at: new Date().toISOString(),
    })
    .select(ATTEMPT_COLUMNS)
    .single();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });

  // Quick review submissions reschedule the next due date regardless of
  // score -- the value is the retrieval attempt itself, not the result.
  // Users have no UPDATE policy on enrollments, so this goes through the
  // service-role client, same as the completion rollup in the progress route.
  if (assessment.data.assessment_type === "quick_review") {
    const course = await context.client.from("courses").select("repeat_review_interval_days").eq("id", assessment.data.course_id).maybeSingle();
    const intervalDays = course.data?.repeat_review_interval_days ?? 90;
    const dueAt = new Date(Date.now() + intervalDays * 24 * 60 * 60 * 1000).toISOString();
    await serviceClient.from("enrollments").update({ next_quick_review_due_at: dueAt }).eq("user_id", context.user.id).eq("course_id", assessment.data.course_id);
  }

  return NextResponse.json({ data });
}
