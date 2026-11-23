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
  // Mock mode (no Supabase env vars) is a local-dev convenience only. In any
  // other environment a missing config fails closed: nothing is served without a session.
  const allowMock = mockMode && process.env.NODE_ENV === "development";
  const isLoginRoute = request.nextUrl.pathname === "/login";
  if (user && isLoginRoute) {
    const requested = request.nextUrl.searchParams.get("next");
    const target = request.nextUrl.clone();
    target.pathname = requested?.startsWith("/") && !requested.startsWith("//") ? requested.split("?")[0] : "/";
    target.search = "";
    return NextResponse.redirect(target);
  }
  if (!allowMock && !isPublicRoute && !user) {
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
