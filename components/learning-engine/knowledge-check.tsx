"use client";

import { useEffect, useState } from "react";
import { recordActivityAttempt } from "@/lib/persistence/activity-attempts";
import { isQuestionAnswered, scoreQuestion } from "@/lib/learning-engine/scoring";
import type { AssessmentQuestion, QuestionResponse, QuestionScore } from "@/lib/learning-engine/types";
import { QuestionRenderer } from "./question-renderer";

type Props = {
  question: AssessmentQuestion;
  contentBlockId?: string;
  gatesProgress?: boolean;
  alreadyPassed?: boolean;
  initialResponse?: QuestionResponse;
  onPassed?: () => void;
};

export function KnowledgeCheck({ question, contentBlockId, gatesProgress, alreadyPassed, initialResponse, onPassed }: Props) {
  const [response, setResponse] = useState<QuestionResponse>(() => initialResponse ?? null);
  const [result, setResult] = useState<QuestionScore | null>(() =>
    alreadyPassed ? { question_id: question.id, correct: true, earned_points: question.points, available_points: question.points } : null,
  );

  // alreadyPassed/initialResponse arrive from an async hydration effect one level up,
  // which resolves after this component's first mount -- the useState initializers above
  // only run once, so this syncs the restored answer in once the real data lands.
  useEffect(() => {
    if (alreadyPassed) {
      setResponse(initialResponse ?? null);
      setResult({ question_id: question.id, correct: true, earned_points: question.points, available_points: question.points });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- only re-sync on the hydration transition, not on every question identity change
  }, [alreadyPassed, initialResponse]);

  async function checkAnswer() {
    const scored = scoreQuestion(question, response);
    setResult(scored);
    if (gatesProgress && contentBlockId) {
      await recordActivityAttempt({ content_block_id: contentBlockId, question, response });
    }
    if (scored.correct) onPassed?.();
  }

  return (
    <section className="rounded-xl border border-violet-200 bg-violet-50 p-5">
      <p className="text-xs font-semibold uppercase tracking-wide text-violet-700">Knowledge check</p>
      <h2 className="mt-2 font-semibold">{question.prompt}</h2>
      <div className="mt-4"><QuestionRenderer disabled={result !== null} onChange={setResponse} question={question} response={response} /></div>
      {result ? <div className={`mt-4 rounded-lg border p-4 ${result.correct ? "border-emerald-200 bg-emerald-50 text-emerald-900" : "border-rose-200 bg-rose-50 text-rose-900"}`}><p className="font-semibold">{result.correct ? "Correct" : "Incorrect"} - {result.earned_points}/{result.available_points} point{result.available_points === 1 ? "" : "s"}</p><p className="mt-1 text-sm leading-6">{question.explanation}</p>{!result.correct ? <button className="mt-3 text-sm font-semibold underline" onClick={() => { setResponse(null); setResult(null); }} type="button">Try again</button> : null}</div> : <button className="mt-4 rounded-lg bg-violet-700 px-4 py-2 text-sm font-medium text-white disabled:cursor-not-allowed disabled:opacity-40" disabled={!isQuestionAnswered(question, response)} onClick={() => void checkAnswer()} type="button">Check answer</button>}
    </section>
  );
}
