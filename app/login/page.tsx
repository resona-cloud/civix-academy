import { LoginForm } from "@/components/auth/login-form";

type Props = { searchParams: Promise<{ next?: string }> };

export const metadata = { title: "Sign in | CIVIX Academy" };

export default async function LoginPage({ searchParams }: Props) {
  const requestedPath = (await searchParams).next;
  const nextPath = requestedPath?.startsWith("/") && !requestedPath.startsWith("//") ? requestedPath : "/";
  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-950 px-4 py-12">
      <div className="w-full max-w-sm rounded-2xl border border-slate-800 bg-white p-8 shadow-xl">
        <p className="text-xs font-semibold uppercase tracking-[0.2em] text-sky-700">CIVIX</p>
        <h1 className="mt-1 text-2xl font-semibold text-slate-900">Academy</h1>
        <p className="mt-2 text-sm leading-6 text-slate-600">Sign in to continue.</p>
        <LoginForm nextPath={nextPath} />
      </div>
    </main>
  );
}
