"use client";

import Link from "next/link";
import { useState } from "react";
import type { FieldbookArticle } from "@/lib/fieldbook/types";
import { ArticleCard } from "./article-card";
import { FieldbookContentBlockRenderer } from "./content-block-renderer";

type Props = {
  article: FieldbookArticle;
  relatedArticles: FieldbookArticle[];
};

export function FieldbookArticleDetail({ article, relatedArticles }: Props) {
  const [bookmarks, setBookmarks] = useState<Set<string>>(() => new Set());

  function toggleBookmark(articleId: string) {
    setBookmarks((current) => {
      const next = new Set(current);
      if (next.has(articleId)) next.delete(articleId);
      else next.add(articleId);
      return next;
    });
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
        <div className="mx-auto max-w-3xl space-y-8 px-6 py-10 sm:px-10">{article.content_blocks.map((block) => <FieldbookContentBlockRenderer block={block} key={block.id} />)}</div>
      </article>

      {relatedArticles.length ? <section className="mt-12"><p className="text-xs font-semibold uppercase tracking-wider text-sky-700">Keep exploring</p><h2 className="mt-1 text-2xl font-semibold">Related Fieldbook articles</h2><div className="mt-5 grid gap-4 md:grid-cols-2">{relatedArticles.map((related) => <ArticleCard article={related} bookmarked={bookmarks.has(related.id)} key={related.id} onToggleBookmark={toggleBookmark} />)}</div></section> : null}
    </>
  );
}
