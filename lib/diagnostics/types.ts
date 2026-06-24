export type DiagnosticStatus = "pass" | "fail" | "skipped";

export type DiagnosticResult = {
  key: string;
  label: string;
  status: DiagnosticStatus;
  detail: string;
};
