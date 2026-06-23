import { EmptyState } from "@/components/empty-state";
import { PageHeader } from "@/components/page-header";

export default function CertificationsPage() {
  return <><PageHeader title="Certifications" description="Manage certification definitions, requirements, and awards." /><EmptyState title="No certifications loaded" /></>;
}
