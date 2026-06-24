import { notFound } from "next/navigation";
import { FieldbookArticleDetail } from "@/components/fieldbook/fieldbook-article-detail";
import { fieldbookArticles, relatedFieldbookArticleIds } from "@/lib/fieldbook/mock-data";

type Props = { params: Promise<{ articleId: string }> };

export default async function FieldbookArticlePage({ params }: Props) {
  const { articleId } = await params;
  const article = fieldbookArticles.find((candidate) => candidate.id === articleId);
  if (!article) notFound();

  const relatedIds = relatedFieldbookArticleIds[article.id] ?? [];
  const relatedArticles = relatedIds.flatMap((id) => {
    const related = fieldbookArticles.find((candidate) => candidate.id === id);
    return related ? [related] : [];
  });

  return <FieldbookArticleDetail article={article} relatedArticles={relatedArticles} />;
}
