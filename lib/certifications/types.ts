export type CertificationLevel = {
  id: string;
  name: string;
  rank: number;
  description: string;
};

export type CertificationRequirement = {
  id: string;
  certification_id: string;
  requirement_type: "course" | "assessment";
  resource_id: string;
  title: string;
  required: boolean;
  minimum_score: number | null;
  position: number;
};

export type CertificationTrack = {
  id: string;
  slug: string;
  title: string;
  summary: string;
  level: CertificationLevel;
  status: "published";
  passing_score: number;
  validity_months: number;
  requirements: CertificationRequirement[];
};

export type RequirementProgress = {
  requirement_id: string;
  status: "not_started" | "in_progress" | "completed" | "passed" | "failed";
  score: number | null;
};

export type CertificationProgress = {
  user_id: string;
  certification_id: string;
  eligibility_status: "not_eligible" | "eligible" | "in_progress" | "earned";
  progress_percent: number;
  requirements: RequirementProgress[];
  earned_at: string | null;
  expires_at: string | null;
};
