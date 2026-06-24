import Link from "next/link";
import { mockCourseProgress, mockFlashcards, mockQuickReviews, mockRecommendedLessons, mockSavedBookmarks } from "@/lib/learning-engine/mock-data";
import type { StudyLink } from "@/lib/learning-engine/types";
import { FlashcardDeck } from "./flashcard-deck";
import { ProgressTracker } from "./progress-tracker";
import { StudyPanel } from "./study-panel";

function LinkList({ items }: { items: StudyLink[] }) {
  return <div className="grid gap-3">{items.map((item) => <Link className="rounded-lg border border-slate-200 p-4 hover:border-sky-300 hover:bg-sky-50/40" href={item.href} key={item.id}><span className="font-medium">{item.title}</span><span className="mt-1 block text-sm text-slate-500">{item.description}</span></Link>)}</div>;
}

export function StudyCenter() {
  return (
    <>
      <header className="mb-8"><p className="text-xs font-semibold uppercase tracking-[0.18em] text-violet-700">Learning Engine</p><h1 className="mt-2 text-3xl font-semibold tracking-tight">Study Center</h1><p className="mt-2 max-w-2xl text-slate-600">Review key concepts, resume recommended work, and monitor learning progress.</p></header>
      <ProgressTracker progress={mockCourseProgress} />
      <div className="mt-6 grid gap-6 lg:grid-cols-2"><StudyPanel eyebrow="Quick reviews" title="Test your recall"><LinkList items={mockQuickReviews} /></StudyPanel><StudyPanel eyebrow="Saved bookmarks" title="Return to saved references"><LinkList items={mockSavedBookmarks} /></StudyPanel><StudyPanel eyebrow="Recommended lessons" title="Continue learning"><LinkList items={mockRecommendedLessons} /></StudyPanel><StudyPanel eyebrow="Progress snapshot" title="What to focus on next"><p className="text-sm leading-6 text-slate-600">Finish the market research lesson, then complete the Procurement Foundations Quick Review. Your mock progress updates only inside each interactive component.</p></StudyPanel></div>
      <div className="mt-6"><StudyPanel eyebrow="Flashcards" title="Procurement concepts"><FlashcardDeck cards={mockFlashcards} /></StudyPanel></div>
    </>
  );
}
