"use client";

import { useState } from "react";
import type { LessonReaderData } from "@/lib/lesson-reader/types";
import { ContentBlockRenderer } from "./content-block-renderer";
import { LessonSidebar } from "./lesson-sidebar";
import { NotesPanel } from "./notes-panel";
import { ProgressBar } from "./progress-bar";

export function LessonReader({ lesson }: { lesson: LessonReaderData }) {
  const [activePageIndex, setActivePageIndex] = useState(0);
  const [visitedPages, setVisitedPages] = useState(() => new Set(lesson.pages[0] ? [lesson.pages[0].id] : []));
  const [bookmarks, setBookmarks] = useState<Set<string>>(() => new Set());
  const [notes, setNotes] = useState<Record<string, string>>({});
  const activePage = lesson.pages[activePageIndex];

  if (!activePage) return <p>This lesson has no pages.</p>;

  function goToPage(index: number) {
    const page = lesson.pages[index];
    if (!page) return;
    setActivePageIndex(index);
    setVisitedPages((current) => new Set(current).add(page.id));
  }

  function toggleBookmark() {
    setBookmarks((current) => {
      const next = new Set(current);
      if (next.has(activePage.id)) next.delete(activePage.id);
      else next.add(activePage.id);
      return next;
    });
  }

  return (
    <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
      <header className="border-b border-slate-200 px-5 py-5 sm:px-7">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div><p className="text-sm font-medium text-sky-700">{lesson.course.title}</p><h1 className="mt-1 text-2xl font-semibold tracking-tight">{lesson.lesson.title}</h1></div>
          <button aria-pressed={bookmarks.has(activePage.id)} className={`rounded-lg border px-4 py-2 text-sm font-medium ${bookmarks.has(activePage.id) ? "border-amber-300 bg-amber-50 text-amber-900" : "border-slate-300 bg-white text-slate-700"}`} onClick={toggleBookmark} type="button">
            {bookmarks.has(activePage.id) ? "★ Bookmarked" : "☆ Bookmark page"}
          </button>
        </div>
        <div className="mt-5 max-w-md"><ProgressBar completed={visitedPages.size} total={lesson.pages.length} /></div>
      </header>

      <div className="lg:grid lg:grid-cols-[15rem_minmax(0,1fr)] xl:grid-cols-[15rem_minmax(0,1fr)_18rem]">
        <LessonSidebar activeLessonId={lesson.lesson.id} activePageIndex={activePageIndex} bookmarks={bookmarks} modules={lesson.modules} onPageSelect={goToPage} pages={lesson.pages} />

        <article className="min-w-0 px-6 py-8 sm:px-10 lg:py-10">
          <p className="text-xs font-semibold uppercase tracking-[0.16em] text-sky-700">Page {activePage.position} of {lesson.pages.length}</p>
          <h2 className="mt-2 text-3xl font-semibold tracking-tight">{activePage.title}</h2>
          <div className="mt-8 space-y-7">{activePage.content_blocks.map((block) => <ContentBlockRenderer block={block} key={block.id} />)}</div>

          <nav aria-label="Lesson page navigation" className="mt-12 flex items-center justify-between border-t border-slate-200 pt-6">
            <button className="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium disabled:cursor-not-allowed disabled:opacity-40" disabled={activePageIndex === 0} onClick={() => goToPage(activePageIndex - 1)} type="button">← Previous</button>
            <span className="text-sm text-slate-500">{activePageIndex + 1} / {lesson.pages.length}</span>
            <button className="rounded-lg bg-slate-900 px-4 py-2 text-sm font-medium text-white disabled:cursor-not-allowed disabled:opacity-40" disabled={activePageIndex === lesson.pages.length - 1} onClick={() => goToPage(activePageIndex + 1)} type="button">Next →</button>
          </nav>
        </article>

        <div className="lg:col-span-2 xl:col-span-1">
          <NotesPanel note={notes[activePage.id] ?? ""} onChange={(note) => setNotes((current) => ({ ...current, [activePage.id]: note }))} pageTitle={activePage.title} />
        </div>
      </div>
    </div>
  );
}
