import { mockCertificationTracks } from "@/lib/certifications/mock-data";
import type { CertificationProgress } from "@/lib/certifications/types";
import { mockCompetencies } from "@/lib/evaluation-engine/mock-data";
import type { CourseProgress } from "@/lib/learning-engine/types";
import type { Cohort, InstructorDashboard, InstructorNote, LearnerProfile, OperationsReport, ReviewSubmission, ReviewerWorkload, RiskFlag } from "./types";

const learnerIds = {
  a: "a1000000-0000-4000-8000-000000000001",
  b: "a1000000-0000-4000-8000-000000000002",
  c: "a1000000-0000-4000-8000-000000000003",
  d: "a1000000-0000-4000-8000-000000000004",
} as const;

const cohortIds = {
  a: "a2000000-0000-4000-8000-000000000001",
  b: "a2000000-0000-4000-8000-000000000002",
} as const;

const trackOne = mockCertificationTracks[0];
const trackThree = mockCertificationTracks[2];
if (!trackOne || !trackThree) throw new Error("Certification mock data is incomplete");

function certificationProgress(userId: string, certificationId: string, progress: number, eligibility: CertificationProgress["eligibility_status"]): CertificationProgress {
  return { user_id: userId, certification_id: certificationId, eligibility_status: eligibility, progress_percent: progress, requirements: [], earned_at: eligibility === "earned" ? "2026-05-15T14:00:00Z" : null, expires_at: eligibility === "earned" ? "2028-05-15T14:00:00Z" : null };
}

function courseProgress(userId: string, percent: number): CourseProgress {
  return {
    user_id: userId,
    course_id: "10000000-0000-4000-8000-000000000001",
    title: "Sample Course",
    progress_percent: percent,
    modules: [
      { module_id: "20000000-0000-4000-8000-000000000001", title: "Module 1", progress_percent: Math.min(100, percent + 20), lessons: [
        { lesson_id: "30000000-0000-4000-8000-000000000001", title: "Lesson 1", status: percent >= 30 ? "completed" : "in_progress", progress_percent: percent >= 30 ? 100 : percent },
        { lesson_id: "30000000-0000-4000-8000-000000000002", title: "Lesson 2", status: percent >= 70 ? "completed" : percent ? "in_progress" : "not_started", progress_percent: Math.min(100, percent) },
      ] },
      { module_id: "20000000-0000-4000-8000-000000000002", title: "Module 2", progress_percent: Math.max(0, percent - 35), lessons: [
        { lesson_id: "30000000-0000-4000-8000-000000000004", title: "Lesson 4", status: percent >= 85 ? "completed" : percent >= 40 ? "in_progress" : "not_started", progress_percent: Math.max(0, percent - 20) },
      ] },
    ],
    assessments: [{ assessment_id: "71000000-0000-4000-8000-000000000001", title: "Quick Review Assessment", status: percent >= 75 ? "passed" : percent >= 40 ? "in_progress" : "not_started", score: percent >= 75 ? Math.min(96, percent + 8) : null }],
  };
}

export const mockCohorts: Cohort[] = [
  { id: cohortIds.a, name: "Cohort A", program_title: trackOne.title, start_date: "2026-06-03", end_date: "2026-08-28", instructor_ids: ["b1000000-0000-4000-8000-000000000001"], learner_ids: [learnerIds.a, learnerIds.b, learnerIds.d], progress_percent: 61, status: "active" },
  { id: cohortIds.b, name: "Cohort B", program_title: trackThree.title, start_date: "2026-05-12", end_date: "2026-07-31", instructor_ids: ["b1000000-0000-4000-8000-000000000001", "b1000000-0000-4000-8000-000000000002"], learner_ids: [learnerIds.c], progress_percent: 84, status: "active" },
];

export const mockRiskFlags: RiskFlag[] = [
  { id: "a3000000-0000-4000-8000-000000000001", learner_id: learnerIds.b, category: "inactivity", severity: "high", title: "No activity for 9 days", description: "Learner has not resumed the assigned course.", status: "open", created_at: "2026-06-22T13:00:00Z" },
  { id: "a3000000-0000-4000-8000-000000000002", learner_id: learnerIds.d, category: "assessment", severity: "medium", title: "Two failed assessment attempts", description: "Latest review score is below the required threshold.", status: "monitoring", created_at: "2026-06-21T15:30:00Z" },
  { id: "a3000000-0000-4000-8000-000000000003", learner_id: learnerIds.a, category: "lab", severity: "low", title: "Lab revision requested", description: "Lab Scenario 1 submission needs a clearer evidence trail.", status: "monitoring", created_at: "2026-06-20T17:00:00Z" },
];

