export type AppRole = "admin" | "instructor" | "reviewer" | "trainee" | "certified_agent";

export type Permission =
  | "manage_platform"
  | "manage_users"
  | "manage_learning_content"
  | "manage_cohorts"
  | "view_assigned_learners"
  | "review_submissions"
  | "view_reports"
  | "access_learning"
  | "access_fieldbook"
  | "access_agent_labs"
  | "view_own_profile";

export type CurrentAppUser = {
  id: string;
  email: string;
  display_name: string;
  classification: string;
  roles: AppRole[];
  source: "supabase" | "mock";
};
