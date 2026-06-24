import type { AppRole, Permission } from "./types";

export const appRoles: readonly AppRole[] = ["admin", "instructor", "reviewer", "trainee", "certified_agent"];

export const roleLabels: Record<AppRole, string> = {
  admin: "Administrator",
  instructor: "Instructor",
  reviewer: "Reviewer",
  trainee: "Trainee",
  certified_agent: "Certified Agent",
};

export const rolePermissions: Record<AppRole, readonly Permission[]> = {
  admin: ["manage_platform", "manage_users", "manage_learning_content", "manage_cohorts", "view_assigned_learners", "review_submissions", "view_reports", "access_learning", "access_fieldbook", "access_agent_labs", "view_own_profile"],
  instructor: ["manage_learning_content", "manage_cohorts", "view_assigned_learners", "view_reports", "access_learning", "access_fieldbook", "access_agent_labs", "view_own_profile"],
  reviewer: ["review_submissions", "view_reports", "access_learning", "access_fieldbook", "access_agent_labs", "view_own_profile"],
  trainee: ["access_learning", "access_fieldbook", "access_agent_labs", "view_own_profile"],
  certified_agent: ["access_learning", "access_fieldbook", "access_agent_labs", "view_own_profile"],
};
