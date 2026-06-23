import { PageHeader } from "@/components/page-header";
import { StatCard } from "@/components/stat-card";

export default function DashboardPage() {
  return (
    <>
      <PageHeader title="Overview" description="Training, certification, and field-readiness activity." />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard label="Active training" value="—" />
        <StatCard label="Certifications" value="—" />
        <StatCard label="Lab attempts" value="—" />
        <StatCard label="Active agents" value="—" />
      </div>
    </>
  );
}
