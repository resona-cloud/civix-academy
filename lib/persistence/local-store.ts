"use client";

export const LOCAL_PREFIX = "civix:persistence:";

export function readLocal<T>(key: string, fallback: T): T {
  if (typeof window === "undefined") return fallback;
  const value = window.localStorage.getItem(`${LOCAL_PREFIX}${key}`);
  if (!value) return fallback;
  try { return JSON.parse(value) as T; } catch { return fallback; }
}

export function writeLocal<T>(key: string, value: T) {
  if (typeof window === "undefined") return;
  window.localStorage.setItem(`${LOCAL_PREFIX}${key}`, JSON.stringify(value));
}

export function localId() {
  return typeof crypto !== "undefined" && "randomUUID" in crypto ? crypto.randomUUID() : `local-${Date.now()}`;
}
