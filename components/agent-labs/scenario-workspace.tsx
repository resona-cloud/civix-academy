"use client";

import Link from "next/link";
import { useState } from "react";
import type { LabScenario, LabScenarioProgress } from "@/lib/agent-labs/types";
import type { Competency, Rubric } from "@/lib/evaluation-engine/types";
import { RubricViewer } from "@/components/evaluation-engine/rubric-viewer";

type Props = { scenario: LabScenario; progress: LabScenarioProgress; rubric: Rubric; competencies: Competency[] };

export function ScenarioWorkspace({ scenario, progress, rubric, competencies }: Props) {
  const [completedTasks, setCompletedTasks] = useState(() => new Set(progress.completed_task_ids));
  const completePercent = scenario.tasks.length ? Math.round((completedTasks.size / scenario.tasks.length) * 100) : 0;

  function toggleTask(taskId: string) {
    setCompletedTasks((current) => {
      const next = new Set(current);
      if (next.has(taskId)) next.delete(taskId);
      else next.add(taskId);
      return next;
    });
  }

  return <><Link className="text-sm font-medium text-amber-700" href="/labs">&lt;- Back to Agent Labs</Link><header className="mt-5 rounded-2xl bg-slate-950 p-7 text-white sm:p-10"><div className="flex flex-wrap items-start justify-between gap-5"><div className="max-w-3xl"><p className="text-xs font-semibold uppercase tracking-[0.18em] text-amber-400">Agent Lab - {scenario.difficulty}</p><h1 className="mt-3 text-3xl font-semibold tracking-tight sm:text-4xl">{scenario.title}</h1><p className="mt-4 leading-7 text-slate-300">{scenario.summary}</p></div><div className="rounded-xl bg-white/10 px-5 py-4 text-right"><p className="text-xs uppercase tracking-wide text-slate-400">Completion</p><strong className="mt-1 block text-2xl">{completePercent}%</strong><p className="mt-1 text-xs capitalize text-slate-300">{progress.completion_status.replaceAll("_", " ")}</p></div></div><div className="mt-6 h-2 overflow-hidden rounded-full bg-slate-700"><div className="h-full rounded-full bg-amber-400" style={{ width: `${completePercent}%` }} /></div></header>

  <div className="mt-6 grid gap-6 xl:grid-cols-[minmax(0,1fr)_20rem]"><main className="space-y-6"><section className="rounded-xl border border-slate-200 bg-white p-6"><p className="text-xs font-semibold uppercase tracking-wider text-amber-700">Scenario briefing</p><p className="mt-3 leading-7 text-slate-700">{scenario.briefing}</p><div className="mt-5 flex gap-5 text-sm text-slate-500"><span>{scenario.estimated_minutes} minutes</span><span className="capitalize">{scenario.difficulty}</span></div></section><section className="rounded-xl border border-slate-200 bg-white p-6"><p className="text-xs font-semibold uppercase tracking-wider text-amber-700">Scenario tasks</p><div className="mt-4 grid gap-3">{scenario.tasks.map((task) => <label className={`flex cursor-pointer items-start gap-3 rounded-lg border p-4 ${completedTasks.has(task.id) ? "border-emerald-200 bg-emerald-50" : "border-slate-200"}`} key={task.id}><input checked={completedTasks.has(task.id)} className="mt-1" onChange={() => toggleTask(task.id)} type="checkbox" /><span><span className="font-semibold">{task.position}. {task.title}</span><span className="mt-1 block text-sm leading-6 text-slate-600">{task.instructions}</span></span></label>)}</div>{completePercent === 100 ? <div className="mt-4 rounded-lg bg-emerald-50 p-4 text-sm font-medium text-emerald-800">All required tasks are complete. Submission remains mock-only.</div> : null}</section><RubricViewer competencies={competencies} rubric={rubric} /></main>

  <aside className="space-y-6"><section className="rounded-xl border border-slate-200 bg-white p-5"><p className="text-xs font-semibold uppercase tracking-wider text-amber-700">Objectives</p><ol className="mt-4 space-y-3">{scenario.objectives.map((objective) => <li className="flex gap-2 text-sm leading-6 text-slate-600" key={objective.id}><span className="font-semibold text-amber-700">{objective.position}.</span>{objective.description}</li>)}</ol></section><section className="rounded-xl border border-slate-200 bg-white p-5"><p className="text-xs font-semibold uppercase tracking-wider text-amber-700">Scenario documents</p><div className="mt-4 grid gap-3">{scenario.documents.map((document) => <button className="rounded-lg border border-slate-200 p-3 text-left" key={document.id} type="button"><span className="block text-sm font-semibold">{document.title}</span><span className="mt-1 block text-xs capitalize text-slate-400">{document.document_type.replaceAll("_", " ")}</span><span className="mt-2 block text-xs leading-5 text-slate-500">{document.description}</span></button>)}</div></section><section className="rounded-xl border border-violet-200 bg-violet-50 p-5"><p className="text-xs font-semibold uppercase tracking-wider text-violet-700">Instructor notes</p><ul className="mt-3 list-disc space-y-2 pl-4 text-sm leading-6 text-violet-950">{scenario.instructor_notes.map((note) => <li key={note}>{note}</li>)}</ul></section></aside></div></>;
}
