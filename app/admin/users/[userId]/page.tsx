import { notFound } from "next/navigation";
import { AdminUserDetail } from "@/components/admin/admin-user-detail";
import { RoleGate } from "@/components/auth/role-gate";
import { mockAdminUsers } from "@/lib/admin/mock-data";
import { getCurrentProfile } from "@/lib/auth/session";

export const dynamic = "force-dynamic";
type Props = { params: Promise<{ userId: string }> };

export default async function AdminUserPage({ params }: Props) {
  const currentUser = await getCurrentProfile();
  const { userId } = await params;
  const adminUser = mockAdminUsers.find((item) => item.id === userId);
  if (!adminUser) notFound();
  return <RoleGate roles={["admin"]} user={currentUser}><AdminUserDetail user={adminUser} /></RoleGate>;
}
