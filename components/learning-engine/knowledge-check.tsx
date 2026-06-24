"use client";

import { useState } from "react";
import { isQuestionAnswered, scoreQuestion } from "@/lib/learning-engine/scoring";
import type { AssessmentQuestion, QuestionResponse, QuestionScore } from "@/lib/learning-engine/types";
import { QuestionRenderer } from "./question-renderer";

export function KnowledgeCheck({ question }: { question: AssessmentQuestion }) {
  const [response, setResponse] = useState<QuestionResponse>(null);
  const [result, setResult] = useState<QuestionScore | null>(null);

  return (
    <section className="rounded-xl border border-violet-200 bg-violet-50 p-5">
      <p className="text-xs font-semibold uppercase tracking-wide text-violet-700">Knowledge check</p>
      <h2 className="mt-2 font-semibold">{question.prompt}</h2>
      <div className="mt-4"><QuestionRenderer disabled={result !== null} onChange={setResponse} question={question} response={response} /></div>
      {result ? <div className={`mt-4 rounded-lg border p-4 ${result.correct ? "border-emerald-200 bg-emerald-50 text-emerald-900" : "border-rose-200 bg-rose-50 text-rose-900"}`}><p className="font-semibold">{result.correct ? "Correct" : "Incorrect"} - {result.earned_points}/{result.available_points} point{result.available_points === 1 ? "" : "s"}</p><p className="mt-1 text-sm leading-6">{question.explanation}</p><button className="mt-3 text-sm font-semibold underline" onClick={() => { setResponse(null); setResult(null); }} type="button">Try again</button></div> : <button className="mt-4 rounded-lg bg-violet-700 px-4 py-2 text-sm font-medium text-white disabled:cursor-not-allowed disabled:opacity-40" disabled={!isQuestionAnswered(question, response)} onClick={() => setResult(scoreQuestion(question, response))} type="button">Check answer</button>}
    </section>
  );
}
