import { AdminUserList } from "@/components/admin/admin-user-list";
import { RoleGate } from "@/components/auth/role-gate";
import { getCurrentProfile } from "@/lib/auth/session";

export const dynamic = "force-dynamic";

export default async function AdminUsersPage() {
  const user = await getCurrentProfile();
  return <RoleGate roles={["admin"]} user={user}><AdminUserList /></RoleGate>;
}
