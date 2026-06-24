import { ReviewQueue } from "@/components/instructor-operations/review-queue";
import { RoleGate } from "@/components/auth/role-gate";
import { getCurrentProfile } from "@/lib/auth/session";

export const dynamic = "force-dynamic";

export default async function ReviewsPage() {
  const user = await getCurrentProfile();
  return <RoleGate roles={["admin", "reviewer"]} user={user}><ReviewQueue /></RoleGate>;
}
