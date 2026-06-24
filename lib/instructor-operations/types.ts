import type { CertificationProgress } from "@/lib/certifications/types";
import type { CompetencyScore } from "@/lib/evaluation-engine/types";
import type { CourseProgress } from "@/lib/learning-engine/types";

export type Cohort = {
  id: string;
  name: string;
  program_title: string;
  start_date: string;
  end_date: string;
  instructor_ids: string[];
  learner_ids: string[];
  progress_percent: number;
  status: "planned" | "active" | "completed";
};

export type RiskFlag = {
  id: string;
  learner_id: string;
  category: "inactivity" | "assessment" | "progress" | "lab" | "certification";
  severity: "low" | "medium" | "high";
  title: string;
  description: string;
  status: "open" | "monitoring" | "resolved";
  created_at: string;
};

export type InstructorNote = {
  id: string;
  learner_id: string;
  author_id: string;
  author_name: string;
  body: string;
  visibility: "instructors" | "reviewers";
  created_at: string;
};

export type AssessmentPerformance = {
  assessment_id: string;
  title: string;
  attempt_count: number;
  latest_score: number | null;
  status: "not_started" | "in_progress" | "passed" | "failed" | "needs_review";
  completed_at: string | null;
};

export type LearnerLabSubmission = {
  submission_id: string;
  lab_scenario_id: string;
  scenario_title: string;
  status: "draft" | "submitted" | "in_review" | "passed" | "failed" | "needs_revision";
  score: number | null;
  submitted_at: string | null;
};

export type LearnerCompetencyProgress = {
  competency_id: string;
  competency_name: string;
  progress_percent: number;
  evidence_count: number;
};

export type CertificationAssignment = {
  certification_id: string;
  title: string;
  progress: CertificationProgress;
};

export type LearnerProfile = {
  id: string;
  display_name: string;
  email: string;
  role: "learner" | "senior_agent" | "specialist";
  classification: string;
  cohort_id: string;
  last_active_at: string;
  assigned_certifications: CertificationAssignment[];
  course_progress: CourseProgress[];
  assessment_performance: AssessmentPerformance[];
  lab_submissions: LearnerLabSubmission[];
  competency_progress: LearnerCompetencyProgress[];
  notes: InstructorNote[];
  risk_flags: RiskFlag[];
};

export type ReviewSubmission = {
  id: string;
  submission_type: "lab" | "assessment" | "short_response";
  learner_id: string;
  learner_name: string;
  title: string;
  response_summary: string;
  rubric_id: string | null;
  priority: "low" | "normal" | "high" | "urgent";
  status: "pending" | "assigned" | "in_review" | "completed";
  reviewer_id: string | null;
  reviewer_name: string | null;
  submitted_at: string;
  due_at: string;
  artifacts: { id: string; title: string; artifact_type: "response" | "document" | "worksheet" }[];
};

export type ReviewDecision = {
  id: string;
  submission_id: string;
  reviewer_id: string;
  decision: "pass" | "needs_revision" | "fail";
  total_score: number;
  reviewer_feedback: string;
  competency_scores: CompetencyScore[];
  decided_at: string | null;
};

export type ReviewerWorkload = {
  reviewer_id: string;
  reviewer_name: string;
  assigned_count: number;
  overdue_count: number;
  completed_this_week: number;
  capacity_status: "available" | "balanced" | "at_capacity";
};

export type AssessmentActivity = {
  id: string;
  learner_id: string;
  learner_name: string;
  assessment_title: string;
  score: number | null;
  status: "passed" | "failed" | "needs_review";
  occurred_at: string;
};

export type InstructorAction = {
  id: string;
  title: string;
  description: string;
  priority: "normal" | "high";
  href: string;
};

export type InstructorDashboard = {
  cohorts: Cohort[];
  learners_in_progress: number;
  certification_ready_count: number;
  recent_assessment_activity: AssessmentActivity[];
  pending_lab_reviews: number;
  risk_flags: RiskFlag[];
  recommended_actions: InstructorAction[];
};

export type ReportingMetric = { label: string; value: number; total: number };

export type OperationsReport = {
  training_completion: ReportingMetric[];
  certification_readiness: ReportingMetric[];
  lab_outcomes: ReportingMetric[];
  competency_coverage: ReportingMetric[];
  learner_risk: { severity: RiskFlag["severity"]; count: number }[];
  reviewer_workload: ReviewerWorkload[];
};
