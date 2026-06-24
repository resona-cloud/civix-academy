export type ScenarioObjective = {
  id: string;
  lab_scenario_id: string;
  description: string;
  position: number;
};

export type ScenarioDocument = {
  id: string;
  lab_scenario_id: string;
  title: string;
  document_type: "brief" | "worksheet" | "reference" | "source_material";
  description: string;
  position: number;
};

export type ScenarioTask = {
  id: string;
  lab_scenario_id: string;
  title: string;
  instructions: string;
  required: boolean;
  position: number;
};

export type LabScenario = {
  id: string;
  slug: string;
  title: string;
  summary: string;
  briefing: string;
  difficulty: "foundational" | "intermediate" | "advanced";
  estimated_minutes: number;
  status: "published";
  evaluation_rubric_id: string;
  objectives: ScenarioObjective[];
  documents: ScenarioDocument[];
  tasks: ScenarioTask[];
  instructor_notes: string[];
};

export type LabScenarioProgress = {
  user_id: string;
  lab_scenario_id: string;
  completion_status: "not_started" | "in_progress" | "submitted" | "completed";
  completed_task_ids: string[];
  started_at: string | null;
  submitted_at: string | null;
};
