import { mockRubrics } from "@/lib/evaluation-engine/mock-data";
import type { LabScenario, LabScenarioProgress, ScenarioDocument } from "./types";

type ScenarioSeed = {
  id: string;
  slug: string;
  title: string;
  summary: string;
  briefing: string;
  difficulty: LabScenario["difficulty"];
  estimated_minutes: number;
  objectives: string[];
  documents: { title: string; document_type: ScenarioDocument["document_type"]; description: string }[];
  tasks: { title: string; instructions: string }[];
  instructor_notes: string[];
};

function createScenario(seed: ScenarioSeed, scenarioIndex: number): LabScenario {
  const rubric = mockRubrics[scenarioIndex];
  if (!rubric) throw new Error(`Missing rubric for scenario ${seed.title}`);

  return {
    ...seed,
    status: "published",
    evaluation_rubric_id: rubric.id,
    objectives: seed.objectives.map((description, index) => ({ id: `95${scenarioIndex + 1}${index + 1}0000-0000-4000-8000-000000000001`, lab_scenario_id: seed.id, description, position: index + 1 })),
    documents: seed.documents.map((document, index) => ({ ...document, id: `96${scenarioIndex + 1}${index + 1}0000-0000-4000-8000-000000000001`, lab_scenario_id: seed.id, position: index + 1 })),
    tasks: seed.tasks.map((task, index) => ({ ...task, id: `97${scenarioIndex + 1}${index + 1}0000-0000-4000-8000-000000000001`, lab_scenario_id: seed.id, required: true, position: index + 1 })),
  };
}

