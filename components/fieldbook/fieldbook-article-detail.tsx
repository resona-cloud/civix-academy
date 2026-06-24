"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import type { FieldbookArticle } from "@/lib/fieldbook/types";
import { loadBookmark, toggleBookmark as persistBookmark } from "@/lib/persistence/bookmarks";
import { deleteNote, loadNotes, saveNote } from "@/lib/persistence/notes";
import type { PersistenceMode } from "@/lib/persistence/types";
import { ArticleCard } from "./article-card";
import { FieldbookContentBlockRenderer } from "./content-block-renderer";

type Props = {
  article: FieldbookArticle;
  relatedArticles: FieldbookArticle[];
};

export function FieldbookArticleDetail({ article, relatedArticles }: Props) {
  const [bookmarks, setBookmarks] = useState<Set<string>>(() => new Set());
  const [note, setNote] = useState("");
  const [noteId, setNoteId] = useState<string | undefined>();
  const [savingNote, setSavingNote] = useState(false);
  const [persistenceMode, setPersistenceMode] = useState<PersistenceMode>("local");

  useEffect(() => {
    let active = true;
    async function hydrate() {
      const articleIds = [article.id, ...relatedArticles.map((item) => item.id)];
      const [noteResult, bookmarkResults] = await Promise.all([
        loadNotes({ fieldbook_article_id: article.id }),
        Promise.all(articleIds.map((id) => loadBookmark({ target_type: "fieldbook_article", target_id: id }))),
      ]);
      if (!active) return;
      const existingNote = noteResult.data[0];
      if (existingNote) { setNote(existingNote.body); setNoteId(existingNote.id); }
      setPersistenceMode(noteResult.mode);
      setBookmarks(new Set(bookmarkResults.flatMap((result, index) => result.data ? [articleIds[index]] : []).filter((id): id is string => Boolean(id))));
    }
    void hydrate();
    return () => { active = false; };
  }, [article, relatedArticles]);

  async function toggleBookmark(articleId: string) {
    const target = articleId === article.id ? article : relatedArticles.find((item) => item.id === articleId);
    const result = await persistBookmark({ target_type: "fieldbook_article", target_id: articleId, label: target?.title });
    setPersistenceMode(result.mode);
    setBookmarks((current) => { const next = new Set(current); if (result.data) next.add(articleId); else next.delete(articleId); return next; });
  }

  async function savePersonalNote() {
    setSavingNote(true);
    const body = note.trim();
    if (!body && noteId) {
      const result = await deleteNote(noteId);
      setPersistenceMode(result.mode);
      setNoteId(undefined);
    } else if (body) {
      const result = await saveNote({ id: noteId, fieldbook_article_id: article.id, body });
      setPersistenceMode(result.mode);
      setNoteId(result.data.id);
    }
    setSavingNote(false);
  }

  return (
    <>
      <Link className="text-sm font-medium text-sky-700" href="/reference">&lt;- Back to Fieldbook</Link>
      <article className="mt-5 overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
        <header className="border-b border-slate-200 bg-slate-50 px-6 py-8 sm:px-10">
          <div className="flex flex-wrap items-start justify-between gap-5">
            <div className="max-w-3xl"><span className="rounded-full bg-sky-100 px-3 py-1 text-xs font-medium text-sky-800">{article.category}</span><h1 className="mt-4 text-3xl font-semibold tracking-tight sm:text-4xl">{article.title}</h1><p className="mt-4 leading-7 text-slate-600">{article.summary}</p></div>
            <button aria-pressed={bookmarks.has(article.id)} className={`rounded-lg border px-4 py-2 text-sm font-medium ${bookmarks.has(article.id) ? "border-amber-300 bg-amber-50 text-amber-900" : "border-slate-300 bg-white text-slate-700"}`} onClick={() => toggleBookmark(article.id)} type="button">{bookmarks.has(article.id) ? "Saved to bookmarks" : "Bookmark article"}</button>
          </div>
          <div className="mt-5 flex flex-wrap gap-2">{article.tags.map((tag) => <span className="text-xs text-slate-500" key={tag}>#{tag.replaceAll(" ", "-")}</span>)}</div>
        </header>
        <div className="mx-auto max-w-3xl space-y-8 px-6 py-10 sm:px-10">{article.content_blocks.map((block) => <FieldbookContentBlockRenderer block={block} key={block.id} />)}<section className="rounded-xl border border-amber-200 bg-amber-50/50 p-5"><p className="text-xs font-semibold uppercase tracking-wider text-amber-800">Personal notes</p><textarea className="mt-3 min-h-36 w-full rounded-lg border border-amber-200 bg-white p-3 text-sm leading-6" onChange={(event) => setNote(event.target.value)} placeholder="Add a private note about this Fieldbook article..." value={note} /><div className="mt-3 flex items-center justify-between gap-3"><span className="text-xs text-slate-400">Storage: {persistenceMode === "supabase" ? "Supabase" : "local mock fallback"}</span><button className="rounded-lg bg-amber-700 px-4 py-2 text-sm font-medium text-white disabled:opacity-50" disabled={savingNote} onClick={savePersonalNote} type="button">{savingNote ? "Saving..." : note.trim() ? "Save note" : "Delete saved note"}</button></div></section></div>
      </article>

      {relatedArticles.length ? <section className="mt-12"><p className="text-xs font-semibold uppercase tracking-wider text-sky-700">Keep exploring</p><h2 className="mt-1 text-2xl font-semibold">Related Fieldbook articles</h2><div className="mt-5 grid gap-4 md:grid-cols-2">{relatedArticles.map((related) => <ArticleCard article={related} bookmarked={bookmarks.has(related.id)} key={related.id} onToggleBookmark={toggleBookmark} />)}</div></section> : null}
    </>
  );
}
