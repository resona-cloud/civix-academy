import type { Assessment, AssessmentQuestion, CourseProgress, Flashcard, StudyLink } from "./types";

const assessmentId = "71000000-0000-4000-8000-000000000001";

export const mockAssessment: Assessment = {
  id: assessmentId,
  slug: "quick-review-assessment",
  title: "Quick Review Assessment",
  description: "Seven question formats covering the course fundamentals.",
  status: "published",
  passing_score: 70,
  assessment_type: "exam",
  questions: [
    {
      id: "71100000-0000-4000-8000-000000000001",
      assessment_id: assessmentId,
      question_type: "multiple_choice",
      prompt: "Sample question 1 of 7 (multiple choice).",
      explanation: "Placeholder explanation for question 1.",
      points: 1,
      position: 1,
      options: [
        { id: "71110000-0000-4000-8000-000000000001", label: "Option A (correct)" },
        { id: "71110000-0000-4000-8000-000000000002", label: "Option B" },
        { id: "71110000-0000-4000-8000-000000000003", label: "Option C" },
      ],
      correct_option_id: "71110000-0000-4000-8000-000000000001",
    },
    {
      id: "71100000-0000-4000-8000-000000000002",
      assessment_id: assessmentId,
      question_type: "multiple_select",
      prompt: "Sample question 2 of 7 (multiple select). Select all that apply.",
      explanation: "Placeholder explanation for question 2.",
      points: 2,
      position: 2,
      options: [
        { id: "71120000-0000-4000-8000-000000000001", label: "Option A (correct)" },
        { id: "71120000-0000-4000-8000-000000000002", label: "Option B (correct)" },
        { id: "71120000-0000-4000-8000-000000000003", label: "Option C (correct)" },
        { id: "71120000-0000-4000-8000-000000000004", label: "Option D" },
      ],
      correct_option_ids: [
        "71120000-0000-4000-8000-000000000001",
        "71120000-0000-4000-8000-000000000002",
        "71120000-0000-4000-8000-000000000003",
      ],
    },
    {
      id: "71100000-0000-4000-8000-000000000003",
      assessment_id: assessmentId,
      question_type: "true_false",
      prompt: "Sample question 3 of 7 (true/false).",
      explanation: "Placeholder explanation for question 3.",
      points: 1,
      position: 3,
      correct_answer: false,
    },
    {
      id: "71100000-0000-4000-8000-000000000004",
      assessment_id: assessmentId,
      question_type: "matching",
      prompt: "Sample question 4 of 7 (matching). Match each item to its pair.",
      explanation: "Placeholder explanation for question 4.",
      points: 3,
      position: 4,
      pairs: [
        { id: "71140000-0000-4000-8000-000000000001", left: "Item 1", right: "Match 1" },
        { id: "71140000-0000-4000-8000-000000000002", left: "Item 2", right: "Match 2" },
        { id: "71140000-0000-4000-8000-000000000003", left: "Item 3", right: "Match 3" },
      ],
    },
    {
      id: "71100000-0000-4000-8000-000000000005",
      assessment_id: assessmentId,
      question_type: "ordering",
      prompt: "Sample question 5 of 7 (ordering). Put the steps in order.",
      explanation: "Placeholder explanation for question 5.",
      points: 2,
      position: 5,
      items: [
        { id: "71150000-0000-4000-8000-000000000003", label: "Step 3" },
        { id: "71150000-0000-4000-8000-000000000001", label: "Step 1" },
        { id: "71150000-0000-4000-8000-000000000004", label: "Step 4" },
        { id: "71150000-0000-4000-8000-000000000002", label: "Step 2" },
      ],
      correct_order: [
        "71150000-0000-4000-8000-000000000001",
        "71150000-0000-4000-8000-000000000002",
        "71150000-0000-4000-8000-000000000003",
        "71150000-0000-4000-8000-000000000004",
      ],
    },
    {
      id: "71100000-0000-4000-8000-000000000006",
      assessment_id: assessmentId,
      question_type: "fill_blank",
      prompt: "Sample question 6 of 7 (fill in the blank): The answer is _____.",
      explanation: "Placeholder explanation for question 6.",
      points: 1,
      position: 6,
      accepted_answers: ["answer"],
      case_sensitive: false,
    },
    {
      id: "71100000-0000-4000-8000-000000000007",
      assessment_id: assessmentId,
      question_type: "short_response",
      prompt: "Sample question 7 of 7 (short response).",
      explanation: "Placeholder explanation for question 7.",
      points: 2,
      position: 7,
      sample_answer: "A sample short-response answer.",
      scoring_keywords: ["sample"],
    },
  ],
};

