import { StudyCenter } from "@/components/learning-engine/study-center";
import { getCourseProgress, getFlashcards, getQuickReviewsDue, getRecommendedLesson, getSavedBookmarks } from "@/lib/study-center/queries";

export default async function StudyCenterPage() {
  const [progress, quickReviews, savedBookmarks, recommendedLesson, flashcards] = await Promise.all([
    getCourseProgress(),
    getQuickReviewsDue(),
    getSavedBookmarks(),
    getRecommendedLesson(),
    getFlashcards(),
  ]);

  const isMock = progress.source === "mock";

  return (
    <StudyCenter
      flashcards={flashcards.data}
      isMock={isMock}
      progress={progress.data}
      quickReviews={quickReviews.data}
      recommendedLesson={recommendedLesson.data}
      savedBookmarks={savedBookmarks.data}
    />
  );
}
