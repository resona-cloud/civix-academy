import { notFound } from "next/navigation";
import { ScenarioWorkspace } from "@/components/agent-labs/scenario-workspace";
import { mockLabProgress, mockLabScenarios } from "@/lib/agent-labs/mock-data";
import { mockCompetencies, mockRubrics } from "@/lib/evaluation-engine/mock-data";

type Props = { params: Promise<{ scenarioId: string }> };

export default async function LabScenarioPage({ params }: Props) {
  const { scenarioId } = await params;
  const scenario = mockLabScenarios.find((item) => item.id === scenarioId);
  const progress = mockLabProgress.find((item) => item.lab_scenario_id === scenarioId);
  const rubric = scenario ? mockRubrics.find((item) => item.id === scenario.evaluation_rubric_id) : undefined;
  if (!scenario || !progress || !rubric) notFound();

  return <ScenarioWorkspace competencies={mockCompetencies} progress={progress} rubric={rubric} scenario={scenario} />;
}
