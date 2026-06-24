"use client";

import { createBrowserSupabaseClient } from "@/lib/supabase/browser";

export async function persistenceRequest<T>(path: string, init?: RequestInit): Promise<T | null> {
  const client = createBrowserSupabaseClient();
  if (!client) return null;

  const { data: { session } } = await client.auth.getSession();
  if (!session?.access_token) return null;

  const response = await fetch(path, {
    ...init,
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${session.access_token}`,
      ...init?.headers,
    },
  });
  if (!response.ok) throw new Error(`Persistence request failed (${response.status})`);
  return response.json() as Promise<T>;
}
