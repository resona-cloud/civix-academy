import type { Assessment, AssessmentQuestion, CourseProgress, Flashcard, StudyLink } from "./types";

const assessmentId = "71000000-0000-4000-8000-000000000001";

export const mockAssessment: Assessment = {
  id: assessmentId,
  slug: "quick-review-assessment",
  title: "Quick Review Assessment",
  description: "Seven question formats covering the course fundamentals.",
  status: "published",
  passing_score: 70,
  questions: [
    {
      id: "71100000-0000-4000-8000-000000000001",
      assessment_id: assessmentId,
      question_type: "multiple_choice",
      prompt: "What should market research identify before an acquisition strategy is selected?",
      explanation: "Market research should establish available capabilities, customary practices, and likely sources so the strategy is evidence-based.",
      points: 1,
      position: 1,
      options: [
        { id: "71110000-0000-4000-8000-000000000001", label: "Available capabilities and likely sources" },
        { id: "71110000-0000-4000-8000-000000000002", label: "The preferred incumbent solution only" },
        { id: "71110000-0000-4000-8000-000000000003", label: "The final evaluation ratings" },
      ],
      correct_option_id: "71110000-0000-4000-8000-000000000001",
    },
    {
      id: "71100000-0000-4000-8000-000000000002",
      assessment_id: assessmentId,
      question_type: "multiple_select",
      prompt: "Which items belong in a defensible research record? Select all that apply.",
      explanation: "Sources, dates, limitations, and acquisition implications make findings traceable and reviewable.",
      points: 2,
      position: 2,
      options: [
        { id: "71120000-0000-4000-8000-000000000001", label: "Source and date" },
        { id: "71120000-0000-4000-8000-000000000002", label: "Known limitations" },
        { id: "71120000-0000-4000-8000-000000000003", label: "Acquisition implications" },
        { id: "71120000-0000-4000-8000-000000000004", label: "Undocumented preferences" },
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
      prompt: "A proposal instruction automatically makes a useful evaluation factor.",
      explanation: "False. Evaluation factors must distinguish offers and connect to requirements or acquisition risk.",
      points: 1,
      position: 3,
      correct_answer: false,
    },
    {
      id: "71100000-0000-4000-8000-000000000004",
      assessment_id: assessmentId,
      question_type: "matching",
      prompt: "Match each acquisition artifact to its primary purpose.",
      explanation: "Requirements define the need, proposal instructions define the response, and evaluation factors define how responses are assessed.",
      points: 3,
      position: 4,
      pairs: [
        { id: "71140000-0000-4000-8000-000000000001", left: "Requirement", right: "Defines the agency need" },
        { id: "71140000-0000-4000-8000-000000000002", left: "Proposal instructions", right: "Defines what offerors submit" },
        { id: "71140000-0000-4000-8000-000000000003", left: "Evaluation factors", right: "Defines how offers are assessed" },
      ],
    },
    {
      id: "71100000-0000-4000-8000-000000000005",
      assessment_id: assessmentId,
      question_type: "ordering",
      prompt: "Put the simplified market research workflow in order.",
      explanation: "Start with the decision, gather evidence, analyze implications, then document the record.",
      points: 2,
      position: 5,
      items: [
        { id: "71150000-0000-4000-8000-000000000003", label: "Analyze acquisition implications" },
        { id: "71150000-0000-4000-8000-000000000001", label: "Define the decision" },
        { id: "71150000-0000-4000-8000-000000000004", label: "Document the research record" },
        { id: "71150000-0000-4000-8000-000000000002", label: "Gather balanced evidence" },
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
      prompt: "Complete the sentence: A useful evaluation factor should help _____ among offers.",
      explanation: "Evaluation factors should discriminate among offers in ways that predict successful performance.",
      points: 1,
      position: 6,
      accepted_answers: ["discriminate", "distinguish"],
      case_sensitive: false,
    },
    {
      id: "71100000-0000-4000-8000-000000000007",
      assessment_id: assessmentId,
      question_type: "short_response",
      prompt: "Why should acquisition recommendations be traceable to evidence?",
      explanation: "Traceability lets reviewers understand and defend how evidence supports the acquisition decision.",
      points: 2,
      position: 7,
      sample_answer: "Traceability allows a reviewer to connect the evidence to the acquisition decision and defend the recommendation.",
      scoring_keywords: ["evidence", "decision"],
    },
  ],
};

export const mockKnowledgeCheck: AssessmentQuestion = {
  id: "71200000-0000-4000-8000-000000000001",
  assessment_id: null,
  question_type: "multiple_choice",
  prompt: "Which finding most directly informs the competition strategy?",
  explanation: "The number and type of capable sources directly informs whether meaningful competition is available.",
  points: 1,
  position: 1,
  options: [
    { id: "71210000-0000-4000-8000-000000000001", label: "Three capable small businesses serve the market" },
    { id: "71210000-0000-4000-8000-000000000002", label: "The incumbent contract expires next quarter" },
    { id: "71210000-0000-4000-8000-000000000003", label: "The program office prefers a specific format" },
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