export const mockInstructorNotes: InstructorNote[] = [
  { id: "a4000000-0000-4000-8000-000000000001", learner_id: learnerIds.a, author_id: "b1000000-0000-4000-8000-000000000001", author_name: "Admin User", body: "Strong analytical work. Reinforce traceability between source evidence and recommendations.", visibility: "instructors", created_at: "2026-06-21T16:00:00Z" },
  { id: "a4000000-0000-4000-8000-000000000002", learner_id: learnerIds.b, author_id: "b1000000-0000-4000-8000-000000000001", author_name: "Admin User", body: "Outreach recommended before the learner falls another module behind the cohort.", visibility: "instructors", created_at: "2026-06-22T13:15:00Z" },
  { id: "a4000000-0000-4000-8000-000000000003", learner_id: learnerIds.d, author_id: "b1000000-0000-4000-8000-000000000002", author_name: "Team Lead A", body: "Review submission alignment before the next assessment attempt.", visibility: "reviewers", created_at: "2026-06-21T18:20:00Z" },
];

function competencyProgress(values: number[]) {
  return mockCompetencies.map((competency, index) => ({ competency_id: competency.id, competency_name: competency.name, progress_percent: values[index] ?? 0, evidence_count: Math.max(1, Math.round((values[index] ?? 0) / 20)) }));
}

export const mockLearnerProfiles: LearnerProfile[] = [
  {
    id: learnerIds.a, display_name: "Learner A", email: "learner-a@example.test", role: "learner", classification: "Trainee", cohort_id: cohortIds.a, last_active_at: "2026-06-23T15:40:00Z",
    assigned_certifications: [{ certification_id: trackOne.id, title: trackOne.title, progress: certificationProgress(learnerIds.a, trackOne.id, 72, "in_progress") }],
    course_progress: [courseProgress(learnerIds.a, 78)],
    assessment_performance: [{ assessment_id: "71000000-0000-4000-8000-000000000001", title: "Quick Review Assessment", attempt_count: 1, latest_score: 84, status: "passed", completed_at: "2026-06-19T14:10:00Z" }],
    lab_submissions: [{ submission_id: "c1000000-0000-4000-8000-000000000001", lab_scenario_id: "94000000-0000-4000-8000-000000000001", scenario_title: "Lab Scenario 1", status: "needs_revision", score: 68, submitted_at: "2026-06-20T16:20:00Z" }],
    competency_progress: competencyProgress([82, 70, 65, 74]), notes: mockInstructorNotes.filter((item) => item.learner_id === learnerIds.a), risk_flags: mockRiskFlags.filter((item) => item.learner_id === learnerIds.a),
  },
  {
    id: learnerIds.b, display_name: "Learner B", email: "learner-b@example.test", role: "learner", classification: "Trainee", cohort_id: cohortIds.a, last_active_at: "2026-06-14T11:05:00Z",
    assigned_certifications: [{ certification_id: trackOne.id, title: trackOne.title, progress: certificationProgress(learnerIds.b, trackOne.id, 34, "in_progress") }],
    course_progress: [courseProgress(learnerIds.b, 38)],
    assessment_performance: [{ assessment_id: "71000000-0000-4000-8000-000000000001", title: "Quick Review Assessment", attempt_count: 0, latest_score: null, status: "not_started", completed_at: null }],
    lab_submissions: [], competency_progress: competencyProgress([35, 28, 30, 24]), notes: mockInstructorNotes.filter((item) => item.learner_id === learnerIds.b), risk_flags: mockRiskFlags.filter((item) => item.learner_id === learnerIds.b),
  },
  {
    id: learnerIds.c, display_name: "Learner C", email: "learner-c@example.test", role: "learner", classification: "Trainee", cohort_id: cohortIds.b, last_active_at: "2026-06-23T18:10:00Z",
    assigned_certifications: [{ certification_id: trackThree.id, title: trackThree.title, progress: certificationProgress(learnerIds.c, trackThree.id, 91, "eligible") }],
    course_progress: [courseProgress(learnerIds.c, 96)],
    assessment_performance: [{ assessment_id: "71000000-0000-4000-8000-000000000001", title: "Quick Review Assessment", attempt_count: 1, latest_score: 94, status: "passed", completed_at: "2026-06-18T12:00:00Z" }],
    lab_submissions: [{ submission_id: "c1000000-0000-4000-8000-000000000002", lab_scenario_id: "94000000-0000-4000-8000-000000000004", scenario_title: "Lab Scenario 4", status: "submitted", score: null, submitted_at: "2026-06-23T17:45:00Z" }],
    competency_progress: competencyProgress([92, 86, 90, 88]), notes: [], risk_flags: [],
  },
  {
    id: learnerIds.d, display_name: "Learner D", email: "learner-d@example.test", role: "learner", classification: "Trainee", cohort_id: cohortIds.a, last_active_at: "2026-06-22T19:25:00Z",
    assigned_certifications: [{ certification_id: trackOne.id, title: trackOne.title, progress: certificationProgress(learnerIds.d, trackOne.id, 58, "in_progress") }],
    course_progress: [courseProgress(learnerIds.d, 68)],
    assessment_performance: [{ assessment_id: "71000000-0000-4000-8000-000000000001", title: "Quick Review Assessment", attempt_count: 2, latest_score: 64, status: "failed", completed_at: "2026-06-21T17:30:00Z" }],
    lab_submissions: [{ submission_id: "c1000000-0000-4000-8000-000000000003", lab_scenario_id: "94000000-0000-4000-8000-000000000003", scenario_title: "Lab Scenario 3", status: "in_review", score: null, submitted_at: "2026-06-22T18:45:00Z" }],
    competency_progress: competencyProgress([68, 62, 58, 65]), notes: mockInstructorNotes.filter((item) => item.learner_id === learnerIds.d), risk_flags: mockRiskFlags.filter((item) => item.learner_id === learnerIds.d),
  },
];

