import type { Competency, Evaluation, Rubric } from "./types";

export const mockCompetencies: Competency[] = [
  { id: "91000000-0000-4000-8000-000000000001", slug: "competency-1", name: "Competency 1", description: "Interprets evidence and reaches supported conclusions." },
  { id: "91000000-0000-4000-8000-000000000002", slug: "competency-2", name: "Competency 2", description: "Identifies and applies material requirements accurately." },
  { id: "91000000-0000-4000-8000-000000000003", slug: "competency-3", name: "Competency 3", description: "Produces clear, traceable, review-ready work products." },
  { id: "91000000-0000-4000-8000-000000000004", slug: "competency-4", name: "Competency 4", description: "Identifies, prioritizes, and communicates risk." },
];

const rubricDefinitions = [
  ["92000000-0000-4000-8000-000000000001", "Rubric 1"],
  ["92000000-0000-4000-8000-000000000002", "Rubric 2"],
  ["92000000-0000-4000-8000-000000000003", "Rubric 3"],
  ["92000000-0000-4000-8000-000000000004", "Rubric 4"],
  ["92000000-0000-4000-8000-000000000005", "Rubric 5"],
] as const;

export const mockRubrics: Rubric[] = rubricDefinitions.map(([id, title], rubricIndex) => ({
  id,
  title,
  description: "Mock weighted rubric for practical performance.",
  passing_score: 75,
  criteria: mockCompetencies.map((competency, index) => ({
    id: `92${rubricIndex + 1}${index + 1}0000-0000-4000-8000-000000000001`,
    rubric_id: id,
    competency_id: competency.id,
    title: competency.name,
    description: competency.description,
    weight_percent: 25,
    max_score: 25,
    position: index + 1,
  })),
}));

export const mockEvaluation: Evaluation = {
  id: "93000000-0000-4000-8000-000000000001",
  lab_submission_id: "93100000-0000-4000-8000-000000000001",
  rubric_id: mockRubrics[0].id,
  reviewer_id: null,
  status: "pending",
  total_score: null,
  passed: null,
  reviewer_feedback: null,
  competency_scores: [],
  evaluated_at: null,
};
