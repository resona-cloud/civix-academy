import type { AppRole, Permission } from "@/lib/auth/types";

export type RoleAssignment = {
  id: string;
  user_id: string;
  role: AppRole;
  granted_by: string;
  granted_at: string;
};

export type CohortAssignment = {
  id: string;
  user_id: string;
  cohort_id: string;
  cohort_name: string;
  member_type: "instructor" | "trainee";
  assigned_at: string;
};

export type AccessSummary = {
  permissions: Permission[];
  protected_areas: string[];
  access_level: "platform_admin" | "operations" | "review" | "learning";
};

export type AuditEvent = {
  id: string;
  actor_id: string | null;
  actor_name: string;
  event_type: string;
  entity_type: string;
  entity_id: string;
  summary: string;
  created_at: string;
};

export type AdminUser = {
  id: string;
  email: string;
  display_name: string;
  classification: string;
  status: "active" | "inactive" | "suspended";
  created_at: string;
  last_active_at: string | null;
  role_assignments: RoleAssignment[];
  cohort_assignments: CohortAssignment[];
  access_summary: AccessSummary;
  audit_events: AuditEvent[];
};
