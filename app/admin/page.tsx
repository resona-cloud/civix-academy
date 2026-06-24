import { AdminDashboard } from "@/components/admin/admin-dashboard";
import { RoleGate } from "@/components/auth/role-gate";
import { getCurrentProfile } from "@/lib/auth/session";

export const dynamic = "force-dynamic";

export default async function AdminPage() {
  const user = await getCurrentProfile();
  return <RoleGate roles={["admin"]} user={user}><AdminDashboard /></RoleGate>;
}
