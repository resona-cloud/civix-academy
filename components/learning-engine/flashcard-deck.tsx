"use client";

import { useMemo, useState } from "react";
import type { Flashcard } from "@/lib/learning-engine/types";

export function FlashcardDeck({ cards }: { cards: Flashcard[] }) {
  const categories = useMemo(() => ["All", ...Array.from(new Set(cards.map((card) => card.category)))], [cards]);
  const [category, setCategory] = useState("All");
  const [index, setIndex] = useState(0);
  const [flipped, setFlipped] = useState(false);
  const [known, setKnown] = useState<Set<string>>(() => new Set());
  const [reviewLater, setReviewLater] = useState<Set<string>>(() => new Set());
  const visibleCards = category === "All" ? cards : cards.filter((card) => card.category === category);
  const card = visibleCards[index];
  const percent = cards.length ? Math.round((known.size / cards.length) * 100) : 0;

  function advance() {
    setIndex((current) => visibleCards.length ? (current + 1) % visibleCards.length : 0);
    setFlipped(false);
  }

  function markKnown() {
    if (!card) return;
    setKnown((current) => new Set(current).add(card.id));
    setReviewLater((current) => { const next = new Set(current); next.delete(card.id); return next; });
    advance();
  }

  function markReview() {
    if (!card) return;
    setReviewLater((current) => new Set(current).add(card.id));
    setKnown((current) => { const next = new Set(current); next.delete(card.id); return next; });
    advance();
  }

  return (
    <section>
      <div className="flex flex-wrap items-center justify-between gap-4"><div className="flex flex-wrap gap-2">{categories.map((item) => <button aria-pressed={category === item} className={`rounded-full border px-3 py-1.5 text-xs font-medium ${category === item ? "border-violet-700 bg-violet-700 text-white" : "border-slate-300 bg-white text-slate-600"}`} key={item} onClick={() => { setCategory(item); setIndex(0); setFlipped(false); }} type="button">{item}</button>)}</div><span className="text-sm text-slate-500">{known.size} known - {reviewLater.size} review later</span></div>
      <div className="mt-5 h-2 overflow-hidden rounded-full bg-slate-200"><div className="h-full rounded-full bg-violet-600 transition-[width]" style={{ width: `${percent}%` }} /></div>
      {card ? <><button aria-label="Flip flashcard" className="mt-6 flex min-h-64 w-full items-center justify-center rounded-2xl border border-violet-200 bg-gradient-to-br from-white to-violet-50 p-8 text-center shadow-sm" onClick={() => setFlipped((current) => !current)} type="button"><span><span className="text-xs font-semibold uppercase tracking-wider text-violet-600">{flipped ? "Back" : "Front"} - {card.category}</span><span className={`mt-4 block ${flipped ? "text-lg leading-8 text-slate-700" : "text-3xl font-semibold"}`}>{flipped ? card.back : card.front}</span><span className="mt-6 block text-xs text-slate-400">Click card to flip</span></span></button><div className="mt-5 flex flex-wrap items-center justify-between gap-3"><span className="text-sm text-slate-500">Card {index + 1} of {visibleCards.length}</span><div className="flex gap-2"><button className="rounded-lg border border-amber-300 bg-amber-50 px-4 py-2 text-sm font-medium text-amber-900" onClick={markReview} type="button">Review later</button><button className="rounded-lg bg-emerald-700 px-4 py-2 text-sm font-medium text-white" onClick={markKnown} type="button">Mark known</button></div></div></> : <p className="mt-6 text-sm text-slate-500">No cards in this category.</p>}
    </section>
  );
}
