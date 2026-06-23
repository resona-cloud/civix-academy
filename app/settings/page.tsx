import { EmptyState } from "@/components/empty-state";
import { PageHeader } from "@/components/page-header";

export default function SettingsPage() {
  return <><PageHeader title="Settings" description="Configure the Academy console." /><EmptyState title="Settings are not configured" /></>;
}
