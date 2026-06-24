"use client";

import { getMockCurrentUser } from "@/lib/auth/mock-current-user";
import { persistenceRequest } from "./http";
import { localId, readLocal, writeLocal } from "./local-store";
import type { PersistenceResult, ProgressRecord, SaveProgressInput } from "./types";

function key(lessonId: string) { return `progress:${lessonId}`; }

export async function loadProgress(lessonId: string): Promise<PersistenceResult<ProgressRecord | null>> {
  try {
    const remote = await persistenceRequest<{ data: ProgressRecord | null }>(`/api/persistence/progress?lesson_id=${encodeURIComponent(lessonId)}`);
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }
  return { data: readLocal<ProgressRecord | null>(key(lessonId), null), mode: "local" };
}

export async function saveProgress(input: SaveProgressInput): Promise<PersistenceResult<ProgressRecord>> {
  try {
    const remote = await persistenceRequest<{ data: ProgressRecord }>("/api/persistence/progress", { method: "POST", body: JSON.stringify(input) });
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }

  const existing = readLocal<ProgressRecord | null>(key(input.lesson_id), null);
  const now = new Date().toISOString();
  const record: ProgressRecord = { id: existing?.id ?? localId(), user_id: getMockCurrentUser().id, ...input, started_at: existing?.started_at ?? now, completed_at: input.status === "completed" ? now : null, updated_at: now };
  writeLocal(key(input.lesson_id), record);
  return { data: record, mode: "local" };
}
