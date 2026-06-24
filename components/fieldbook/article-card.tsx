"use client";

import Link from "next/link";
import type { FieldbookArticle } from "@/lib/fieldbook/types";

type Props = {
  article: FieldbookArticle;
  bookmarked: boolean;
  onToggleBookmark: (articleId: string) => void;
};

export function ArticleCard({ article, bookmarked, onToggleBookmark }: Props) {
  return (
    <article className="flex h-full flex-col rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
      <div className="flex items-start justify-between gap-4">
        <span className="rounded-full bg-sky-50 px-2.5 py-1 text-xs font-medium text-sky-700">{article.category}</span>
        <button aria-label={`${bookmarked ? "Remove" : "Add"} bookmark for ${article.title}`} aria-pressed={bookmarked} className={`rounded-md border px-2.5 py-1 text-xs font-medium ${bookmarked ? "border-amber-300 bg-amber-50 text-amber-800" : "border-slate-200 text-slate-500 hover:bg-slate-50"}`} onClick={() => onToggleBookmark(article.id)} type="button">
          {bookmarked ? "Saved" : "Bookmark"}
        </button>
      </div>
      <h3 className="mt-4 text-lg font-semibold tracking-tight">{article.title}</h3>
      <p className="mt-2 flex-1 text-sm leading-6 text-slate-600">{article.summary}</p>
      <div className="mt-4 flex flex-wrap gap-1.5">{article.tags.map((tag) => <span className="text-xs text-slate-400" key={tag}>#{tag.replaceAll(" ", "-")}</span>)}</div>
      <Link className="mt-5 text-sm font-semibold text-sky-700" href={`/reference/${article.id}`}>Read article -&gt;</Link>
    </article>
  );
}
