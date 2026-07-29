import type { AppRole, Permission } from "./types";

export const appRoles: readonly AppRole[] = ["admin", "trainee", "zone_manager", "sales_rep", "sourcing_operator", "developer", "founder"];

export const roleLabels: Record<AppRole, string> = {
  admin: "Administrator",
  trainee: "Trainee",
  zone_manager: "Zone Manager",
  sales_rep: "Sales Rep",
  sourcing_operator: "Sourcing Operator",
  developer: "Developer",
  founder: "Founder",
};

// zone_manager is the one job role with elevated platform permissions
// (cohort leadership + submission review), consolidating what used to be
// split across 'instructor' and 'reviewer'. Every other job role gets the
// same baseline learner permissions; elevated platform-wide access comes
// from separately holding the 'admin' permission tier, not from job title.
const baselineLearnerPermissions: readonly Permission[] = ["access_learning", "access_fieldbook", "access_agent_labs", "view_own_profile"];

export const rolePermissions: Record<AppRole, readonly Permission[]> = {
  admin: ["manage_platform", "manage_users", "manage_learning_content", "manage_cohorts", "view_assigned_learners", "review_submissions", "view_reports", "access_learning", "access_fieldbook", "access_agent_labs", "view_own_profile"],
  zone_manager: ["manage_learning_content", "manage_cohorts", "view_assigned_learners", "review_submissions", "view_reports", "access_learning", "access_fieldbook", "access_agent_labs", "view_own_profile"],
  trainee: baselineLearnerPermissions,
  sales_rep: baselineLearnerPermissions,
  sourcing_operator: baselineLearnerPermissions,
  developer: baselineLearnerPermissions,
  founder: baselineLearnerPermissions,
};
