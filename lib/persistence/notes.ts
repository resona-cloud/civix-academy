"use client";

import { getMockCurrentUser } from "@/lib/auth/mock-current-user";
import { persistenceRequest } from "./http";
import { LOCAL_PREFIX, localId, readLocal, writeLocal } from "./local-store";
import type { Note, NoteTarget, PersistenceResult, SaveNoteInput } from "./types";

function targetKey(target: NoteTarget) {
  return target.lesson_page_id ? `notes:lesson_page:${target.lesson_page_id}` : `notes:fieldbook_article:${target.fieldbook_article_id}`;
}

export async function loadNotes(target: NoteTarget): Promise<PersistenceResult<Note[]>> {
  const query = new URLSearchParams(target.lesson_page_id ? { lesson_page_id: target.lesson_page_id } : { fieldbook_article_id: target.fieldbook_article_id as string });
  try {
    const remote = await persistenceRequest<{ data: Note[] }>(`/api/persistence/notes?${query}`);
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }
  return { data: readLocal<Note[]>(targetKey(target), []), mode: "local" };
}

export async function saveNote(input: SaveNoteInput): Promise<PersistenceResult<Note>> {
  try {
    const remote = await persistenceRequest<{ data: Note }>("/api/persistence/notes", { method: "POST", body: JSON.stringify(input) });
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }

  const target: NoteTarget = input.lesson_page_id ? { lesson_page_id: input.lesson_page_id } : { fieldbook_article_id: input.fieldbook_article_id as string };
  const existing = readLocal<Note[]>(targetKey(target), []);
  const now = new Date().toISOString();
  const note: Note = { id: input.id ?? localId(), author_id: getMockCurrentUser().id, lesson_page_id: input.lesson_page_id ?? null, fieldbook_article_id: input.fieldbook_article_id ?? null, body: input.body.trim(), visibility: "private", created_at: existing.find((item) => item.id === input.id)?.created_at ?? now, updated_at: now };
  writeLocal(targetKey(target), [...existing.filter((item) => item.id !== note.id), note]);
  return { data: note, mode: "local" };
}

export async function deleteNote(noteId: string): Promise<PersistenceResult<boolean>> {
  try {
    const remote = await persistenceRequest<{ data: boolean }>(`/api/persistence/notes?id=${encodeURIComponent(noteId)}`, { method: "DELETE" });
    if (remote) return { data: remote.data, mode: "supabase" };
  } catch { /* Fall through to local mode. */ }

  if (typeof window !== "undefined") {
    for (let index = window.localStorage.length - 1; index >= 0; index -= 1) {
      const key = window.localStorage.key(index);
      if (!key?.startsWith(`${LOCAL_PREFIX}notes:`)) continue;
      const notes = readLocal<Note[]>(key.slice(LOCAL_PREFIX.length), []);
      writeLocal(key.slice(LOCAL_PREFIX.length), notes.filter((note) => note.id !== noteId));
    }
  }
  return { data: true, mode: "local" };
}
