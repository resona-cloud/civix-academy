import type { LessonReaderData } from "./types";

const ids = {
  course: "10000000-0000-4000-8000-000000000001",
  moduleFoundations: "20000000-0000-4000-8000-000000000001",
  moduleExecution: "20000000-0000-4000-8000-000000000002",
  lifecycle: "30000000-0000-4000-8000-000000000001",
  marketResearch: "30000000-0000-4000-8000-000000000002",
  requirements: "30000000-0000-4000-8000-000000000003",
  solicitation: "30000000-0000-4000-8000-000000000004",
  evaluation: "30000000-0000-4000-8000-000000000005",
  purpose: "40000000-0000-4000-8000-000000000001",
  sources: "40000000-0000-4000-8000-000000000002",
  analysis: "40000000-0000-4000-8000-000000000003",
  document: "40000000-0000-4000-8000-000000000004",
} as const;

export const mockLesson: LessonReaderData = {
  course: {
    id: ids.course,
    slug: "procurement-foundations",
    title: "GovCon Procurement Foundations",
  },
  lesson: {
    id: ids.marketResearch,
    module_id: ids.moduleFoundations,
    title: "Conducting Effective Market Research",
    position: 2,
    estimated_minutes: 12,
  },
  modules: [
    {
      id: ids.moduleFoundations,
      course_id: ids.course,
      title: "Foundations",
      position: 1,
      lessons: [
        { id: ids.lifecycle, module_id: ids.moduleFoundations, title: "The procurement lifecycle", position: 1, estimated_minutes: 8 },
        { id: ids.marketResearch, module_id: ids.moduleFoundations, title: "Conducting market research", position: 2, estimated_minutes: 12 },
        { id: ids.requirements, module_id: ids.moduleFoundations, title: "Defining requirements", position: 3, estimated_minutes: 10 },
      ],
    },
    {
      id: ids.moduleExecution,
      course_id: ids.course,
      title: "Execution",
      position: 2,
      lessons: [
        { id: ids.solicitation, module_id: ids.moduleExecution, title: "Building a solicitation", position: 1, estimated_minutes: 14 },
        { id: ids.evaluation, module_id: ids.moduleExecution, title: "Evaluating responses", position: 2, estimated_minutes: 16 },
      ],
    },
  ],
  pages: [
    {
      id: ids.purpose,
      lesson_id: ids.marketResearch,
      position: 1,
      title: "Why market research matters",
      content_blocks: [
        {
          id: "50000000-0000-4000-8000-000000000001",
          lesson_page_id: ids.purpose,
          fieldbook_article_id: null,
          position: 1,
          block_type: "rich_text",
          content: {
            heading: "Start with the acquisition question",
            body: [
              "Market research gives the acquisition team evidence about available capabilities, customary commercial practices, and likely sources before a procurement strategy is selected.",
              "The objective is not to justify a predetermined approach. It is to reduce uncertainty and document why the chosen approach fits the requirement.",
            ],
          },
        },
        {
          id: "50000000-0000-4000-8000-000000000002",
          lesson_page_id: ids.purpose,
          fieldbook_article_id: null,
          position: 2,
          block_type: "callout",
          content: {
            tone: "info",
            title: "Fieldbook reminder",
            body: "Record sources, dates, assumptions, and unresolved questions as the research develops.",
          },
        },
      ],
    },
    {
      id: ids.sources,
      lesson_id: ids.marketResearch,
      position: 2,
      title: "Build a balanced source set",
      content_blocks: [
        {
          id: "50000000-0000-4000-8000-000000000003",
          lesson_page_id: ids.sources,
          fieldbook_article_id: null,
          position: 1,
          block_type: "rich_text",
          content: { body: ["Use multiple source types to avoid over-weighting a single vendor or database. Prior acquisitions, industry publications, government-wide vehicles, and direct industry engagement each answer different questions."] },
        },
        {
          id: "50000000-0000-4000-8000-000000000004",
          lesson_page_id: ids.sources,
          fieldbook_article_id: null,
          position: 2,
          block_type: "callout",
          content: { tone: "warning", title: "Avoid confirmation bias", body: "Document evidence that challenges the initial acquisition assumptions, not only evidence that supports them." },
        },
        {
          id: "50000000-0000-4000-8000-000000000005",
          lesson_page_id: ids.sources,
          fieldbook_article_id: null,
          position: 3,
          block_type: "download",
          content: { title: "Market research worksheet", description: "Mock downloadable template - DOCX - 42 KB" },
        },
      ],
    },
    {
      id: ids.analysis,
      lesson_id: ids.marketResearch,
      position: 3,
      title: "Turn findings into decisions",
      content_blocks: [
        {
          id: "50000000-0000-4000-8000-000000000006",
          lesson_page_id: ids.analysis,
          fieldbook_article_id: null,
          position: 1,
          block_type: "rich_text",
          content: { heading: "Synthesize, do not inventory", body: ["A useful report explains what the findings mean for competition, contract type, evaluation, schedule, and risk. A list of vendor facts without analysis does not support an acquisition decision."] },
        },
        {
          id: "50000000-0000-4000-8000-000000000007",
          lesson_page_id: ids.analysis,
          fieldbook_article_id: null,
          position: 2,
          block_type: "activity",
          content: { prompt: "Which finding most directly informs the competition strategy?", options: ["Three capable small businesses serve the market", "The incumbent contract expires next quarter", "The program office prefers a specific format"] },
        },
      ],
    },
    {
      id: ids.document,
      lesson_id: ids.marketResearch,
      position: 4,
      title: "Document the research record",
      content_blocks: [
        {
          id: "50000000-0000-4000-8000-000000000008",
          lesson_page_id: ids.document,
          fieldbook_article_id: null,
          position: 1,
          block_type: "rich_text",
          content: { body: ["Conclude with the acquisition implications, research limitations, and recommended next steps. The record should allow a reviewer to understand how the evidence led to the recommendation."] },
        },
        {
          id: "50000000-0000-4000-8000-000000000009",
          lesson_page_id: ids.document,
          fieldbook_article_id: null,
          position: 2,
          block_type: "callout",
          content: { tone: "success", title: "Ready for review", body: "Confirm that every major recommendation is traceable to a dated source or a clearly labeled assumption." },
        },
      ],
    },
  ],
};
