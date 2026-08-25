import Link from "next/link";
import type { CourseProgress, Flashcard, StudyLink } from "@/lib/learning-engine/types";
import { FlashcardDeck } from "./flashcard-deck";
import { ProgressTracker } from "./progress-tracker";
import { StudyPanel } from "./study-panel";

function LinkList({ items, emptyLabel }: { items: StudyLink[]; emptyLabel: string }) {
  if (items.length === 0) return <p className="text-sm text-slate-500">{emptyLabel}</p>;
  return <div className="grid gap-3">{items.map((item) => <Link className="rounded-lg border border-slate-200 p-4 hover:border-sky-300 hover:bg-sky-50/40" href={item.href} key={item.id}><span className="font-medium">{item.title}</span><span className="mt-1 block text-sm text-slate-500">{item.description}</span></Link>)}</div>;
}

type Props = {
  progress: CourseProgress | null;
  quickReviews: StudyLink[];
  savedBookmarks: StudyLink[];
  recommendedLesson: StudyLink | null;
  flashcards: Flashcard[];
  isMock: boolean;
};

export function StudyCenter({ progress, quickReviews, savedBookmarks, recommendedLesson, flashcards, isMock }: Props) {
  return (
    <>
      <header className="mb-8"><p className="text-xs font-semibold uppercase tracking-[0.18em] text-violet-700">Learning Engine</p><h1 className="mt-2 text-3xl font-semibold tracking-tight">Study Center</h1><p className="mt-2 max-w-2xl text-slate-600">Review key concepts, resume recommended work, and monitor learning progress.</p></header>
      {isMock && <p className="mb-4 text-xs font-semibold uppercase tracking-wider text-amber-700">Local mock catalog</p>}
      {progress ? <ProgressTracker progress={progress} /> : <section className="rounded-xl border border-slate-200 bg-white p-6"><p className="text-sm text-slate-500">No active course enrollment yet.</p></section>}
      <div className="mt-6 grid gap-6 lg:grid-cols-2">
        <StudyPanel eyebrow="Quick reviews" title="Test your recall"><LinkList emptyLabel="No quick reviews due right now." items={quickReviews} /></StudyPanel>
        <StudyPanel eyebrow="Saved bookmarks" title="Return to saved references"><LinkList emptyLabel="No bookmarks saved yet." items={savedBookmarks} /></StudyPanel>
        <StudyPanel eyebrow="Recommended lessons" title="Continue learning"><LinkList emptyLabel="No lessons in progress." items={recommendedLesson ? [recommendedLesson] : []} /></StudyPanel>
        <StudyPanel eyebrow="Progress snapshot" title="What to focus on next">
          <p className="text-sm leading-6 text-slate-600">
            {recommendedLesson ? <>Continue with <strong>{recommendedLesson.title}</strong>.</> : "You're caught up on lessons."}
            {quickReviews.length > 0 ? ` ${quickReviews.length} quick review${quickReviews.length === 1 ? " is" : "s are"} due.` : ""}
          </p>
        </StudyPanel>
      </div>
      <div className="mt-6"><StudyPanel eyebrow="Flashcards" title="Key concepts"><FlashcardDeck cards={flashcards} /></StudyPanel></div>
    </>
  );
}
