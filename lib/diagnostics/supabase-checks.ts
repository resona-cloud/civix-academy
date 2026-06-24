import "server-only";

import type { SupabaseClient } from "@supabase/supabase-js";
import type { Database } from "@/lib/database.types";
import { createServerSupabaseClient } from "@/lib/supabase/server";
import type { DiagnosticResult } from "./types";

type Context = { client: SupabaseClient<Database>; userId: string };

async function context(): Promise<Context | null> {
  const client = await createServerSupabaseClient();
  if (!client) return null;
  const { data: { user }, error } = await client.auth.getUser();
  return error || !user ? null : { client, userId: user.id };
}

function skipped(key: string, label: string): DiagnosticResult {
  return { key, label, status: "skipped", detail: "Supabase is not configured or no authenticated session is available." };
}

function result(key: string, label: string, error: { message: string } | null, detail: string): DiagnosticResult {
  return error ? { key, label, status: "fail", detail: error.message } : { key, label, status: "pass", detail };
}

export async function canLoadProfile(): Promise<DiagnosticResult> {
  const current = await context();
  if (!current) return skipped("profile", "Profile lookup");
  const { data, error } = await current.client.from("profiles").select("id").eq("id", current.userId).maybeSingle();
  if (!error && !data) return { key: "profile", label: "Profile lookup", status: "fail", detail: "Authenticated user has no public.profiles row." };
  return result("profile", "Profile lookup", error, `Profile row found for ${current.userId}.`);
}

export async function canLoadRoles(): Promise<DiagnosticResult> {
  const current = await context();
  if (!current) return skipped("roles", "Role lookup");
  const { data, error } = await current.client.from("profile_roles").select("role").eq("user_id", current.userId);
  return result("roles", "Role lookup", error, `${data?.length ?? 0} role assignment(s) readable.`);
}

export async function canLoadNotes(): Promise<DiagnosticResult> {
  const current = await context();
  if (!current) return skipped("notes", "Notes adapter");
  const { error, count } = await current.client.from("notes").select("id", { count: "exact", head: true }).eq("author_id", current.userId);
  return result("notes", "Notes adapter", error, `Notes table readable; ${count ?? 0} owned row(s).`);
}

export async function canLoadBookmarks(): Promise<DiagnosticResult> {
  const current = await context();
  if (!current) return skipped("bookmarks", "Bookmarks adapter");
  const { error, count } = await current.client.from("bookmarks").select("id", { count: "exact", head: true }).eq("user_id", current.userId);
  return result("bookmarks", "Bookmarks adapter", error, `Bookmarks table readable; ${count ?? 0} owned row(s).`);
}

export async function canLoadProgress(): Promise<DiagnosticResult> {
  const current = await context();
  if (!current) return skipped("progress", "Progress adapter");
  const { error, count } = await current.client.from("user_progress").select("id", { count: "exact", head: true }).eq("user_id", current.userId);
  return result("progress", "Progress adapter", error, `Progress table readable; ${count ?? 0} owned row(s).`);
}

export async function canConnectDatabase(): Promise<DiagnosticResult> {
  const current = await context();
  if (!current) return skipped("database", "Database connectivity");
  const { error } = await current.client.from("profiles").select("id").limit(1);
  return result("database", "Database connectivity", error, "Authenticated PostgREST query completed successfully.");
}
