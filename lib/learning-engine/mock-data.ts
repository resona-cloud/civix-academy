import type { Assessment, AssessmentQuestion, CourseProgress, Flashcard, StudyLink } from "./types";

const assessmentId = "71000000-0000-4000-8000-000000000001";

export const mockAssessment: Assessment = {
  id: assessmentId,
  slug: "procurement-foundations-review",
  title: "Procurement Foundations Quick Review",
  description: "Seven question formats covering planning, market research, and evaluation fundamentals.",
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
  { id: "72000000-0000-4000-8000-000000000001", category: "Acquisition Planning", front: "Acquisition plan", back: "The documented strategy for fulfilling an agency need in a timely manner and at a reasonable cost.", position: 1 },
  { id: "72000000-0000-4000-8000-000000000002", category: "Market Research", front: "Market research", back: "Collecting and analyzing market information to determine capabilities and acquisition implications.", position: 2 },
  { id: "72000000-0000-4000-8000-000000000003", category: "Market Research", front: "Sources sought notice", back: "A market research notice used to identify interested and capable sources; it is not a solicitation.", position: 3 },
  { id: "72000000-0000-4000-8000-000000000004", category: "Solicitation", front: "Amendment", back: "A formal change to a solicitation issued before contract award.", position: 4 },
  { id: "72000000-0000-4000-8000-000000000005", category: "Evaluation", front: "Strength", back: "An aspect of a proposal that has merit or exceeds specified requirements in a beneficial way.", position: 5 },
  { id: "72000000-0000-4000-8000-000000000006", category: "Evaluation", front: "Deficiency", back: "A material failure to meet a requirement or a combination of significant weaknesses that increases risk to an unacceptable level.", position: 6 },
  { id: "72000000-0000-4000-8000-000000000007", category: "Pricing", front: "Price analysis", back: "Evaluation of a proposed price without evaluating its separate cost elements and profit.", position: 7 },
  { id: "72000000-0000-4000-8000-000000000008", category: "Pricing", front: "Cost realism", back: "Independent review of proposed cost elements to determine whether they are realistic for the work to be performed.", position: 8 },
];

export const mockCourseProgress: CourseProgress = {
  user_id: "73000000-0000-4000-8000-000000000001",
  course_id: "10000000-0000-4000-8000-000000000001",
  title: "GovCon Procurement Foundations",
  progress_percent: 58,
  modules: [
    {
      module_id: "20000000-0000-4000-8000-000000000001",
      title: "Foundations",
      progress_percent: 76,
      lessons: [
        { lesson_id: "30000000-0000-4000-8000-000000000001", title: "The procurement lifecycle", status: "completed", progress_percent: 100 },
        { lesson_id: "30000000-0000-4000-8000-000000000002", title: "Conducting market research", status: "in_progress", progress_percent: 75 },
        { lesson_id: "30000000-0000-4000-8000-000000000003", title: "Defining requirements", status: "in_progress", progress_percent: 55 },
      ],
    },
    {
      module_id: "20000000-0000-4000-8000-000000000002",
      title: "Execution",
      progress_percent: 30,
      lessons: [
        { lesson_id: "30000000-0000-4000-8000-000000000004", title: "Building a solicitation", status: "in_progress", progress_percent: 60 },
        { lesson_id: "30000000-0000-4000-8000-000000000005", title: "Evaluating responses", status: "not_started", progress_percent: 0 },
      ],
    },
  ],
  assessments: [
    { assessment_id: assessmentId, title: "Procurement Foundations Quick Review", status: "in_progress", score: null },
    { assessment_id: "71000000-0000-4000-8000-000000000002", title: "Module 1 Checkpoint", status: "passed", score: 86 },
  ],
};

export const mockQuickReviews: StudyLink[] = [
  { id: assessmentId, title: "Procurement Foundations Quick Review", description: "7 questions - all supported formats", href: `/study/assessments/${assessmentId}` },
  { id: "74000000-0000-4000-8000-000000000002", title: "Market Research Review", description: "5 minute concept refresh", href: "/training/10000000-0000-4000-8000-000000000001/lessons/30000000-0000-4000-8000-000000000002" },
];

export const mockSavedBookmarks: StudyLink[] = [
  { id: "61000000-0000-4000-8000-000000000001", title: "Market Research Quick Guide", description: "Fieldbook - Market Research", href: "/reference/61000000-0000-4000-8000-000000000001" },
  { id: "61000000-0000-4000-8000-000000000003", title: "Writing Useful Evaluation Factors", description: "Fieldbook - Evaluation", href: "/reference/61000000-0000-4000-8000-000000000003" },
];

export const mockRecommendedLessons: StudyLink[] = [
  { id: "30000000-0000-4000-8000-000000000002", title: "Conducting Effective Market Research", description: "Continue at page 4 of 4", href: "/training/10000000-0000-4000-8000-000000000001/lessons/30000000-0000-4000-8000-000000000002" },
  { id: "30000000-0000-4000-8000-000000000004", title: "Building a Solicitation", description: "Recommended from recent activity", href: "/training/10000000-0000-4000-8000-000000000001/lessons/30000000-0000-4000-8000-000000000004" },
];
