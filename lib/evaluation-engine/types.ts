export type Competency = {
  id: string;
  slug: string;
  name: string;
  description: string;
};

export type RubricCriterion = {
  id: string;
  rubric_id: string;
  competency_id: string;
  title: string;
  description: string;
  weight_percent: number;
  max_score: number;
  position: number;
};

export type Rubric = {
  id: string;
  title: string;
  description: string;
  passing_score: number;
  criteria: RubricCriterion[];
};

export type CompetencyScore = {
  competency_id: string;
  criterion_id: string;
  score: number;
  max_score: number;
  feedback: string | null;
};

export type Evaluation = {
  id: string;
  lab_submission_id: string;
  rubric_id: string;
  reviewer_id: string | null;
  status: "pending" | "in_review" | "completed";
  total_score: number | null;
  passed: boolean | null;
  reviewer_feedback: string | null;
  competency_scores: CompetencyScore[];
  evaluated_at: string | null;
};
