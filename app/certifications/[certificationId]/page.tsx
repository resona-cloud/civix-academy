import { notFound } from "next/navigation";
import { CertificationDetail } from "@/components/certifications/certification-detail";
import { mockCertificationProgress, mockCertificationTracks } from "@/lib/certifications/mock-data";

type Props = { params: Promise<{ certificationId: string }> };

export default async function CertificationDetailPage({ params }: Props) {
  const { certificationId } = await params;
  const certification = mockCertificationTracks.find((item) => item.id === certificationId);
  const progress = mockCertificationProgress.find((item) => item.certification_id === certificationId);
  if (!certification || !progress) notFound();

  return <CertificationDetail certification={certification} progress={progress} />;
}
