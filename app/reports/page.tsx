import { EmptyState } from "@/components/empty-state";
import { PageHeader } from "@/components/page-header";

export default function ReportsPage() {
  return <><PageHeader title="Reports" description="Review completion, certification, readiness, and lab performance." /><EmptyState title="Reporting is not configured" /></>;
}
