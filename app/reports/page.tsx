import { ReportingDashboard } from "@/components/instructor-operations/reporting-dashboard";
import { RoleGate } from "@/components/auth/role-gate";
import { getCurrentProfile } from "@/lib/auth/session";

export const dynamic = "force-dynamic";

export default async function ReportsPage() {
  const user = await getCurrentProfile();
  return <RoleGate roles={["admin", "instructor", "reviewer"]} user={user}><ReportingDashboard /></RoleGate>;
}