export const mockReviewSubmissions: ReviewSubmission[] = [
  { id: "c1000000-0000-4000-8000-000000000001", submission_type: "lab", learner_id: learnerIds.a, learner_name: "Learner A", title: "Lab Scenario 1", response_summary: "Recommendation with supporting evidence.", rubric_id: "92000000-0000-4000-8000-000000000001", priority: "normal", status: "completed", reviewer_id: "b1000000-0000-4000-8000-000000000001", reviewer_name: "Admin User", submitted_at: "2026-06-20T16:20:00Z", due_at: "2026-06-22T17:00:00Z", artifacts: [{ id: "c2000000-0000-4000-8000-000000000000", title: "Worksheet 1", artifact_type: "worksheet" }] },
  { id: "c1000000-0000-4000-8000-000000000002", submission_type: "lab", learner_id: learnerIds.c, learner_name: "Learner C", title: "Lab Scenario 4", response_summary: "Research profile and recommended next steps.", rubric_id: "92000000-0000-4000-8000-000000000004", priority: "high", status: "pending", reviewer_id: null, reviewer_name: null, submitted_at: "2026-06-23T17:45:00Z", due_at: "2026-06-25T17:00:00Z", artifacts: [{ id: "c2000000-0000-4000-8000-000000000001", title: "Research brief", artifact_type: "document" }] },
  { id: "c1000000-0000-4000-8000-000000000003", submission_type: "lab", learner_id: learnerIds.d, learner_name: "Learner D", title: "Lab Scenario 3", response_summary: "Intake summary and action register.", rubric_id: "92000000-0000-4000-8000-000000000003", priority: "urgent", status: "assigned", reviewer_id: "b1000000-0000-4000-8000-000000000002", reviewer_name: "Team Lead A", submitted_at: "2026-06-22T18:45:00Z", due_at: "2026-06-24T12:00:00Z", artifacts: [{ id: "c2000000-0000-4000-8000-000000000002", title: "Intake worksheet", artifact_type: "worksheet" }] },
  { id: "c1000000-0000-4000-8000-000000000004", submission_type: "short_response", learner_id: learnerIds.a, learner_name: "Learner A", title: "Short Response 1", response_summary: "A short response explaining why recommendations must be traceable to dated evidence.", rubric_id: null, priority: "normal", status: "pending", reviewer_id: null, reviewer_name: null, submitted_at: "2026-06-23T13:10:00Z", due_at: "2026-06-26T17:00:00Z", artifacts: [{ id: "c2000000-0000-4000-8000-000000000003", title: "Written response", artifact_type: "response" }] },
  { id: "c1000000-0000-4000-8000-000000000005", submission_type: "assessment", learner_id: learnerIds.d, learner_name: "Learner D", title: "Quick Review Assessment (Manual Review)", response_summary: "Assessment attempt flagged for instructor review after repeated below-threshold scores.", rubric_id: null, priority: "high", status: "assigned", reviewer_id: "b1000000-0000-4000-8000-000000000001", reviewer_name: "Admin User", submitted_at: "2026-06-21T17:30:00Z", due_at: "2026-06-25T12:00:00Z", artifacts: [{ id: "c2000000-0000-4000-8000-000000000004", title: "Assessment attempt", artifact_type: "response" }] },
];

