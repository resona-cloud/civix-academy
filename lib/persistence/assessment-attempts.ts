"use client";

import { getMockCurrentUser } from "@/lib/auth/mock-current-user";
import { scoreQuestion } from "@/lib/learning-engine/scoring";
import type { AssessmentQuestion, QuestionResponse } from "@/lib/learning-engine/types";
import { persistenceRequest } from "./http";
import { localId, readLocal, writeLocal } from "./local-store";
import type { AssessmentAttempt, PersistenceResult } from "./types";

function key(assessmentId: string) { return `assessment-attempt:${assessmentId}`; }

export async function loadAssessmentAttempt(assessmentId: string): Promise<PersistenceResult<AssessmentAttempt | null>> {
  try {
    const remote = await persistenceRequest<{ data: AssessmentAttempt | null }>(`/api/persistence/assessment-attempts?assessment_id=${encodeURIComponent(assessmentId)}`);
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }
  return { data: readLocal<AssessmentAttempt | null>(key(assessmentId), null), mode: "local" };
}

// `questions`/`passingScore` are only used for the local/mock-fallback
// scoring path below -- in Supabase mode the server always re-derives every
// question from assessment_questions itself and never trusts anything the
// client sends beyond which question ids it answered.
export async function recordAssessmentAttempt(input: { assessment_id: string; questions: AssessmentQuestion[]; passing_score: number; is_exam: boolean; responses: Record<string, QuestionResponse> }): Promise<PersistenceResult<AssessmentAttempt>> {
  try {
    const remote = await persistenceRequest<{ data: AssessmentAttempt }>("/api/persistence/assessment-attempts", {
      method: "POST",
      body: JSON.stringify({ assessment_id: input.assessment_id, question_ids: input.questions.map((question) => question.id), responses: input.responses }),
    });
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }

  const existing = readLocal<AssessmentAttempt | null>(key(input.assessment_id), null);
  const results = input.questions.map((question) => scoreQuestion(question, input.responses[question.id] ?? null));
  const earned = results.reduce((total, result) => total + result.earned_points, 0);
  const available = results.reduce((total, result) => total + result.available_points, 0);
  const percent = available ? Math.round((earned / available) * 10000) / 100 : 0;
  const now = new Date().toISOString();
  const record: AssessmentAttempt = {
    id: existing?.id ?? localId(),
    user_id: getMockCurrentUser().id,
    assessment_id: input.assessment_id,
    attempt_number: (existing?.attempt_number ?? 0) + 1,
    responses: input.responses,
    score: percent,
    passed: input.is_exam ? percent >= input.passing_score : null,
    started_at: existing?.started_at ?? now,
    submitted_at: now,
  };
  writeLocal(key(input.assessment_id), record);
  return { data: record, mode: "local" };
}
