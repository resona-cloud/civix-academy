import { NextRequest, NextResponse } from "next/server";
import { getPersistenceContext } from "@/lib/persistence/server-auth";
import type { SaveNoteInput } from "@/lib/persistence/types";

export async function GET(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const lessonPageId = request.nextUrl.searchParams.get("lesson_page_id");
  const articleId = request.nextUrl.searchParams.get("fieldbook_article_id");
  if (Boolean(lessonPageId) === Boolean(articleId)) return NextResponse.json({ error: "Provide exactly one note target" }, { status: 400 });

  let query = context.client.from("notes").select("id, author_id, lesson_page_id, fieldbook_article_id, body, visibility, created_at, updated_at").eq("author_id", context.user.id);
  query = lessonPageId ? query.eq("lesson_page_id", lessonPageId) : query.eq("fieldbook_article_id", articleId as string);
  const { data, error } = await query.order("updated_at", { ascending: false });
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json({ data });
}

export async function POST(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const input = await request.json() as SaveNoteInput;
  const body = typeof input.body === "string" ? input.body.trim() : "";
  const lessonPageId = input.lesson_page_id;
  const articleId = input.fieldbook_article_id;
  if (!body || Boolean(lessonPageId) === Boolean(articleId)) return NextResponse.json({ error: "Invalid note" }, { status: 400 });

  const values = { author_id: context.user.id, lesson_page_id: lessonPageId ?? null, fieldbook_article_id: articleId ?? null, body, visibility: "private" as const };
  const result = input.id
    ? await context.client.from("notes").update(values).eq("id", input.id).eq("author_id", context.user.id).select("id, author_id, lesson_page_id, fieldbook_article_id, body, visibility, created_at, updated_at").single()
    : await context.client.from("notes").insert(values).select("id, author_id, lesson_page_id, fieldbook_article_id, body, visibility, created_at, updated_at").single();
  if (result.error) return NextResponse.json({ error: result.error.message }, { status: 400 });
  return NextResponse.json({ data: result.data });
}

export async function DELETE(request: NextRequest) {
  const context = await getPersistenceContext(request);
  if (!context) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const id = request.nextUrl.searchParams.get("id");
  if (!id) return NextResponse.json({ error: "Missing note id" }, { status: 400 });
  const { error } = await context.client.from("notes").delete().eq("id", id).eq("author_id", context.user.id);
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json({ data: true });
}
