"use client";

import { useState } from "react";
import { mockReviewSubmissions, mockReviewerWorkloads } from "@/lib/instructor-operations/mock-data";
import type { ReviewSubmission } from "@/lib/instructor-operations/types";
import { ReviewCard } from "./review-card";

type Filter = "active" | "lab" | "assessment" | "short_response" | "completed";

export function ReviewQueue() {
  const [filter, setFilter] = useState<Filter>("active");
  const submissions = mockReviewSubmissions.filter((item) => filter === "active" ? item.status !== "completed" : filter === "completed" ? item.status === "completed" : item.submission_type === filter && item.status !== "completed");
  const filters: { value: Filter; label: string }[] = [{ value: "active", label: "Active" }, { value: "lab", label: "Labs" }, { value: "assessment", label: "Assessments" }, { value: "short_response", label: "Short responses" }, { value: "completed", label: "Completed" }];

  return <><header className="mb-8"><p className="text-xs font-semibold uppercase tracking-[0.18em] text-indigo-700">Instructor operations</p><h1 className="mt-2 text-3xl font-semibold tracking-tight">Review Queue</h1><p className="mt-2 max-w-2xl text-slate-600">Prioritize lab submissions, assessment attempts, and written responses requiring human judgment.</p></header><div className="flex flex-wrap gap-2">{filters.map((item) => <button aria-pressed={filter === item.value} className={`rounded-full border px-3 py-1.5 text-sm font-medium ${filter === item.value ? "border-indigo-700 bg-indigo-700 text-white" : "border-slate-300 bg-white text-slate-600"}`} key={item.value} onClick={() => setFilter(item.value)} type="button">{item.label}</button>)}</div><div className="mt-6 grid gap-6 xl:grid-cols-[minmax(0,1fr)_20rem]"><section><div className="mb-3 flex justify-between text-sm text-slate-500"><span>{submissions.length} submission{submissions.length === 1 ? "" : "s"}</span><span>{mockReviewSubmissions.filter((item) => item.reviewer_id === null && item.status !== "completed").length} unassigned</span></div><div className="grid gap-4 md:grid-cols-2">{submissions.map((submission: ReviewSubmission) => <ReviewCard key={submission.id} submission={submission} />)}</div></section><aside className="rounded-xl border border-slate-200 bg-white p-5"><p className="text-xs font-semibold uppercase tracking-wider text-indigo-700">Reviewer workload</p><div className="mt-4 divide-y divide-slate-100">{mockReviewerWorkloads.map((reviewer) => <div className="py-3" key={reviewer.reviewer_id}><div className="flex justify-between gap-3"><span className="text-sm font-medium">{reviewer.reviewer_name}</span><span className="text-xs capitalize text-slate-500">{reviewer.capacity_status.replaceAll("_", " ")}</span></div><p className="mt-1 text-xs text-slate-400">{reviewer.assigned_count} assigned - {reviewer.overdue_count} overdue</p></div>)}</div></aside></div></>;
}
