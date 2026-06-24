import Link from "next/link";

export function PermissionNotice({ title = "Access restricted", description = "Your current role does not include permission to view this area." }: { title?: string; description?: string }) {
  return <section className="mx-auto max-w-xl rounded-2xl border border-amber-200 bg-amber-50 p-7 text-center"><p className="text-xs font-semibold uppercase tracking-wider text-amber-700">Permission notice</p><h1 className="mt-2 text-2xl font-semibold text-amber-950">{title}</h1><p className="mt-3 text-sm leading-6 text-amber-900">{description}</p><Link className="mt-5 inline-block rounded-lg bg-amber-900 px-4 py-2 text-sm font-medium text-white" href="/account">Review account roles</Link></section>;
}
