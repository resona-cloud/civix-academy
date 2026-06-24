"use client";

import { useMemo, useState } from "react";
import type { FieldbookCategory } from "@/lib/fieldbook/types";
import { featuredFieldbookArticleIds, fieldbookArticles, fieldbookCategories, glossaryTerms } from "@/lib/fieldbook/mock-data";
import { ArticleCard } from "./article-card";
import { CategoryFilter } from "./category-filter";
import { GlossaryTermCard } from "./glossary-term-card";

type CategorySelection = "All" | FieldbookCategory;

export function FieldbookLanding() {
  const [query, setQuery] = useState("");
  const [category, setCategory] = useState<CategorySelection>("All");
  const [bookmarks, setBookmarks] = useState<Set<string>>(() => new Set());

  const filteredArticles = useMemo(() => {
    const search = query.trim().toLocaleLowerCase();
    return fieldbookArticles.filter((article) => {
      const categoryMatches = category === "All" || article.category === category;
      const searchMatches = !search || [article.title, article.summary, article.category, ...article.tags].some((value) => value.toLocaleLowerCase().includes(search));
      return categoryMatches && searchMatches;
    });
  }, [category, query]);

  const featuredArticles = fieldbookArticles.filter((article) => featuredFieldbookArticleIds.includes(article.id));

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
      <section className="rounded-2xl bg-slate-950 px-6 py-10 text-white sm:px-10">
        <p className="text-xs font-semibold uppercase tracking-[0.18em] text-sky-400">Fieldbook</p>
        <h1 className="mt-3 max-w-2xl text-3xl font-semibold tracking-tight sm:text-4xl">Procurement guidance for work in the field</h1>
        <p className="mt-3 max-w-2xl text-sm leading-6 text-slate-300">Search practical guides, review checklists, and refresh essential GovCon terminology.</p>
        <label className="mt-7 block max-w-2xl"><span className="sr-only">Search the Fieldbook</span><input className="w-full rounded-xl border border-slate-700 bg-white px-4 py-3 text-slate-950 outline-none focus:border-sky-400 focus:ring-2 focus:ring-sky-400/30" onChange={(event) => setQuery(event.target.value)} placeholder="Search articles, categories, or tags" type="search" value={query} /></label>
      </section>

      <section className="mt-10"><div className="mb-5 flex items-end justify-between gap-4"><div><p className="text-xs font-semibold uppercase tracking-wider text-sky-700">Start here</p><h2 className="mt-1 text-2xl font-semibold">Featured articles</h2></div></div><div className="grid gap-4 md:grid-cols-2">{featuredArticles.map((article) => <ArticleCard article={article} bookmarked={bookmarks.has(article.id)} key={article.id} onToggleBookmark={toggleBookmark} />)}</div></section>

      <section className="mt-12"><div className="flex flex-wrap items-end justify-between gap-4"><div><p className="text-xs font-semibold uppercase tracking-wider text-sky-700">Browse</p><h2 className="mt-1 text-2xl font-semibold">Fieldbook articles</h2></div><span className="text-sm text-slate-500">{filteredArticles.length} result{filteredArticles.length === 1 ? "" : "s"}</span></div><div className="mt-5"><CategoryFilter categories={fieldbookCategories} onSelect={setCategory} selected={category} /></div>{filteredArticles.length ? <div className="mt-6 grid gap-4 md:grid-cols-2 xl:grid-cols-3">{filteredArticles.map((article) => <ArticleCard article={article} bookmarked={bookmarks.has(article.id)} key={article.id} onToggleBookmark={toggleBookmark} />)}</div> : <div className="mt-6 rounded-xl border border-dashed border-slate-300 bg-white p-10 text-center text-sm text-slate-500">No Fieldbook articles match this search and category.</div>}</section>

      <section className="mt-12"><p className="text-xs font-semibold uppercase tracking-wider text-violet-700">Quick reference</p><h2 className="mt-1 text-2xl font-semibold">Glossary terms</h2><div className="mt-5 grid gap-4 md:grid-cols-2 xl:grid-cols-3">{glossaryTerms.map((term) => <GlossaryTermCard key={term.id} term={term} />)}</div></section>
    </>
  );
}
