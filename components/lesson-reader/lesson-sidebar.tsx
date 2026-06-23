import type { LessonModule, LessonPage } from "@/lib/lesson-reader/types";

type Props = {
  activeLessonId: string;
  activePageIndex: number;
  bookmarks: Set<string>;
  modules: LessonModule[];
  pages: LessonPage[];
  onPageSelect: (index: number) => void;
};

export function LessonSidebar({ activeLessonId, activePageIndex, bookmarks, modules, pages, onPageSelect }: Props) {
  return (
    <aside className="border-b border-slate-200 bg-slate-50 p-5 lg:border-b-0 lg:border-r">
      <p className="text-xs font-semibold uppercase tracking-wider text-slate-500">Course outline</p>
      <div className="mt-5 space-y-6">{modules.map((module) => <section key={module.id}><h2 className="text-xs font-semibold text-slate-500">Module {module.position} - {module.title}</h2><ul className="mt-2 space-y-1">{module.lessons.map((lesson) => <li key={lesson.id} className={`rounded-lg px-3 py-2 text-sm ${lesson.id === activeLessonId ? "bg-sky-100 font-medium text-sky-950" : "text-slate-600"}`}><div>{lesson.title}</div><span className="text-xs text-slate-400">{lesson.estimated_minutes ? `${lesson.estimated_minutes} min` : "Self-paced"}</span></li>)}</ul></section>)}</div>
      <div className="mt-7 border-t border-slate-200 pt-5"><h2 className="text-xs font-semibold uppercase tracking-wider text-slate-500">In this lesson</h2><ol className="mt-2 space-y-1">{pages.map((page, index) => <li key={page.id}><button className={`flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm ${index === activePageIndex ? "bg-slate-900 text-white" : "text-slate-600 hover:bg-slate-100"}`} onClick={() => onPageSelect(index)} type="button"><span>{index + 1}. {page.title}</span>{bookmarks.has(page.id) ? <span aria-label="Bookmarked" title="Bookmarked">★</span> : null}</button></li>)}</ol></div>
    </aside>
  );
}
