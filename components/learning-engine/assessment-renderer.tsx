"use client";

import { useMemo, useState } from "react";
import { recordAssessmentAttempt } from "@/lib/persistence/assessment-attempts";
import { isQuestionAnswered, scoreQuestion } from "@/lib/learning-engine/scoring";
import type { Assessment, QuestionResponse, QuestionScore } from "@/lib/learning-engine/types";
import type { PersistenceMode } from "@/lib/persistence/types";
import { QuestionRenderer } from "./question-renderer";

export function AssessmentRenderer({ assessment }: { assessment: Assessment }) {
  const isQuickReview = assessment.assessment_type === "quick_review";
  const [responses, setResponses] = useState<Record<string, QuestionResponse>>({});
  const [results, setResults] = useState<QuestionScore[] | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [persistenceMode, setPersistenceMode] = useState<PersistenceMode | null>(null);
  const answered = assessment.questions.filter((question) => isQuestionAnswered(question, responses[question.id] ?? null)).length;

  const summary = useMemo(() => {
    if (!results) return null;
    const earned = results.reduce((total, result) => total + result.earned_points, 0);
    const available = results.reduce((total, result) => total + result.available_points, 0);
    const percent = available ? Math.round((earned / available) * 100) : 0;
    return { earned, available, percent, passed: percent >= assessment.passing_score };
  }, [assessment.passing_score, results]);

  async function submit() {
    setSubmitting(true);
    setResults(assessment.questions.map((question) => scoreQuestion(question, responses[question.id] ?? null)));
    const result = await recordAssessmentAttempt({
      assessment_id: assessment.id,
      questions: assessment.questions,
      passing_score: assessment.passing_score,
      is_exam: !isQuickReview,
      responses,
    });
    setPersistenceMode(result.mode);
    setSubmitting(false);
  }

  function reset() {
    setResponses({});
    setResults(null);
    setPersistenceMode(null);
  }

  return (
    <section className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
      <header className="border-b border-slate-200 bg-slate-50 p-6 sm:p-8"><p className="text-xs font-semibold uppercase tracking-wider text-sky-700">{isQuickReview ? "Quick review" : "Assessment"}</p><h1 className="mt-2 text-3xl font-semibold tracking-tight">{assessment.title}</h1><p className="mt-3 max-w-3xl text-slate-600">{assessment.description}</p><div className="mt-5 flex flex-wrap gap-4 text-sm text-slate-500"><span>{assessment.questions.length} questions</span><span>{answered} answered</span>{!isQuickReview && <span>{assessment.passing_score}% to pass</span>}</div></header>

      {summary ? (
        <div className={`m-6 rounded-xl border p-5 sm:m-8 ${isQuickReview ? "border-sky-200 bg-sky-50" : summary.passed ? "border-emerald-200 bg-emerald-50" : "border-rose-200 bg-rose-50"}`}>
          <p className="text-sm font-medium">{isQuickReview ? "Review complete" : "Assessment status"}</p>
          <p className="mt-1 text-2xl font-semibold">{isQuickReview ? `${summary.percent}%` : `${summary.passed ? "Passed" : "Review recommended"} - ${summary.percent}%`}</p>
          <p className="mt-1 text-sm text-slate-600">{summary.earned} of {summary.available} points{persistenceMode ? ` - ${persistenceMode === "supabase" ? "saved" : "local mock mode"}` : ""}</p>
        </div>
      ) : null}

      <div className="space-y-6 p-6 sm:p-8">{assessment.questions.map((question, index) => { const result = results?.find((item) => item.question_id === question.id); return <article className="rounded-xl border border-slate-200 p-5" key={question.id}><div className="flex items-start justify-between gap-4"><div><p className="text-xs font-semibold uppercase tracking-wider text-slate-400">Question {index + 1} - {question.question_type.replaceAll("_", " ")}</p><h2 className="mt-2 font-semibold leading-6">{question.prompt}</h2></div><span className="text-xs text-slate-400">{question.points} pt</span></div><div className="mt-4"><QuestionRenderer disabled={results !== null} onChange={(response) => setResponses((current) => ({ ...current, [question.id]: response }))} question={question} response={responses[question.id] ?? null} /></div>{result ? <div className={`mt-4 rounded-lg p-4 text-sm ${result.correct ? "bg-emerald-50 text-emerald-900" : "bg-rose-50 text-rose-900"}`}><p className="font-semibold">{result.correct ? "Correct" : "Incorrect"}</p><p className="mt-1 leading-6">{question.explanation}</p>{question.question_type === "short_response" ? <p className="mt-2"><strong>Sample answer:</strong> {question.sample_answer}</p> : null}</div> : null}</article>; })}</div>

      <footer className="flex flex-wrap items-center justify-between gap-4 border-t border-slate-200 bg-slate-50 p-6 sm:px-8"><span className="text-sm text-slate-500">{answered} of {assessment.questions.length} complete</span>{results ? <button className="rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-medium" onClick={reset} type="button">{isQuickReview ? "Review again" : "Retake assessment"}</button> : <button className="rounded-lg bg-slate-900 px-4 py-2 text-sm font-medium text-white disabled:opacity-40" disabled={answered !== assessment.questions.length || submitting} onClick={() => void submit()} type="button">{submitting ? "Submitting..." : isQuickReview ? "Submit review" : "Submit assessment"}</button>}</footer>
    </section>
  );
}
