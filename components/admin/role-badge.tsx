import { roleLabels } from "@/lib/auth/roles";
import type { AppRole } from "@/lib/auth/types";

export function RoleBadge({ role }: { role: AppRole }) {
  return <span className="rounded-full bg-indigo-50 px-2.5 py-1 text-xs font-medium text-indigo-700">{roleLabels[role]}</span>;
}
