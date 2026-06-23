import { EmptyState } from "@/components/empty-state";
import { PageHeader } from "@/components/page-header";

export default function PeoplePage() {
  return <><PageHeader title="People" description="Manage agent profiles, roles, enrollments, and access." /><EmptyState title="No people loaded" /></>;
}
