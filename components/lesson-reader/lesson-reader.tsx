"use client";

import { useEffect, useState } from "react";
import type { LessonReaderData } from "@/lib/lesson-reader/types";
import { loadBookmark, toggleBookmark as persistBookmark } from "@/lib/persistence/bookmarks";
import { deleteNote, loadNotes, saveNote } from "@/lib/persistence/notes";
import { loadProgress, saveProgress } from "@/lib/persistence/progress";
import type { PersistenceMode } from "@/lib/persistence/types";
import { ContentBlockRenderer } from "./content-block-renderer";
import { LessonSidebar } from "./lesson-sidebar";
import { NotesPanel } from "./notes-panel";
import { ProgressBar } from "./progress-bar";

export function LessonReader({ lesson }: { lesson: LessonReaderData }) {
  const [activePageIndex, setActivePageIndex] = useState(0);
  const [visitedPages, setVisitedPages] = useState(() => new Set(lesson.pages[0] ? [lesson.pages[0].id] : []));
  const [completedPages, setCompletedPages] = useState<Set<string>>(() => new Set());
  const [bookmarks, setBookmarks] = useState<Set<string>>(() => new Set());
  const [notes, setNotes] = useState<Record<string, string>>({});
  const [noteIds, setNoteIds] = useState<Record<string, string>>({});
  const [savingNote, setSavingNote] = useState(false);
  const [persistenceMode, setPersistenceMode] = useState<PersistenceMode>("local");
  const activePage = lesson.pages[activePageIndex];

  useEffect(() => {
    let active = true;
    async function hydrate() {
      const [progressResult, noteResults, bookmarkResults] = await Promise.all([
        loadProgress(lesson.lesson.id),
        Promise.all(lesson.pages.map((page) => loadNotes({ lesson_page_id: page.id }))),
        Promise.all(lesson.pages.map((page) => loadBookmark({ target_type: "lesson_page", target_id: page.id }))),
      ]);
      if (!active) return;
      setPersistenceMode(progressResult.mode);
      const progress = progressResult.data;
      if (progress) {
        setVisitedPages(new Set(progress.visited_page_ids));
        setCompletedPages(new Set(progress.completed_page_ids));
        const lastIndex = lesson.pages.findIndex((page) => page.id === progress.last_page_id);
        if (lastIndex >= 0) setActivePageIndex(lastIndex);
      }
      const hydratedNotes: Record<string, string> = {};
      const hydratedNoteIds: Record<string, string> = {};
      noteResults.forEach((result, index) => {
        const page = lesson.pages[index];
        const note = result.data[0];
        if (page && note) { hydratedNotes[page.id] = note.body; hydratedNoteIds[page.id] = note.id; }
        if (result.mode === "supabase") setPersistenceMode("supabase");
      });
      setNotes(hydratedNotes);
      setNoteIds(hydratedNoteIds);
      setBookmarks(new Set(bookmarkResults.flatMap((result, index) => result.data && lesson.pages[index] ? [lesson.pages[index].id] : [])));
    }
    void hydrate();
    return () => { active = false; };
  }, [lesson]);

  if (!activePage) return <p>This lesson has no pages.</p>;

  async function persistLessonProgress(lastPageId: string, visited: Set<string>, completed: Set<string>) {
    const progressPercent = lesson.pages.length ? Math.round((completed.size / lesson.pages.length) * 100) : 0;
    const result = await saveProgress({ lesson_id: lesson.lesson.id, last_page_id: lastPageId, status: completed.size === lesson.pages.length ? "completed" : "in_progress", progress_percent: progressPercent, visited_page_ids: Array.from(visited), completed_page_ids: Array.from(completed) });
    setPersistenceMode(result.mode);
  }

  function goToPage(index: number) {
    const page = lesson.pages[index];
    if (!page) return;
    setActivePageIndex(index);
    const nextVisited = new Set(visitedPages).add(page.id);
    setVisitedPages(nextVisited);
    void persistLessonProgress(page.id, nextVisited, completedPages);
  }

  async function toggleBookmark() {
    const result = await persistBookmark({ target_type: "lesson_page", target_id: activePage.id, label: activePage.title });
    setPersistenceMode(result.mode);
    setBookmarks((current) => { const next = new Set(current); if (result.data) next.add(activePage.id); else next.delete(activePage.id); return next; });
  }

  async function saveCurrentNote() {
    setSavingNote(true);
    const body = notes[activePage.id]?.trim() ?? "";
    const existingId = noteIds[activePage.id];
    if (!body && existingId) {
      const result = await deleteNote(existingId);
      setPersistenceMode(result.mode);
      setNoteIds((current) => { const next = { ...current }; delete next[activePage.id]; return next; });
    } else if (body) {
      const result = await saveNote({ id: existingId, lesson_page_id: activePage.id, body });
      setPersistenceMode(result.mode);
      setNoteIds((current) => ({ ...current, [activePage.id]: result.data.id }));
    }
    setSavingNote(false);
  }

  function markPageComplete() {
    const nextCompleted = new Set(completedPages).add(activePage.id);
    const nextVisited = new Set(visitedPages).add(activePage.id);
    setCompletedPages(nextCompleted);
    setVisitedPages(nextVisited);
    void persistLessonProgress(activePage.id, nextVisited, nextCompleted);
  }

  return (
    <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
      <header className="border-b border-slate-200 px-5 py-5 sm:px-7">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div><p className="text-sm font-medium text-sky-700">{lesson.course.title}</p><h1 className="mt-1 text-2xl font-semibold tracking-tight">{lesson.lesson.title}</h1></div>
          <button aria-pressed={bookmarks.has(activePage.id)} className={`rounded-lg border px-4 py-2 text-sm font-medium ${bookmarks.has(activePage.id) ? "border-amber-300 bg-amber-50 text-amber-900" : "border-slate-300 bg-white text-slate-700"}`} onClick={toggleBookmark} type="button">
            {bookmarks.has(activePage.id) ? "Bookmarked" : "Bookmark page"}
          </button>
        </div>
        <div className="mt-5 max-w-md"><ProgressBar completed={completedPages.size} total={lesson.pages.length} /><p className="mt-2 text-xs text-slate-400">{visitedPages.size} pages visited - {persistenceMode === "supabase" ? "persisted" : "local mock mode"}</p></div>
      </header>

      <div className="lg:grid lg:grid-cols-[15rem_minmax(0,1fr)] xl:grid-cols-[15rem_minmax(0,1fr)_18rem]">
        <LessonSidebar activeLessonId={lesson.lesson.id} activePageIndex={activePageIndex} bookmarks={bookmarks} modules={lesson.modules} onPageSelect={goToPage} pages={lesson.pages} />

        <article className="min-w-0 px-6 py-8 sm:px-10 lg:py-10">
          <p className="text-xs font-semibold uppercase tracking-[0.16em] text-sky-700">Page {activePage.position} of {lesson.pages.length}</p>
          <h2 className="mt-2 text-3xl font-semibold tracking-tight">{activePage.title}</h2>
          <div className="mt-8 space-y-7">{activePage.content_blocks.map((block) => <ContentBlockRenderer block={block} key={block.id} />)}</div>
          <button className={`mt-8 rounded-lg px-4 py-2 text-sm font-medium ${completedPages.has(activePage.id) ? "bg-emerald-50 text-emerald-800" : "bg-emerald-700 text-white"}`} disabled={completedPages.has(activePage.id)} onClick={markPageComplete} type="button">{completedPages.has(activePage.id) ? "Page completed" : "Mark page complete"}</button>

          <nav aria-label="Lesson page navigation" className="mt-12 flex items-center justify-between border-t border-slate-200 pt-6">
            <button className="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium disabled:cursor-not-allowed disabled:opacity-40" disabled={activePageIndex === 0} onClick={() => goToPage(activePageIndex - 1)} type="button">&lt;- Previous</button>
            <span className="text-sm text-slate-500">{activePageIndex + 1} / {lesson.pages.length}</span>
            <button className="rounded-lg bg-slate-900 px-4 py-2 text-sm font-medium text-white disabled:cursor-not-allowed disabled:opacity-40" disabled={activePageIndex === lesson.pages.length - 1} onClick={() => goToPage(activePageIndex + 1)} type="button">Next -&gt;</button>
          </nav>
        </article>

        <div className="lg:col-span-2 xl:col-span-1">
          <NotesPanel note={notes[activePage.id] ?? ""} onChange={(note) => setNotes((current) => ({ ...current, [activePage.id]: note }))} onSave={saveCurrentNote} pageTitle={activePage.title} persistenceMode={persistenceMode} saving={savingNote} />
        </div>
      </div>
    </div>
  );
}
