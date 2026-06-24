import { mockLabProgress, mockLabScenarios } from "@/lib/agent-labs/mock-data";
import { ScenarioCard } from "./scenario-card";

export function LabCatalog() {
  return <><header className="mb-8"><p className="text-xs font-semibold uppercase tracking-[0.18em] text-amber-700">Practical assessment</p><h1 className="mt-2 text-3xl font-semibold tracking-tight">Agent Labs</h1><p className="mt-2 max-w-2xl text-slate-600">Practice procurement decisions in structured scenarios evaluated against competency-based rubrics.</p></header><div className="grid gap-5 md:grid-cols-2 xl:grid-cols-3">{mockLabScenarios.map((scenario) => <ScenarioCard key={scenario.id} progress={mockLabProgress.find((item) => item.lab_scenario_id === scenario.id)} scenario={scenario} />)}</div></>;
}
