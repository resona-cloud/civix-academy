import { mockCertificationProgress, mockCertificationTracks } from "@/lib/certifications/mock-data";
import { CertificationCard } from "./certification-card";

export function CertificationCatalog() {
  return <><header className="mb-8"><p className="text-xs font-semibold uppercase tracking-[0.18em] text-sky-700">Credentials</p><h1 className="mt-2 text-3xl font-semibold tracking-tight">Certifications</h1><p className="mt-2 max-w-2xl text-slate-600">Track eligibility, required learning, assessment thresholds, and credential progress.</p></header><div className="grid gap-5 md:grid-cols-2 xl:grid-cols-3">{mockCertificationTracks.map((certification) => <CertificationCard certification={certification} key={certification.id} progress={mockCertificationProgress.find((item) => item.certification_id === certification.id)} />)}</div></>;
}
