import { AuthGate } from "@/components/auth/auth-gate";
import { RoleGate } from "@/components/auth/role-gate";
import { DiagnosticsPanel } from "@/components/admin/diagnostics-panel";
import { getCurrentProfile, getCurrentSession } from "@/lib/auth/session";
import { canConnectDatabase, canLoadBookmarks, canLoadNotes, canLoadProfile, canLoadProgress, canLoadRoles } from "@/lib/diagnostics/supabase-checks";
import { isServerSupabaseConfigured } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

export default async function AdminDiagnosticsPage() {
  const [user, session, ...checks] = await Promise.all([
    getCurrentProfile(),
    getCurrentSession(),
    canLoadProfile(),
    canLoadRoles(),
    canLoadNotes(),
    canLoadBookmarks(),
    canLoadProgress(),
    canConnectDatabase(),
  ]);
  const configured = isServerSupabaseConfigured();
  return <AuthGate user={user}><RoleGate roles={["admin"]} user={user}><DiagnosticsPanel checks={checks} configured={configured} sessionStatus={configured ? session ? "active" : "missing" : "mock mode"} userId={session?.user.id ?? user?.id ?? null} /></RoleGate></AuthGate>;
}
