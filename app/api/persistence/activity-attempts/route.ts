import { NextRequest, NextResponse } from "next/server";
import { scoreQuestion } from "@/lib/learning-engine/scoring";
import type { AssessmentQuestion, QuestionResponse } from "@/lib/learning-engine/types";
import { getPersistenceContext } from "@/lib/persistence/server-auth";
import { createServiceRoleSupabaseClient } from "@/lib/supabase/service-role";

const ATTEMPT_COLUMNS = "id, user_id, content_block_id, attempt_number, status, response, score, max_score, started_at, submitted_at";

export async function GET(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const contentBlockId = request.nextUrl.searchParams.get("content_block_id");
  if (!contentBlockId) return NextResponse.json({ error: "Missing content_block_id" }, { status: 400 });

  const { data, error } = await context.client
    .from("activity_attempts")
    .select(ATTEMPT_COLUMNS)
    .eq("user_id", context.user.id)
    .eq("content_block_id", contentBlockId)
    .order("attempt_number", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json({ data });
}

export async function POST(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const input = (await request.json()) as { content_block_id?: string; response?: QuestionResponse };
  if (!input.content_block_id) return NextResponse.json({ error: "Missing content_block_id" }, { status: 400 });

  // Read the block through the caller's own RLS-scoped client -- confirms
  // the caller can actually see this block (the same course-access RLS that
  // gates training content), independent of the activity_attempts policies.
  const block = await context.client
    .from("content_blocks")
    .select("id, content")
    .eq("id", input.content_block_id)
    .eq("block_type", "activity")
    .maybeSingle();
  if (block.error || !block.data) return NextResponse.json({ error: "Activity block not found" }, { status: 404 });

  const question = (block.data.content as { question?: AssessmentQuestion } | null)?.question;
  if (!question) return NextResponse.json({ error: "Malformed activity block" }, { status: 400 });

  // Grading happens here, server-side, from the question stored in the DB --
  // never from anything the client claims about correctness or score.
  const result = scoreQuestion(question, input.response ?? null);

  const previous = await context.client
    .from("activity_attempts")
    .select("attempt_number")
    .eq("user_id", context.user.id)
    .eq("content_block_id", input.content_block_id)
    .order("attempt_number", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (previous.error) return NextResponse.json({ error: previous.error.message }, { status: 400 });
  const attemptNumber = (previous.data?.attempt_number ?? 0) + 1;

  // activity_attempts RLS only allows an authenticated INSERT with
  // status in ('started','submitted') and score/max_score forced null -- by
  // design, so a client can never self-report a pass or a score. The
  // authoritative passed/failed + score row is written with the
  // service-role client, using only the server-computed result above.
  const serviceClient = createServiceRoleSupabaseClient();
  if (!serviceClient) return NextResponse.json({ error: "Grading is not configured" }, { status: 503 });

  const { data, error } = await serviceClient
    .from("activity_attempts")
    .insert({
      user_id: context.user.id,
      content_block_id: input.content_block_id,
      attempt_number: attemptNumber,
      status: result.correct ? "passed" : "failed",
      response: input.response ?? {},
      score: result.earned_points,
      max_score: result.available_points,
      submitted_at: new Date().toISOString(),
    })
    .select(ATTEMPT_COLUMNS)
    .single();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json({ data });
}
