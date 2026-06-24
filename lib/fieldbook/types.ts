export type FieldbookCategory =
  | "Acquisition Planning"
  | "Market Research"
  | "Solicitation"
  | "Evaluation";

type FieldbookBlockBase = {
  id: string;
  lesson_page_id: null;
  fieldbook_article_id: string;
  position: number;
};

export type FieldbookContentBlock =
  | (FieldbookBlockBase & {
      block_type: "rich_text";
      content: { heading?: string; body: string[] };
    })
  | (FieldbookBlockBase & {
      block_type: "callout";
      content: { title: string; body: string; tone: "info" | "warning" | "success" };
    })
  | (FieldbookBlockBase & {
      block_type: "download";
      content: { title: string; description: string };
    });

export type FieldbookArticle = {
  id: string;
  slug: string;
  title: string;
  summary: string;
  category: FieldbookCategory;
  tags: string[];
  status: "published";
  content_blocks: FieldbookContentBlock[];
};

export type GlossaryTerm = {
  id: string;
  term: string;
  definition: string;
  source_url: string | null;
  status: "published";
};
