import type { AssessmentQuestion, QuestionResponse, QuestionScore } from "./types";

function sameValues(left: string[], right: string[]) {
  return left.length === right.length && left.every((value) => right.includes(value));
}

export function isQuestionAnswered(question: AssessmentQuestion, response: QuestionResponse) {
  if (response === null) return false;
  if (typeof response === "string") return response.trim().length > 0;
  if (typeof response === "boolean") return true;
  if (Array.isArray(response)) return response.length > 0;
  return question.question_type === "matching" && Object.keys(response).length === question.pairs.length;
}

export function scoreQuestion(question: AssessmentQuestion, response: QuestionResponse): QuestionScore {
  let correct = false;

  switch (question.question_type) {
    case "multiple_choice":
      correct = response === question.correct_option_id;
      break;
    case "multiple_select":
      correct = Array.isArray(response) && sameValues(response, question.correct_option_ids);
      break;
    case "true_false":
      correct = response === question.correct_answer;
      break;
    case "matching":
      correct = !Array.isArray(response) && typeof response === "object" && response !== null && question.pairs.every((pair) => response[pair.id] === pair.id);
      break;
    case "ordering":
      correct = Array.isArray(response) && response.length === question.correct_order.length && response.every((value, index) => value === question.correct_order[index]);
      break;
    case "fill_blank": {
      if (typeof response !== "string") break;
      const submitted = question.case_sensitive ? response.trim() : response.trim().toLocaleLowerCase();
      correct = question.accepted_answers.some((answer) => (question.case_sensitive ? answer : answer.toLocaleLowerCase()) === submitted);
      break;
    }
    case "short_response": {
      if (typeof response !== "string") break;
      const submitted = response.toLocaleLowerCase();
      correct = question.scoring_keywords.every((keyword) => submitted.includes(keyword.toLocaleLowerCase()));
      break;
    }
  }

  return {
    question_id: question.id,
    correct,
    earned_points: correct ? question.points : 0,
    available_points: question.points,
  };
}
