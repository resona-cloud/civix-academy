import type { CurrentAppUser } from "./types";

export const mockCurrentUser: CurrentAppUser = {
  id: "b1000000-0000-4000-8000-000000000001",
  email: "admin@example.test",
  display_name: "Admin User",
  classification: "Zone Manager",
  roles: ["admin", "zone_manager"],
  source: "mock",
};

export function getMockCurrentUser() {
  return mockCurrentUser;
}
