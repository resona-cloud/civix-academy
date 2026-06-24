"use client";

import type { ContentBlock } from "@/lib/lesson-reader/types";
import { KnowledgeCheck } from "@/components/learning-engine/knowledge-check";

const calloutStyles = {
  info: "border-sky-200 bg-sky-50 text-sky-950",
  warning: "border-amber-200 bg-amber-50 text-amber-950",
  success: "border-emerald-200 bg-emerald-50 text-emerald-950",
};

export function ContentBlockRenderer({ block }: { block: ContentBlock }) {
  switch (block.block_type) {
    case "rich_text":
      return <section>{block.content.heading ? <h2 className="mb-3 text-xl font-semibold">{block.content.heading}</h2> : null}<div className="space-y-4 leading-7 text-slate-700">{block.content.body.map((paragraph) => <p key={paragraph}>{paragraph}</p>)}</div></section>;
    case "callout":
      return <aside className={`rounded-xl border p-5 ${calloutStyles[block.content.tone]}`}><h2 className="font-semibold">{block.content.title}</h2><p className="mt-2 text-sm leading-6">{block.content.body}</p></aside>;
    case "download":
      return <section className="flex items-center justify-between gap-4 rounded-xl border border-slate-200 bg-slate-50 p-5"><div><h2 className="font-semibold">{block.content.title}</h2><p className="mt-1 text-sm text-slate-500">{block.content.description}</p></div><button className="rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-medium" type="button">Preview</button></section>;
    case "activity":
      return <KnowledgeCheck question={block.content.question} />;
    case "image":
      return <section className="rounded-xl border border-dashed border-slate-300 bg-slate-50 p-5 text-sm text-slate-500">Image block placeholder: {block.content.alt}</section>;
    case "video":
      return <section className="rounded-xl border border-dashed border-slate-300 bg-slate-50 p-5 text-sm text-slate-500">Video block placeholder: {block.content.title}</section>;
  }
}
