import { NextResponse, type NextRequest } from "next/server";
import { refreshSupabaseSession } from "@/lib/supabase/middleware";

const protectedPrefixes = ["/account", "/admin", "/instructor", "/reviews", "/people", "/reports", "/settings"];

export async function middleware(request: NextRequest) {
  const { response, user, mockMode } = await refreshSupabaseSession(request);
  const protectedRoute = protectedPrefixes.some((prefix) => request.nextUrl.pathname === prefix || request.nextUrl.pathname.startsWith(`${prefix}/`));
  if (!mockMode && protectedRoute && !user) {
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