export const mockKnowledgeCheck: AssessmentQuestion = {
  id: "71200000-0000-4000-8000-000000000001",
  assessment_id: null,
  question_type: "multiple_choice",
  prompt: "Sample knowledge-check question.",
  explanation: "Placeholder explanation for the sample knowledge check.",
  points: 1,
  position: 1,
  options: [
    { id: "71210000-0000-4000-8000-000000000001", label: "Option A (correct)" },
    { id: "71210000-0000-4000-8000-000000000002", label: "Option B" },
    { id: "71210000-0000-4000-8000-000000000003", label: "Option C" },
  ],
  correct_option_id: "71210000-0000-4000-8000-000000000001",
};

export const mockFlashcards: Flashcard[] = [
  { id: "72000000-0000-4000-8000-000000000001", category: "Category 1", front: "Term 1", back: "Placeholder definition for term 1.", position: 1 },
  { id: "72000000-0000-4000-8000-000000000002", category: "Category 2", front: "Term 2", back: "Placeholder definition for term 2.", position: 2 },
  { id: "72000000-0000-4000-8000-000000000003", category: "Category 2", front: "Term 3", back: "Placeholder definition for term 3.", position: 3 },
  { id: "72000000-0000-4000-8000-000000000004", category: "Category 3", front: "Term 4", back: "Placeholder definition for term 4.", position: 4 },
  { id: "72000000-0000-4000-8000-000000000005", category: "Category 4", front: "Term 5", back: "Placeholder definition for term 5.", position: 5 },
  { id: "72000000-0000-4000-8000-000000000006", category: "Category 4", front: "Term 6", back: "Placeholder definition for term 6.", position: 6 },
  { id: "72000000-0000-4000-8000-000000000007", category: "Category 5", front: "Term 7", back: "Placeholder definition for term 7.", position: 7 },
  { id: "72000000-0000-4000-8000-000000000008", category: "Category 5", front: "Term 8", back: "Placeholder definition for term 8.", position: 8 },
];

export const mockCourseProgress: CourseProgress = {
  user_id: "73000000-0000-4000-8000-000000000001",
  course_id: "10000000-0000-4000-8000-000000000001",
  title: "Sample Course",
  progress_percent: 58,
  modules: [
    {
      module_id: "20000000-0000-4000-8000-000000000001",
      title: "Module 1",
      progress_percent: 76,
      lessons: [
        { lesson_id: "30000000-0000-4000-8000-000000000001", title: "Lesson 1", status: "completed", progress_percent: 100 },
        { lesson_id: "30000000-0000-4000-8000-000000000002", title: "Lesson 2", status: "in_progress", progress_percent: 75 },
        { lesson_id: "30000000-0000-4000-8000-000000000003", title: "Lesson 3", status: "in_progress", progress_percent: 55 },
      ],
    },
    {
      module_id: "20000000-0000-4000-8000-000000000002",
      title: "Module 2",
      progress_percent: 30,
      lessons: [
        { lesson_id: "30000000-0000-4000-8000-000000000004", title: "Lesson 4", status: "in_progress", progress_percent: 60 },
        { lesson_id: "30000000-0000-4000-8000-000000000005", title: "Lesson 5", status: "not_started", progress_percent: 0 },
      ],
    },
  ],
  assessments: [
    { assessment_id: assessmentId, title: "Quick Review Assessment", status: "in_progress", score: null },
    { assessment_id: "71000000-0000-4000-8000-000000000002", title: "Module 1 Checkpoint", status: "passed", score: 86 },
  ],
};

export const mockQuickReviews: StudyLink[] = [
  { id: assessmentId, title: "Quick Review Assessment", description: "7 questions - all supported formats", href: `/study/assessments/${assessmentId}` },
  { id: "74000000-0000-4000-8000-000000000002", title: "Lesson 2 Review", description: "5 minute concept refresh", href: "/training/10000000-0000-4000-8000-000000000001/lessons/30000000-0000-4000-8000-000000000002" },
];

export const mockSavedBookmarks: StudyLink[] = [
  { id: "61000000-0000-4000-8000-000000000001", title: "Fieldbook Guide 1", description: "Fieldbook - Category 2", href: "/reference/61000000-0000-4000-8000-000000000001" },
  { id: "61000000-0000-4000-8000-000000000003", title: "Fieldbook Guide 3", description: "Fieldbook - Category 4", href: "/reference/61000000-0000-4000-8000-000000000003" },
];

export const mockRecommendedLessons: StudyLink[] = [
  { id: "30000000-0000-4000-8000-000000000002", title: "Lesson 2", description: "Continue at page 4 of 4", href: "/training/10000000-0000-4000-8000-000000000001/lessons/30000000-0000-4000-8000-000000000002" },
  { id: "30000000-0000-4000-8000-000000000004", title: "Lesson 4", description: "Recommended from recent activity", href: "/training/10000000-0000-4000-8000-000000000001/lessons/30000000-0000-4000-8000-000000000004" },
];
