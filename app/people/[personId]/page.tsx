import { notFound } from "next/navigation";
import { LearnerProfile } from "@/components/instructor-operations/learner-profile";
import { RoleGate } from "@/components/auth/role-gate";
import { getCurrentProfile } from "@/lib/auth/session";
import { mockLearnerProfiles } from "@/lib/instructor-operations/mock-data";

export const dynamic = "force-dynamic";

type Props = { params: Promise<{ personId: string }> };

export default async function LearnerProfilePage({ params }: Props) {
  const user = await getCurrentProfile();
  const { personId } = await params;
  const learner = mockLearnerProfiles.find((item) => item.id === personId);
  if (!learner) notFound();
  return <RoleGate roles={["admin", "instructor", "reviewer"]} user={user}><LearnerProfile learner={learner} /></RoleGate>;
}
