import type { ReactNode } from "react";
import type { CurrentAppUser } from "@/lib/auth/types";
import { PermissionNotice } from "./permission-notice";

export function AuthGate({ user, children, fallback }: { user: CurrentAppUser | null; children: ReactNode; fallback?: ReactNode }) {
  if (!user) return fallback ?? <PermissionNotice title="Sign in required" description="Sign in to access this area." />;
  return children;
}
