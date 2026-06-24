import Link from "next/link";
import { LoginForm } from "@/components/auth/login-form";

type Props = { searchParams: Promise<{ next?: string }> };

export default async function LoginPage({ searchParams }: Props) {
  const requestedPath = (await searchParams).next;
  const nextPath = requestedPath?.startsWith("/") && !requestedPath.startsWith("//") ? requestedPath : "/account";
  return <div className="mx-auto max-w-md rounded-2xl border border-slate-200 bg-white p-7 shadow-sm"><p className="text-xs font-semibold uppercase tracking-[0.18em] text-sky-700">CIVIX Academy</p><h1 className="mt-2 text-3xl font-semibold">Sign in</h1><p className="mt-2 text-sm leading-6 text-slate-600">Use Supabase credentials when configured. Without environment variables, this page remains in mock mode.</p><LoginForm nextPath={nextPath} /><Link className="mt-5 block text-center text-sm font-medium text-sky-700" href="/account">View account</Link></div>;
}
