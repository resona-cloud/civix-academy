"use client";

import { getMockCurrentUser } from "@/lib/auth/mock-current-user";
import { scoreQuestion } from "@/lib/learning-engine/scoring";
import type { AssessmentQuestion, QuestionResponse } from "@/lib/learning-engine/types";
import { persistenceRequest } from "./http";
import { localId, readLocal, writeLocal } from "./local-store";
import type { ActivityAttempt, PersistenceResult } from "./types";

function key(contentBlockId: string) { return `activity-attempt:${contentBlockId}`; }

export async function loadActivityAttempt(contentBlockId: string): Promise<PersistenceResult<ActivityAttempt | null>> {
  try {
    const remote = await persistenceRequest<{ data: ActivityAttempt | null }>(`/api/persistence/activity-attempts?content_block_id=${encodeURIComponent(contentBlockId)}`);
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }
  return { data: readLocal<ActivityAttempt | null>(key(contentBlockId), null), mode: "local" };
}

// `question` is only used for the local/mock-fallback scoring path below --
// in Supabase mode the server always re-derives the question from the
// content_block row itself and never trusts anything the client sends.
export async function recordActivityAttempt(input: { content_block_id: string; question: AssessmentQuestion; response: QuestionResponse }): Promise<PersistenceResult<ActivityAttempt>> {
  try {
    const remote = await persistenceRequest<{ data: ActivityAttempt }>("/api/persistence/activity-attempts", {
      method: "POST",
      body: JSON.stringify({ content_block_id: input.content_block_id, response: input.response }),
    });
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }

  const existing = readLocal<ActivityAttempt | null>(key(input.content_block_id), null);
  const result = scoreQuestion(input.question, input.response);
  const now = new Date().toISOString();
  const record: ActivityAttempt = {
    id: existing?.id ?? localId(),
    user_id: getMockCurrentUser().id,
    content_block_id: input.content_block_id,
    attempt_number: (existing?.attempt_number ?? 0) + 1,
    status: result.correct ? "passed" : "failed",
    response: input.response,
    score: result.earned_points,
    max_score: result.available_points,
    started_at: existing?.started_at ?? now,
    submitted_at: now,
  };
  writeLocal(key(input.content_block_id), record);
  return { data: record, mode: "local" };
}
