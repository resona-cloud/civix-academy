import { NextResponse, type NextRequest } from "next/server";
import { refreshSupabaseSession } from "@/lib/supabase/middleware";

// Everything requires login by default. Only these stay public -- API routes
// handle their own bearer-token auth (see lib/persistence/server-auth.ts) and
// must return their own 401 JSON rather than being redirected to /login.
const publicPrefixes = ["/login", "/logout"];

export async function middleware(request: NextRequest) {
  const { response, user, mockMode } = await refreshSupabaseSession(request);
  const isApiRoute = request.nextUrl.pathname.startsWith("/api/");
  const isPublicRoute = isApiRoute || publicPrefixes.some((prefix) => request.nextUrl.pathname === prefix || request.nextUrl.pathname.startsWith(`${prefix}/`));
  if (!mockMode && !isPublicRoute && !user) {
    const loginUrl = request.nextUrl.clone();
    loginUrl.pathname = "/login";
    loginUrl.searchParams.set("next", `${request.nextUrl.pathname}${request.nextUrl.search}`);
    return NextResponse.redirect(loginUrl);
  }
  return response;
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)"],
};
