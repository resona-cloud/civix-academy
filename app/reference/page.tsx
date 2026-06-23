import { EmptyState } from "@/components/empty-state";
import { PageHeader } from "@/components/page-header";

export default function ReferencePage() {
  return <><PageHeader title="Fieldbook" description="Maintain searchable procurement guides, checklists, and job aids." /><EmptyState title="No Fieldbook articles loaded" /></>;
}
