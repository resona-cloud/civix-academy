import { EmptyState } from "@/components/empty-state";
import { PageHeader } from "@/components/page-header";

export default function LabsPage() {
  return <><PageHeader title="Labs" description="Manage scenario-based procurement exercises and evaluations." /><EmptyState title="No labs loaded" /></>;
}
