import "server-only";

import { createServerSupabaseClient, isServerSupabaseConfigured } from "@/lib/supabase/server";
import { mockCourseProgress, mockFlashcards, mockQuickReviews, mockRecommendedLessons, mockSavedBookmarks } from "@/lib/learning-engine/mock-data";
import type { Assessment, AssessmentQuestion, CourseProgress, Flashcard, QuestionType, StudyLink } from "@/lib/learning-engine/types";
import type { Json } from "@/lib/database.types";

export type StudyCenterSource = "supabase" | "mock";
export type StudyCenterResult<T> = { data: T; source: StudyCenterSource };

function sortByPosition<T extends { position: number }>(items: readonly T[] | null | undefined): T[] {
  return [...(items ?? [])].sort((a, b) => a.position - b.position);
}

function shuffle<T>(items: readonly T[]): T[] {
  const next = [...items];
  for (let i = next.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [next[i], next[j]] = [next[j], next[i]];
  }
  return next;
}

type QuestionRow = {
  id: string;
  assessment_id: string;
  question_type: QuestionType;
  prompt: string;
  explanation: string;
  points: number;
  position: number;
  data: Json;
};

// assessment_questions.data holds exactly the type-specific fields
// (options/correct_option_id, pairs, etc.) -- spreading it onto the shared
// columns reconstructs the discriminated union QuestionRenderer/scoring.ts
// already expect, unchanged.
export function mapAssessmentQuestionRow(row: QuestionRow): AssessmentQuestion {
  return {
    id: row.id,
    assessment_id: row.assessment_id,
    question_type: row.question_type,
    prompt: row.prompt,
    explanation: row.explanation,
    points: row.points,
    position: row.position,
    ...(row.data as Record<string, unknown>),
  } as AssessmentQuestion;
}

async function getStudyCenterClient() {
  const client = await createServerSupabaseClient();
  if (!client) return null;
  const { data: { user } } = await client.auth.getUser();
  if (!user) return null;
  return { client, user };
}

// Picks the enrollment the Study Center should treat as "the current course":
// the first non-completed enrollment (in enrollment order), falling back to
// the most recently completed one. Matches the single-course framing every
// Study Center panel and the CourseProgress type already assume.
async function getPrimaryEnrollment(client: NonNullable<Awaited<ReturnType<typeof getStudyCenterClient>>>["client"], userId: string) {
  const { data } = await client
    .from("enrollments")
    .select("id, course_id, status, next_quick_review_due_at, courses(id, title, repeat_review_interval_days)")
    .eq("user_id", userId)
    .order("enrolled_at", { ascending: true });
  if (!data || data.length === 0) return null;
  return data.find((row) => row.status !== "completed") ?? data[data.length - 1];
}

