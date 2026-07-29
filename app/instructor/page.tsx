import { InstructorConsole } from "@/components/instructor-operations/instructor-console";
import { RoleGate } from "@/components/auth/role-gate";
import { getCurrentProfile } from "@/lib/auth/session";

export const dynamic = "force-dynamic";

export default async function InstructorPage() {
  const user = await getCurrentProfile();
  return <RoleGate roles={["admin", "zone_manager"]} user={user}><InstructorConsole /></RoleGate>;
}
