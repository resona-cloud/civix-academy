import { rolePermissions } from "@/lib/auth/roles";
import type { AppRole } from "@/lib/auth/types";
import type { AccessSummary, AdminUser, AuditEvent, CohortAssignment, RoleAssignment } from "./types";

const adminId = "b1000000-0000-4000-8000-000000000001";
const juneCohortId = "a2000000-0000-4000-8000-000000000001";
const specialistCohortId = "a2000000-0000-4000-8000-000000000002";

function roleAssignments(userId: string, roles: AppRole[]): RoleAssignment[] {
  return roles.map((role, index) => ({ id: `${userId.slice(0, 8)}-1000-4000-8000-${String(index + 1).padStart(12, "0")}`, user_id: userId, role, granted_by: adminId, granted_at: "2026-06-10T14:00:00Z" }));
}

function cohortAssignment(userId: string, cohortId: string, cohortName: string, memberType: CohortAssignment["member_type"]): CohortAssignment {
  return { id: `${userId.slice(0, 8)}-2000-4000-8000-000000000001`, user_id: userId, cohort_id: cohortId, cohort_name: cohortName, member_type: memberType, assigned_at: "2026-06-11T13:00:00Z" };
}

function accessSummary(roles: AppRole[]): AccessSummary {
  const permissions = Array.from(new Set(roles.flatMap((role) => rolePermissions[role])));
  const accessLevel: AccessSummary["access_level"] = roles.includes("admin") ? "platform_admin" : roles.includes("instructor") ? "operations" : roles.includes("reviewer") ? "review" : "learning";
  const areas = accessLevel === "platform_admin" ? ["All application areas", "User and role administration", "Audit events"] : accessLevel === "operations" ? ["Instructor Console", "People", "Reports"] : accessLevel === "review" ? ["Reviews", "Reports"] : ["Training", "Study Center", "Fieldbook", "Labs"];
  return { permissions: [...permissions], protected_areas: areas, access_level: accessLevel };
}

function audit(userId: string, actorName: string, event: string, summary: string, index: number): AuditEvent {
  return { id: `${userId.slice(0, 8)}-3000-4000-8000-${String(index).padStart(12, "0")}`, actor_id: adminId, actor_name: actorName, event_type: event, entity_type: "profile", entity_id: userId, summary, created_at: `2026-06-${String(10 + index).padStart(2, "0")}T14:00:00Z` };
}

const seeds: Array<{ id: string; email: string; name: string; classification: string; status: AdminUser["status"]; roles: AppRole[]; cohorts: CohortAssignment[]; lastActive: string | null }> = [
  { id: adminId, email: "elena.brooks@example.test", name: "Elena Brooks", classification: "Senior Procurement Instructor", status: "active", roles: ["admin", "instructor", "reviewer"], cohorts: [cohortAssignment(adminId, juneCohortId, "June Agent Cohort", "instructor")], lastActive: "2026-06-24T13:30:00Z" },
  { id: "b1000000-0000-4000-8000-000000000002", email: "darius.king@example.test", name: "Darius King", classification: "Senior Reviewer", status: "active", roles: ["reviewer"], cohorts: [], lastActive: "2026-06-24T12:45:00Z" },
  { id: "a1000000-0000-4000-8000-000000000001", email: "maya.chen@example.test", name: "Maya Chen", classification: "Procurement Agent I Candidate", status: "active", roles: ["trainee"], cohorts: [cohortAssignment("a1000000-0000-4000-8000-000000000001", juneCohortId, "June Agent Cohort", "trainee")], lastActive: "2026-06-23T15:40:00Z" },
  { id: "a1000000-0000-4000-8000-000000000003", email: "priya.nair@example.test", name: "Priya Nair", classification: "Opportunity Research Specialist Candidate", status: "active", roles: ["trainee", "certified_agent"], cohorts: [cohortAssignment("a1000000-0000-4000-8000-000000000003", specialistCohortId, "Research Specialist Cohort", "trainee")], lastActive: "2026-06-23T18:10:00Z" },
  { id: "a1000000-0000-4000-8000-000000000002", email: "jordan.ellis@example.test", name: "Jordan Ellis", classification: "Procurement Agent I Candidate", status: "inactive", roles: ["trainee"], cohorts: [cohortAssignment("a1000000-0000-4000-8000-000000000002", juneCohortId, "June Agent Cohort", "trainee")], lastActive: "2026-06-14T11:05:00Z" },
];

export const mockAdminUsers: AdminUser[] = seeds.map((seed) => {
  const assignments = roleAssignments(seed.id, seed.roles);
  return { id: seed.id, email: seed.email, display_name: seed.name, classification: seed.classification, status: seed.status, created_at: "2026-06-10T14:00:00Z", last_active_at: seed.lastActive, role_assignments: assignments, cohort_assignments: seed.cohorts, access_summary: accessSummary(seed.roles), audit_events: [audit(seed.id, "Elena Brooks", "profile.created", `${seed.name} profile created`, 1), audit(seed.id, "Elena Brooks", "roles.updated", `${seed.roles.join(", ")} roles assigned`, 2)] };
});

export const mockAdminAuditEvents: AuditEvent[] = mockAdminUsers.flatMap((user) => user.audit_events).sort((left, right) => right.created_at.localeCompare(left.created_at));
