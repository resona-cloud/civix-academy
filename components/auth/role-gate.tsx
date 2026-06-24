import type { ReactNode } from "react";
import { hasAnyRole } from "@/lib/auth/guards";
import type { AppRole, CurrentAppUser } from "@/lib/auth/types";
import { PermissionNotice } from "./permission-notice";

export function RoleGate({ user, roles, children, fallback }: { user: CurrentAppUser | null; roles: readonly AppRole[]; children: ReactNode; fallback?: ReactNode }) {
  if (!hasAnyRole(user, roles)) return fallback ?? <PermissionNotice />;
  return children;
}
