import { PeopleDirectory } from "@/components/instructor-operations/people-directory";
import { RoleGate } from "@/components/auth/role-gate";
import { getCurrentProfile } from "@/lib/auth/session";

export const dynamic = "force-dynamic";

export default async function PeoplePage() {
  const user = await getCurrentProfile();
  return <RoleGate roles={["admin", "instructor", "reviewer"]} user={user}><PeopleDirectory /></RoleGate>;
}
