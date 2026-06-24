import { EmptyState } from "@/components/empty-state";
import { PageHeader } from "@/components/page-header";
import { RoleGate } from "@/components/auth/role-gate";
import { getCurrentProfile } from "@/lib/auth/session";

export const dynamic = "force-dynamic";

export default async function SettingsPage() {
  const user = await getCurrentProfile();
  return <RoleGate roles={["admin"]} user={user}><><PageHeader title="Settings" description="Configure the Academy console." /><EmptyState title="Settings are not configured" /></></RoleGate>;
}
