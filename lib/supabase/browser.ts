"use client";

import { createBrowserClient } from "@supabase/ssr";
import type { SupabaseClient } from "@supabase/supabase-js";
import type { Database } from "@/lib/database.types";

let browserClient: SupabaseClient<Database> | null | undefined;

export function isBrowserSupabaseConfigured() {
  return Boolean(process.env.NEXT_PUBLIC_SUPABASE_URL && process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);
}

export function createBrowserSupabaseClient(): SupabaseClient<Database> | null {
  if (browserClient !== undefined) return browserClient;

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !anonKey) {
    browserClient = null;
    return browserClient;
  }

  browserClient = createBrowserClient<Database>(url, anonKey);
  return browserClient;
}