export const mockReviewerWorkloads: ReviewerWorkload[] = [
  { reviewer_id: "b1000000-0000-4000-8000-000000000001", reviewer_name: "Admin User", assigned_count: 4, overdue_count: 0, completed_this_week: 7, capacity_status: "balanced" },
  { reviewer_id: "b1000000-0000-4000-8000-000000000002", reviewer_name: "Team Lead A", assigned_count: 6, overdue_count: 1, completed_this_week: 5, capacity_status: "at_capacity" },
  { reviewer_id: "b1000000-0000-4000-8000-000000000003", reviewer_name: "Team Lead B", assigned_count: 1, overdue_count: 0, completed_this_week: 4, capacity_status: "available" },
];

export const mockInstructorDashboard: InstructorDashboard = {
  cohorts: mockCohorts,
  learners_in_progress: mockLearnerProfiles.filter((item) => item.course_progress.some((course) => course.progress_percent > 0 && course.progress_percent < 100)).length,
  certification_ready_count: mockLearnerProfiles.filter((item) => item.assigned_certifications.some((assignment) => assignment.progress.eligibility_status === "eligible")).length,
  recent_assessment_activity: [
    { id: "c3000000-0000-4000-8000-000000000001", learner_id: learnerIds.c, learner_name: "Learner C", assessment_title: "Quick Review Assessment", score: 94, status: "passed", occurred_at: "2026-06-23T12:00:00Z" },
    { id: "c3000000-0000-4000-8000-000000000002", learner_id: learnerIds.d, learner_name: "Learner D", assessment_title: "Quick Review Assessment", score: 64, status: "failed", occurred_at: "2026-06-21T17:30:00Z" },
    { id: "c3000000-0000-4000-8000-000000000003", learner_id: learnerIds.a, learner_name: "Learner A", assessment_title: "Short Response 1", score: null, status: "needs_review", occurred_at: "2026-06-23T13:10:00Z" },
  ],
  pending_lab_reviews: mockReviewSubmissions.filter((item) => item.submission_type === "lab" && item.status !== "completed").length,
  risk_flags: mockRiskFlags,
  recommended_actions: [
    { id: "c4000000-0000-4000-8000-000000000001", title: "Contact Learner B", description: "Resolve the 9-day inactivity flag before the next cohort checkpoint.", priority: "high", href: `/people/${learnerIds.b}` },
    { id: "c4000000-0000-4000-8000-000000000002", title: "Assign Lab Scenario 4 review", description: "Learner C's submission is unassigned and due within two days.", priority: "high", href: "/reviews/c1000000-0000-4000-8000-000000000002" },
    { id: "c4000000-0000-4000-8000-000000000003", title: "Review certification readiness", description: "One learner is eligible for a specialist certification review.", priority: "normal", href: "/certifications" },
  ],
};

export const mockOperationsReport: OperationsReport = {
  training_completion: [{ label: "Completed", value: 9, total: 20 }, { label: "In progress", value: 8, total: 20 }, { label: "Not started", value: 3, total: 20 }],
  certification_readiness: [{ label: "Ready", value: 4, total: 15 }, { label: "In progress", value: 8, total: 15 }, { label: "Not eligible", value: 3, total: 15 }],
  lab_outcomes: [{ label: "Passed", value: 11, total: 18 }, { label: "Needs revision", value: 4, total: 18 }, { label: "Failed", value: 3, total: 18 }],
  competency_coverage: mockCompetencies.map((item, index) => ({ label: item.name, value: [14, 11, 12, 9][index] ?? 0, total: 16 })),
  learner_risk: [{ severity: "high", count: 1 }, { severity: "medium", count: 1 }, { severity: "low", count: 1 }],
  reviewer_workload: mockReviewerWorkloads,
};
