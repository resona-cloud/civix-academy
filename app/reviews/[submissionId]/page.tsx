import { notFound } from "next/navigation";
import { ReviewWorkspace } from "@/components/instructor-operations/review-workspace";
import { RoleGate } from "@/components/auth/role-gate";
import { getCurrentProfile } from "@/lib/auth/session";
import { mockRubrics } from "@/lib/evaluation-engine/mock-data";
import { mockReviewSubmissions } from "@/lib/instructor-operations/mock-data";

export const dynamic = "force-dynamic";

type Props = { params: Promise<{ submissionId: string }> };

export default async function ReviewSubmissionPage({ params }: Props) {
  const user = await getCurrentProfile();
  const { submissionId } = await params;
  const submission = mockReviewSubmissions.find((item) => item.id === submissionId);
  if (!submission) notFound();
  const rubric = submission.rubric_id ? mockRubrics.find((item) => item.id === submission.rubric_id) : undefined;
  return <RoleGate roles={["admin", "reviewer"]} user={user}><ReviewWorkspace rubric={rubric} submission={submission} /></RoleGate>;
}
