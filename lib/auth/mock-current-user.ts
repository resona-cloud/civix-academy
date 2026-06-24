import type { CurrentAppUser } from "./types";

export const mockCurrentUser: CurrentAppUser = {
  id: "b1000000-0000-4000-8000-000000000001",
  email: "elena.brooks@example.test",
  display_name: "Elena Brooks",
  classification: "Senior Procurement Instructor",
  roles: ["admin", "instructor", "reviewer"],
  source: "mock",
};

export function getMockCurrentUser() {
  return mockCurrentUser;
}
