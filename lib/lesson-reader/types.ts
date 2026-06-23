/** Reader DTO shaped for a nested Supabase select over the lesson content tables. */
type LessonPageBlockBase = {
  id: string;
  lesson_page_id: string;
  fieldbook_article_id: null;
  position: number;
};

export type RichTextBlock = LessonPageBlockBase & {
  block_type: "rich_text";
  content: { heading?: string; body: string[] };
};

export type CalloutBlock = LessonPageBlockBase & {
  block_type: "callout";
  content: { title: string; body: string; tone: "info" | "warning" | "success" };
};

export type ActivityBlock = LessonPageBlockBase & {
  block_type: "activity";
  content: { prompt: string; options: string[] };
};

export type DownloadBlock = LessonPageBlockBase & {
  block_type: "download";
  content: { title: string; description: string };
};

export type ImageBlock = LessonPageBlockBase & {
  block_type: "image";
  content: { src: string; alt: string; caption?: string };
};

export type VideoBlock = LessonPageBlockBase & {
  block_type: "video";
  content: { src: string; title: string };
};

export type ContentBlock = RichTextBlock | CalloutBlock | ActivityBlock | DownloadBlock | ImageBlock | VideoBlock;

export type LessonPage = {
  id: string;
  lesson_id: string;
  title: string;
  position: number;
  content_blocks: ContentBlock[];
};

export type LessonNavItem = {
  id: string;
  module_id: string;
  title: string;
  position: number;
  estimated_minutes: number | null;
};

export type LessonModule = {
  id: string;
  course_id: string;
  title: string;
  position: number;
  lessons: LessonNavItem[];
};

export type LessonReaderData = {
  course: { id: string; slug: string; title: string };
  lesson: LessonNavItem;
  modules: LessonModule[];
  pages: LessonPage[];
};
