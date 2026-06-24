export type QuestionType =
  | "multiple_choice"
  | "multiple_select"
  | "true_false"
  | "matching"
  | "ordering"
  | "fill_blank"
  | "short_response";

export type QuestionOption = { id: string; label: string };

type QuestionBase = {
  id: string;
  assessment_id: string | null;
  question_type: QuestionType;
  prompt: string;
  explanation: string;
  points: number;
  position: number;
};

export type MultipleChoiceQuestion = QuestionBase & {
  question_type: "multiple_choice";
  options: QuestionOption[];
  correct_option_id: string;
};

export type MultipleSelectQuestion = QuestionBase & {
  question_type: "multiple_select";
  options: QuestionOption[];
  correct_option_ids: string[];
};

export type TrueFalseQuestion = QuestionBase & {
  question_type: "true_false";
  correct_answer: boolean;
};

export type MatchingQuestion = QuestionBase & {
  question_type: "matching";
  pairs: { id: string; left: string; right: string }[];
};

export type OrderingQuestion = QuestionBase & {
  question_type: "ordering";
  items: QuestionOption[];
  correct_order: string[];
};

export type FillBlankQuestion = QuestionBase & {
  question_type: "fill_blank";
  accepted_answers: string[];
  case_sensitive: boolean;
};

export type ShortResponseQuestion = QuestionBase & {
  question_type: "short_response";
  sample_answer: string;
  scoring_keywords: string[];
};

export type AssessmentQuestion =
  | MultipleChoiceQuestion
  | MultipleSelectQuestion
  | TrueFalseQuestion
  | MatchingQuestion
  | OrderingQuestion
  | FillBlankQuestion
  | ShortResponseQuestion;

export type QuestionResponse = string | string[] | boolean | Record<string, string> | null;

export type Assessment = {
  id: string;
  slug: string;
  title: string;
  description: string;
  status: "published";
  passing_score: number;
  questions: AssessmentQuestion[];
};

export type QuestionScore = {
  question_id: string;
  correct: boolean;
  earned_points: number;
  available_points: number;
};

export type Flashcard = {
  id: string;
  category: string;
  front: string;
  back: string;
  position: number;
};

export type LessonProgress = {
  lesson_id: string;
  title: string;
  status: "not_started" | "in_progress" | "completed";
  progress_percent: number;
};

export type ModuleProgress = {
  module_id: string;
  title: string;
  progress_percent: number;
  lessons: LessonProgress[];
};

export type AssessmentProgress = {
  assessment_id: string;
  title: string;
  status: "not_started" | "in_progress" | "passed" | "failed";
  score: number | null;
};

export type CourseProgress = {
  user_id: string;
  course_id: string;
  title: string;
  progress_percent: number;
  modules: ModuleProgress[];
  assessments: AssessmentProgress[];
};

export type StudyLink = {
  id: string;
  title: string;
  description: string;
  href: string;
};
