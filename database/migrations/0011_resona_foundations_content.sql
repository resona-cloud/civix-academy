begin;

-- Seeds the real Resona Foundations course. Mastery checks with two
-- questions in the source content are modeled as two sequential single-
-- question `activity` content_blocks (rather than extending ActivityBlock to
-- hold an array of questions) -- this fits the existing schema/type/renderer
-- exactly as-is and, since gating requires every gating block on a page to
-- be passed, delivers the same "both questions required" behavior with zero
-- type or component changes.
--
-- The course-end cumulative review is intentionally NOT seeded here -- the
-- handoff doc explicitly defers its exact question set to a follow-up
-- content pass. has_completed_course() checks "every lesson in the course
-- has status='completed'", so adding that lesson later needs no gating-logic
-- changes, just an additional lesson row.
--
-- Mermaid diagrams are hand-authored as static SVG (per Decision 3) and
-- inlined as base64 data URIs via Postgres's built-in encode()/convert_to(),
-- avoiding a mermaid-rendering dependency for seven simple flowcharts.

do $$
declare
  v_course_id uuid;
  v_m1 uuid;
  v_m2 uuid;
  v_m3 uuid;
  v_m4 uuid;
  v_l uuid;
  v_p uuid;
begin
  ------------------------------------------------------------------
  -- Course
  ------------------------------------------------------------------
  insert into public.courses (slug, title, description, certification_id, status, position, estimated_minutes)
  values (
    'resona-foundations',
    'Resona Foundations',
    'An introduction to Resona IO -- A Product Studio building strategic software for operational clarity, and the mission, culture, and structure behind it.',
    null,
    'published',
    1,
    90
  )
  returning id into v_course_id;

  ------------------------------------------------------------------
  -- MODULE 1: Mission, Culture & Vision
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Mission, Culture & Vision', '', 1)
  returning id into v_m1;

  -- Lesson 1.1 -- The Resona Story
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m1, 'The Resona Story', '', 1, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The Problem', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Resona started as an analytics firm in 2024, providing enterprise-level clarity to small businesses across the country.',
      'Most small and mid-size businesses aren''t short on data. They''re short on a system that turns that data into a decision.',
      'The scale of the gap:',
      '34 million+ SMBs in the US',
      'Roughly 70% operate without an in-house data team',
      '$1.2 trillion lost industry-wide, every year, to decisions made on incomplete, inaccurate, or disconnected data',
      'They''re not ignoring their numbers. They don''t have the infrastructure enterprise companies have had for decades -- the analysts, the tooling, the operating discipline to turn raw numbers into a next move.'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Key distinction', 'tone', 'info', 'body', 'Not a data problem. A clarity problem -- and clarity has to be built deliberately.'));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The Evolution', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'As client needs evolved, providing clarity and insight wasn''t enough. Businesses needed help fixing what the insight uncovered. Resona evolved from an analytics firm into a strategic software company, servicing businesses through strategy, architecture, and digital solutions.',
      'The order:',
      'Strategy first -- where the business actually is, not where it assumes it is',
      'Architecture second -- the system before the build',
      'Execution third -- ship it, install the capacity to run it',
      'That progression produced Resona''s own flagship methodology, ARC (Adapt -> React -> Control) -- proof of the process on the company that built it, before it was offered to anyone else.'
    ])),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'Strategy, then Architecture, then Execution',
      'src', 'data:image/svg+xml;base64,' || encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 620 140" font-family="sans-serif"><defs><marker id="a1" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="10" y="35" width="170" height="70" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="95" y="65" text-anchor="middle" font-size="15" font-weight="600" fill="#0c4a6e">Strategy</text><text x="95" y="85" text-anchor="middle" font-size="11" fill="#0c4a6e">Where is the business, really?</text><line x1="185" y1="70" x2="225" y2="70" stroke="#334155" stroke-width="2" marker-end="url(#a1)"/><rect x="230" y="35" width="170" height="70" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="315" y="65" text-anchor="middle" font-size="15" font-weight="600" fill="#0c4a6e">Architecture</text><text x="315" y="85" text-anchor="middle" font-size="11" fill="#0c4a6e">Design the system first</text><line x1="405" y1="70" x2="445" y2="70" stroke="#334155" stroke-width="2" marker-end="url(#a1)"/><rect x="450" y="35" width="165" height="70" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="532" y="65" text-anchor="middle" font-size="15" font-weight="600" fill="#0c4a6e">Execution</text><text x="532" y="85" text-anchor="middle" font-size="11" fill="#0c4a6e">Ship it, hand over control</text></svg>$svg$, 'UTF8'), 'base64')
    )),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l11-p2-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Put Resona''s process in the correct order.',
      'explanation', 'Strategy first, then Architecture, then Execution.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Architecture -> Strategy -> Execution'),
        jsonb_build_object('id', 'b', 'label', 'Strategy -> Architecture -> Execution'),
        jsonb_build_object('id', 'c', 'label', 'Execution -> Strategy -> Architecture'),
        jsonb_build_object('id', 'd', 'label', 'Strategy -> Execution -> Architecture')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Resona builds strategic software that gives businesses the operational clarity to compete, grow, and make decisions with confidence.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l11-p3-mastery-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What was Resona originally founded to do in 2024?',
      'explanation', 'Resona started as an analytics firm providing enterprise-level clarity to small businesses.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Build mobile apps for small businesses'),
        jsonb_build_object('id', 'b', 'label', 'Provide enterprise-level data clarity to small businesses'),
        jsonb_build_object('id', 'c', 'label', 'Manage government contracts for SMBs'),
        jsonb_build_object('id', 'd', 'label', 'Offer legal consulting for startups')
      ),
      'correct_option_id', 'b'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l11-p3-mastery-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Why did Resona evolve beyond just providing insight?',
      'explanation', 'Insight alone wasn''t enough -- clients also needed help executing solutions.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Clients wanted a cheaper product'),
        jsonb_build_object('id', 'b', 'label', 'Insight alone wasn''t enough -- clients also needed help executing solutions'),
        jsonb_build_object('id', 'c', 'label', 'The analytics market became too competitive'),
        jsonb_build_object('id', 'd', 'label', 'Resona wanted to focus only on software, not strategy')
      ),
      'correct_option_id', 'b'
    )));

  -- Lesson 1.2 -- What We Value (Part 1: How We Decide)
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m1, 'What We Value (Part 1: How We Decide)', '', 2, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Data-Driven Excellence', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'This isn''t about being a data company. It''s about building the system that turns a number into a decision. Data on its own is a fact -- it becomes valuable the moment it''s connected to a decision, inside the right operational context. A recommendation without that system underneath it is a guess with a citation.',
      'The standard:',
      'Not: "Did we look at the numbers?"',
      'But: "Did we build the framework that makes the numbers mean something?"',
      'Strategy comes first -- reading the operational reality honestly. Data confirms the strategy is right. It doesn''t replace having one.'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Example', 'tone', 'info', 'body', 'A dashboard full of accurate numbers isn''t Data-Driven Excellence. A framework that tells a business owner what to do next, and why -- that is.'));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Simplicity in Complexity', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'We take complex operational systems and make them clear, actionable, and accessible -- to everyone the system serves, not just the people who built it.',
      'A system that''s technically sound but too complicated to act on isn''t done yet',
      'The job is finished when it''s usable, not when it''s correct',
      'Correct-but-unusable is a failure state, not a partial success',
      'Together, these two values describe one posture from two angles: build the right system, then make sure a person -- not just a spreadsheet -- can run it.'
    ])),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'Data-Driven Excellence leads to Simplicity in Complexity',
      'src', 'data:image/svg+xml;base64,' || encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 560 140" font-family="sans-serif"><defs><marker id="a2" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="10" y="30" width="240" height="80" rx="10" fill="#ede9fe" stroke="#6d28d9"/><text x="130" y="65" text-anchor="middle" font-size="14" font-weight="600" fill="#4c1d95">Data-Driven Excellence</text><text x="130" y="88" text-anchor="middle" font-size="11" fill="#4c1d95">Is the foundation right?</text><line x1="255" y1="70" x2="300" y2="70" stroke="#334155" stroke-width="2" marker-end="url(#a2)"/><rect x="305" y="30" width="245" height="80" rx="10" fill="#ede9fe" stroke="#6d28d9"/><text x="427" y="65" text-anchor="middle" font-size="14" font-weight="600" fill="#4c1d95">Simplicity in Complexity</text><text x="427" y="88" text-anchor="middle" font-size="11" fill="#4c1d95">Can a person actually use it?</text></svg>$svg$, 'UTF8'), 'base64')
    )),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l12-p2-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What best describes "Data-Driven Excellence" at Resona?',
      'explanation', 'It''s building the system that turns data into a decision, not just gathering numbers.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Prioritizing data collection above all else'),
        jsonb_build_object('id', 'b', 'label', 'Building the system that turns data into a decision, not just gathering numbers'),
        jsonb_build_object('id', 'c', 'label', 'Avoiding decisions until enough data exists'),
        jsonb_build_object('id', 'd', 'label', 'Replacing human judgment with automated analysis')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'The goal was never more data. It''s a system good enough that data becomes a decision -- and simple enough that a person can act on it.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l12-p3-mastery-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Client scenario -- an assisted living facility expanding to a new state. Before making that call, what should happen first?',
      'explanation', 'Gather the data and complete due diligence before deciding.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Move forward -- the client''s confidence in the opportunity is enough'),
        jsonb_build_object('id', 'b', 'label', 'Gather the data and complete due diligence before deciding'),
        jsonb_build_object('id', 'c', 'label', 'Wait until a competitor expands first, then follow'),
        jsonb_build_object('id', 'd', 'label', 'Base the decision on the facility''s current-state performance alone')
      ),
      'correct_option_id', 'b'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l12-p3-mastery-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Why does due diligence matter more in a case like a healthcare expansion than in a lower-stakes decision?',
      'explanation', 'Higher-stakes decisions carry more downside if the data and context are wrong.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'It doesn''t -- due diligence matters equally everywhere'),
        jsonb_build_object('id', 'b', 'label', 'Higher-stakes decisions carry more downside if the data and context are wrong'),
        jsonb_build_object('id', 'c', 'label', 'Regulations require it, but it wouldn''t otherwise be recommended'),
        jsonb_build_object('id', 'd', 'label', 'It''s only necessary when a client asks for it directly')
      ),
      'correct_option_id', 'b'
    )));

  -- Lesson 1.3 -- What We Value (Part 2: How We Treat People)
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m1, 'What We Value (Part 2: How We Treat People)', '', 3, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Client Success First', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Our success is measured by how well our clients perform. Not by how polished the deliverable looks, not by how sophisticated the system is under the hood -- by whether the client is better off.',
      'A recommendation is judged by its outcome, not its cleverness',
      '"Technically delivered" and "actually successful" are not the same thing',
      'An impressive system that doesn''t move the client''s real numbers hasn''t succeeded'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Example', 'tone', 'info', 'body', 'A beautifully architected system a client never fully adopts is not a win. A simple system a client actually runs and grows with is.'));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Integrity and Transparency', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Honest, ethical, and transparent in everything we build and every relationship we carry. Given what Resona has access to, this is an operating rule.',
      'Full transparency about what''s accessed, why, where it goes, and when it''s removed',
      'Explicit consent before any system or data source is touched',
      'A client''s data is theirs; Resona processes it on their behalf, and it leaves with them at the end of an engagement',
      'Every action leaves an audit trail',
      'Client Success First and Integrity and Transparency reinforce each other: a client can only trust that Resona is working in their interest if the relationship is transparent enough to verify it.'
    ])),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'Integrity and Transparency leads to Client Success First',
      'src', 'data:image/svg+xml;base64,' || encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 560 140" font-family="sans-serif"><defs><marker id="a3" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="10" y="30" width="255" height="80" rx="10" fill="#ecfdf5" stroke="#047857"/><text x="137" y="65" text-anchor="middle" font-size="14" font-weight="600" fill="#065f46">Integrity and Transparency</text><text x="137" y="88" text-anchor="middle" font-size="11" fill="#065f46">Can they trust how we operate?</text><line x1="270" y1="70" x2="310" y2="70" stroke="#334155" stroke-width="2" marker-end="url(#a3)"/><rect x="315" y="30" width="235" height="80" rx="10" fill="#ecfdf5" stroke="#047857"/><text x="432" y="65" text-anchor="middle" font-size="14" font-weight="600" fill="#065f46">Client Success First</text><text x="432" y="88" text-anchor="middle" font-size="11" fill="#065f46">Are they actually better off?</text></svg>$svg$, 'UTF8'), 'base64')
    )),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l13-p2-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What does "Client Success First" actually measure?',
      'explanation', 'Whether the client''s real outcomes improved.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'How polished the final deliverable looks'),
        jsonb_build_object('id', 'b', 'label', 'Whether the client''s real outcomes improved'),
        jsonb_build_object('id', 'c', 'label', 'How advanced the technical system is'),
        jsonb_build_object('id', 'd', 'label', 'How quickly the engagement was completed')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Trust the outcome by trusting the process behind it.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l13-p3-mastery-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Continuing the assisted living facility scenario -- due diligence shows the client''s originally preferred state isn''t the strongest option. What''s the right move?',
      'explanation', 'Present the honest findings, even if it''s not what the client hoped to hear.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Proceed with the client''s original choice to avoid conflict'),
        jsonb_build_object('id', 'b', 'label', 'Present the honest findings, even if it''s not what the client hoped to hear'),
        jsonb_build_object('id', 'c', 'label', 'Soften the findings so the client feels supported either way'),
        jsonb_build_object('id', 'd', 'label', 'Let the client decide without sharing the due diligence results')
      ),
      'correct_option_id', 'b'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l13-p3-mastery-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Why does Resona maintain an audit trail for every data migration session?',
      'explanation', 'It keeps the relationship transparent and verifiable.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'It''s a legal requirement with no other purpose'),
        jsonb_build_object('id', 'b', 'label', 'It keeps the relationship transparent and verifiable'),
        jsonb_build_object('id', 'c', 'label', 'It helps Resona bill clients more accurately'),
        jsonb_build_object('id', 'd', 'label', 'It''s only used internally and never shared with clients')
      ),
      'correct_option_id', 'b'
    )));

  -- Lesson 1.4 -- Where We're Headed
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m1, 'Where We''re Headed', '', 4, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Innovation and Growth', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'At Resona, we embrace change and look for smarter, faster, more effective solutions -- not just for clients, but in how Resona operates.',
      'This value exists because the gap covered earlier doesn''t close by itself, and it doesn''t stay closed once it''s closed:',
      'The methodology gets refined as more businesses run it',
      'The tooling improves as real engagements surface what works',
      'The standard for "good enough" keeps moving, on purpose',
      'Innovation and Growth is what keeps Resona from becoming the next version of the enterprise tools it was built to replace.'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Key distinction', 'tone', 'info', 'body', 'Innovation and Growth isn''t chasing new technology. It''s refusing to let the system calcify.')),
    (v_p, 'callout', 3, jsonb_build_object('title', 'What this looks like in a person', 'tone', 'info', 'body', 'The desire to create something new and genuinely impactful -- backed by real action, not just ideas talked about. That combination is what Resona looks for and develops in its people.'));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'How Resona Empowers Businesses', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Resona''s impact shows up in outcomes:',
      'Roughly 68% of businesses that implement a structured data strategy report measurable revenue improvement within the first year',
      'A structured operating cycle produces decisions roughly three times faster, with higher confidence',
      'Improvements built on a real Control layer stick -- without one, businesses tend to revert to old patterns within 90 days',
      'Resona doesn''t stop at handing over a system. Every engagement installs the methodology, tooling, and operating capacity directly into the business -- so the client keeps running and improving it after Resona steps back.',
      'Same pattern, different industries: a consumer platform needing architecture and brand before it could function, a medtech hardware company with a strong product and no system around it, a twelve-year retail business with no infrastructure for the shift online. Strategy first, architecture second, execution third -- every time.'
    ])),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'Priced out of intelligence, through Resona installing the system, to running independently, to compounding impact',
      'src', 'data:image/svg+xml;base64,' || encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 140" font-family="sans-serif"><defs><marker id="a4" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="5" y="35" width="205" height="70" rx="10" fill="#fff7ed" stroke="#c2410c"/><text x="107" y="76" text-anchor="middle" font-size="12.5" font-weight="600" fill="#7c2d12">Priced Out of Intelligence</text><line x1="215" y1="70" x2="240" y2="70" stroke="#334155" stroke-width="2" marker-end="url(#a4)"/><rect x="245" y="35" width="205" height="70" rx="10" fill="#fff7ed" stroke="#c2410c"/><text x="347" y="76" text-anchor="middle" font-size="12.5" font-weight="600" fill="#7c2d12">Resona Installs the System</text><line x1="455" y1="70" x2="480" y2="70" stroke="#334155" stroke-width="2" marker-end="url(#a4)"/><rect x="485" y="35" width="205" height="70" rx="10" fill="#fff7ed" stroke="#c2410c"/><text x="587" y="76" text-anchor="middle" font-size="12.5" font-weight="600" fill="#7c2d12">Business Runs It Independently</text><line x1="695" y1="70" x2="720" y2="70" stroke="#334155" stroke-width="2" marker-end="url(#a4)"/><rect x="725" y="35" width="170" height="70" rx="10" fill="#fff7ed" stroke="#c2410c"/><text x="810" y="76" text-anchor="middle" font-size="12.5" font-weight="600" fill="#7c2d12">Impact Compounds</text></svg>$svg$, 'UTF8'), 'base64')
    )),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l14-p2-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Why does Resona keep refining its methodology instead of treating it as finished?',
      'explanation', 'What worked as "the system" a year ago isn''t automatically the best system today.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Clients expect frequent updates regardless of need'),
        jsonb_build_object('id', 'b', 'label', 'What worked as "the system" a year ago isn''t automatically the best system today'),
        jsonb_build_object('id', 'c', 'label', 'Competitors require Resona to constantly rebrand'),
        jsonb_build_object('id', 'd', 'label', 'The original methodology was incomplete at launch')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Resona''s impact is measured in businesses that gained clarity and capability once reserved for companies with full analytics teams -- through a system that keeps improving instead of standing still.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l14-p3-mastery-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Why does Resona install the operating capacity into a business instead of just delivering a report?',
      'explanation', 'So the client can keep running and improving the system after Resona steps back.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'It''s required by the service agreement'),
        jsonb_build_object('id', 'b', 'label', 'So the client can keep running and improving the system after Resona steps back'),
        jsonb_build_object('id', 'c', 'label', 'It reduces Resona''s ongoing workload'),
        jsonb_build_object('id', 'd', 'label', 'Reports aren''t something clients want')
      ),
      'correct_option_id', 'b'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l14-p3-mastery-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What happens to improvements that aren''t built on a real Control layer?',
      'explanation', 'They tend to revert to old patterns within about 90 days.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'They typically last indefinitely'),
        jsonb_build_object('id', 'b', 'label', 'They tend to revert to old patterns within about 90 days'),
        jsonb_build_object('id', 'c', 'label', 'They only fail if the client stops paying'),
        jsonb_build_object('id', 'd', 'label', 'They become permanent immediately')
      ),
      'correct_option_id', 'b'
    )));

  -- MODULE 1 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m1, 'Module 1 Check', '', 5, 3, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 1 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Module 1 Check', 'tone', 'info', 'body', 'Answer both questions correctly to unlock Module 2.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'm1-check-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What are the three things Resona builds, in order, when working with a client?',
      'explanation', 'Strategy, then Architecture, then Execution.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Strategy -> Architecture -> Execution'),
        jsonb_build_object('id', 'b', 'label', 'Architecture -> Execution -> Strategy'),
        jsonb_build_object('id', 'c', 'label', 'Execution -> Architecture -> Strategy'),
        jsonb_build_object('id', 'd', 'label', 'Architecture -> Strategy -> Execution')
      ),
      'correct_option_id', 'a'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'm1-check-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Which value is being applied when Resona presents honest findings to a client, even if it''s not what they hoped to hear?',
      'explanation', 'Client Success First and Integrity and Transparency both apply here.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Innovation and Growth'),
        jsonb_build_object('id', 'b', 'label', 'Client Success First / Integrity and Transparency'),
        jsonb_build_object('id', 'c', 'label', 'Data-Driven Excellence'),
        jsonb_build_object('id', 'd', 'label', 'Simplicity in Complexity')
      ),
      'correct_option_id', 'b'
    )));

  ------------------------------------------------------------------
  -- MODULE 2: Resona IO
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Resona IO', '', 2)
  returning id into v_m2;

  -- Lesson 2.1 -- Company Structure
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m2, 'Company Structure', '', 1, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Company Structure', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Resona operates with a small, founder-led core team.',
      'Structure is fluid -- roles and responsibilities shift as the company grows',
      'A small team means most people carry more than one function',
      'There is no large formal hierarchy at this stage'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Key distinction', 'tone', 'info', 'body', 'Fluid structure still means structure -- decisions and ownership are clear even without a formal org chart.'));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Resona, ARC, and Procurely', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Resona operates as a Product Studio -- it builds its own products and, through that same expertise, builds for others. ARC and Procurely are the clearest proof of that: both are Resona''s own products, built using the same strategy-first discipline the studio applies to every engagement.',
      'Each product has its own team structure, covered in that product''s own course',
      'Resona builds the architecture and operating discipline; ARC and Procurely are two expressions of that discipline, shipped as standalone products'
    ])),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'Resona IO as a Product Studio, branching into ARC and Procurely',
      'src', 'data:image/svg+xml;base64,' || encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 460 190" font-family="sans-serif"><defs><marker id="a5" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="130" y="10" width="200" height="60" rx="10" fill="#eff6ff" stroke="#1d4ed8"/><text x="230" y="35" text-anchor="middle" font-size="14" font-weight="600" fill="#1e3a8a">Resona IO</text><text x="230" y="55" text-anchor="middle" font-size="11" fill="#1e3a8a">Product Studio</text><line x1="200" y1="70" x2="115" y2="115" stroke="#334155" stroke-width="2" marker-end="url(#a5)"/><line x1="260" y1="70" x2="345" y2="115" stroke="#334155" stroke-width="2" marker-end="url(#a5)"/><rect x="10" y="120" width="200" height="60" rx="10" fill="#eff6ff" stroke="#1d4ed8"/><text x="110" y="145" text-anchor="middle" font-size="14" font-weight="600" fill="#1e3a8a">ARC</text><text x="110" y="163" text-anchor="middle" font-size="11" fill="#1e3a8a">own team structure</text><rect x="250" y="120" width="200" height="60" rx="10" fill="#eff6ff" stroke="#1d4ed8"/><text x="350" y="145" text-anchor="middle" font-size="14" font-weight="600" fill="#1e3a8a">Procurely</text><text x="350" y="163" text-anchor="middle" font-size="11" fill="#1e3a8a">own team structure</text></svg>$svg$, 'UTF8'), 'base64')
    )),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l21-p2-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What does "Resona IO -- A Product Studio" mean in practice?',
      'explanation', 'Resona builds its own products and applies the same expertise to build for others.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Resona only builds products for outside clients, never its own'),
        jsonb_build_object('id', 'b', 'label', 'Resona builds its own products and applies the same expertise to build for others'),
        jsonb_build_object('id', 'c', 'label', '"Studio" means Resona only does branding work, not software'),
        jsonb_build_object('id', 'd', 'label', 'Resona has stopped building its own products in favor of client work')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Resona IO is a Product Studio. ARC and Procurely are its own products, and proof of the same discipline the studio applies to every engagement.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l21-p3-mastery-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'How would you best describe Resona''s identity?',
      'explanation', 'A Product Studio that builds its own products and builds for others.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'A pure software company with no service work'),
        jsonb_build_object('id', 'b', 'label', 'A Product Studio that builds its own products and builds for others'),
        jsonb_build_object('id', 'c', 'label', 'A branding agency that occasionally builds software'),
        jsonb_build_object('id', 'd', 'label', 'A holding company with unrelated business lines')
      ),
      'correct_option_id', 'b'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l21-p3-mastery-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Where would you go to learn about ARC''s or Procurely''s specific team structure?',
      'explanation', 'Each product''s own course.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'This lesson covers it in full'),
        jsonb_build_object('id', 'b', 'label', 'Each product''s own course'),
        jsonb_build_object('id', 'c', 'label', 'Team structure isn''t documented anywhere'),
        jsonb_build_object('id', 'd', 'label', 'It''s identical across both products')
      ),
      'correct_option_id', 'b'
    )));

  -- Lesson 2.2 -- The Service Arm
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m2, 'The Service Arm', '', 2, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What the Service Arm Covers', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Resona IO identifies as a Product Studio -- externally, this is the name people will recognize. Internally, the actual function behind that identity is the service arm, which covers three things:',
      'Product architecture -- designing the system before anything gets built',
      'Management -- running the engagement and the build, start to finish',
      'Solutions -- the delivered result, installed so the business runs it independently',
      'Product Studio and service arm describe the same thing from two angles -- one is the name, the other is the function.'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Key distinction', 'tone', 'info', 'body', '"A Product Studio" is what you call it. "Service arm" is what it actually does. Use both -- they''re not in conflict.'));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Resona Brands', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'The service arm operates under Resona Brands -- the part of the company focused on developing brand products and the strategy around them.',
      'Resona Brands is where product architecture and brand identity get built together, not handed off in sequence',
      'A Resona-built product ships with both a working system and a coherent market position from day one',
      'Future product lines run through the same service arm and the same Resona Brands discipline'
    ])),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'Resona Brands, through the Service Arm, to ARC, Procurely, and future products',
      'src', 'data:image/svg+xml;base64,' || encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 210" font-family="sans-serif"><defs><marker id="a6" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="90" y="10" width="220" height="55" rx="10" fill="#fef3c7" stroke="#b45309"/><text x="200" y="43" text-anchor="middle" font-size="14" font-weight="600" fill="#78350f">Resona Brands</text><line x1="200" y1="65" x2="200" y2="90" stroke="#334155" stroke-width="2" marker-end="url(#a6)"/><rect x="60" y="95" width="280" height="55" rx="10" fill="#fef3c7" stroke="#b45309"/><text x="200" y="120" text-anchor="middle" font-size="13" font-weight="600" fill="#78350f">Service Arm</text><text x="200" y="138" text-anchor="middle" font-size="10.5" fill="#78350f">Architecture . Management . Solutions</text><line x1="200" y1="150" x2="200" y2="175" stroke="#334155" stroke-width="2" marker-end="url(#a6)"/><rect x="45" y="180" width="310" height="25" rx="8" fill="#fef3c7" stroke="#b45309"/><text x="200" y="197" text-anchor="middle" font-size="11.5" fill="#78350f">ARC &amp; Procurely, and future products</text></svg>$svg$, 'UTF8'), 'base64')
    )),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l22-p2-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What''s the relationship between "Product Studio" and "service arm"?',
      'explanation', 'Same function -- Product Studio is the external name, service arm is the internal working term.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'They''re competing, contradictory descriptions'),
        jsonb_build_object('id', 'b', 'label', 'Same function -- Product Studio is the external name, service arm is the internal working term'),
        jsonb_build_object('id', 'c', 'label', 'Product Studio replaced the service arm entirely'),
        jsonb_build_object('id', 'd', 'label', 'The service arm only applies to external clients, not ARC or Procurely')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Resona IO -- Product Studio. The service arm -- architecture, management, and solutions -- is the function behind that identity, operating under Resona Brands.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l22-p3-mastery-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Which three things does the service arm cover?',
      'explanation', 'Product architecture, management, and solutions.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Sales, marketing, and legal'),
        jsonb_build_object('id', 'b', 'label', 'Product architecture, management, and solutions'),
        jsonb_build_object('id', 'c', 'label', 'Hardware, software, and hosting'),
        jsonb_build_object('id', 'd', 'label', 'HR, finance, and operations')
      ),
      'correct_option_id', 'b'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l22-p3-mastery-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What''s the relationship between the service arm and Resona Brands?',
      'explanation', 'The service arm operates under Resona Brands.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'They''re unrelated departments'),
        jsonb_build_object('id', 'b', 'label', 'The service arm operates under Resona Brands'),
        jsonb_build_object('id', 'c', 'label', 'Resona Brands is a client of the service arm'),
        jsonb_build_object('id', 'd', 'label', 'Resona Brands replaced the service arm')
      ),
      'correct_option_id', 'b'
    )));

  -- Lesson 2.3 -- Product Line & Service Structure
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m2, 'Product Line & Service Structure', '', 3, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Two Products, Two Markets', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Resona''s two products solve different problems for different markets:',
      'ARC -- connecting businesses to their visibility',
      'Procurely -- a rapid-win procurement solution',
      'Different markets, vastly different products, both built through the same service arm and the same strategy-first discipline.'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Key distinction', 'tone', 'info', 'body', 'Same builder, same architecture discipline, different markets. Don''t assume feature overlap between ARC and Procurely.'));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'How They Relate', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Both products share one underlying belief: businesses lose ground without the right system, and the right system has to be built deliberately.',
      'ARC applies that belief to operational visibility and decision-making',
      'Procurely applies it to winning government procurement opportunities faster',
      'Each product''s own course covers its mechanics, features, and workflows -- this lesson only covers where each sits in the landscape'
    ])),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'Resona Service Arm branching into ARC and Procurely',
      'src', 'data:image/svg+xml;base64,' || encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 620 140" font-family="sans-serif"><defs><marker id="a7" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="10" y="35" width="190" height="70" rx="10" fill="#f1f5f9" stroke="#334155"/><text x="105" y="76" text-anchor="middle" font-size="14" font-weight="600" fill="#1e293b">Resona Service Arm</text><line x1="205" y1="55" x2="245" y2="35" stroke="#334155" stroke-width="2" marker-end="url(#a7)"/><line x1="205" y1="85" x2="245" y2="105" stroke="#334155" stroke-width="2" marker-end="url(#a7)"/><rect x="250" y="5" width="180" height="60" rx="10" fill="#f1f5f9" stroke="#334155"/><text x="340" y="30" text-anchor="middle" font-size="14" font-weight="600" fill="#1e293b">ARC</text><text x="340" y="48" text-anchor="middle" font-size="10.5" fill="#1e293b">Business visibility</text><rect x="250" y="75" width="180" height="60" rx="10" fill="#f1f5f9" stroke="#334155"/><text x="340" y="100" text-anchor="middle" font-size="14" font-weight="600" fill="#1e293b">Procurely</text><text x="340" y="118" text-anchor="middle" font-size="10.5" fill="#1e293b">Procurement wins</text></svg>$svg$, 'UTF8'), 'base64')
    )),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l23-p2-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'How should ARC and Procurely be understood in relation to each other?',
      'explanation', 'Different markets, vastly different products, built on the same discipline.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Two competing versions of the same product'),
        jsonb_build_object('id', 'b', 'label', 'Different markets, vastly different products, built on the same discipline'),
        jsonb_build_object('id', 'c', 'label', 'ARC is a feature inside Procurely'),
        jsonb_build_object('id', 'd', 'label', 'Procurely is being phased out in favor of ARC')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'ARC connects businesses to their visibility. Procurely delivers rapid-win procurement solutions. Different markets, same Resona discipline underneath.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l23-p3-mastery-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What does ARC do, at the landscape level?',
      'explanation', 'Connects businesses to their visibility.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Manages government procurement'),
        jsonb_build_object('id', 'b', 'label', 'Connects businesses to their visibility'),
        jsonb_build_object('id', 'c', 'label', 'Handles payroll and HR'),
        jsonb_build_object('id', 'd', 'label', 'Provides legal compliance review')
      ),
      'correct_option_id', 'b'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l23-p3-mastery-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What does Procurely do, at the landscape level?',
      'explanation', 'Delivers a rapid-win procurement solution.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Connects businesses to their visibility'),
        jsonb_build_object('id', 'b', 'label', 'Delivers a rapid-win procurement solution'),
        jsonb_build_object('id', 'c', 'label', 'Builds brand identity for startups'),
        jsonb_build_object('id', 'd', 'label', 'Manages internal Slack workflows')
      ),
      'correct_option_id', 'b'
    )));

  -- MODULE 2 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m2, 'Module 2 Check', '', 4, 3, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 2 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Module 2 Check', 'tone', 'info', 'body', 'Answer both questions correctly to unlock Module 3.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'm2-check-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What does Resona itself focus on, separate from ARC and Procurely?',
      'explanation', 'The service arm / solution architecture.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Direct-to-consumer retail'),
        jsonb_build_object('id', 'b', 'label', 'The service arm / solution architecture'),
        jsonb_build_object('id', 'c', 'label', 'Venture capital investing'),
        jsonb_build_object('id', 'd', 'label', 'Hardware manufacturing')
      ),
      'correct_option_id', 'b'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'm2-check-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What best describes Resona''s identity?',
      'explanation', 'A Product Studio that builds its own products and builds for others.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'A branding agency'),
        jsonb_build_object('id', 'b', 'label', 'A Product Studio that builds its own products and builds for others'),
        jsonb_build_object('id', 'c', 'label', 'A holding company'),
        jsonb_build_object('id', 'd', 'label', 'A pure consulting firm')
      ),
      'correct_option_id', 'b'
    )));

  ------------------------------------------------------------------
  -- MODULE 3: Working at Resona
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Working at Resona', '', 3)
  returning id into v_m3;

  -- Lesson 3.1 -- Ownership & Autonomy
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m3, 'Ownership & Autonomy', '', 1, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What Ownership Looks Like', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Given Resona''s fluid, founder-led structure, ownership isn''t assigned by title -- it''s the working assumption. If something is yours, you run with it.',
      'Ownership is tracked and visible through Monday -- where work lives, gets assigned, and moves forward',
      'Ownership does come with role responsibilities -- but every contribution, in whatever form it takes, is vital to Resona''s success',
      'Owning something means seeing it through, not just starting it'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Key distinction', 'tone', 'info', 'body', 'Ownership at Resona is less about being told what to do and more about making sure what you''re doing is visible to everyone else.')),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l31-p1-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'How does ownership stay visible across a small, fluid team at Resona?',
      'explanation', 'Through Monday, where work is tracked and assigned.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Weekly all-hands meetings'),
        jsonb_build_object('id', 'b', 'label', 'Through Monday, where work is tracked and assigned'),
        jsonb_build_object('id', 'c', 'label', 'It isn''t tracked -- everyone just knows'),
        jsonb_build_object('id', 'd', 'label', 'Through a formal chain-of-command sign-off process')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Ownership means running with what''s yours and keeping it visible in Monday -- not waiting to be told, and not letting it go quiet.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l31-p2-mastery', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Where does ownership of work get tracked at Resona?',
      'explanation', 'Monday.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Slack threads only'),
        jsonb_build_object('id', 'b', 'label', 'Monday'),
        jsonb_build_object('id', 'c', 'label', 'Email'),
        jsonb_build_object('id', 'd', 'label', 'It''s informal and untracked')
      ),
      'correct_option_id', 'b'
    )));

  -- Lesson 3.2 -- Communication Norms
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m3, 'Communication Norms', '', 2, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Direct, but Not Formal', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Communication at Resona is direct -- feedback and disagreement are said plainly, not softened into vague suggestions. But directness doesn''t mean formal.',
      'Slack is where this shows up most: a casual environment built for ideas and execution, not rigid back-and-forth approval chains',
      'Direct means clear and honest, not stiff or corporate',
      'You can disagree plainly with someone and still keep the conversation easy'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Key distinction', 'tone', 'info', 'body', 'Directness is about clarity, not tone. Being direct and being casual aren''t in conflict at Resona -- they coexist.')),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l32-p1-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What best describes Resona''s communication style?',
      'explanation', 'Direct in content, semi-casual in tone.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Formal and hierarchical'),
        jsonb_build_object('id', 'b', 'label', 'Direct in content, semi-casual in tone'),
        jsonb_build_object('id', 'c', 'label', 'Indirect, to avoid conflict'),
        jsonb_build_object('id', 'd', 'label', 'Communication happens only through official channels')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Say it plainly. Keep it easy. Both, at the same time.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l32-p2-mastery', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'If you disagree with a teammate''s approach at Resona, what''s the expected response?',
      'explanation', 'Say it directly, without needing to make it feel formal.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Say nothing and go along with it'),
        jsonb_build_object('id', 'b', 'label', 'Say it directly, without needing to make it feel formal'),
        jsonb_build_object('id', 'c', 'label', 'Escalate immediately to the founder'),
        jsonb_build_object('id', 'd', 'label', 'Wait for a scheduled review to bring it up')
      ),
      'correct_option_id', 'b'
    )));

  -- MODULE 3 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m3, 'Module 3 Check', '', 3, 3, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 3 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Module 3 Check', 'tone', 'info', 'body', 'Answer both questions correctly to unlock Module 4.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'm3-check-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Where is ownership of work tracked at Resona?',
      'explanation', 'Monday.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Monday'),
        jsonb_build_object('id', 'b', 'label', 'Email threads'),
        jsonb_build_object('id', 'c', 'label', 'A shared spreadsheet'),
        jsonb_build_object('id', 'd', 'label', 'It isn''t tracked')
      ),
      'correct_option_id', 'a'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'm3-check-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What kind of environment does Slack provide at Resona?',
      'explanation', 'Casual, focused on ideas and execution rather than rigid bureaucracy.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'A formal approval-chain environment'),
        jsonb_build_object('id', 'b', 'label', 'Casual, focused on ideas and execution rather than rigid bureaucracy'),
        jsonb_build_object('id', 'c', 'label', 'Used only for announcements'),
        jsonb_build_object('id', 'd', 'label', 'Reserved for leadership only')
      ),
      'correct_option_id', 'b'
    )));

  ------------------------------------------------------------------
  -- MODULE 4: Resona Growth (no module-check after this one)
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Resona Growth', '', 4)
  returning id into v_m4;

  -- Lesson 4.1 -- The Growth Plan
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m4, 'The Growth Plan', '', 1, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Where Growth Comes From', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Resona''s growth plan doesn''t hinge on chasing a fixed target -- it''s built around continuing to develop top-tier products and letting those products lead the company''s growth over time.',
      'The near-term focus is on Procurely and ARC becoming genuinely excellent, not just shipped',
      'As product quality compounds, growth follows from the products themselves -- not from a separate growth initiative running alongside them',
      'This is the same logic covered in Module 1: strategy first, architecture second, execution third -- growth is what happens when that sequence is done right, repeatedly'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Key distinction', 'tone', 'info', 'body', 'Growth isn''t a separate function bolted onto the products. At Resona, the products are the growth strategy.')),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l41-p1-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'According to Resona''s current growth plan, what primarily drives growth?',
      'explanation', 'Continuing to develop top-tier products and letting them lead.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'A dedicated growth/marketing department separate from product'),
        jsonb_build_object('id', 'b', 'label', 'Continuing to develop top-tier products and letting them lead'),
        jsonb_build_object('id', 'c', 'label', 'Acquiring smaller competitors'),
        jsonb_build_object('id', 'd', 'label', 'Expanding headcount ahead of product demand')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Resona''s growth plan is product-led -- build genuinely excellent products, and let that quality carry the company forward.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l41-p2-mastery', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What''s the relationship between Resona''s products and its growth plan?',
      'explanation', 'The products are the growth strategy -- quality compounds into growth.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'They''re unrelated -- growth comes from sales activity alone'),
        jsonb_build_object('id', 'b', 'label', 'The products are the growth strategy -- quality compounds into growth'),
        jsonb_build_object('id', 'c', 'label', 'Growth is planned independently of product development'),
        jsonb_build_object('id', 'd', 'label', 'Growth only applies to the studio arm, not the products')
      ),
      'correct_option_id', 'b'
    )));

  -- Lesson 4.2 -- Strategy
  -- Content gate: no financial/sequencing framing between the two arms --
  -- this lesson was explicitly rewritten to remove that, preserved verbatim.
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m4, 'Strategy', '', 2, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Two Engines, Working Together', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Resona runs on two engines: the studio arm and the product line. Both are active, both matter, and both reinforce each other.',
      'The studio applies Resona''s methodology directly with client engagements',
      'The products -- ARC and Procurely -- apply that same methodology at scale, built by Resona for Resona''s own market',
      'Client work and product work aren''t competing priorities. They''re two expressions of the same discipline, running in parallel'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Key distinction', 'tone', 'info', 'body', 'Resona isn''t choosing between being a studio and being a product company. It''s built to run both, at the same time, permanently.')),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l42-p1-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'How do Resona''s studio arm and product line relate to each other?',
      'explanation', 'They''re two engines running in parallel, both applying the same methodology.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'The studio is temporary until the products take over'),
        jsonb_build_object('id', 'b', 'label', 'They''re two engines running in parallel, both applying the same methodology'),
        jsonb_build_object('id', 'c', 'label', 'They compete for the same resources and one will eventually be shut down'),
        jsonb_build_object('id', 'd', 'label', 'The products were built to eventually replace the studio arm')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Resona runs on two engines -- the studio and the products -- both active, both permanent, both proof of the same discipline.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l42-p2-mastery', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What''s true about Resona''s studio arm going forward?',
      'explanation', 'It continues running alongside the products indefinitely.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'It will be phased out once the products succeed'),
        jsonb_build_object('id', 'b', 'label', 'It continues running alongside the products indefinitely'),
        jsonb_build_object('id', 'c', 'label', 'It only exists because the products aren''t ready yet'),
        jsonb_build_object('id', 'd', 'label', 'It will merge into the product teams')
      ),
      'correct_option_id', 'b'
    )));

  -- Lesson 4.3 -- Industry & Community Impact
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m4, 'Industry & Community Impact', '', 3, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Closing the SMB Access Gap, in Practice', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, jsonb_build_object('body', array[
      'Module 1 covered the problem: enterprise-grade clarity has been out of reach for most SMBs. This lesson covers what Resona is actually doing about that gap, beyond its own paying clients:',
      'Creating educational resources made available to all -- not gated behind a client engagement',
      'Partnering with non-profits to extend that access into the community directly',
      'These aren''t marketing gestures. They''re the same "level the playing field" mission from Module 1, applied to people and organizations who may never become paying clients at all.'
    ])),
    (v_p, 'callout', 2, jsonb_build_object('title', 'Key distinction', 'tone', 'info', 'body', 'The mission isn''t just "serve the clients we have." It''s "close the gap," and that includes people outside Resona''s client base entirely.')),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l43-p1-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'How does Resona extend its mission beyond its own paying clients?',
      'explanation', 'Through educational resources for all and partnerships with non-profits.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'It doesn''t -- the mission only applies to clients'),
        jsonb_build_object('id', 'b', 'label', 'Through educational resources for all and partnerships with non-profits'),
        jsonb_build_object('id', 'c', 'label', 'By lowering prices for all clients equally'),
        jsonb_build_object('id', 'd', 'label', 'By requiring non-profits to become paying customers')
      ),
      'correct_option_id', 'b'
    )));

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Resona''s impact isn''t measured only in client outcomes -- it shows up in educational access and non-profit partnerships that extend the mission into the wider community.')),
    (v_p, 'activity', 2, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l43-p2-mastery-1', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'What does Resona do to give back to the community beyond its client work?',
      'explanation', 'Creates educational resources and partners with non-profits.',
      'points', 1, 'position', 1,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'Nothing -- impact is limited to paying clients'),
        jsonb_build_object('id', 'b', 'label', 'Creates educational resources and partners with non-profits'),
        jsonb_build_object('id', 'c', 'label', 'Offers free product licenses to any business that asks'),
        jsonb_build_object('id', 'd', 'label', 'Only sponsors industry conferences')
      ),
      'correct_option_id', 'b'
    ))),
    (v_p, 'activity', 3, jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
      'id', 'l43-p2-mastery-2', 'assessment_id', null, 'question_type', 'multiple_choice',
      'prompt', 'Why does this community work matter to Resona''s overall mission?',
      'explanation', 'It extends the same "close the SMB access gap" mission from Module 1 to non-clients.',
      'points', 1, 'position', 2,
      'options', jsonb_build_array(
        jsonb_build_object('id', 'a', 'label', 'It''s unrelated to the company''s core mission'),
        jsonb_build_object('id', 'b', 'label', 'It extends the same "close the SMB access gap" mission from Module 1 to non-clients'),
        jsonb_build_object('id', 'c', 'label', 'It''s primarily a tax strategy'),
        jsonb_build_object('id', 'd', 'label', 'It replaces the need for client work entirely')
      ),
      'correct_option_id', 'b'
    )));

  ------------------------------------------------------------------
  -- Backfill: enroll every existing profile in Foundations now that the
  -- course row exists (mirrors the auto-enroll logic added to
  -- handle_new_user() in the prior migration, for users created before it).
  ------------------------------------------------------------------
  insert into public.enrollments (user_id, course_id, org_id, status)
  select p.id, v_course_id, p.org_id, 'assigned'
  from public.profiles p
  where not exists (
    select 1 from public.enrollments e
    where e.user_id = p.id and e.course_id = v_course_id
  );
end $$;

commit;
