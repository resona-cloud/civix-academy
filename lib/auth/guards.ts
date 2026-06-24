import { rolePermissions } from "./roles";
import type { AppRole, CurrentAppUser, Permission } from "./types";

export class AccessDeniedError extends Error {
  constructor(message = "Access denied") {
    super(message);
    this.name = "AccessDeniedError";
  }
}

export function hasRole(user: CurrentAppUser | null, role: AppRole) {
  return Boolean(user?.roles.includes(role));
}

export function hasAnyRole(user: CurrentAppUser | null, roles: readonly AppRole[]) {
  return Boolean(user?.roles.some((role) => roles.includes(role)));
}

export function hasPermission(user: CurrentAppUser | null, permission: Permission) {
  return Boolean(user?.roles.some((role) => rolePermissions[role].includes(permission)));
}

export function requireRole(user: CurrentAppUser | null, roles: readonly AppRole[]) {
  if (!user || !hasAnyRole(user, roles)) throw new AccessDeniedError();
  return user;
}

export function requirePermission(user: CurrentAppUser | null, permission: Permission) {
  if (!user || !hasPermission(user, permission)) throw new AccessDeniedError();
  return user;
}
