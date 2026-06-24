import "server-only";

import type { NextRequest } from "next/server";
import { createServerSupabaseClient } from "@/lib/supabase/server";

export async function getPersistenceContext(request: NextRequest) {
  const authorization = request.headers.get("authorization");
  const accessToken = authorization?.startsWith("Bearer ") ? authorization.slice(7) : null;
  if (!accessToken) return null;

  const client = await createServerSupabaseClient(accessToken);
  if (!client) return null;
  const { data: { user }, error } = await client.auth.getUser(accessToken);
  if (error || !user) return null;
  return { client, user };
}