export async function getCourseProgress(): Promise<StudyCenterResult<CourseProgress | null>> {
  if (!isServerSupabaseConfigured()) return { data: mockCourseProgress, source: "mock" };
  const context = await getStudyCenterClient();
  if (!context) return { data: null, source: "supabase" };
  const { client, user } = context;

  const enrollment = await getPrimaryEnrollment(client, user.id);
  if (!enrollment) return { data: null, source: "supabase" };
  const course = enrollment.courses as { id: string; title: string } | null;
  if (!course) return { data: null, source: "supabase" };

  const { data: modulesData } = await client
    .from("modules")
    .select("id, title, position, lessons(id, title, position)")
    .eq("course_id", course.id);
  const modules = sortByPosition(modulesData);
  const lessonIds = modules.flatMap((module_) => (module_.lessons ?? []).map((lesson) => lesson.id));

  const { data: progressRows } = lessonIds.length
    ? await client.from("user_progress").select("lesson_id, status, progress_percent").eq("user_id", user.id).in("lesson_id", lessonIds)
    : { data: [] };
  const progressByLesson = new Map((progressRows ?? []).map((row) => [row.lesson_id, row]));

  const moduleProgress = modules.map((module_) => {
    const lessons = sortByPosition(module_.lessons).map((lesson) => {
      const progress = progressByLesson.get(lesson.id);
      return {
        lesson_id: lesson.id,
        title: lesson.title,
        status: progress?.status ?? "not_started",
        progress_percent: progress?.progress_percent ?? 0,
      };
    });
    const modulePercent = lessons.length ? Math.round(lessons.reduce((total, lesson) => total + lesson.progress_percent, 0) / lessons.length) : 0;
    return { module_id: module_.id, title: module_.title, progress_percent: modulePercent, lessons };
  });
  const coursePercent = moduleProgress.length
    ? Math.round(moduleProgress.reduce((total, module_) => total + module_.progress_percent, 0) / moduleProgress.length)
    : 0;

  // Assessment status only reflects exam-type assessments -- quick reviews
  // are ungated retrieval practice, not a pass/fail checkpoint, so they're
  // excluded from progress here (they surface separately as due reminders).
  const { data: exams } = await client
    .from("assessments")
    .select("id, title")
    .eq("course_id", course.id)
    .eq("assessment_type", "exam")
    .eq("status", "published");
  const examIds = (exams ?? []).map((exam) => exam.id);
  const { data: attempts } = examIds.length
    ? await client.from("assessment_attempts").select("assessment_id, score, passed").eq("user_id", user.id).in("assessment_id", examIds).order("attempt_number", { ascending: false })
    : { data: [] };
  const latestAttemptByAssessment = new Map<string, { score: number | null; passed: boolean | null }>();
  (attempts ?? []).forEach((attempt) => {
    if (!latestAttemptByAssessment.has(attempt.assessment_id)) latestAttemptByAssessment.set(attempt.assessment_id, attempt);
  });
  const assessmentProgress = (exams ?? []).map((exam) => {
    const attempt = latestAttemptByAssessment.get(exam.id);
    const status = !attempt ? "not_started" : attempt.passed ? "passed" : "failed";
    return { assessment_id: exam.id, title: exam.title, status, score: attempt?.score ?? null } as const;
  });

  return {
    data: {
      user_id: user.id,
      course_id: course.id,
      title: course.title,
      progress_percent: coursePercent,
      modules: moduleProgress,
      assessments: assessmentProgress,
    },
    source: "supabase",
  };
}

export async function getRecommendedLesson(): Promise<StudyCenterResult<StudyLink | null>> {
  if (!isServerSupabaseConfigured()) return { data: mockRecommendedLessons[0] ?? null, source: "mock" };
  const context = await getStudyCenterClient();
  if (!context) return { data: null, source: "supabase" };
  const { client, user } = context;

  const enrollment = await getPrimaryEnrollment(client, user.id);
  const course = enrollment?.courses as { id: string } | null;
  if (!enrollment || !course) return { data: null, source: "supabase" };

  const { data: modulesData } = await client.from("modules").select("id, position, lessons(id, title, position)").eq("course_id", course.id);
  const orderedLessons = sortByPosition(modulesData).flatMap((module_) => sortByPosition(module_.lessons));
  if (orderedLessons.length === 0) return { data: null, source: "supabase" };

  const { data: progressRows } = await client.from("user_progress").select("lesson_id, status").eq("user_id", user.id).in("lesson_id", orderedLessons.map((lesson) => lesson.id));
  const completedIds = new Set((progressRows ?? []).filter((row) => row.status === "completed").map((row) => row.lesson_id));
  const nextLesson = orderedLessons.find((lesson) => !completedIds.has(lesson.id));
  if (!nextLesson) return { data: null, source: "supabase" };

  return {
    data: {
      id: nextLesson.id,
      title: nextLesson.title,
      description: completedIds.size > 0 ? "Continue learning" : "Start here",
      href: `/training/${course.id}/lessons/${nextLesson.id}`,
    },
    source: "supabase",
  };
}

