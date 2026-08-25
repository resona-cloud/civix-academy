begin;

-- Authors the Resona Foundations course-end cumulative review, per Decision 4
-- from the Study Center handoff: a real exam-type assessments row spanning
-- all four modules, passing at 80%, plus a quick_review-type row that
-- samples from this same question pool at attempt time (no separately
-- authored quick-review questions -- see 0013_study_center_schema.sql).
-- Questions are freshly worded, not verbatim copies of any lesson-level
-- activity, and stay within the standing content gate (no internal
-- financial/competitive/funding-sequencing detail).

do $$
declare
  v_course_id uuid := 'ca8d3f95-0439-4c86-8514-09330f96f1c6'; -- resona-foundations
  v_exam_id uuid;
begin
  insert into public.assessments (course_id, assessment_type, title, passing_score, question_count, status)
  values (v_course_id, 'exam', 'Resona Foundations Cumulative Review', 80, 12, 'published')
  returning id into v_exam_id;

  insert into public.assessments (course_id, assessment_type, title, question_count, status)
  values (v_course_id, 'quick_review', 'Resona Foundations Quick Review', 5, 'published');

  insert into public.assessment_questions (assessment_id, question_type, prompt, explanation, points, position, data) values
    -- Module 1: Mission, Culture & Vision
    (v_exam_id, 'multiple_choice', 'Put Resona''s current process in the correct order.',
      'Discovery, then Architecture, then Brand & Execution, then Systemize -- the four-phase process covered in Module 1.', 1, 1,
      jsonb_build_object('options', jsonb_build_array(
          jsonb_build_object('id','a','label','Discovery -> Architecture -> Brand & Execution -> Systemize'),
          jsonb_build_object('id','b','label','Architecture -> Discovery -> Systemize -> Brand & Execution'),
          jsonb_build_object('id','c','label','Brand & Execution -> Discovery -> Architecture -> Systemize'),
          jsonb_build_object('id','d','label','Systemize -> Architecture -> Discovery -> Brand & Execution')
        ), 'correct_option_id', 'a')),
    (v_exam_id, 'true_false', 'Resona measures its own success primarily by how sophisticated its systems are, not by how well clients actually perform.',
      'False. Client Success First measures whether the client''s real outcomes improved -- not how impressive the system looks.', 1, 2,
      jsonb_build_object('correct_answer', false)),
    (v_exam_id, 'multiple_choice', 'Why does Resona keep refining its methodology instead of treating it as finished?',
      'What worked as "the system" a year ago isn''t automatically the best system today.', 1, 3,
      jsonb_build_object('options', jsonb_build_array(
          jsonb_build_object('id','a','label','Clients expect frequent updates regardless of need'),
          jsonb_build_object('id','b','label','What worked as "the system" a year ago isn''t automatically the best system today'),
          jsonb_build_object('id','c','label','Competitors require Resona to constantly rebrand'),
          jsonb_build_object('id','d','label','The original methodology was incomplete at launch')
        ), 'correct_option_id', 'b')),
    -- Module 2: Resona (company structure, service arm, product line)
    (v_exam_id, 'multiple_choice', 'How would you best describe Resona''s identity?',
      'A Product Studio that builds its own products and applies the same expertise to build for others.', 1, 4,
      jsonb_build_object('options', jsonb_build_array(
          jsonb_build_object('id','a','label','A pure software company with no service work'),
          jsonb_build_object('id','b','label','A Product Studio that builds its own products and builds for others'),
          jsonb_build_object('id','c','label','A branding agency that occasionally builds software'),
          jsonb_build_object('id','d','label','A holding company with unrelated business lines')
        ), 'correct_option_id', 'b')),
    (v_exam_id, 'multiple_select', 'Which three things does the service arm cover? Select all that apply.',
      'Product architecture, management, and solutions.', 2, 5,
      jsonb_build_object('options', jsonb_build_array(
          jsonb_build_object('id','a','label','Product architecture'),
          jsonb_build_object('id','b','label','Management'),
          jsonb_build_object('id','c','label','Solutions'),
          jsonb_build_object('id','d','label','Sales & marketing')
        ), 'correct_option_ids', jsonb_build_array('a','b','c'))),
    (v_exam_id, 'multiple_choice', 'At the landscape level, what does ARC do?',
      'Connects businesses to their visibility.', 1, 6,
      jsonb_build_object('options', jsonb_build_array(
          jsonb_build_object('id','a','label','Manages government procurement'),
          jsonb_build_object('id','b','label','Connects businesses to their visibility'),
          jsonb_build_object('id','c','label','Handles payroll and HR'),
          jsonb_build_object('id','d','label','Provides legal compliance review')
        ), 'correct_option_id', 'b')),
    (v_exam_id, 'multiple_choice', 'At the landscape level, what does Procurely do?',
      'Delivers a rapid-win procurement solution.', 1, 7,
      jsonb_build_object('options', jsonb_build_array(
          jsonb_build_object('id','a','label','Connects businesses to their visibility'),
          jsonb_build_object('id','b','label','Delivers a rapid-win procurement solution'),
          jsonb_build_object('id','c','label','Builds brand identity for startups'),
          jsonb_build_object('id','d','label','Manages internal Slack workflows')
        ), 'correct_option_id', 'b')),
    -- Module 3: Working at Resona
    (v_exam_id, 'multiple_choice', 'Where is ownership of work tracked at Resona?',
      'Monday -- where work is tracked and assigned.', 1, 8,
      jsonb_build_object('options', jsonb_build_array(
          jsonb_build_object('id','a','label','Slack threads only'),
          jsonb_build_object('id','b','label','Monday'),
          jsonb_build_object('id','c','label','Email'),
          jsonb_build_object('id','d','label','It''s informal and untracked')
        ), 'correct_option_id', 'b')),
    (v_exam_id, 'multiple_choice', 'What best describes Resona''s communication style?',
      'Direct in content, semi-casual in tone.', 1, 9,
      jsonb_build_object('options', jsonb_build_array(
          jsonb_build_object('id','a','label','Formal and hierarchical'),
          jsonb_build_object('id','b','label','Direct in content, semi-casual in tone'),
          jsonb_build_object('id','c','label','Indirect, to avoid conflict'),
          jsonb_build_object('id','d','label','Communication happens only through official channels')
        ), 'correct_option_id', 'b')),
    -- Module 4: Resona Growth
    (v_exam_id, 'multiple_choice', 'According to Resona''s current growth plan, what primarily drives growth?',
      'Continuing to develop top-tier products and letting them lead.', 1, 10,
      jsonb_build_object('options', jsonb_build_array(
          jsonb_build_object('id','a','label','A dedicated growth/marketing department separate from product'),
          jsonb_build_object('id','b','label','Continuing to develop top-tier products and letting them lead'),
          jsonb_build_object('id','c','label','Acquiring smaller competitors'),
          jsonb_build_object('id','d','label','Expanding headcount ahead of product demand')
        ), 'correct_option_id', 'b')),
    (v_exam_id, 'true_false', 'Resona''s studio arm is expected to be phased out once ARC and Procurely fully succeed.',
      'False. The studio arm continues running alongside the products indefinitely -- both are permanent.', 1, 11,
      jsonb_build_object('correct_answer', false)),
    (v_exam_id, 'multiple_choice', 'How does Resona extend its mission beyond its own paying clients?',
      'Through educational resources for all and partnerships with non-profits.', 1, 12,
      jsonb_build_object('options', jsonb_build_array(
          jsonb_build_object('id','a','label','It doesn''t -- the mission only applies to clients'),
          jsonb_build_object('id','b','label','Through educational resources for all and partnerships with non-profits'),
          jsonb_build_object('id','c','label','By lowering prices for all clients equally'),
          jsonb_build_object('id','d','label','By requiring non-profits to become paying customers')
        ), 'correct_option_id', 'b'));
end $$;

commit;
