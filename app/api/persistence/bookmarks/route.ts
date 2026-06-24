import { NextRequest, NextResponse } from "next/server";
import { getPersistenceContext } from "@/lib/persistence/server-auth";
import type { BookmarkTargetType, ToggleBookmarkInput } from "@/lib/persistence/types";

const targetTypes: BookmarkTargetType[] = ["lesson_page", "fieldbook_article", "lab_scenario"];

export async function GET(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const targetType = request.nextUrl.searchParams.get("target_type") as BookmarkTargetType | null;
  const targetId = request.nextUrl.searchParams.get("target_id");
  if (!targetType || !targetTypes.includes(targetType) || !targetId) return NextResponse.json({ error: "Invalid bookmark target" }, { status: 400 });
  const { data, error } = await context.client.from("bookmarks").select("id, user_id, target_type, target_id, label, created_at").eq("user_id", context.user.id).eq("target_type", targetType).eq("target_id", targetId).maybeSingle();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json({ data });
}

export async function POST(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const input = await request.json() as ToggleBookmarkInput;
  if (!targetTypes.includes(input.target_type) || typeof input.target_id !== "string" || !input.target_id) return NextResponse.json({ error: "Invalid bookmark target" }, { status: 400 });

  const existing = await context.client.from("bookmarks").select("id").eq("user_id", context.user.id).eq("target_type", input.target_type).eq("target_id", input.target_id).maybeSingle();
  if (existing.error) return NextResponse.json({ error: existing.error.message }, { status: 400 });
  if (existing.data) {
    const { error } = await context.client.from("bookmarks").delete().eq("id", existing.data.id).eq("user_id", context.user.id);
    if (error) return NextResponse.json({ error: error.message }, { status: 400 });
    return NextResponse.json({ data: null });
  }

  const { data, error } = await context.client.from("bookmarks").insert({ user_id: context.user.id, target_type: input.target_type, target_id: input.target_id, label: input.label?.trim() || null }).select("id, user_id, target_type, target_id, label, created_at").single();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json({ data });
}