export async function getQuickReviewsDue(): Promise<StudyCenterResult<StudyLink[]>> {
  if (!isServerSupabaseConfigured()) return { data: mockQuickReviews, source: "mock" };
  const context = await getStudyCenterClient();
  if (!context) return { data: [], source: "supabase" };
  const { client, user } = context;

  const { data: dueEnrollments } = await client
    .from("enrollments")
    .select("course_id, courses(title)")
    .eq("user_id", user.id)
    .eq("status", "completed")
    .not("next_quick_review_due_at", "is", null)
    .lte("next_quick_review_due_at", new Date().toISOString());
  if (!dueEnrollments || dueEnrollments.length === 0) return { data: [], source: "supabase" };

  const courseIds = dueEnrollments.map((row) => row.course_id);
  const { data: quickReviews } = await client
    .from("assessments")
    .select("id, course_id, title")
    .in("course_id", courseIds)
    .eq("assessment_type", "quick_review")
    .eq("status", "published");

  const links: StudyLink[] = (quickReviews ?? []).map((assessment) => {
    const courseTitle = (dueEnrollments.find((row) => row.course_id === assessment.course_id)?.courses as { title: string } | null)?.title;
    return {
      id: assessment.id,
      title: assessment.title,
      description: courseTitle ? `Due -- ${courseTitle}` : "Due for review",
      href: `/study/assessments/${assessment.id}`,
    };
  });
  return { data: links, source: "supabase" };
}

// FlashcardDeck derives its own category filter client-side from whatever
// cards it's given, so this fetches the full published set -- no separate
// category query needed.
export async function getFlashcards(): Promise<StudyCenterResult<Flashcard[]>> {
  if (!isServerSupabaseConfigured()) return { data: mockFlashcards, source: "mock" };
  const context = await getStudyCenterClient();
  if (!context) return { data: [], source: "supabase" };

  const { data } = await context.client.from("glossary_terms").select("id, term, definition, category").eq("status", "published").order("term", { ascending: true });

  const cards: Flashcard[] = (data ?? []).map((term, index) => ({
    id: term.id,
    category: term.category ?? "General",
    front: term.term,
    back: term.definition,
    position: index + 1,
  }));
  return { data: cards, source: "supabase" };
}

