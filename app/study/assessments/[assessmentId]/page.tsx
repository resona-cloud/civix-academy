import Link from "next/link";
import { notFound } from "next/navigation";
import { AssessmentRenderer } from "@/components/learning-engine/assessment-renderer";
import { mockAssessment } from "@/lib/learning-engine/mock-data";

type Props = { params: Promise<{ assessmentId: string }> };

export default async function AssessmentPage({ params }: Props) {
  const { assessmentId } = await params;
  if (assessmentId !== mockAssessment.id) notFound();

  return <><Link className="mb-5 inline-block text-sm font-medium text-sky-700" href="/study">&lt;- Back to Study Center</Link><AssessmentRenderer assessment={mockAssessment} /></>;
}
