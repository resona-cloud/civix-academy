export type PersistenceMode = "supabase" | "local";

export type PersistenceResult<T> = {
  data: T;
  mode: PersistenceMode;
};

export type NoteTarget =
  | { lesson_page_id: string; fieldbook_article_id?: never }
  | { lesson_page_id?: never; fieldbook_article_id: string };

export type Note = {
  id: string;
  author_id: string;
  lesson_page_id: string | null;
  fieldbook_article_id: string | null;
  body: string;
  visibility: "private" | "instructors" | "reviewers";
  created_at: string;
  updated_at: string;
};

export type SaveNoteInput = NoteTarget & {
  id?: string;
  body: string;
};

export type BookmarkTargetType = "lesson_page" | "fieldbook_article" | "lab_scenario";

export type Bookmark = {
  id: string;
  user_id: string;
  target_type: BookmarkTargetType;
  target_id: string;
  label: string | null;
  created_at: string;
};

export type ToggleBookmarkInput = {
  target_type: BookmarkTargetType;
  target_id: string;
  label?: string;
};

export type ProgressStatus = "not_started" | "in_progress" | "completed";

export type ProgressRecord = {
  id: string;
  user_id: string;
  lesson_id: string;
  last_page_id: string | null;
  status: ProgressStatus;
  progress_percent: number;
  visited_page_ids: string[];
  completed_page_ids: string[];
  started_at: string | null;
  completed_at: string | null;
  updated_at: string;
};

export type SaveProgressInput = {
  lesson_id: string;
  last_page_id: string;
  status: ProgressStatus;
  progress_percent: number;
  visited_page_ids: string[];
  completed_page_ids: string[];
};
