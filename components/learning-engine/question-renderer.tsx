"use client";

import type { AssessmentQuestion, QuestionResponse } from "@/lib/learning-engine/types";

type Props = {
  question: AssessmentQuestion;
  response: QuestionResponse;
  onChange: (response: QuestionResponse) => void;
  disabled?: boolean;
};

const optionClass = "flex w-full items-start gap-3 rounded-lg border border-slate-200 bg-white px-4 py-3 text-left text-sm hover:border-sky-300 disabled:cursor-not-allowed disabled:opacity-70";

export function QuestionRenderer({ question, response, onChange, disabled = false }: Props) {
  switch (question.question_type) {
    case "multiple_choice":
      return <div className="grid gap-2">{question.options.map((option) => <label className={optionClass} key={option.id}><input checked={response === option.id} disabled={disabled} name={question.id} onChange={() => onChange(option.id)} type="radio" /><span>{option.label}</span></label>)}</div>;

    case "multiple_select": {
      const selected = Array.isArray(response) ? response : [];
      return <div className="grid gap-2">{question.options.map((option) => <label className={optionClass} key={option.id}><input checked={selected.includes(option.id)} disabled={disabled} onChange={() => onChange(selected.includes(option.id) ? selected.filter((id) => id !== option.id) : [...selected, option.id])} type="checkbox" /><span>{option.label}</span></label>)}</div>;
    }

    case "true_false":
      return <div className="grid grid-cols-2 gap-3">{[true, false].map((value) => <button aria-pressed={response === value} className={`rounded-lg border px-4 py-3 text-sm font-medium ${response === value ? "border-sky-600 bg-sky-50 text-sky-900" : "border-slate-200 bg-white"}`} disabled={disabled} key={String(value)} onClick={() => onChange(value)} type="button">{value ? "True" : "False"}</button>)}</div>;

    case "matching": {
      const mapping = response && !Array.isArray(response) && typeof response === "object" ? response : {};
      return <div className="grid gap-3">{question.pairs.map((pair) => <label className="grid gap-2 rounded-lg border border-slate-200 bg-white p-4 text-sm sm:grid-cols-2 sm:items-center" key={pair.id}><span className="font-medium">{pair.left}</span><select className="rounded-md border border-slate-300 bg-white px-3 py-2" disabled={disabled} onChange={(event) => onChange({ ...mapping, [pair.id]: event.target.value })} value={mapping[pair.id] ?? ""}><option value="">Choose a match</option>{question.pairs.map((choice) => <option key={choice.id} value={choice.id}>{choice.right}</option>)}</select></label>)}</div>;
    }

    case "ordering": {
      const order = Array.isArray(response) && response.length ? response : question.items.map((item) => item.id);
      const move = (index: number, direction: -1 | 1) => {
        const target = index + direction;
        if (target < 0 || target >= order.length) return;
        const next = [...order];
        [next[index], next[target]] = [next[target], next[index]];
        onChange(next);
      };
      return <ol className="grid gap-2">{order.map((itemId, index) => { const item = question.items.find((candidate) => candidate.id === itemId); if (!item) return null; return <li className="flex items-center gap-3 rounded-lg border border-slate-200 bg-white p-3" key={item.id}><span className="flex h-7 w-7 items-center justify-center rounded-full bg-slate-100 text-xs font-semibold">{index + 1}</span><span className="flex-1 text-sm">{item.label}</span><button aria-label={`Move ${item.label} up`} className="rounded border px-2 py-1 text-xs" disabled={disabled || index === 0} onClick={() => move(index, -1)} type="button">Up</button><button aria-label={`Move ${item.label} down`} className="rounded border px-2 py-1 text-xs" disabled={disabled || index === order.length - 1} onClick={() => move(index, 1)} type="button">Down</button></li>; })}</ol>;
    }

    case "fill_blank":
      return <input className="w-full rounded-lg border border-slate-300 bg-white px-4 py-3 text-sm" disabled={disabled} onChange={(event) => onChange(event.target.value)} placeholder="Type the missing term" type="text" value={typeof response === "string" ? response : ""} />;

    case "short_response":
      return <textarea className="min-h-32 w-full rounded-lg border border-slate-300 bg-white px-4 py-3 text-sm leading-6" disabled={disabled} onChange={(event) => onChange(event.target.value)} placeholder="Write a short response" value={typeof response === "string" ? response : ""} />;
  }
}