export async function getSavedBookmarks(): Promise<StudyCenterResult<StudyLink[]>> {
  if (!isServerSupabaseConfigured()) return { data: mockSavedBookmarks, source: "mock" };
  const context = await getStudyCenterClient();
  if (!context) return { data: [], source: "supabase" };
  const { client, user } = context;

  const { data: bookmarks } = await client.from("bookmarks").select("id, target_type, target_id, label, created_at").eq("user_id", user.id).order("created_at", { ascending: false });
  if (!bookmarks || bookmarks.length === 0) return { data: [], source: "supabase" };

  const lessonPageIds = bookmarks.filter((b) => b.target_type === "lesson_page").map((b) => b.target_id);
  const fieldbookIds = bookmarks.filter((b) => b.target_type === "fieldbook_article").map((b) => b.target_id);
  const labIds = bookmarks.filter((b) => b.target_type === "lab_scenario").map((b) => b.target_id);

  const [lessonPages, fieldbookArticles, labScenarios] = await Promise.all([
    lessonPageIds.length
      ? client.from("lesson_pages").select("id, title, lessons(id, title, modules(course_id))").in("id", lessonPageIds)
      : Promise.resolve({ data: [] }),
    // fieldbook_articles/lab_scenarios have no Supabase query layer built
    // anywhere else in the app yet (still mock-data-driven domains) -- these
    // rows may simply not exist for a bookmark's target_id. Resolved title
    // falls back to the bookmark's saved label rather than silently
    // dropping the bookmark from the list.
    fieldbookIds.length ? client.from("fieldbook_articles").select("id, title").in("id", fieldbookIds) : Promise.resolve({ data: [] }),
    labIds.length ? client.from("lab_scenarios").select("id, title").in("id", labIds) : Promise.resolve({ data: [] }),
  ]);

  const lessonPageById = new Map((lessonPages.data ?? []).map((row) => [row.id, row]));
  const fieldbookById = new Map((fieldbookArticles.data ?? []).map((row) => [row.id, row]));
  const labById = new Map((labScenarios.data ?? []).map((row) => [row.id, row]));

  const links: StudyLink[] = bookmarks.map((bookmark) => {
    if (bookmark.target_type === "lesson_page") {
      const page = lessonPageById.get(bookmark.target_id);
      const lesson = page?.lessons as { id: string; title: string; modules: { course_id: string } | null } | null;
      const courseId = lesson?.modules?.course_id;
      return {
        id: bookmark.id,
        title: bookmark.label ?? page?.title ?? "Saved lesson page",
        description: lesson ? `Lesson -- ${lesson.title}` : "Lesson page",
        href: lesson && courseId ? `/training/${courseId}/lessons/${lesson.id}` : "/training",
      };
    }
    if (bookmark.target_type === "fieldbook_article") {
      const article = fieldbookById.get(bookmark.target_id);
      return {
        id: bookmark.id,
        title: bookmark.label ?? article?.title ?? "Saved Fieldbook article",
        description: "Fieldbook",
        href: `/reference/${bookmark.target_id}`,
      };
    }
    const scenario = labById.get(bookmark.target_id);
    return {
      id: bookmark.id,
      title: bookmark.label ?? scenario?.title ?? "Saved lab scenario",
      description: "Agent lab",
      href: `/labs/${bookmark.target_id}`,
    };
  });
  return { data: links, source: "supabase" };
}

// Powers /study/assessments/[assessmentId]. For quick_review assessments,
// questions are sampled fresh here (not owned by the assessment row itself --
// see 0013_study_center_schema.sql) from the course's exam question pool.
// The sampled question ids travel back to the client and are echoed on
// submit so grading scores exactly what was displayed.
export async function getAssessmentForDisplay(assessmentId: string): Promise<StudyCenterResult<Assessment | null>> {
  if (!isServerSupabaseConfigured()) return { data: null, source: "mock" };
  const context = await getStudyCenterClient();
  if (!context) return { data: null, source: "supabase" };
  const { client } = context;

  const { data: assessment } = await client
    .from("assessments")
    .select("id, course_id, assessment_type, title, passing_score, question_count")
    .eq("id", assessmentId)
    .eq("status", "published")
    .maybeSingle();
  if (!assessment) return { data: null, source: "supabase" };

  let questionRows: QuestionRow[] = [];
  if (assessment.assessment_type === "exam") {
    const { data } = await client.from("assessment_questions").select("id, assessment_id, question_type, prompt, explanation, points, position, data").eq("assessment_id", assessment.id).order("position", { ascending: true });
    questionRows = data ?? [];
  } else {
    const { data: examAssessment } = await client.from("assessments").select("id").eq("course_id", assessment.course_id).eq("assessment_type", "exam").maybeSingle();
    if (examAssessment) {
      const { data } = await client.from("assessment_questions").select("id, assessment_id, question_type, prompt, explanation, points, position, data").eq("assessment_id", examAssessment.id);
      questionRows = shuffle(data ?? []).slice(0, assessment.question_count);
    }
  }

  return {
    data: {
      id: assessment.id,
      slug: assessment.id,
      title: assessment.title,
      description: assessment.assessment_type === "exam" ? "Course exam -- 80% required to pass." : "Quick review -- a short, ungated retrieval check.",
      status: "published",
      passing_score: assessment.passing_score ?? 0,
      questions: questionRows.map(mapAssessmentQuestionRow),
      assessment_type: assessment.assessment_type,
    },
    source: "supabase",
  };
}
