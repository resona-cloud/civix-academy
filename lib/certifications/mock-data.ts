import type { CertificationLevel, CertificationProgress, CertificationTrack } from "./types";

const userId = "73000000-0000-4000-8000-000000000001";
const foundationsCourseId = "10000000-0000-4000-8000-000000000001";
const foundationsAssessmentId = "71000000-0000-4000-8000-000000000001";

export const certificationLevels: CertificationLevel[] = [
  { id: "81000000-0000-4000-8000-000000000001", name: "Level I", rank: 1, description: "Foundational proficiency with guided execution." },
  { id: "81000000-0000-4000-8000-000000000002", name: "Level II", rank: 2, description: "Independent execution across complex procurement work." },
  { id: "81000000-0000-4000-8000-000000000003", name: "Specialist", rank: 3, description: "Role-focused expertise demonstrated through training and practical evaluation." },
];

const ids = {
  agentOne: "81100000-0000-4000-8000-000000000001",
  agentTwo: "81100000-0000-4000-8000-000000000002",
  opportunity: "81100000-0000-4000-8000-000000000003",
  vendor: "81100000-0000-4000-8000-000000000004",
  capture: "81100000-0000-4000-8000-000000000005",
} as const;

export const mockCertificationTracks: CertificationTrack[] = [
  {
    id: ids.agentOne,
    slug: "govcon-procurement-agent-i",
    title: "GovCon Procurement Agent I",
    summary: "Foundational training for agents supporting opportunity research, vendor readiness, and procurement intake.",
    level: certificationLevels[0],
    status: "published",
    passing_score: 70,
    validity_months: 24,
    requirements: [
      { id: "81200000-0000-4000-8000-000000000001", certification_id: ids.agentOne, requirement_type: "course", resource_id: foundationsCourseId, title: "GovCon Procurement Foundations", required: true, minimum_score: null, position: 1 },
      { id: "81200000-0000-4000-8000-000000000002", certification_id: ids.agentOne, requirement_type: "assessment", resource_id: foundationsAssessmentId, title: "Procurement Foundations Quick Review", required: true, minimum_score: 70, position: 2 },
    ],
  },
  {
    id: ids.agentTwo,
    slug: "govcon-procurement-agent-ii",
    title: "GovCon Procurement Agent II",
    summary: "Advanced qualification for agents managing complex intake, evaluation support, and compliance review.",
    level: certificationLevels[1],
    status: "published",
    passing_score: 80,
    validity_months: 24,
    requirements: [
      { id: "81200000-0000-4000-8000-000000000003", certification_id: ids.agentTwo, requirement_type: "course", resource_id: "81300000-0000-4000-8000-000000000001", title: "Advanced Procurement Operations", required: true, minimum_score: null, position: 1 },
      { id: "81200000-0000-4000-8000-000000000004", certification_id: ids.agentTwo, requirement_type: "assessment", resource_id: "81400000-0000-4000-8000-000000000001", title: "Agent II Capstone Assessment", required: true, minimum_score: 80, position: 2 },
    ],
  },
  {
    id: ids.opportunity,
    slug: "opportunity-research-specialist",
    title: "Opportunity Research Specialist",
    summary: "Specialist track for opportunity discovery, qualification, agency research, and evidence synthesis.",
    level: certificationLevels[2],
    status: "published",
    passing_score: 80,
    validity_months: 18,
    requirements: [
      { id: "81200000-0000-4000-8000-000000000005", certification_id: ids.opportunity, requirement_type: "course", resource_id: "81300000-0000-4000-8000-000000000002", title: "Opportunity Research Methods", required: true, minimum_score: null, position: 1 },
      { id: "81200000-0000-4000-8000-000000000006", certification_id: ids.opportunity, requirement_type: "assessment", resource_id: "81400000-0000-4000-8000-000000000002", title: "Opportunity Qualification Lab", required: true, minimum_score: 80, position: 2 },
    ],
  },
  {
    id: ids.vendor,
    slug: "vendor-success-specialist",
    title: "Vendor Success Specialist",
    summary: "Specialist track for assessing vendor readiness and translating findings into actionable improvement plans.",
    level: certificationLevels[2],
    status: "published",
    passing_score: 75,
    validity_months: 18,
    requirements: [
      { id: "81200000-0000-4000-8000-000000000007", certification_id: ids.vendor, requirement_type: "course", resource_id: "81300000-0000-4000-8000-000000000003", title: "Vendor Readiness Foundations", required: true, minimum_score: null, position: 1 },
      { id: "81200000-0000-4000-8000-000000000008", certification_id: ids.vendor, requirement_type: "assessment", resource_id: "81400000-0000-4000-8000-000000000003", title: "Vendor Readiness Review Lab", required: true, minimum_score: 75, position: 2 },
    ],
  },
  {
    id: ids.capture,
    slug: "capture-support-analyst",
    title: "Capture Support Analyst",
    summary: "Specialist track for RFP intake, compliance analysis, research support, and capture-team coordination.",
    level: certificationLevels[2],
    status: "published",
    passing_score: 80,
    validity_months: 18,
    requirements: [
      { id: "81200000-0000-4000-8000-000000000009", certification_id: ids.capture, requirement_type: "course", resource_id: "81300000-0000-4000-8000-000000000004", title: "Capture Support Fundamentals", required: true, minimum_score: null, position: 1 },
      { id: "81200000-0000-4000-8000-000000000010", certification_id: ids.capture, requirement_type: "assessment", resource_id: "81400000-0000-4000-8000-000000000004", title: "RFP Intake Assessment", required: true, minimum_score: 80, position: 2 },
    ],
  },
];

export const mockCertificationProgress: CertificationProgress[] = mockCertificationTracks.map((track, trackIndex) => ({
  user_id: userId,
  certification_id: track.id,
  eligibility_status: trackIndex === 0 ? "in_progress" : trackIndex === 2 ? "eligible" : "not_eligible",
  progress_percent: trackIndex === 0 ? 65 : trackIndex === 2 ? 20 : 0,
  requirements: track.requirements.map((requirement, index) => ({
    requirement_id: requirement.id,
    status: trackIndex === 0 && index === 0 ? "completed" : trackIndex === 0 ? "in_progress" : "not_started",
    score: trackIndex === 0 && index === 0 ? 100 : null,
  })),
  earned_at: null,
  expires_at: null,
}));
