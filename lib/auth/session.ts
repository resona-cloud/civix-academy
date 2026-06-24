import "server-only";

import type { Session, SupabaseClient } from "@supabase/supabase-js";
import { redirect } from "next/navigation";
import { getMockCurrentUser } from "./mock-current-user";
import { appRoles } from "./roles";
import type { AppRole, CurrentAppUser } from "./types";
import { createServerSupabaseClient, isServerSupabaseConfigured } from "@/lib/supabase/server";
import type { Database } from "@/lib/database.types";

function isAppRole(value: unknown): value is AppRole {
  return typeof value === "string" && appRoles.includes(value as AppRole);
}

async function loadRoles(client: SupabaseClient<Database>, userId: string): Promise<AppRole[]> {
  const { data } = await client.from("profile_roles").select("role").eq("user_id", userId);
  return (data ?? []).map((item) => item.role).filter(isAppRole);
}

export async function getCurrentSession(): Promise<Session | null> {
  const client = await createServerSupabaseClient();
  if (!client) return null;
  const { data: { user } } = await client.auth.getUser();
  if (!user) return null;
  const { data: { session } } = await client.auth.getSession();
  return session;
}

export async function getCurrentUserRoles(userId?: string): Promise<AppRole[]> {
  if (!isServerSupabaseConfigured()) return getMockCurrentUser().roles;
  const client = await createServerSupabaseClient();
  if (!client) return [];
  let resolvedUserId = userId;
  if (!resolvedUserId) {
    const { data: { user } } = await client.auth.getUser();
    resolvedUserId = user?.id;
  }
  return resolvedUserId ? loadRoles(client, resolvedUserId) : [];
}

export async function getCurrentProfile(): Promise<CurrentAppUser | null> {
  if (!isServerSupabaseConfigured()) return getMockCurrentUser();
  const client = await createServerSupabaseClient();
  if (!client) return null;
  const { data: { user } } = await client.auth.getUser();
  if (!user) return null;

  const [{ data: profile }, roles] = await Promise.all([
    client.from("profiles").select("display_name, classification").eq("id", user.id).maybeSingle(),
    loadRoles(client, user.id),
  ]);
  return {
    id: user.id,
    email: user.email ?? "",
    display_name: profile?.display_name ?? user.user_metadata.display_name ?? user.email?.split("@")[0] ?? "CIVIX User",
    classification: profile?.classification ?? "CIVIX Academy User",
    roles,
    source: "supabase",
  };
}

export async function requireAuth(): Promise<CurrentAppUser> {
  const user = await getCurrentProfile();
  if (!user) redirect("/login");
  return user;
}

export async function requireRole(allowedRoles: readonly AppRole[]): Promise<CurrentAppUser> {
  const user = await requireAuth();
  if (!user.roles.some((role) => allowedRoles.includes(role))) redirect("/account?denied=1");
  return user;
}
