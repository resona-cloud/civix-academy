import type { CertificationLevel, CertificationProgress, CertificationTrack } from "./types";

const userId = "73000000-0000-4000-8000-000000000001";
const foundationsCourseId = "10000000-0000-4000-8000-000000000001";
const foundationsAssessmentId = "71000000-0000-4000-8000-000000000001";

export const certificationLevels: CertificationLevel[] = [
  { id: "81000000-0000-4000-8000-000000000001", name: "Level I", rank: 1, description: "Foundational proficiency with guided execution." },
  { id: "81000000-0000-4000-8000-000000000002", name: "Level II", rank: 2, description: "Independent execution across complex work." },
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
    slug: "certification-track-1",
    title: "Certification Track 1",
    summary: "Foundational training for the first certification track.",
    level: certificationLevels[0],
    status: "published",
    passing_score: 70,
    validity_months: 24,
    requirements: [
      { id: "81200000-0000-4000-8000-000000000001", certification_id: ids.agentOne, requirement_type: "course", resource_id: foundationsCourseId, title: "Sample Course", required: true, minimum_score: null, position: 1 },
      { id: "81200000-0000-4000-8000-000000000002", certification_id: ids.agentOne, requirement_type: "assessment", resource_id: foundationsAssessmentId, title: "Quick Review Assessment", required: true, minimum_score: 70, position: 2 },
    ],
  },
  {
    id: ids.agentTwo,
    slug: "certification-track-2",
    title: "Certification Track 2",
    summary: "Advanced qualification for the second certification track.",
    level: certificationLevels[1],
    status: "published",
    passing_score: 80,
    validity_months: 24,
    requirements: [
      { id: "81200000-0000-4000-8000-000000000003", certification_id: ids.agentTwo, requirement_type: "course", resource_id: "81300000-0000-4000-8000-000000000001", title: "Course 2", required: true, minimum_score: null, position: 1 },
      { id: "81200000-0000-4000-8000-000000000004", certification_id: ids.agentTwo, requirement_type: "assessment", resource_id: "81400000-0000-4000-8000-000000000001", title: "Capstone Assessment 2", required: true, minimum_score: 80, position: 2 },
    ],
  },
  {
    id: ids.opportunity,
    slug: "certification-track-3",
    title: "Certification Track 3",
    summary: "Specialist track for the third certification path.",
    level: certificationLevels[2],
    status: "published",
    passing_score: 80,
    validity_months: 18,
    requirements: [
      { id: "81200000-0000-4000-8000-000000000005", certification_id: ids.opportunity, requirement_type: "course", resource_id: "81300000-0000-4000-8000-000000000002", title: "Course 3", required: true, minimum_score: null, position: 1 },
      { id: "81200000-0000-4000-8000-000000000006", certification_id: ids.opportunity, requirement_type: "assessment", resource_id: "81400000-0000-4000-8000-000000000002", title: "Lab Assessment 3", required: true, minimum_score: 80, position: 2 },
    ],
  },
  {
    id: ids.vendor,
    slug: "certification-track-4",
    title: "Certification Track 4",
    summary: "Specialist track for the fourth certification path.",
    level: certificationLevels[2],
    status: "published",
    passing_score: 75,
    validity_months: 18,
    requirements: [
      { id: "81200000-0000-4000-8000-000000000007", certification_id: ids.vendor, requirement_type: "course", resource_id: "81300000-0000-4000-8000-000000000003", title: "Course 4", required: true, minimum_score: null, position: 1 },
      { id: "81200000-0000-4000-8000-000000000008", certification_id: ids.vendor, requirement_type: "assessment", resource_id: "81400000-0000-4000-8000-000000000003", title: "Lab Assessment 4", required: true, minimum_score: 75, position: 2 },
    ],
  },
  {
    id: ids.capture,
    slug: "certification-track-5",
    title: "Certification Track 5",
    summary: "Specialist track for the fifth certification path.",
    level: certificationLevels[2],
    status: "published",
    passing_score: 80,
    validity_months: 18,
    requirements: [
      { id: "81200000-0000-4000-8000-000000000009", certification_id: ids.capture, requirement_type: "course", resource_id: "81300000-0000-4000-8000-000000000004", title: "Course 5", required: true, minimum_score: null, position: 1 },
      { id: "81200000-0000-4000-8000-000000000010", certification_id: ids.capture, requirement_type: "assessment", resource_id: "81400000-0000-4000-8000-000000000004", title: "Assessment 5", required: true, minimum_score: 80, position: 2 },
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