const scenarioSeeds: ScenarioSeed[] = [
  {
    id: "94000000-0000-4000-8000-000000000001",
    slug: "opportunity-qualification",
    title: "Opportunity Qualification",
    summary: "Assess a federal opportunity and recommend whether the vendor should advance, monitor, or decline.",
    briefing: "A small technology integrator has identified a newly released agency forecast item. Leadership needs an evidence-based qualification recommendation before committing capture resources.",
    difficulty: "foundational",
    estimated_minutes: 45,
    objectives: ["Identify material fit and eligibility signals.", "Distinguish evidence from assumptions.", "Produce a supported qualification recommendation."],
    documents: [
      { title: "Opportunity notice", document_type: "source_material", description: "Mock agency forecast and opportunity summary." },
      { title: "Qualification worksheet", document_type: "worksheet", description: "Structured fit, timing, competition, and risk review." },
    ],
    tasks: [
      { title: "Extract qualification signals", instructions: "Identify the customer, requirement, vehicle, timing, and likely competition." },
      { title: "Assess vendor fit", instructions: "Compare opportunity needs to the vendor's capabilities, past performance, and constraints." },
      { title: "Recommend disposition", instructions: "Select advance, monitor, or decline and support the recommendation with evidence." },
    ],
    instructor_notes: ["Look for unsupported assumptions presented as facts.", "Strong responses make uncertainty explicit and recommend a next action."],
  },
  {
    id: "94000000-0000-4000-8000-000000000002",
    slug: "vendor-readiness-review",
    title: "Vendor Readiness Review",
    summary: "Evaluate whether a vendor is prepared to pursue federal opportunities and prioritize readiness gaps.",
    briefing: "A commercial services firm wants to enter the federal market within six months. Review its current posture and provide a practical readiness plan.",
    difficulty: "intermediate",
    estimated_minutes: 60,
    objectives: ["Assess foundational federal-market readiness.", "Prioritize gaps by impact and urgency.", "Translate findings into an action plan."],
    documents: [
      { title: "Vendor capability profile", document_type: "source_material", description: "Mock capabilities, registrations, certifications, and past performance." },
      { title: "Readiness scorecard", document_type: "worksheet", description: "Evaluation worksheet for compliance, positioning, and operations." },
    ],
    tasks: [
      { title: "Review current posture", instructions: "Assess registrations, capability positioning, pricing readiness, and delivery evidence." },
      { title: "Prioritize gaps", instructions: "Rank gaps by impact on near-term opportunity pursuit." },
      { title: "Create a 90-day plan", instructions: "Recommend sequenced actions, owners, and validation evidence." },
    ],
    instructor_notes: ["Do not treat every gap as equally urgent.", "Recommendations should match the vendor's target market and resources."],
  },
  {
    id: "94000000-0000-4000-8000-000000000003",
    slug: "rfp-intake-assessment",
    title: "RFP Intake Assessment",
    summary: "Triage a solicitation package and produce an actionable intake summary for the capture team.",
    briefing: "A capture manager has received a dense solicitation package with a short response window. Build the initial intake record and flag immediate decisions.",
    difficulty: "intermediate",
    estimated_minutes: 75,
    objectives: ["Locate material solicitation requirements.", "Identify deadlines, submission rules, and evaluation structure.", "Escalate critical gaps and risks."],
    documents: [
      { title: "Mock RFP package", document_type: "source_material", description: "Condensed solicitation sections and attachments." },
      { title: "RFP intake template", document_type: "worksheet", description: "Structured summary for capture handoff." },
    ],
    tasks: [
      { title: "Build the intake summary", instructions: "Capture scope, dates, vehicle, set-aside, contract type, and submission structure." },
      { title: "Map evaluation and instructions", instructions: "Connect requested proposal content to the stated evaluation factors." },
      { title: "Flag immediate actions", instructions: "Identify questions, compliance risks, and decisions requiring capture leadership." },
    ],
    instructor_notes: ["Accuracy matters more than copying every solicitation detail.", "High-quality intake work highlights decisions and owners."],
  },
  {
    id: "94000000-0000-4000-8000-000000000004",
    slug: "agency-research-exercise",
    title: "Agency Research Exercise",
    summary: "Develop a concise agency profile that supports opportunity and account planning decisions.",
    briefing: "A vendor is considering investment in a new civilian agency account. Assemble a decision-oriented agency research brief from the provided sources.",
    difficulty: "foundational",
    estimated_minutes: 50,
    objectives: ["Synthesize mission, spending, and procurement signals.", "Identify relevant stakeholders and buying patterns.", "Separate current evidence from inference."],
    documents: [
      { title: "Agency source packet", document_type: "source_material", description: "Mock budget, forecast, organization, and award data." },
      { title: "Agency brief template", document_type: "worksheet", description: "Structured account research deliverable." },
    ],
    tasks: [
      { title: "Summarize agency context", instructions: "Describe mission, priorities, organization, and relevant spending signals." },
      { title: "Identify procurement patterns", instructions: "Analyze vehicles, incumbents, buying offices, and acquisition timing." },
      { title: "Recommend next research", instructions: "List evidence gaps and the next sources or conversations required." },
    ],
    instructor_notes: ["Reward synthesis over source inventory.", "The brief should state why each finding matters to the vendor."],
  },
  {
    id: "94000000-0000-4000-8000-000000000005",
    slug: "compliance-review-exercise",
    title: "Compliance Review Exercise",
    summary: "Review a mock proposal response against solicitation instructions and identify material compliance issues.",
    briefing: "A proposal team is approaching final review. Compare the response outline and draft artifacts to the solicitation requirements before production begins.",
    difficulty: "advanced",
    estimated_minutes: 90,
    objectives: ["Build a traceable compliance review.", "Distinguish material defects from editorial issues.", "Communicate corrective actions and ownership."],
    documents: [
      { title: "Solicitation instructions", document_type: "source_material", description: "Mock response instructions, evaluation factors, and attachments." },
      { title: "Draft proposal outline", document_type: "source_material", description: "Mock volume structure and response crosswalk." },
      { title: "Compliance matrix", document_type: "worksheet", description: "Traceability and corrective-action worksheet." },
    ],
    tasks: [
      { title: "Trace requirements", instructions: "Map each submission and content requirement to the draft response location." },
      { title: "Classify findings", instructions: "Identify omissions, conflicts, page-limit risks, and unsupported representations." },
      { title: "Issue corrective actions", instructions: "Assign priority, owner, evidence, and due date for each material finding." },
    ],
    instructor_notes: ["Material compliance defects should be distinguished from style preferences.", "Review whether each corrective action is specific and verifiable."],
  },
];

export const mockLabScenarios: LabScenario[] = scenarioSeeds.map(createScenario);

export const mockLabProgress: LabScenarioProgress[] = mockLabScenarios.map((scenario, index) => ({
  user_id: "73000000-0000-4000-8000-000000000001",
  lab_scenario_id: scenario.id,
  completion_status: index === 0 ? "in_progress" : index === 1 ? "submitted" : "not_started",
  completed_task_ids: index === 0 ? [scenario.tasks[0]?.id].filter((id): id is string => Boolean(id)) : index === 1 ? scenario.tasks.map((task) => task.id) : [],
  started_at: index < 2 ? "2026-06-20T14:00:00Z" : null,
  submitted_at: index === 1 ? "2026-06-21T16:30:00Z" : null,
}));
