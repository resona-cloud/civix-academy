"use client";

import { getMockCurrentUser } from "@/lib/auth/mock-current-user";
import { persistenceRequest } from "./http";
import { localId, readLocal, writeLocal } from "./local-store";
import type { Bookmark, PersistenceResult, ToggleBookmarkInput } from "./types";

function key(input: ToggleBookmarkInput) { return `bookmark:${input.target_type}:${input.target_id}`; }

export async function loadBookmark(input: ToggleBookmarkInput): Promise<PersistenceResult<Bookmark | null>> {
  const query = new URLSearchParams({ target_type: input.target_type, target_id: input.target_id });
  try {
    const remote = await persistenceRequest<{ data: Bookmark | null }>(`/api/persistence/bookmarks?${query}`);
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }
  return { data: readLocal<Bookmark | null>(key(input), null), mode: "local" };
}

export async function toggleBookmark(input: ToggleBookmarkInput): Promise<PersistenceResult<Bookmark | null>> {
  try {
    const remote = await persistenceRequest<{ data: Bookmark | null }>("/api/persistence/bookmarks", { method: "POST", body: JSON.stringify(input) });
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }

  const existing = readLocal<Bookmark | null>(key(input), null);
  if (existing) {
    writeLocal(key(input), null);
    return { data: null, mode: "local" };
  }
  const bookmark: Bookmark = { id: localId(), user_id: getMockCurrentUser().id, target_type: input.target_type, target_id: input.target_id, label: input.label ?? null, created_at: new Date().toISOString() };
  writeLocal(key(input), bookmark);
  return { data: bookmark, mode: "local" };
}
