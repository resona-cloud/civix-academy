"use client";

import { useState } from "react";
import type { ContentBlock } from "@/lib/lesson-reader/types";

const calloutStyles = {
  info: "border-sky-200 bg-sky-50 text-sky-950",
  warning: "border-amber-200 bg-amber-50 text-amber-950",
  success: "border-emerald-200 bg-emerald-50 text-emerald-950",
};

export function ContentBlockRenderer({ block }: { block: ContentBlock }) {
  const [selection, setSelection] = useState<string | null>(null);

  switch (block.block_type) {
    case "rich_text":
      return <section>{block.content.heading ? <h2 className="mb-3 text-xl font-semibold">{block.content.heading}</h2> : null}<div className="space-y-4 leading-7 text-slate-700">{block.content.body.map((paragraph) => <p key={paragraph}>{paragraph}</p>)}</div></section>;
    case "callout":
      return <aside className={`rounded-xl border p-5 ${calloutStyles[block.content.tone]}`}><h2 className="font-semibold">{block.content.title}</h2><p className="mt-2 text-sm leading-6">{block.content.body}</p></aside>;
    case "download":
      return <section className="flex items-center justify-between gap-4 rounded-xl border border-slate-200 bg-slate-50 p-5"><div><h2 className="font-semibold">{block.content.title}</h2><p className="mt-1 text-sm text-slate-500">{block.content.description}</p></div><button className="rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-medium" type="button">Preview</button></section>;
    case "activity":
      return <section className="rounded-xl border border-violet-200 bg-violet-50 p-5"><p className="text-xs font-semibold uppercase tracking-wide text-violet-700">Knowledge check</p><h2 className="mt-2 font-semibold">{block.content.prompt}</h2><div className="mt-4 grid gap-2">{block.content.options.map((option) => <button className={`rounded-lg border px-4 py-3 text-left text-sm ${selection === option ? "border-violet-600 bg-white ring-2 ring-violet-200" : "border-violet-200 bg-white/70"}`} key={option} onClick={() => setSelection(option)} type="button">{option}</button>)}</div>{selection ? <p className="mt-3 text-sm text-violet-800">Response selected. Scoring is not connected in this mock.</p> : null}</section>;
    case "image":
      return <section className="rounded-xl border border-dashed border-slate-300 bg-slate-50 p-5 text-sm text-slate-500">Image block placeholder: {block.content.alt}</section>;
    case "video":
      return <section className="rounded-xl border border-dashed border-slate-300 bg-slate-50 p-5 text-sm text-slate-500">Video block placeholder: {block.content.title}</section>;
  }
}
