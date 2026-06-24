import Link from "next/link";
import type { LabScenario, LabScenarioProgress } from "@/lib/agent-labs/types";

export function ScenarioCard({ scenario, progress }: { scenario: LabScenario; progress?: LabScenarioProgress }) {
  return <article className="flex h-full flex-col rounded-xl border border-slate-200 bg-white p-6 shadow-sm"><div className="flex items-start justify-between gap-3"><span className="rounded-full bg-amber-50 px-3 py-1 text-xs font-semibold capitalize text-amber-800">{scenario.difficulty}</span><span className="text-xs font-medium capitalize text-slate-500">{progress?.completion_status.replaceAll("_", " ") ?? "not started"}</span></div><h2 className="mt-4 text-xl font-semibold tracking-tight">{scenario.title}</h2><p className="mt-2 flex-1 text-sm leading-6 text-slate-600">{scenario.summary}</p><div className="mt-5 flex gap-4 text-xs text-slate-500"><span>{scenario.estimated_minutes} min</span><span>{scenario.tasks.length} tasks</span><span>{scenario.documents.length} documents</span></div><Link className="mt-5 text-sm font-semibold text-amber-700" href={`/labs/${scenario.id}`}>Open scenario -&gt;</Link></article>;
}
