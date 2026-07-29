import type { FieldbookArticle, FieldbookCategory, GlossaryTerm } from "./types";

export const fieldbookCategories: readonly FieldbookCategory[] = [
  "Category 1",
  "Category 2",
  "Category 3",
  "Category 4",
];

const articleIds = {
  marketResearch: "61000000-0000-4000-8000-000000000001",
  acquisitionPlan: "61000000-0000-4000-8000-000000000002",
  evaluationFactors: "61000000-0000-4000-8000-000000000003",
  solicitationReview: "61000000-0000-4000-8000-000000000004",
} as const;

export const fieldbookArticles: FieldbookArticle[] = [
  {
    id: articleIds.marketResearch,
    slug: "fieldbook-guide-1",
    title: "Fieldbook Guide 1",
    summary: "A practical sequence for the first fieldbook guide.",
    category: "Category 2",
    tags: ["guide", "sources", "documentation"],
    status: "published",
    content_blocks: [
      {
        id: "62000000-0000-4000-8000-000000000001",
        lesson_page_id: null,
        fieldbook_article_id: articleIds.marketResearch,
        position: 1,
        block_type: "rich_text",
        content: {
          heading: "Define the decision first",
          body: [
            "Begin by identifying the acquisition decisions the research must support. This keeps the effort focused on evidence that can change the strategy.",
            "Use a balanced mix of government, commercial, and direct industry sources. Record the source, date, limitation, and implication of each material finding.",
          ],
        },
      },
      {
        id: "62000000-0000-4000-8000-000000000002",
        lesson_page_id: null,
        fieldbook_article_id: articleIds.marketResearch,
        position: 2,
        block_type: "callout",
        content: { title: "Review check", body: "A reviewer should be able to trace every recommendation back to evidence or a clearly labeled assumption.", tone: "info" },
      },
      {
        id: "62000000-0000-4000-8000-000000000003",
        lesson_page_id: null,
        fieldbook_article_id: articleIds.marketResearch,
        position: 3,
        block_type: "download",
        content: { title: "Market research checklist", description: "Mock reference attachment - PDF" },
      },
    ],
  },
  {
    id: articleIds.acquisitionPlan,
    slug: "fieldbook-guide-2",
    title: "Fieldbook Guide 2",
    summary: "Key questions for the second fieldbook guide.",
    category: "Category 1",
    tags: ["checklist", "review", "risk"],
    status: "published",
    content_blocks: [
      {
        id: "62000000-0000-4000-8000-000000000004",
        lesson_page_id: null,
        fieldbook_article_id: articleIds.acquisitionPlan,
        position: 1,
        block_type: "rich_text",
        content: { heading: "Test the strategy as a system", body: ["Confirm that the requirement, market findings, competition approach, contract type, evaluation method, funding, and schedule reinforce one another.", "Document material risks with an owner, mitigation, and decision date."] },
      },
      {
        id: "62000000-0000-4000-8000-000000000005",
        lesson_page_id: null,
        fieldbook_article_id: articleIds.acquisitionPlan,
        position: 2,
        block_type: "callout",
        content: { title: "Common gap", body: "An aggressive award date is not a strategy. Validate the time required for reviews, solicitation, evaluation, and approvals.", tone: "warning" },
      },
    ],
  },
  {
    id: articleIds.evaluationFactors,
    slug: "fieldbook-guide-3",
    title: "Fieldbook Guide 3",
    summary: "Structure factors that are discriminating and measurable, for the third fieldbook guide.",
    category: "Category 4",
    tags: ["evaluation", "factors", "criteria"],
    status: "published",
    content_blocks: [
      {
        id: "62000000-0000-4000-8000-000000000006",
        lesson_page_id: null,
        fieldbook_article_id: articleIds.evaluationFactors,
        position: 1,
        block_type: "rich_text",
        content: { heading: "Evaluate what matters", body: ["Each factor should help distinguish among offers in a way that predicts successful performance. Avoid restating proposal instructions as evaluation criteria.", "Define the evidence evaluators will examine and how strengths, weaknesses, deficiencies, and risk will be documented."] },
      },
      {
        id: "62000000-0000-4000-8000-000000000007",
        lesson_page_id: null,
        fieldbook_article_id: articleIds.evaluationFactors,
        position: 2,
        block_type: "callout",
        content: { title: "Alignment test", body: "Every requested proposal element should map to an evaluation factor, and every factor should map to the requirement or acquisition risk.", tone: "success" },
      },
    ],
  },
  {
    id: articleIds.solicitationReview,
    slug: "fieldbook-guide-4",
    title: "Fieldbook Guide 4",
    summary: "A concise quality-control pass for the fourth fieldbook guide.",
    category: "Category 3",
    tags: ["quality control", "review"],
    status: "published",
    content_blocks: [
      {
        id: "62000000-0000-4000-8000-000000000008",
        lesson_page_id: null,
        fieldbook_article_id: articleIds.solicitationReview,
        position: 1,
        block_type: "rich_text",
        content: { heading: "Read it as an offeror", body: ["Check that the solicitation uses consistent terms, dates, submission requirements, page limits, and evaluation language throughout.", "Resolve internal conflicts before release and ensure amendments can be tracked cleanly."] },
      },
      {
        id: "62000000-0000-4000-8000-000000000009",
        lesson_page_id: null,
        fieldbook_article_id: articleIds.solicitationReview,
        position: 2,
        block_type: "download",
        content: { title: "Pre-release review sheet", description: "Mock reference attachment - DOCX" },
      },
    ],
  },
];

export const featuredFieldbookArticleIds: readonly string[] = [
  articleIds.marketResearch,
  articleIds.acquisitionPlan,
];

export const relatedFieldbookArticleIds: Readonly<Record<string, readonly string[]>> = {
  [articleIds.marketResearch]: [articleIds.acquisitionPlan, articleIds.solicitationReview],
  [articleIds.acquisitionPlan]: [articleIds.marketResearch, articleIds.evaluationFactors],
  [articleIds.evaluationFactors]: [articleIds.solicitationReview, articleIds.acquisitionPlan],
  [articleIds.solicitationReview]: [articleIds.evaluationFactors, articleIds.marketResearch],
};

export const glossaryTerms: GlossaryTerm[] = [
  { id: "63000000-0000-4000-8000-000000000001", term: "Glossary Term 1", definition: "Placeholder definition for glossary term 1.", source_url: null, status: "published" },
  { id: "63000000-0000-4000-8000-000000000002", term: "Glossary Term 2", definition: "Placeholder definition for glossary term 2.", source_url: null, status: "published" },
  { id: "63000000-0000-4000-8000-000000000003", term: "Glossary Term 3", definition: "Placeholder definition for glossary term 3.", source_url: null, status: "published" },
  { id: "63000000-0000-4000-8000-000000000004", term: "Glossary Term 4", definition: "Placeholder definition for glossary term 4.", source_url: null, status: "published" },
  { id: "63000000-0000-4000-8000-000000000005", term: "Glossary Term 5", definition: "Placeholder definition for glossary term 5.", source_url: null, status: "published" },
  { id: "63000000-0000-4000-8000-000000000006", term: "Glossary Term 6", definition: "Placeholder definition for glossary term 6.", source_url: null, status: "published" },
];
