begin;

-- Seeds the Procurement Foundations course from the source modules under
-- Courses/Procurement Foundations/ (generated from those files, then reviewed).
-- Same content model as 0011 (Resona Foundations): courses > modules > lessons
-- > lesson_pages > content_blocks, with module checks modeled as ordinary
-- lessons flagged is_check.
--
-- Decisions (confirmed with the user before authoring):
--   * Every activity gates at 100% (gates_progress = true), including each
--     question of every module check -- same standard as Resona Foundations.
--     The 80% in the source markdown was a placeholder.
--   * The source's open-ended retrieval prompts ("in your own words...") can't
--     be graded by the activity engine, so each lesson gets one gated
--     multiple-choice retrieval question instead.
--   * No auto-enrollment. Enrollments are assigned manually; can_access_course()
--     still requires Resona Foundations to be complete first, and admin /
--     zone_manager bypass as usual.
--   * Seeded as published. Figures that go stale (Module 3 threshold
--     illustrations, Module 7 federal thresholds and small-business goals) are
--     already labeled illustrative / "as of" in the lesson text; see BUILD_LOG.
--
-- Mermaid diagrams are hand-authored static SVG inlined as base64 data URIs
-- (same approach as 0011, Decision 3). Tables in the source are flattened into
-- rich_text entries, since ContentBlockRenderer has no table or list support.
-- Each lesson's per-module glossary table is not rendered as a page; those
-- terms are seeded into glossary_terms at the end instead, scoped to this
-- course (requires 0017).

do $$
declare
  v_course_id uuid;
  v_m uuid;
  v_l uuid;
  v_p uuid;
  v_exam_id uuid;
begin
  insert into public.courses (slug, title, description, certification_id, status, position, estimated_minutes)
  values (
    'procurement-foundations',
    'Procurement Foundations',
    'A plain-language guide to how organizations buy, with a focus on how state, county and local governments procure: the core cycle, public-sector rules, solicitations and contracts, ethics and compliance, a federal snapshot, and an end-to-end walkthrough.',
    null,
    'published',
    (select coalesce(max(position), 0) + 1 from public.courses),
    218
  )
  returning id into v_course_id;

  ------------------------------------------------------------------
  -- MODULE 1: Procurement Fundamentals
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Procurement Fundamentals', '', 1)
  returning id into v_m;

  -- Lesson 1.1 -- What Procurement Is (and Isn't)
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'What Procurement Is (and Isn''t)', '', 1, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The short version', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain what procurement is in one sentence, and tell it apart from \"purchasing\" and \"buying.\""}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Procurement is the organized process an organization uses to get the goods and services it needs, from working out what the need is through paying for it.","Every organization buys things: a coffee shop buys beans, a hospital buys MRI machines, and a city buys road salt. What makes the buying procurement is the process behind it. Without one, a purchase is whatever someone happened to put on a credit card; with one, the organization has a repeatable way to decide what to buy, from whom, at what price, and on what terms."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Procurement vs. purchasing vs. buying', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["People use these three words interchangeably in conversation, though each covers a different amount of the same activity. Buying is the act of acquiring something, purchasing is the transactional side of it, and procurement is the whole process wrapped around both."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Buying: The act of acquiring something. Example: Ordering 10 laptops.","Purchasing: The transaction side: the order, the PO, the payment. Example: Issuing the purchase order and paying the invoice.","Procurement: The whole process, including defining the need, finding suppliers, comparing offers, negotiating, awarding, receiving, and paying. Example: Everything from \"we need laptops\" to \"laptops are delivered and paid for.\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["A simple way to keep them apart is by size. Buying is a single moment, purchasing is a transaction with several steps, and procurement is the process that contains both."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why organizations bother with a process', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A formal process earns its keep in four ways that reinforce each other. Comparing options instead of taking the first one holds costs down, and vetting suppliers before depending on them lowers the chance of a bad surprise later. A record of who decided what, and why, gives the organization an answer when someone asks about a purchase months afterward. Consistent rules mean that a purchase made in March is handled the same way as one made in November, whoever happens to be making it.","The larger the organization, and the more it answers to others for how it spends money, the more formal the process tends to become, which is the subject of Module 2."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l11-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which statement best distinguishes procurement from purchasing?","explanation":"Purchasing covers the transaction (the order, the purchase order, and the payment), whereas procurement also includes defining the need, finding suppliers, comparing offers, and awarding, which is why placing an order is only one part of it.","points":1,"position":1,"options":[{"id":"a","label":"Purchasing is the whole process, while procurement covers only placing the order"},{"id":"b","label":"Procurement is the whole process from need to payment, while purchasing is the transaction side"},{"id":"c","label":"Procurement applies to government buyers, while purchasing applies to private companies"},{"id":"d","label":"The two terms mean the same thing, and the difference is only a matter of company size"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Procurement covers everything from recognizing a need to paying for what arrives, which is why placing the order is only one small part of it."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Buyers often use \"procurement\" to mean their entire function rather than just the placing of orders, so using the word the same way shows you understand how they see their work."}$j$::jsonb);

  -- Lesson 1.2 -- Who's Involved
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Who''s Involved', '', 2, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Two sides of every transaction', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can name the main roles in a procurement and describe what each one cares about."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Every transaction has two sides: the buyer, which is the organization that needs something and pays for it, and the supplier, which provides it. Supplier goes by several names depending on the setting. \"Vendor\" is common in government, \"supplier\" is common in private industry, and \"contractor\" usually implies services or construction work, but the terms overlap heavily, so expect to hear them mixed."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The roles inside a buying organization', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Titles differ from one organization to the next, but the functions behind them are consistent."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Requester / end user: The person or department with the need. What they care about: Getting the right thing, on time.","Procurement / purchasing staff: Run the process: sourcing, comparing, awarding. What they care about: Following the process, value, avoiding mistakes.","Approver: Authorizes spending (a manager, director, or board, depending on amount). What they care about: Budget, justification.","Finance / accounts payable: Confirms funds and pays invoices. What they care about: Accuracy, documentation, timing.","Legal / contracts: Reviews terms for larger or riskier deals. What they care about: Liability, compliance.","Receiving / operations: Confirms what arrived matches what was ordered. What they care about: Quality, quantity."]}$j$::jsonb),
    (v_p, 'callout', 3, $j${"title":"Why this matters","tone":"info","body":"In most organizations the person who wants the product isn't the person who buys it, and neither is the person who approves it, so a deal can stall at any of those seats."}$j$::jsonb),
    (v_p, 'callout', 4, $j${"title":"Varies by jurisdiction / organization","tone":"warning","body":"Small organizations may have one person doing several of these jobs, while large ones split them across departments. Since there's no reliable way to tell from the outside, it's safer to confirm who holds the decision than to assume the person you're talking to does."}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The supplier side', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Suppliers have functions of their own: sales finds and wins opportunities, proposal or bid staff respond to formal requests, delivery or operations does the work, and billing collects payment. Their goals mirror the buyer's, because they want to win the work, deliver it well, and get paid for it."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l12-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"A department head says \"we need new software.\" What can you reasonably assume?","explanation":"Needing, buying, approving, and paying are usually handled by different people, so a deal can stall at any of those seats even after the end user says yes.","points":1,"position":1,"options":[{"id":"a","label":"They will place the order themselves once the budget is confirmed"},{"id":"b","label":"The purchase has already been approved because they asked for it"},{"id":"c","label":"They have the need, but procurement staff, approvers, and finance are likely still involved"},{"id":"d","label":"They are the person the supplier will send invoices to"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Needing, buying, approving, and paying are usually handled by different people, so knowing who sits in each seat tells you much of what you need to understand about a given procurement."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Asking who else is involved in the decision is a normal question, and the answer shows where the deal actually lives."}$j$::jsonb);

  -- Lesson 1.3 -- The Core Procurement Cycle
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'The Core Procurement Cycle', '', 3, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The five stages', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can walk through the five core stages of procurement in order and explain what happens at each."}$j$::jsonb),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'The five stages: identify the need, source and compare, award and contract, deliver and receive, pay and close out, with lessons feeding the next need',
      'src', 'data:image/svg+xml;base64,' || replace(encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 160" font-family="sans-serif"><defs><marker id="a13" markerUnits="userSpaceOnUse" markerWidth="10" markerHeight="10" refX="9" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="10" y="20" width="165" height="64" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="92.5" y="48.166666666666664" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">1. Identify</text><text x="92.5" y="65.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">the Need</text><line x1="177" y1="52" x2="198" y2="52" stroke="#334155" stroke-width="2" marker-end="url(#a13)"/><rect x="200" y="20" width="165" height="64" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="282.5" y="48.166666666666664" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">2. Source</text><text x="282.5" y="65.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">and Compare</text><line x1="367" y1="52" x2="388" y2="52" stroke="#334155" stroke-width="2" marker-end="url(#a13)"/><rect x="390" y="20" width="165" height="64" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="472.5" y="48.166666666666664" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">3. Award</text><text x="472.5" y="65.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">and Contract</text><line x1="557" y1="52" x2="578" y2="52" stroke="#334155" stroke-width="2" marker-end="url(#a13)"/><rect x="580" y="20" width="165" height="64" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="662.5" y="48.166666666666664" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">4. Deliver</text><text x="662.5" y="65.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">and Receive</text><line x1="747" y1="52" x2="768" y2="52" stroke="#334155" stroke-width="2" marker-end="url(#a13)"/><rect x="770" y="20" width="165" height="64" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="852.5" y="48.166666666666664" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">5. Pay and</text><text x="852.5" y="65.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Close Out</text><path d="M 852 86 C 852 150, 92 150, 92 90" fill="none" stroke="#334155" stroke-width="2" stroke-dasharray="5 4" marker-end="url(#a13)"/><text x="472" y="142" text-anchor="middle" font-size="11" fill="#334155">Lessons and records feed the next need</text></svg>$svg$, 'UTF8'), 'base64'), E'\n', '')
    )),
    (v_p, 'rich_text', 3, $j${"body":["This is the simplified, universal version. Later modules add detail on budgeting, formal solicitations, evaluation, and administration, but every procurement, from a box of pens to a bridge, is some version of these five stages."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What happens at each stage', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Identify the need. Someone defines what is needed, how much, by when, and roughly what it should cost. Weak definitions at this point cause most of the problems that appear later.","Source and compare. The buyer finds possible suppliers and gathers prices or proposals. Depending on the size of the purchase and the rules in play, this can be a quick phone call or a formal competitive process.","Award and contract. The buyer selects a supplier and formalizes the deal through a purchase order, a contract, or both.","Deliver and receive. The supplier provides the goods or services, and the buyer checks that they match what was agreed.","Pay and close out. The supplier invoices, the buyer pays, and the records are kept. Any leftover issues, such as warranty claims, disputes, or performance notes, are settled here."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction / organization","tone":"warning","body":"How formal each stage is depends on the size of the purchase and the rules the buyer must follow. A small purchase might compress the first three stages into one conversation, whereas a large one can take months, yet the stages themselves stay the same and only the paperwork around them changes."}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The loop', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The dotted line back to the start of the diagram marks a loop. What a buyer learns from one procurement, such as which suppliers performed and what things really cost, shapes the next one, which is one reason suppliers who deliver well tend to be considered again."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l13-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is the correct order of the five core procurement stages?","explanation":"Every procurement follows these five stages in this order, and the size of the purchase and the rules that apply change how formal each stage is rather than whether it happens.","points":1,"position":1,"options":[{"id":"a","label":"Identify the need, source and compare, award and contract, deliver and receive, pay and close out"},{"id":"b","label":"Source and compare, identify the need, award and contract, pay and close out, deliver and receive"},{"id":"c","label":"Identify the need, award and contract, source and compare, deliver and receive, pay and close out"},{"id":"d","label":"Identify the need, source and compare, deliver and receive, award and contract, pay and close out"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Every procurement moves through the same five stages, and the size of the purchase and the rules that apply change how formal each stage is rather than whether it happens."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Which stage a buyer is in tells you what they need from you at that moment: clarity at stage 1, comparison material at stage 2, paperwork at stage 3, and so on."}$j$::jsonb);

  -- MODULE 1 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 1 Check', '', 4, 7, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 1 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 1 Check","tone":"info","body":"Answer every question correctly to unlock Module 2."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-m1-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"Which best describes procurement?","explanation":"Correct answer: The full process from identifying a need through payment and close-out","points":1,"position":1,"options":[{"id":"a","label":"Placing an order and issuing the purchase order to a supplier"},{"id":"b","label":"Paying a supplier's invoice and filing the records"},{"id":"c","label":"The full process from identifying a need through payment and close-out"},{"id":"d","label":"Comparing prices from two or more vendors before choosing one"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-m1-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"A department manager says they need new equipment and the budget is available. What can you reasonably assume?","explanation":"Correct answer: Procurement, approvers, and finance are likely still involved","points":1,"position":2,"options":[{"id":"a","label":"Procurement, approvers, and finance are likely still involved"},{"id":"b","label":"They'll place the order themselves once the budget is confirmed"},{"id":"c","label":"The purchase is already approved because the funds exist"},{"id":"d","label":"They're the contact the supplier will send invoices to"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"pf-m1-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"\"Vendor,\" \"supplier,\" and \"contractor\" are:","explanation":"Correct answer: Overlapping terms for the party that provides goods or services","points":1,"position":3,"options":[{"id":"a","label":"Three separate roles with distinct duties in a purchase"},{"id":"b","label":"Titles for people inside the buying organization"},{"id":"c","label":"Different names for the person who approves spending"},{"id":"d","label":"Overlapping terms for the party that provides goods or services"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"pf-m1-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"In the five-stage cycle, which stage comes immediately after \"Award and contract\"?","explanation":"Correct answer: Deliver and receive","points":1,"position":4,"options":[{"id":"a","label":"Source and compare"},{"id":"b","label":"Deliver and receive"},{"id":"c","label":"Identify the need"},{"id":"d","label":"Pay and close out"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"pf-m1-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"A small purchase and a large purchase differ mainly in:","explanation":"Correct answer: How formal each stage is","points":1,"position":5,"options":[{"id":"a","label":"Which stages they follow"},{"id":"b","label":"How formal each stage is"},{"id":"c","label":"Whether a need has to be defined first"},{"id":"d","label":"Whether a supplier is involved"}],"correct_option_id":"b"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 2: The Public Procurement Landscape
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'The Public Procurement Landscape', '', 2)
  returning id into v_m;

  -- Lesson 2.1 -- Public vs. Private Buying
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Public vs. Private Buying', '', 1, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Same cycle, different pressure', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain why government buying works differently from private-company buying, and name the three principles that drive most of the differences."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The five-stage cycle from Module 1 (identify the need, source and compare, award and contract, deliver and receive, pay and close out) applies to every buyer. What changes in the public sector is the pressure around each stage.","A private company spends its own money and answers to its owners or investors. A public agency spends public money, which comes from taxpayers, and it answers to the public, elected officials, auditors, and the law, all of whom can ask how a given dollar was spent."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The three principles', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Most of the differences between public and private buying trace back to three ideas."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Competition: Suppliers get a fair chance to compete for the work. What you'll see in practice: Formal solicitations, published opportunities, multiple quotes or bids.","Transparency: The public can see how money is spent and why. What you'll see in practice: Public notices, public bid openings, records that can be requested.","Accountability: Decisions must be documented and defensible. What you'll see in practice: Written criteria, scoring, approvals, audit trails."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What this changes day to day', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Because of these principles, public buying follows written rules rather than personal judgment alone, whether those rules take the form of procurement laws, codes, or local policies. The process also tends to be slower and better documented than a private purchase, since each step exists so that the decision can be explained later to an auditor, a board, or a losing bidder.","The same rules change how relationships work. A buyer may be perfectly friendly and still be unable to favor one supplier, and rules about gifts, contact during a solicitation, and conflicts of interest are common for that reason. Many jurisdictions also let losing bidders protest an award, which is why buyers document so much of what they do."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"The specific laws, thresholds, and formalities differ by state, county, city, and agency, though the three principles hold almost everywhere."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l21-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which describes a main way public buying differs from private buying?","explanation":"The same cycle applies to every buyer, but because public agencies spend taxpayer money, competition, transparency, and accountability shape how each stage is carried out.","points":1,"position":1,"options":[{"id":"a","label":"Public buyers can choose any supplier they prefer without justifying the choice"},{"id":"b","label":"Public buyers skip parts of the five-stage cycle to move faster"},{"id":"c","label":"Public buyers aren't required to compare offers from several suppliers"},{"id":"d","label":"Public money must be accounted for, so decisions have to be documented and defensible"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Public buyers use the same cycle as everyone else, but competition, transparency, and accountability shape how each stage is carried out."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Expect a public buyer to talk about process, documentation, and compliance, and respect those constraints, because doing so builds trust faster than pushing for speed does."}$j$::jsonb);

  -- Lesson 2.2 -- Who Buys in the Public Sector
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Who Buys in the Public Sector', '', 2, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The levels of government', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can name the main types of public buyers and describe how they differ in size and structure."}$j$::jsonb),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'Public sector buyers: federal, state, county, city or municipality, special districts and authorities, public education and other public bodies',
      'src', 'data:image/svg+xml;base64,' || replace(encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1028 196" font-family="sans-serif"><defs><marker id="a22" markerUnits="userSpaceOnUse" markerWidth="10" markerHeight="10" refX="9" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="394" y="10" width="240" height="52" rx="10" fill="#ede9fe" stroke="#6d28d9"/><text x="514" y="41" text-anchor="middle" font-size="15" font-weight="600" fill="#4c1d95">Public Sector Buyers</text><line x1="514" y1="62" x2="89" y2="118" stroke="#334155" stroke-width="2" marker-end="url(#a22)"/><rect x="10" y="122" width="158" height="60" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="89" y="156" text-anchor="middle" font-size="12" font-weight="600" fill="#0c4a6e">Federal</text><line x1="514" y1="62" x2="259" y2="118" stroke="#334155" stroke-width="2" marker-end="url(#a22)"/><rect x="180" y="122" width="158" height="60" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="259" y="156" text-anchor="middle" font-size="12" font-weight="600" fill="#0c4a6e">State</text><line x1="514" y1="62" x2="429" y2="118" stroke="#334155" stroke-width="2" marker-end="url(#a22)"/><rect x="350" y="122" width="158" height="60" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="429" y="156" text-anchor="middle" font-size="12" font-weight="600" fill="#0c4a6e">County</text><line x1="514" y1="62" x2="599" y2="118" stroke="#334155" stroke-width="2" marker-end="url(#a22)"/><rect x="520" y="122" width="158" height="60" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="599" y="148.5" text-anchor="middle" font-size="12" font-weight="600" fill="#0c4a6e">City or</text><text x="599" y="163.5" text-anchor="middle" font-size="12" font-weight="600" fill="#0c4a6e">Municipality</text><line x1="514" y1="62" x2="769" y2="118" stroke="#334155" stroke-width="2" marker-end="url(#a22)"/><rect x="690" y="122" width="158" height="60" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="769" y="148.5" text-anchor="middle" font-size="12" font-weight="600" fill="#0c4a6e">Special Districts</text><text x="769" y="163.5" text-anchor="middle" font-size="12" font-weight="600" fill="#0c4a6e">and Authorities</text><line x1="514" y1="62" x2="939" y2="118" stroke="#334155" stroke-width="2" marker-end="url(#a22)"/><rect x="860" y="122" width="158" height="60" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="939" y="141" text-anchor="middle" font-size="12" font-weight="600" fill="#0c4a6e">Public Education</text><text x="939" y="156" text-anchor="middle" font-size="12" font-weight="600" fill="#0c4a6e">and Other</text><text x="939" y="171" text-anchor="middle" font-size="12" font-weight="600" fill="#0c4a6e">Public Bodies</text></svg>$svg$, 'UTF8'), 'base64'), E'\n', '')
    )),
    (v_p, 'rich_text', 3, $j${"body":["Federal: National agencies and programs. Notes: Largest buyer; governed by federal rules.","State: State agencies, programs, and infrastructure. Notes: Often has a central purchasing office plus agency-level buying.","County: Courts, roads, public safety, health and human services. Notes: Mix of centralized and departmental purchasing.","City / municipality: Public works, utilities, parks, local services. Notes: Wide range from very small to very large.","Special districts and authorities: A single purpose (water, transit, ports, airports). Notes: Often have their own boards and purchasing rules.","Public education and other public bodies: School districts, colleges, universities, housing authorities. Notes: Frequently have separate rules from the city or county they sit in."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Size changes the experience', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A large state agency may have a dedicated purchasing team, formal procedures, and electronic bidding, whereas a small town may have one clerk handling purchasing alongside several other duties. The principles are the same in both places, but the capacity to carry them out is very different."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Which entities exist, how they overlap, and which rules apply to each depends on the state and locality. It's risky to assume a school district follows the same rules as the city around it."}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why the layers matter', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Each public entity is usually its own buyer, with its own budget, board, and rules, so winning work with one tells you little about how another will behave. Some entities can buy off each other's contracts, which Module 3 covers. Money also flows between levels, as when a federal or state grant funds a local purchase, and that money can come with extra requirements the local buyer has to follow."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l22-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why is it risky to assume a school district follows the same rules as the city it sits in?","explanation":"The public sector is made up of many separate buyers, and school districts frequently have rules that differ from those of the city or county around them.","points":1,"position":1,"options":[{"id":"a","label":"School districts are exempt from public purchasing rules altogether"},{"id":"b","label":"A city's rules apply automatically to every entity inside its boundaries"},{"id":"c","label":"Each entity is usually its own buyer, with its own budget, governing body, and rules"},{"id":"d","label":"School districts can only buy through programs run by the federal government"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"The public sector is made up of many separate buyers, each with its own budget, governing body, and rules."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Start by learning what kind of entity you're talking to, since that tells you who decides, how formal the process is likely to be, and which rules probably apply."}$j$::jsonb);

  -- Lesson 2.3 -- Who Decides Inside a Government Buyer
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Who Decides Inside a Government Buyer', '', 3, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The roles', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe the typical roles inside a public buyer and how a purchase moves between them."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Department / end user: Has the need and defines what is required. What they care about: Getting something that works, on time.","Purchasing / procurement office: Runs the process, enforces the rules. What they care about: Compliance, fairness, documentation.","Contracting or legal staff: Reviews terms and risk. What they care about: Liability, enforceability.","Finance / budget office: Confirms funds exist. What they care about: Budget limits, proper coding of spending.","Governing body (council, board, commission): Approves larger purchases and sets policy. What they care about: Public accountability, value, community impact.","Elected or appointed executive: Oversees operations (mayor, county manager, superintendent, director). What they care about: Priorities, politics, results.","Auditors / oversight: Review after the fact. What they care about: Whether rules were followed."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'How a purchase typically moves', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'image', 1, jsonb_build_object(
      'alt', 'A department identifies a need, budget is confirmed, purchasing runs the process; above the approval threshold the governing body approves, otherwise staff approve; then contract and purchase order',
      'src', 'data:image/svg+xml;base64,' || replace(encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1072 200" font-family="sans-serif"><defs><marker id="a23" markerUnits="userSpaceOnUse" markerWidth="10" markerHeight="10" refX="9" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="10" y="70" width="150" height="60" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="85" y="96.16666666666667" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Department</text><text x="85" y="113.16666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">identifies need</text><line x1="162" y1="100" x2="188" y2="100" stroke="#334155" stroke-width="2" marker-end="url(#a23)"/><rect x="190" y="70" width="130" height="60" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="255" y="96.16666666666667" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Budget</text><text x="255" y="113.16666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">confirmed</text><line x1="322" y1="100" x2="348" y2="100" stroke="#334155" stroke-width="2" marker-end="url(#a23)"/><rect x="350" y="70" width="140" height="60" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="420" y="96.16666666666667" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Purchasing</text><text x="420" y="113.16666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">runs process</text><line x1="492" y1="100" x2="518" y2="100" stroke="#334155" stroke-width="2" marker-end="url(#a23)"/><polygon points="600,50 680,100 600,150 520,100" fill="#fef3c7" stroke="#b45309"/><text x="600" y="97" text-anchor="middle" font-size="12" font-weight="600" fill="#78350f">Above approval</text><text x="600" y="111" text-anchor="middle" font-size="12" font-weight="600" fill="#78350f">threshold?</text><line x1="600" y1="50" x2="700" y2="30" stroke="#334155" stroke-width="2" marker-end="url(#a23)"/><text x="615" y="40" text-anchor="start" font-size="11" fill="#334155">Yes</text><rect x="702" y="8" width="170" height="50" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="787" y="29.166666666666668" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Governing body</text><text x="787" y="46.16666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">approves</text><line x1="600" y1="150" x2="700" y2="172" stroke="#334155" stroke-width="2" marker-end="url(#a23)"/><text x="615" y="166" text-anchor="start" font-size="11" fill="#334155">No</text><rect x="702" y="142" width="170" height="50" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="787" y="163.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Staff-level</text><text x="787" y="180.16666666666666" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">approval</text><line x1="874" y1="33" x2="920" y2="78" stroke="#334155" stroke-width="2" marker-end="url(#a23)"/><line x1="874" y1="167" x2="920" y2="122" stroke="#334155" stroke-width="2" marker-end="url(#a23)"/><rect x="922" y="70" width="140" height="60" rx="10" fill="#dcfce7" stroke="#15803d"/><text x="992" y="96.16666666666667" text-anchor="middle" font-size="14" font-weight="600" fill="#14532d">Contract</text><text x="992" y="113.16666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#14532d">and PO</text></svg>$svg$, 'UTF8'), 'base64'), E'\n', '')
    )),
    (v_p, 'rich_text', 2, $j${"body":["The person who wants the item, the person who runs the process, and the person who approves it are usually three different people. Bigger purchases pull in more of them, and often include a public meeting."]}$j$::jsonb),
    (v_p, 'callout', 3, $j${"title":"Varies by jurisdiction","tone":"warning","body":"The dollar level at which a board or council must approve a purchase differs widely, and so does who counts as the \"purchasing office.\" Smaller entities may combine several of these roles in one person."}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"pf-l23-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why can a board or council calendar decide when a purchase can happen?","explanation":"Bigger purchases pull in more approvers and often a public meeting, so the meeting schedule can decide when an award is possible.","points":1,"position":1,"options":[{"id":"a","label":"Larger purchases often need approval at a public meeting, so the calendar sets the earliest award date"},{"id":"b","label":"Councils meet only once a year, so every purchase waits for that meeting"},{"id":"c","label":"Governing bodies write the supplier's contract before any award is made"},{"id":"d","label":"Meetings are attended only by auditors, who must approve each purchase"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Public purchases move through several hands, and the larger ones need approval from a governing body in public view."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Asking who else needs to approve and when the governing body meets is worthwhile, because board and council calendars often decide when a purchase can happen."}$j$::jsonb);

  -- MODULE 2 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 2 Check', '', 4, 7, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 2 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 2 Check","tone":"info","body":"Answer every question correctly to unlock Module 3."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-m2-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"Which three principles drive most differences between public and private buying?","explanation":"Correct answer: Competition, transparency, and accountability","points":1,"position":1,"options":[{"id":"a","label":"Speed, price, and convenience"},{"id":"b","label":"Loyalty, discretion, and volume"},{"id":"c","label":"Branding, reputation, and timing"},{"id":"d","label":"Competition, transparency, and accountability"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-m2-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"A friendly public buyer can't give you an inside track mainly because:","explanation":"Correct answer: Rules require fair competition and documented decisions","points":1,"position":2,"options":[{"id":"a","label":"Rules require fair competition and documented decisions"},{"id":"b","label":"Public buyers are told to avoid working with outside suppliers"},{"id":"c","label":"Their budgets are fixed, so there's nothing to negotiate"},{"id":"d","label":"Contact with suppliers is limited to written communication"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"pf-m2-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"Which statement about public buyers is most accurate?","explanation":"Correct answer: Each entity is usually its own buyer, with its own budget, governing body, and rules","points":1,"position":3,"options":[{"id":"a","label":"Government buyers at every level follow the same set of rules"},{"id":"b","label":"Only federal agencies run formal purchasing processes"},{"id":"c","label":"Each entity is usually its own buyer, with its own budget, governing body, and rules"},{"id":"d","label":"School districts follow the purchasing rules of the city they sit in"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"pf-m2-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"Inside a government buyer, who typically runs the buying process?","explanation":"Correct answer: The purchasing or procurement office","points":1,"position":4,"options":[{"id":"a","label":"The department that has the need"},{"id":"b","label":"The auditors who review spending"},{"id":"c","label":"The purchasing or procurement office"},{"id":"d","label":"The governing body that approves the budget"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"pf-m2-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"What commonly happens when a purchase exceeds a set dollar level?","explanation":"Correct answer: It requires approval from a governing body such as a board or council","points":1,"position":5,"options":[{"id":"a","label":"It requires approval from a governing body such as a board or council"},{"id":"b","label":"It's cancelled and has to be resubmitted the next fiscal year"},{"id":"c","label":"It skips the usual review because of its size"},{"id":"d","label":"It must be awarded to a single source"}],"correct_option_id":"a"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 3: How State, County and Local Governments Buy
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'How State, County and Local Governments Buy', '', 3)
  returning id into v_m;

  -- Lesson 3.1 -- Where the Rules Come From
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Where the Rules Come From', '', 1, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Layers of rules', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain the layers of rules a state, county, or local buyer follows, and why you must always ask which rules apply."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A public buyer's process is usually shaped by several layers of rules at once."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["State law: Statutes passed by the legislature. Example of what it sets: Minimum competition requirements for local entities, public notice rules.","Local code or ordinance: Rules adopted by a city, county, or district. Example of what it sets: Dollar tiers, approval levels, preferences.","Board or council policy: Adopted policies and resolutions. Example of what it sets: Procedures, delegated authority.","Department procedures: Internal guides and templates. Example of what it sets: Forms, checklists, who signs what.","Funding conditions: Requirements attached to grants or special funds. Example of what it sets: Extra steps when outside money pays for the purchase."]}$j$::jsonb),
    (v_p, 'rich_text', 4, $j${"body":["When the layers disagree, the stricter one usually wins. A city may be free to set its own tiers, but only inside what state law allows, and grant money can add requirements on top of both."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why this matters', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Two neighboring entities can buy the same item under very different rules, because there's no single national rulebook for state and local buying. Public-sector buyers generally set their own tiers, dollar amounts, and approval levels, and that is the reason you ask which rules apply instead of assuming."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Everything in this module. The right habit is to ask, not assume."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l31-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What is the best way to learn which rules apply to a local buyer's purchase?","explanation":"No single rulebook governs state and local buying, so asking is more reliable than assuming, and it keeps you from misquoting rules that don't apply.","points":1,"position":1,"options":[{"id":"a","label":"Assume the rules match those of a neighboring city"},{"id":"b","label":"Quote the national procurement rulebook to the buyer"},{"id":"c","label":"Check our own company's policy to see what the buyer must do"},{"id":"d","label":"Ask the buyer what process they follow for a purchase like this"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"There's no single rulebook for state and local buying: state law, local code, policy, and funding conditions stack on top of one another, and the stricter layer governs."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Ask, \"What process do you follow for a purchase like this?\" instead of telling them what the rules are. They know their own rules, and asking keeps you from misquoting ones that don't apply."}$j$::jsonb);

  -- Lesson 3.2 -- Dollar Thresholds and the Tiers of Process
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Dollar Thresholds and the Tiers of Process', '', 2, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The typical tiers', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe the typical three-tier structure of public purchasing and explain why thresholds differ so much."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Most public buyers scale the formality of the process to the size of the purchase."]}$j$::jsonb),
    (v_p, 'image', 3, jsonb_build_object(
      'alt', 'Three tiers of public purchasing: small purchase with little or no competition, informal quotes with several price quotes, formal competition with public solicitation, scoring, award and board approval',
      'src', 'data:image/svg+xml;base64,' || replace(encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 880 136" font-family="sans-serif"><defs><marker id="a32" markerUnits="userSpaceOnUse" markerWidth="10" markerHeight="10" refX="9" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="10" y="20" width="250" height="96" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="135" y="54.333333333333336" text-anchor="middle" font-size="16" font-weight="600" fill="#0c4a6e">Small purchase</text><text x="135" y="73.33333333333334" text-anchor="middle" font-size="13" font-weight="400" fill="#0c4a6e">Little or no competition</text><text x="135" y="92.33333333333334" text-anchor="middle" font-size="13" font-weight="400" fill="#0c4a6e">required; staff discretion</text><line x1="262" y1="68" x2="306" y2="68" stroke="#334155" stroke-width="2" marker-end="url(#a32)"/><rect x="310" y="20" width="250" height="96" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="435" y="54.333333333333336" text-anchor="middle" font-size="16" font-weight="600" fill="#0c4a6e">Informal quotes</text><text x="435" y="73.33333333333334" text-anchor="middle" font-size="13" font-weight="400" fill="#0c4a6e">Several price quotes</text><text x="435" y="92.33333333333334" text-anchor="middle" font-size="13" font-weight="400" fill="#0c4a6e">gathered</text><line x1="562" y1="68" x2="606" y2="68" stroke="#334155" stroke-width="2" marker-end="url(#a32)"/><rect x="610" y="20" width="250" height="96" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="735" y="54.333333333333336" text-anchor="middle" font-size="16" font-weight="600" fill="#0c4a6e">Formal competition</text><text x="735" y="73.33333333333334" text-anchor="middle" font-size="13" font-weight="400" fill="#0c4a6e">Public solicitation, scoring,</text><text x="735" y="92.33333333333334" text-anchor="middle" font-size="13" font-weight="400" fill="#0c4a6e">award, board approval</text></svg>$svg$, 'UTF8'), 'base64'), E'\n', '')
    )),
    (v_p, 'rich_text', 4, $j${"body":["Small purchase: Often no bidding requirement; staff use judgment. Who decides: Department or purchasing staff.","Informal / quote tier: Staff typically gather several price quotes, sometimes with room to pick something other than the lowest price. Who decides: Purchasing staff, sometimes a director.","Formal competition: Published solicitation, market research, scoring, award, protest handling, and contract approval. Who decides: Purchasing office plus approval by a manager, board, or council."]}$j$::jsonb),
    (v_p, 'rich_text', 5, $j${"body":["Formal competition is where much of the money goes. One practitioner overview says roughly 80% of local government spending falls in the formal tier, and that the process can take anywhere from several months to a couple of years. Both figures come from a single source, so treat them as rough context and not as a promise."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'How much thresholds vary', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A December 2024 comparison of state small-purchase thresholds found limits ranging from about $1,000 to $250,000, depending on the state. The figures measure different things (direct-purchase limits, quote requirements, and competition triggers), which means they can't be compared directly. Three illustrations from that comparison show the spread: one state requires only good purchasing practice below a few thousand dollars, another requires no competition up to $10,000 and three quotes from $10,000 to $25,000, and a third allows documented quotes for purchases up to $250,000.","City examples from a local-purchasing overview show the same spread, with informal ranges that start in the low thousands and, in some places, reach six figures."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"These are examples of the spread, not figures to repeat. Thresholds change whenever laws and policies are amended, so figures like these go stale quickly. For an actual buyer, find their current policy."}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why the tiers exist', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Heavy process costs time and money for both sides, so tiers aim to match the effort to the risk. A few hundred dollars of supplies doesn't need a formal bid, whereas a large multi-year contract does."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l32-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why do public buyers use tiers of process based on purchase size?","explanation":"A few hundred dollars of supplies doesn't need a formal bid, whereas a large multi-year contract does, so the tiers scale the process to the purchase.","points":1,"position":1,"options":[{"id":"a","label":"To make every purchase follow the same set of steps"},{"id":"b","label":"To match the effort and formality of the process to the risk of the purchase"},{"id":"c","label":"To keep suppliers from learning what the buyer pays"},{"id":"d","label":"Because federal law sets identical tiers for every state"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Process scales with the size of the purchase, but where the lines sit depends on the entity, and the lines move over time."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Learn where the purchase sits relative to the buyer's thresholds, since a buyer under the formal threshold may be able to move quickly while one above it follows a longer, public process."}$j$::jsonb);

  -- Lesson 3.3 -- Exceptions: Sole Source, Emergency and Local Programs
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Exceptions: Sole Source, Emergency and Local Programs', '', 3, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Common exceptions', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can recognize the common exceptions to competition and the programs that shape who gets a chance to compete."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Competition is the default, but most jurisdictions allow narrow exceptions, each with its own documentation requirements."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Sole source: Only one supplier can provide what is needed (for example, proprietary products or unique services). Typical safeguard: Written justification, sometimes public notice or higher approval.","Emergency: An urgent threat to health, safety, or essential services leaves no time for the normal process. Typical safeguard: Documentation after the fact, limits on scope and duration.","Existing contract use: An already-competed contract can be used (covered in Lesson 3.4). Typical safeguard: Must be permitted by local rules."]}$j$::jsonb),
    (v_p, 'rich_text', 4, $j${"body":["Exceptions are meant to be rare and defensible. A buyer who asks for a sole-source justification isn't being difficult; they're protecting themselves from audit findings."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Programs that shape the field', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Many entities run programs that influence who competes or how bids are evaluated. Small, local, or disadvantaged business programs are one example, and they can include outreach requirements during informal bidding or allowances for purchases from certified firms. Some jurisdictions also use preferences or set-asides, and funding can add its own requirements when grants or special funds pay for the purchase."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Whether these programs exist, who qualifies, and how they work depends entirely on the entity and, often, on the funding source."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l33-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"When may a public buyer legitimately skip normal competition?","explanation":"Competition is the default, and the exceptions to it are narrow and documented, which is why buyers record their justification carefully.","points":1,"position":1,"options":[{"id":"a","label":"Whenever the buyer prefers a particular supplier"},{"id":"b","label":"In narrow, documented exceptions such as sole source or a genuine emergency"},{"id":"c","label":"Any time the requester wants the purchase to move faster"},{"id":"d","label":"Whenever a supplier asks for an exception"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Competition is the default, and the exceptions to it are narrow and documented, while local programs can shape who gets to compete in the first place."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Never suggest a way around the process. Buyers are expected to justify any exception, and being asked to bend the rules damages trust."}$j$::jsonb);

  -- Lesson 3.4 -- Cooperative Purchasing and Piggybacking
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Cooperative Purchasing and Piggybacking', '', 4, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Sharing one competition', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain how public entities share contracts and why it matters to suppliers and buyers."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Cooperative purchasing lets public entities share a single competitive process rather than each running its own. It takes three common forms."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Joint solicitation: Several entities issue a shared bid, splitting the work and combining buying power.","Multiple-award schedules: A lead agency (often a state) competitively awards contracts to several qualified suppliers; other agencies buy from those suppliers.","Piggybacking: An entity uses a contract another entity already awarded competitively."]}$j$::jsonb),
    (v_p, 'rich_text', 4, $j${"body":["Purchasing cooperatives and regional bodies often coordinate these contracts, and suppliers commonly pay them administrative fees. NASPO ValuePoint, Sourcewell, and U.S. Communities are examples of such organizations."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Benefits and cautions', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["For buyers, the appeal is practical. A shared contract saves staff time, avoids a duplicate procurement, combines volume for better pricing, and lets a buyer rely on vetting that peers have already done. It can also speed access to new vendors and technologies.","The cautions are just as practical. Local rules still apply, so entities often adapt a shared contract to their own requirements. The legal authority to use cooperative contracts, or another entity's contracts, varies by state, which is why buyers check before relying on one. Cooperatives also differ in governance and fees, so their terms get reviewed as well."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l34-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What does cooperative purchasing let public entities do?","explanation":"Shared contracts save buyers time, but they only work where local and state rules permit them.","points":1,"position":1,"options":[{"id":"a","label":"Skip competition for all purchases below a set amount"},{"id":"b","label":"Override their own local rules whenever a shared contract exists"},{"id":"c","label":"Share a single competitive process instead of each running its own"},{"id":"d","label":"Pay suppliers jointly without needing a contract"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Shared contracts save buyers time, but they only work where local and state rules permit them."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Asking whether they use cooperative contracts tells you whether their buying runs through a shared vehicle or through their own solicitations."}$j$::jsonb);

  -- MODULE 3 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 3 Check', '', 5, 8, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 3 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 3 Check","tone":"info","body":"Answer every question correctly to unlock Module 4."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-m3-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"Which best describes the rules a local buyer follows?","explanation":"Correct answer: Several layers (state law, local code, policy, funding conditions) apply, and the stricter layer governs","points":1,"position":1,"options":[{"id":"a","label":"One national rulebook applies to every state and local buyer"},{"id":"b","label":"Only the buyer's own preferences and internal habits matter"},{"id":"c","label":"The supplier's contract terms replace the buyer's usual rules"},{"id":"d","label":"Several layers (state law, local code, policy, funding conditions) apply, and the stricter layer governs"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-m3-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"A rep tells a buyer, \"Your threshold for formal bidding is $25,000, right?\" What is the best correction?","explanation":"Correct answer: Thresholds vary by entity, so the rep should ask what the buyer's current policy says","points":1,"position":2,"options":[{"id":"a","label":"That's correct, since $25,000 is the standard national figure"},{"id":"b","label":"Thresholds vary by entity, so the rep should ask what the buyer's current policy says"},{"id":"c","label":"Local governments don't use dollar thresholds at all"},{"id":"d","label":"Only state agencies set thresholds, so it doesn't apply here"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"pf-m3-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"Which pairing correctly describes typical tiers?","explanation":"Correct answer: Small purchases need little process, while larger ones need formal, documented competition","points":1,"position":3,"options":[{"id":"a","label":"Larger purchases need less documentation than smaller ones"},{"id":"b","label":"Small purchases need little process, while larger ones need formal, documented competition"},{"id":"c","label":"Every purchase follows the same process regardless of size"},{"id":"d","label":"Informal quotes are reserved for the largest purchases"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"pf-m3-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"What is the right response when a buyer asks for a sole-source justification?","explanation":"Correct answer: Recognize it as a normal safeguard and supply what they need","points":1,"position":4,"options":[{"id":"a","label":"Treat it as an obstacle and push back on the request"},{"id":"b","label":"Suggest that the paperwork can be skipped this once"},{"id":"c","label":"Move on to a different buyer who asks for less"},{"id":"d","label":"Recognize it as a normal safeguard and supply what they need"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"pf-m3-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"What is piggybacking?","explanation":"Correct answer: Using a contract another entity already awarded competitively, where local rules allow it","points":1,"position":5,"options":[{"id":"a","label":"Using a contract another entity already awarded competitively, where local rules allow it"},{"id":"b","label":"Splitting one purchase into several smaller pieces"},{"id":"c","label":"Awarding a contract to someone the buyer already knows"},{"id":"d","label":"Buying without a contract and billing afterward"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"pf-m3-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"Which statement about cooperative contracts is most accurate?","explanation":"Correct answer: They can save time, but legal authority to use them varies and local rules still apply","points":1,"position":6,"options":[{"id":"a","label":"They override the buyer's own procurement rules"},{"id":"b","label":"Every entity may use them in every state"},{"id":"c","label":"They can save time, but legal authority to use them varies and local rules still apply"},{"id":"d","label":"They can only be used for emergency purchases"}],"correct_option_id":"c"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 4: The Procurement Lifecycle
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'The Procurement Lifecycle', '', 4)
  returning id into v_m;

  -- Lesson 4.1 -- The Lifecycle at a Glance
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'The Lifecycle at a Glance', '', 1, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'From five stages to seven', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can name the seven stages of a public procurement, and map them onto the five-stage cycle from Module 1."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Module 1 gave you the universal five-stage cycle. Public buyers break the same journey into more steps, because each step needs its own documentation and approval."]}$j$::jsonb),
    (v_p, 'image', 3, jsonb_build_object(
      'alt', 'The seven stages of a public procurement: requirement, planning and budget, solicitation, evaluation, award, contract administration, closeout',
      'src', 'data:image/svg+xml;base64,' || replace(encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1018 136" font-family="sans-serif"><defs><marker id="a41" markerUnits="userSpaceOnUse" markerWidth="10" markerHeight="10" refX="9" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="10" y="20" width="120" height="62" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="70" y="55.333333333333336" text-anchor="middle" font-size="13" font-weight="600" fill="#0c4a6e">1. Requirement</text><line x1="131" y1="51" x2="152" y2="51" stroke="#334155" stroke-width="2" marker-end="url(#a41)"/><rect x="154" y="20" width="120" height="62" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="214" y="47.333333333333336" text-anchor="middle" font-size="13" font-weight="600" fill="#0c4a6e">2. Planning</text><text x="214" y="63.333333333333336" text-anchor="middle" font-size="13" font-weight="600" fill="#0c4a6e">and Budget</text><line x1="275" y1="51" x2="296" y2="51" stroke="#334155" stroke-width="2" marker-end="url(#a41)"/><rect x="298" y="20" width="120" height="62" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="358" y="55.333333333333336" text-anchor="middle" font-size="13" font-weight="600" fill="#0c4a6e">3. Solicitation</text><line x1="419" y1="51" x2="440" y2="51" stroke="#334155" stroke-width="2" marker-end="url(#a41)"/><rect x="442" y="20" width="120" height="62" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="502" y="55.333333333333336" text-anchor="middle" font-size="13" font-weight="600" fill="#0c4a6e">4. Evaluation</text><line x1="563" y1="51" x2="584" y2="51" stroke="#334155" stroke-width="2" marker-end="url(#a41)"/><rect x="586" y="20" width="120" height="62" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="646" y="55.333333333333336" text-anchor="middle" font-size="13" font-weight="600" fill="#0c4a6e">5. Award</text><line x1="707" y1="51" x2="728" y2="51" stroke="#334155" stroke-width="2" marker-end="url(#a41)"/><rect x="730" y="20" width="120" height="62" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="790" y="47.333333333333336" text-anchor="middle" font-size="13" font-weight="600" fill="#0c4a6e">6. Contract</text><text x="790" y="63.333333333333336" text-anchor="middle" font-size="13" font-weight="600" fill="#0c4a6e">Administration</text><line x1="851" y1="51" x2="872" y2="51" stroke="#334155" stroke-width="2" marker-end="url(#a41)"/><rect x="874" y="20" width="120" height="62" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="934" y="55.333333333333336" text-anchor="middle" font-size="13" font-weight="600" fill="#0c4a6e">7. Closeout</text><line x1="10" y1="100" x2="274" y2="100" stroke="#6d28d9" stroke-width="3"/><text x="142" y="122" text-anchor="middle" font-size="12" font-weight="600" fill="#4c1d95">Pre-solicitation</text><line x1="298" y1="100" x2="706" y2="100" stroke="#6d28d9" stroke-width="3"/><text x="502" y="122" text-anchor="middle" font-size="12" font-weight="600" fill="#4c1d95">Solicitation to award</text><line x1="730" y1="100" x2="994" y2="100" stroke="#6d28d9" stroke-width="3"/><text x="862" y="122" text-anchor="middle" font-size="12" font-weight="600" fill="#4c1d95">Post-award</text></svg>$svg$, 'UTF8'), 'base64'), E'\n', '')
    )),
    (v_p, 'rich_text', 4, $j${"body":["Identify the need: 1. Requirement, 2. Planning and Budget.","Source and compare: 3. Solicitation, 4. Evaluation.","Award and contract: 5. Award.","Deliver and receive: 6. Contract Administration.","Pay and close out: 6. Contract Administration, 7. Closeout."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Three phases', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The seven stages are easier to hold in mind when you group them into three phases. The first, pre-solicitation (stages 1 and 2), is where the buyer decides what it needs and whether it can pay for it, and most of a procurement's success is decided here. The second, solicitation to award (stages 3 to 5), is the competitive part, in which suppliers are invited, compared, and one is selected. The third, post-award (stages 6 and 7), covers delivery, oversight, payment, and wrapping up."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Names and number of stages differ. Some entities fold planning into the requirement, and others treat award and contracting as separate steps, so it's the sequence that matters more than the labels."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l41-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which phase of the public lifecycle includes solicitation, evaluation, and award?","explanation":"Stages 3 to 5 are the competitive part of the lifecycle, in which suppliers are invited, compared, and one is selected.","points":1,"position":1,"options":[{"id":"a","label":"Solicitation to award (stages 3 to 5)"},{"id":"b","label":"Pre-solicitation (stages 1 to 2)"},{"id":"c","label":"Post-award (stages 6 to 7)"},{"id":"d","label":"Closeout (stage 7) only"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"The public lifecycle is the same journey as the five-stage cycle, broken into more documented steps."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"\"Where are you in the process?\" is a natural opening question, and the answer tells you what the buyer needs to hear from you."}$j$::jsonb);

  -- Lesson 4.2 -- Before the Solicitation: Need, Planning and Budget
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Before the Solicitation: Need, Planning and Budget', '', 2, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Requirement', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe what happens before a solicitation is published, and why the earliest stages matter most."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Someone in a department defines the need: what is required, in what quantity, by when, and to what standard. In practice this often becomes a scope of work for services or a set of specifications for goods.","A weak requirement is the most common source of later trouble, since vague scope leads to mismatched bids, change orders, or disputes."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Planning and budget', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Before spending anything, the buyer has several questions to settle. The first is whether the money is there, because funds must be budgeted or otherwise available, and they may be tied to a grant or a specific fund. The second is how much the purchase is likely to cost; an estimate, sometimes called an independent cost estimate, helps place the purchase in the right tier and gives the buyer something to judge bids against later.","The estimated value and the type of need then guide the choice of method, meaning a quote process or a formal competition (Module 3). Higher-value purchases may need sign-off before going out, so the buyer also works out who has to approve. Last, the buyer checks for an existing vehicle, since a cooperative or existing contract might make a new solicitation unnecessary."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why this stage is quiet and powerful', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Suppliers usually don't see these stages, yet many outcomes are shaped here: how the scope is written, which method is chosen, and what the budget allows."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Budget cycles, planning requirements, and approval steps differ widely. Many entities budget annually, so the timing of a purchase often follows the fiscal calendar."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l42-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What is a scope of work?","explanation":"For services the requirement usually becomes a scope of work, and for goods it becomes a set of specifications.","points":1,"position":1,"options":[{"id":"a","label":"The supplier's price proposal for the work"},{"id":"b","label":"The list of people who will evaluate responses"},{"id":"c","label":"A record of the invoices the buyer has paid"},{"id":"d","label":"A description of the services and deliverables the buyer requires"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Need and planning shape everything downstream, which is why a clear requirement and confirmed funding are the foundation of a clean procurement."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"The earlier you understand the buyer's need and timing, the more useful you can be, and learning their budget cycle often explains why the timing looks the way it does."}$j$::jsonb);

  -- Lesson 4.3 -- Solicitation, Evaluation and Award
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Solicitation, Evaluation and Award', '', 3, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Solicitation', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain how a public buyer invites, compares, and selects suppliers, and why the process is documented the way it is."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The buyer publishes a request that tells suppliers what is needed and how to respond. A solicitation typically includes the scope or specifications, the instructions for responding and the deadline, and the evaluation criteria that say how responses will be judged. It also carries the required forms and terms, along with a contact for questions and the rules on communication during the process.","Public notice is common so that suppliers have a fair chance to see it. Many buyers allow questions and answer them for everyone, often through an addendum, so that no one has an informational edge. Module 5 covers the types of solicitations in detail."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Evaluation', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["After the deadline, responses are reviewed in three steps.","Compliance check: Did the supplier follow the instructions and submit what was required?","Evaluation against the stated criteria: Some processes look at price alone, while others weigh price together with quality, experience, and approach.","Documentation: Scoring and notes are kept so that the decision can be explained later.","Throughout, buyers evaluate against the criteria they published and not against new ones, since changing the standard after responses arrive would undo the fairness the process exists to protect."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Award', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The buyer selects the supplier according to the process. Depending on size and rules, the award may need approval from a manager, board, or council, and it may be announced publicly. After the award, the buyer and supplier finalize the contract.","Unsuccessful suppliers may be able to request a debrief or file a protest, depending on local rules, which is another reason the paper trail matters."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Rules for communication during a solicitation, public bid openings, debriefs, protest windows, and award announcements differ by entity."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l43-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What do buyers evaluate responses against?","explanation":"Buyers evaluate against the criteria they published and not new ones, because changing the standard after responses arrive would undo the fairness the process exists to protect.","points":1,"position":1,"options":[{"id":"a","label":"Whatever criteria the evaluators prefer once responses arrive"},{"id":"b","label":"Price alone, whichever method the buyer uses"},{"id":"c","label":"The criteria published in the solicitation"},{"id":"d","label":"The reputation each supplier has with the buyer"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Solicitation, evaluation, and award form the visible competitive core of the lifecycle, and fairness and documentation drive how each step is run."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"During an open solicitation, follow the buyer's communication rules strictly, because contact outside the designated channel can disqualify a supplier or taint the process."}$j$::jsonb);

  -- Lesson 4.4 -- After the Award: Administration and Closeout
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'After the Award: Administration and Closeout', '', 4, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Contract administration', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe what happens after a contract is awarded and why this stage matters to both sides."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Awarding the contract isn't the end, because someone still has to make sure the agreement is carried out. That means monitoring performance against the contract terms and deliverables, and managing changes, which are usually made through formal modifications or amendments. It also means reviewing and approving invoices before paying them, handling issues such as delays, quality problems, or disputes, and tracking dates such as renewals and expirations.","The buyer's contract administrator or project manager is often a different person from the one who ran the solicitation."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Closeout', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["When the work or term is complete, the buyer accepts the final deliverables, pays the final invoices, and releases any retained amounts. Records are filed and retained as required, and performance may be documented. Those records often have to be kept for a set period, because audits and public records requests can come years later."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The loop back', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["How a supplier performs becomes part of the buyer's experience, and in some places part of a formal record, which then shapes future procurements. The lifecycle is a loop, much like the cycle in Module 1."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l44-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What is the purpose of contract administration after award?","explanation":"Awarding the contract isn't the end, since someone still has to make sure it delivers what was agreed.","points":1,"position":1,"options":[{"id":"a","label":"Making sure the agreement is carried out, including monitoring performance and reviewing invoices"},{"id":"b","label":"Choosing the winning supplier from among the responses"},{"id":"c","label":"Writing the scope of work before the solicitation goes out"},{"id":"d","label":"Publishing the solicitation and answering supplier questions"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"The work isn't over at award, since administration and closeout determine whether the contract delivers and feed into the buyer's next decision."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Many buyers care as much about what happens after award as before it, so knowing how they track performance and invoicing shows you understand their full lifecycle."}$j$::jsonb);

  -- MODULE 4 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 4 Check', '', 5, 8, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 4 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 4 Check","tone":"info","body":"Answer every question correctly to unlock Module 5."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-m4-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"Which phase of the public lifecycle largely determines a procurement's success?","explanation":"Correct answer: Pre-solicitation, when the requirement and plan are set","points":1,"position":1,"options":[{"id":"a","label":"Closeout, when final deliverables are accepted"},{"id":"b","label":"Contract administration, when performance is monitored"},{"id":"c","label":"Pre-solicitation, when the requirement and plan are set"},{"id":"d","label":"Evaluation, when responses are scored"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-m4-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"Which pairing is correct?","explanation":"Correct answer: Evaluation: judging responses against published criteria","points":1,"position":2,"options":[{"id":"a","label":"Evaluation: judging responses against published criteria"},{"id":"b","label":"Requirement: selecting the winning supplier"},{"id":"c","label":"Closeout: writing the scope of work"},{"id":"d","label":"Planning: reviewing and paying invoices"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"pf-m4-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"Why do buyers often share answers to supplier questions with everyone?","explanation":"Correct answer: So no supplier has an informational advantage","points":1,"position":3,"options":[{"id":"a","label":"To save the buyer's staff time on follow-up calls"},{"id":"b","label":"To avoid having to write the solicitation in full"},{"id":"c","label":"To make the evaluation step shorter"},{"id":"d","label":"So no supplier has an informational advantage"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"pf-m4-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"During an open solicitation, the best practice is to:","explanation":"Correct answer: Use only the communication channel the buyer designates","points":1,"position":4,"options":[{"id":"a","label":"Contact the department head directly to learn more about the need"},{"id":"b","label":"Use only the communication channel the buyer designates"},{"id":"c","label":"Ask the end user how the evaluation scores are shaping up"},{"id":"d","label":"Hold all questions until after the award has been announced"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"pf-m4-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"A formal change to an existing contract is called a:","explanation":"Correct answer: Modification or amendment","points":1,"position":5,"options":[{"id":"a","label":"Solicitation"},{"id":"b","label":"Modification or amendment"},{"id":"c","label":"Addendum issued before award"},{"id":"d","label":"Closeout"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"pf-m4-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"Why do buyers retain records after closeout?","explanation":"Correct answer: Because audits and public records requests can come years later","points":1,"position":6,"options":[{"id":"a","label":"To keep track of which invoices are still unpaid"},{"id":"b","label":"To choose suppliers at random in future procurements"},{"id":"c","label":"Because retention is optional, so many entities simply skip it"},{"id":"d","label":"Because audits and public records requests can come years later"}],"correct_option_id":"d"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 5: Solicitations, Contracts and Purchasing Vehicles
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Solicitations, Contracts and Purchasing Vehicles', '', 5)
  returning id into v_m;

  -- Lesson 5.1 -- Solicitation Types
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Solicitation Types', '', 1, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The alphabet soup', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can define the common solicitation types (RFI, RFQ, IFB/ITB, RFP) and recognize when each is typically used."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Public buyers use different documents for different situations, and the table below lists the common ones."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["RFI: Request for Information. Typical use: Gathers information about the market or options before a purchase; it does not buy anything.","RFQ: Request for Quotation (or Quotes). Typical use: Clearly defined needs where price is the main difference; often faster and lighter.","IFB / ITB: Invitation for Bid / Invitation to Bid. Typical use: Tightly defined specifications; award typically goes to the lowest responsive and responsible bidder.","RFP: Request for Proposal. Typical use: Needs where more than price matters (experience, approach, service levels); award weighs these factors together with cost."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Words that trip people up', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Two terms in bidding are easy to confuse. A bid is responsive when it followed the instructions and met the requirements, and a bidder is responsible when it's capable of performing the work, for example because it's qualified and financially sound. A low bid that is either not responsive or not responsible can be rejected.","The abbreviations themselves cause trouble as well. RFQ has two meanings: it can stand for Request for Quotes, which is price-based and often informal, or for Request for Qualifications, which selects a firm on its qualifications and is used in some places for design and engineering services. Since the two work quite differently, check the document. IFB and ITB, by contrast, are used interchangeably in many places."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The name does not control', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A document's title matters less than the process that law or policy requires for that kind of purchase, so a solicitation called one thing may be required to follow another process. If grant funding is involved, the grant's requirements apply as well."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Which type a buyer may use for which purchase is usually set by state law or local policy. Some entities use lighter hybrids, sometimes called \"RFP lite,\" and the same term can carry different requirements in different places."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l51-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which solicitation type is typically used when needs are complex and more than price matters?","explanation":"An RFI informs, an RFQ prices, an IFB or ITB awards on low bid, and an RFP weighs value, which is why it suits complex needs.","points":1,"position":1,"options":[{"id":"a","label":"RFI (Request for Information)"},{"id":"b","label":"IFB / ITB (Invitation for Bid / to Bid)"},{"id":"c","label":"RFQ (Request for Quotes)"},{"id":"d","label":"RFP (Request for Proposal)"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"RFI informs, RFQ prices, IFB/ITB awards on low bid, and RFP weighs value, but terms vary by entity, which is why the document is worth reading and not just the title."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"When a buyer says \"we're putting out an RFQ,\" ask what they mean by it, because the question takes ten seconds and keeps you from preparing the wrong kind of response."}$j$::jsonb);

  -- Lesson 5.2 -- Choosing Between Price and Value
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Choosing Between Price and Value', '', 2, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Two award logics', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain why a buyer picks a price-based or value-based method, and what that means for how a response is judged."}$j$::jsonb),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'The buyer defines the need. If it can be defined tightly and price is the main difference, use a price-based method (IFB/ITB or RFQ) and award to the lowest responsive and responsible bidder. Otherwise use a value-based method (RFP) and award to the best overall proposal under published criteria.',
      'src', 'data:image/svg+xml;base64,' || replace(encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 760 392" font-family="sans-serif"><defs><marker id="a52" markerUnits="userSpaceOnUse" markerWidth="10" markerHeight="10" refX="9" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="280" y="10" width="200" height="46" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="380" y="37.666666666666664" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Buyer defines the need</text><line x1="380" y1="58" x2="380" y2="88" stroke="#334155" stroke-width="2" marker-end="url(#a52)"/><polygon points="380,90 495,140 380,190 265,140" fill="#fef3c7" stroke="#b45309"/><text x="380" y="136.83333333333334" text-anchor="middle" font-size="13" font-weight="600" fill="#78350f">Can the need be</text><text x="380" y="151.83333333333334" text-anchor="middle" font-size="13" font-weight="600" fill="#78350f">defined tightly?</text><polyline points="265,140 130,140 130,206" fill="none" stroke="#334155" stroke-width="2" marker-end="url(#a52)"/><text x="200" y="132" text-anchor="middle" font-size="11" fill="#334155">Yes: price is the main difference</text><polyline points="495,140 630,140 630,206" fill="none" stroke="#334155" stroke-width="2" marker-end="url(#a52)"/><text x="560" y="132" text-anchor="middle" font-size="11" fill="#334155">No: quality and approach matter</text><rect x="10" y="210" width="240" height="56" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="130" y="234.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Price-based</text><text x="130" y="251.16666666666666" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">IFB / ITB or RFQ</text><rect x="510" y="210" width="240" height="56" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="630" y="234.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Value-based</text><text x="630" y="251.16666666666666" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">RFP</text><line x1="130" y1="268" x2="130" y2="304" stroke="#334155" stroke-width="2" marker-end="url(#a52)"/><line x1="630" y1="268" x2="630" y2="304" stroke="#334155" stroke-width="2" marker-end="url(#a52)"/><rect x="10" y="308" width="240" height="70" rx="10" fill="#dcfce7" stroke="#15803d"/><text x="130" y="330.6666666666667" text-anchor="middle" font-size="14" font-weight="600" fill="#14532d">Award</text><text x="130" y="347.6666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#14532d">Lowest responsive and</text><text x="130" y="364.6666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#14532d">responsible bidder</text><rect x="510" y="308" width="240" height="70" rx="10" fill="#dcfce7" stroke="#15803d"/><text x="630" y="330.6666666666667" text-anchor="middle" font-size="14" font-weight="600" fill="#14532d">Award</text><text x="630" y="347.6666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#14532d">Best overall proposal under</text><text x="630" y="364.6666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#14532d">published criteria</text></svg>$svg$, 'UTF8'), 'base64'), E'\n', '')
    )),
    (v_p, 'rich_text', 3, $j${"body":["Best when. Price-based (IFB/ITB, RFQ): Specifications are precise; goods are standard. Value-based (RFP): Needs are complex; approach and experience matter.","How award is decided. Price-based (IFB/ITB, RFQ): Lowest price among those who qualify. Value-based (RFP): Published criteria weighing price with other factors.","Negotiation. Price-based (IFB/ITB, RFQ): Typically limited or none. Value-based (RFP): Often allowed in some form, depending on rules.","Effort for both sides. Price-based (IFB/ITB, RFQ): Lower. Value-based (RFP): Higher."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A common mistake', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Teams often misread \"lowest bid\" rules. In a price-based process, the buyer generally can't choose a more expensive bidder because they like that bidder better. In a value-based process the lowest price doesn't automatically win, yet the buyer is still limited to the published criteria when deciding."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why the choice of method is not about dollar size', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The choice usually depends on complexity, on how much quality matters, and on how much flexibility the buyer needs, and not simply on how much money is involved. The dollar thresholds in Module 3 decide how formal the process must be, which is a separate question from which philosophy it follows."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Some jurisdictions require price-based bidding for certain purchases, such as standard supplies or construction above a set amount, and allow value-based methods only for specific categories such as technology or professional services."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l52-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Does the dollar amount alone decide whether a buyer uses a price-based or value-based method?","explanation":"Dollar thresholds decide how formal the process must be, while the choice between price and value depends on complexity and on how much quality matters.","points":1,"position":1,"options":[{"id":"a","label":"Yes; large purchases always go through an RFP and small ones through an IFB"},{"id":"b","label":"No; the choice depends mainly on how tightly the need can be defined and how much quality matters"},{"id":"c","label":"Yes; small purchases use RFPs because they're simpler to evaluate"},{"id":"d","label":"Yes; the supplier chooses the method that suits its own pricing"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Price-based methods reward the lowest qualified price, while value-based methods reward the best overall proposal under the published criteria."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Understanding which logic the buyer is using tells you what they care about, whether that's precision and price or approach and experience."}$j$::jsonb);

  -- Lesson 5.3 -- Contract Types: Who Carries the Cost Risk
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Contract Types: Who Carries the Cost Risk', '', 3, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The core idea', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe the main ways contracts set price and explain who carries the risk of cost overruns under each."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Contract types differ mostly in how they answer one question: if the work costs more or less than expected, who feels it?"]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Fixed price: One agreed price for defined work. Who carries cost risk: The supplier.","Fixed price with incentives: Target price with adjustments for performance or cost outcomes, often with a ceiling. Who carries cost risk: Shared.","Time and materials (T&M): Buyer pays set hourly rates for labor plus the cost of materials, usually up to a limit. Who carries cost risk: Mostly the buyer, with a cap as protection.","Cost-reimbursement: Buyer reimburses allowed costs plus a fee, usually up to an estimate. Who carries cost risk: Mostly the buyer.","Unit price: A set price per unit (per item, per hour, per ton), with the total depending on quantity ordered. Who carries cost risk: Depends on volume."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why a buyer picks one', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Fixed price fits well-defined work, where the supplier can estimate costs reliably, and it's common in sealed-bid, price-based processes. Time and materials and cost-reimbursement contracts suit work that is hard to define in advance, but they need more oversight because the final cost isn't known up front. Incentive structures try to reward efficiency or performance by tying fees or profit to outcomes."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Where you''ll see them', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["At the state and local level, fixed-price and unit-price arrangements are very common. Cost-reimbursement structures show up more in the federal world and in specialized work, so treat the federal-style variations (cost-plus-fixed-fee, award-fee, and similar) as awareness and not as daily vocabulary."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Some entities restrict certain contract types, for example by limiting cost-based pricing, or they require extra approval for open-ended arrangements."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l53-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which contract type typically leaves most cost risk with the buyer, and usually carries a cap for protection?","explanation":"Contract types allocate cost risk: fixed price pushes it toward the supplier, while time and materials leaves most of it with the buyer, which is why a cap is usual.","points":1,"position":1,"options":[{"id":"a","label":"Firm fixed price"},{"id":"b","label":"Time and materials"},{"id":"c","label":"Fixed price with incentives"},{"id":"d","label":"Sole-source award"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Contract types allocate cost risk, and the tighter the scope, the more a buyer can push that risk to the supplier with a fixed price."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Listening to which pricing structure a buyer prefers shows how confident they are in their scope and how they want to manage risk."}$j$::jsonb);

  -- Lesson 5.4 -- Purchasing Vehicles: Master Agreements and Indefinite-Quantity Contracts
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Purchasing Vehicles: Master Agreements and Indefinite-Quantity Contracts', '', 4, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'One competition, many purchases', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain what a purchasing vehicle is and how buyers use agreements that are competed once and used many times."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A purchasing vehicle is an agreement set up so that a buyer can make repeated purchases without running a full competition each time. It takes several common forms."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Master agreement / price agreement: Pre-negotiated terms and prices with one or more suppliers; buyers order as needed.","On-call / as-needed contract: A supplier is available to be called when a need arises (common for recurring services).","Indefinite-quantity (IDIQ-style) contract: A contract for an unspecified quantity within stated limits and a fixed period; specific work is ordered through task or delivery orders.","Blanket purchase agreement (BPA): A simplified arrangement for repeat purchases of similar items.","Cooperative contract: A contract competed by another entity that others may use (Module 3)."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'How indefinite-quantity contracts work', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The federal definition serves as the model here. An indefinite-quantity contract covers an indefinite quantity of goods or services within stated limits over a fixed period, often a base period with optional extension years. A minimum guarantee commits the buyer to purchase at least a set amount, and specific needs are filled by task orders (for services) or delivery orders (for supplies) placed as they arise, with the price and detail fixed when each order goes out.","Who holds the contract is the other major variable. Under a single award, one supplier holds it, which is simpler but can lock the buyer in to that vendor. Under a multiple award, several qualified suppliers hold contracts and each order is competed among them, an arrangement generally favored for keeping competition alive."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why it matters to suppliers', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Winning a vehicle often means getting on a list and not receiving any guaranteed work. Revenue depends on orders actually being placed and, in multiple-award vehicles, on winning them."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l54-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"In a multiple-award indefinite-quantity contract, how is each specific order typically placed?","explanation":"Competing each order among the qualified suppliers keeps competition alive, which is why buyers generally favor multiple-award vehicles.","points":1,"position":1,"options":[{"id":"a","label":"It always goes to the first supplier on the list"},{"id":"b","label":"It goes through a brand-new formal solicitation open to anyone"},{"id":"c","label":"It is competed among the qualified suppliers who hold the contract"},{"id":"d","label":"The suppliers decide among themselves who takes each order"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"A vehicle is an agreement competed once and used many times, and being on one creates opportunity without guaranteeing revenue."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Ask whether the purchase will run through an existing vehicle, since in that case the competition may already be over and the conversation is about how to get on, or use, that vehicle."}$j$::jsonb);

  -- MODULE 5 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 5 Check', '', 5, 9, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 5 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 5 Check","tone":"info","body":"Answer every question correctly to unlock Module 6."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-m5-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"Which solicitation type is used only to gather information and does not buy anything?","explanation":"Correct answer: RFI","points":1,"position":1,"options":[{"id":"a","label":"RFI"},{"id":"b","label":"IFB"},{"id":"c","label":"RFQ"},{"id":"d","label":"RFP"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-m5-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"An IFB/ITB is typically awarded to:","explanation":"Correct answer: The lowest responsive and responsible bidder","points":1,"position":2,"options":[{"id":"a","label":"The firm with the strongest presentation and references"},{"id":"b","label":"The most experienced firm among those who bid"},{"id":"c","label":"The lowest responsive and responsible bidder"},{"id":"d","label":"The first qualified bidder to submit a response"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"pf-m5-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"What does \"responsible\" mean for a bidder?","explanation":"Correct answer: The bidder is capable of performing the work","points":1,"position":3,"options":[{"id":"a","label":"The bid was submitted before the deadline"},{"id":"b","label":"The bid followed the required format and forms"},{"id":"c","label":"The bidder is capable of performing the work"},{"id":"d","label":"The bid had the lowest price of those received"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"pf-m5-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"Under a firm fixed-price contract, who carries the risk of cost overruns?","explanation":"Correct answer: The supplier","points":1,"position":4,"options":[{"id":"a","label":"The supplier"},{"id":"b","label":"The buyer, who pays whatever the work ends up costing"},{"id":"c","label":"Both sides equally, unless the contract says otherwise"},{"id":"d","label":"The agency's auditor"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"pf-m5-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"Why do T&M contracts usually include a cap?","explanation":"Correct answer: To protect the buyer from open-ended cost","points":1,"position":5,"options":[{"id":"a","label":"To make the contract less expensive for the supplier to perform"},{"id":"b","label":"To remove the need for hourly rates in the contract"},{"id":"c","label":"To avoid the documentation a fixed-price contract needs"},{"id":"d","label":"To protect the buyer from open-ended cost"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"pf-m5-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"In an indefinite-quantity contract, how is a specific need fulfilled?","explanation":"Correct answer: Through task or delivery orders placed under the contract","points":1,"position":6,"options":[{"id":"a","label":"Through a new solicitation each time a need arises"},{"id":"b","label":"Through task or delivery orders placed under the contract"},{"id":"c","label":"Through a sole-source award to the original supplier"},{"id":"d","label":"Through a protest filed by the other qualified suppliers"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"pf-m5-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"What does winning a place on a purchasing vehicle usually guarantee?","explanation":"Correct answer: The opportunity to receive orders, without guaranteed work","points":1,"position":7,"options":[{"id":"a","label":"A fixed amount of revenue over the contract term"},{"id":"b","label":"The opportunity to receive orders, without guaranteed work"},{"id":"c","label":"Exclusive rights to every order the buyer places"},{"id":"d","label":"Protection from competition on future orders"}],"correct_option_id":"b"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 6: Rules, Ethics and Compliance
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Rules, Ethics and Compliance', '', 6)
  returning id into v_m;

  -- Lesson 6.1 -- Fairness and Conduct
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Fairness and Conduct', '', 1, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The standard buyers hold themselves to', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe the conduct rules public buyers follow during a solicitation, and what they mean for how our team communicates with them."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Public buyers are held to a simple test: would this decision hold up if it were fully disclosed to the public? Nearly every rule in this module comes from that idea, and it explains the practices buyers follow.","Buyers treat every bidder equally, applying the same requirements to all of them, and they share material information equally too, through written answers or formal amendments (addenda) and not through private conversations. Contacts with suppliers during a solicitation are recorded, because undocumented contact raises protest risk. Requirements describe what is needed rather than one supplier's product, and an award without competition is treated as an exception that has to be visibly justified."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What this means for us', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Our own conduct has to match. The rules below are firm, because a violation can disqualify a response or damage a buyer's relationship with us.","During an open solicitation, communicate only through the channel the buyer designates. Many entities restrict or prohibit contact with staff and officials outside that channel, sometimes with penalties up to disqualification.","Do not ask for, and do not offer, information that others cannot get.","Do not coordinate pricing or bids with competitors. Collusion and price-fixing are serious violations.","Do not misrepresent qualifications, capabilities, or products."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Some entities define a formal \"no-contact\" or \"cone of silence\" period with specific start and end points. Read the solicitation to see what applies."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l61-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What is the \"public trust\" test public buyers hold themselves to?","explanation":"Nearly every conduct rule comes from this test, which is why buyers give every bidder equal treatment, share equal information, and document their contacts.","points":1,"position":1,"options":[{"id":"a","label":"Would this decision hold up if it were fully disclosed to the public?"},{"id":"b","label":"Did the lowest bidder end up winning the award?"},{"id":"c","label":"Did the supplier have a good relationship with staff?"},{"id":"d","label":"Was the process finished as quickly as possible?"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Fairness is the governing rule in public buying, which is why buyers give every bidder the same treatment and the same information and keep a record of every contact."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Relationship-building is fine before a solicitation opens, but once it opens, check the solicitation's contact rules first and follow them strictly."}$j$::jsonb);

  -- Lesson 6.2 -- Conflicts of Interest and Gifts
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Conflicts of Interest and Gifts', '', 2, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Conflicts of interest', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can recognize situations that create a conflict of interest or an improper gift, and know to stop and ask."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A conflict of interest exists when someone involved in a purchasing decision has a personal or financial interest that could affect, or appear to affect, their judgment. Public buyers typically require evaluators and decision-makers to disclose such interests, and they remove or replace conflicted people from the process. If a conflict surfaces late, scores can be disregarded or a response re-evaluated.","Buyers pay attention to perceived conflicts as well as actual ones, because public trust depends on how a decision looks as well as on how it was made. They also watch for past-employment relationships, such as a supplier who recently employed a decision-maker, or the reverse."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Gifts and improper benefits', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Gifts, bribes, and kickbacks are among the most serious concerns in public buying. Many entities set strict limits, and some prohibit gifts from suppliers altogether, even small ones such as meals."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A practical rule for our team', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["You are unsure whether something is a gift: Do not offer it. Ask first.","A buyer declines a coffee or lunch: Respect the decision without comment.","Someone on our team has a personal tie to a buyer (family, past job, financial interest): Tell your manager before engaging.","A buyer tells you about a conflict they have: Do not push them to engage; let them follow their process."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Gift limits and disclosure rules differ widely by entity and state. The safest default is to offer nothing of value to anyone involved in a purchase."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l62-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"You are not sure whether offering a buyer lunch counts as a gift. What should you do?","explanation":"When there is any doubt about a gift or a personal tie, stop and ask before acting, because many entities limit or prohibit gifts from suppliers altogether.","points":1,"position":1,"options":[{"id":"a","label":"Offer it, since a lunch is too small to matter"},{"id":"b","label":"Offer it, but keep it between the two of you"},{"id":"c","label":"Send it to their office instead of offering it in person"},{"id":"d","label":"Do not offer it, and ask first"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"When there's any doubt about a gift or a personal tie, stop and ask before acting."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Don't push a courtesy that a buyer has declined, since their rules protect them and respecting those rules builds trust."}$j$::jsonb);

  -- Lesson 6.3 -- Public Records and Confidential Information
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Public Records and Confidential Information', '', 3, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Most of what you submit is public', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain why bids and proposals are usually public, and how a supplier protects genuinely confidential information."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["In many jurisdictions, the bids and proposals a public entity receives become public records. After the appropriate point in the process, often after award or after bid opening, anyone, including competitors, may request and review them. A response should therefore be written on the assumption that a competitor may read it."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Protecting real trade secrets', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Vendors can sometimes keep genuinely confidential information from being released, but the standard is narrow. Using one state's framework as an example, protection generally requires that the information meet four conditions:","It has independent commercial value because it is not generally known, and the owner takes reasonable steps to keep it secret.","It belongs to a business or legal entity.","It was provided in connection with a public contract, bid, or proposal.","It was marked \"confidential\" or \"trade secret\" when first provided.","In practice, most of a proposal (compliance, terms, basic company information, and in many places prices) does not qualify. Only truly secret items, such as formulas, proprietary methods, or customer lists, may. Marking is required but not sufficient, so stamping everything \"confidential\" protects nothing, and buyers may ask the vendor to explain its basis for protection, release the non-secret portions, and redact the rest."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Public records laws and trade secret exemptions differ widely. Some entities require specific marking methods or separate redacted copies. Read the solicitation's instructions and consult counsel for anything important."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l63-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which information is most likely to qualify as a protected trade secret in a proposal?","explanation":"Marking is required but not sufficient, so only information that is truly secret, such as a proprietary method, may qualify.","points":1,"position":1,"options":[{"id":"a","label":"The company's name, address, and basic company information"},{"id":"b","label":"Compliance forms and standard contract terms"},{"id":"c","label":"A proprietary method that isn't generally known and was marked confidential when provided"},{"id":"d","label":"Any page the supplier chose to stamp \"confidential\""}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Proposals should be written assuming they'll become public, and only what truly qualifies should be protected, marked in the way the buyer's instructions describe."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"If a buyer mentions a records request, stay calm and cooperative, since it's a routine part of public buying and not a sign of a problem."}$j$::jsonb);

  -- Lesson 6.4 -- Protests
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Protests', '', 4, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What a protest is', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain what a protest is, why buyers document so carefully because of them, and why timing matters."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A protest is a formal challenge to a solicitation or an award, usually filed by a supplier who believes the process was unfair or the rules weren't followed. Protest rules at the state and local level are a patchwork of statutes, policies, and local ordinances, so they vary a lot."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Typical grounds', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Protests usually rest on a procedural complaint, such as the buyer failing to follow its own stated evaluation criteria or using unstated ones. Other common grounds include unequal treatment of bidders (a requirement waived for one and not for another), a wrong finding on responsiveness or responsibility, or a winner who lacked a mandatory qualification. Conflicts of interest, biased specifications, improper communications, and errors in evaluating price or cost also appear.","Disagreeing with a score is usually not enough. Many reviewing bodies defer to the buyer and look for conduct that was arbitrary, biased, or unfair."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why timing matters', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Deadlines are often very short. Some jurisdictions require filing within about five to ten business days of the award notice, and some set earlier deadlines for challenging the solicitation's terms. A protest often does not automatically pause the contract, and the typical path runs from a protest to the agency, to an administrative appeal or hearing, and possibly to court. Remedies tend to be limited to re-evaluation, cancellation and re-solicitation, and similar steps, and money damages are often unavailable."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What it means for us', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Any protest decision, whether ours or a competitor's, is a matter for management and counsel, not a rep-level action. If a buyer mentions a protest, escalate immediately, because the deadlines move fast, and expect the buyer to be cautious and formal while a protest is possible."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Who decides a protest, the filing deadline, whether a bond or sworn statement is needed, and what remedies exist all differ."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l64-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why does timing matter so much in a protest?","explanation":"Because the deadlines move fast, any mention of a protest should be escalated immediately to management and counsel.","points":1,"position":1,"options":[{"id":"a","label":"Deadlines are often very short, and a protest usually doesn't automatically pause the contract"},{"id":"b","label":"Protests can be filed at any time after an award is made"},{"id":"c","label":"Protest deadlines are the same 90 days in every jurisdiction"},{"id":"d","label":"Deadlines apply only to the buyer and never to the protester"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Protests are real, procedural, and subject to short deadlines, which is why buyers document so carefully and why we escalate to management and counsel rather than improvise."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Do not discuss a competitor's award with a buyer, and do not encourage or discourage a protest. Escalate internally."}$j$::jsonb);

  -- Lesson 6.5 -- Preference and Small-Business Programs
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Preference and Small-Business Programs', '', 5, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why these programs exist', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe the common types of local-preference and small-business programs and why they differ so much between entities."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Many governments want public spending to support small, local, minority-owned, or women-owned businesses, or to serve other policy goals. These programs often rely on certification, meaning official recognition that a business qualifies."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Common forms', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Percentage preference: A qualifying bidder can win even if its price is somewhat higher, within a set margin.","Bid discount or points: A price discount or bonus evaluation points for qualifying firms.","Set-aside / reserve: Certain purchases are limited to qualifying businesses.","Subcontracting goals or requirements: Prime suppliers must include qualifying subcontractors.","First opportunity on small purchases: Qualifying firms get the first chance to quote.","Outreach requirements: Buyers must invite qualifying firms to quote."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["One research overview illustrates the range with percentage preferences from roughly 5% up to 15% in some places, and with a number of states using reciprocal rules that add a percentage to out-of-state bids. These are examples of variety and not figures to repeat, and the overview's data is older than most of this course."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Legal footing', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Courts have generally upheld local preferences, especially where the government acts as the buyer and shows a legitimate purpose, though challenges happen and trade agreements can limit some programs."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Varies by jurisdiction","tone":"warning","body":"Whether a program exists, who qualifies, how certification works, and how large any preference is depend entirely on the entity and often on the funding source."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l65-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What usually proves that a business qualifies for a preference or set-aside program?","explanation":"These programs typically rely on certification, and whether a program exists at all depends on the entity.","points":1,"position":1,"options":[{"id":"a","label":"A statement in the proposal's cover letter"},{"id":"b","label":"A place on a purchasing vehicle"},{"id":"c","label":"A record of having won a prior contract"},{"id":"d","label":"Certification"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Preference programs vary widely, so it's best to ask whether a buyer has one and how qualification works instead of assuming one applies."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"If a buyer mentions a preference or certification program, ask where to find the details. Do not advise a business on whether to claim a status, because that decision belongs to the business and its counsel."}$j$::jsonb);

  -- MODULE 6 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 6 Check', '', 6, 9, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 6 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 6 Check","tone":"info","body":"Answer every question correctly to unlock Module 7."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-m6-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"During an open solicitation, how should you communicate with the buyer?","explanation":"Correct answer: Only through the channel the buyer designates","points":1,"position":1,"options":[{"id":"a","label":"By calling the department head, who knows the need best"},{"id":"b","label":"Through a mutual contact who can pass along questions"},{"id":"c","label":"Not at all, even to ask a clarifying question about the requirements"},{"id":"d","label":"Only through the channel the buyer designates"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-m6-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"A buyer politely declines a lunch offer. The best response is to:","explanation":"Correct answer: Respect the decision without comment","points":1,"position":2,"options":[{"id":"a","label":"Respect the decision without comment"},{"id":"b","label":"Insist, since a modest lunch is unlikely to matter"},{"id":"c","label":"Mail something smaller to their office instead"},{"id":"d","label":"Offer to cover coffee at a later meeting"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"pf-m6-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"Why do buyers care about perceived conflicts, not just actual ones?","explanation":"Correct answer: Public trust depends on how a decision looks as well as how it was made","points":1,"position":3,"options":[{"id":"a","label":"Perceived conflicts are illegal in every jurisdiction"},{"id":"b","label":"Disclosure forms are required whether or not a conflict exists"},{"id":"c","label":"Public trust depends on how a decision looks as well as how it was made"},{"id":"d","label":"Evaluators are expected to avoid every acquaintance with a supplier"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"pf-m6-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"A supplier stamps \"CONFIDENTIAL\" on every page of its proposal. This:","explanation":"Correct answer: Does not by itself protect information, and only genuine trade secrets may qualify","points":1,"position":4,"options":[{"id":"a","label":"Guarantees that nothing in the proposal will be released"},{"id":"b","label":"Is required on every proposal submitted to a public buyer"},{"id":"c","label":"Does not by itself protect information, and only genuine trade secrets may qualify"},{"id":"d","label":"Prevents competitors from requesting a copy of the proposal"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"pf-m6-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is a typical protest ground?","explanation":"Correct answer: The buyer used evaluation factors that were not stated in the solicitation","points":1,"position":5,"options":[{"id":"a","label":"The buyer used evaluation factors that were not stated in the solicitation"},{"id":"b","label":"The winner's price was higher than the protester expected"},{"id":"c","label":"The buyer asked bidders for references"},{"id":"d","label":"The buyer announced the award earlier than planned"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"pf-m6-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"A buyer mentions that a competitor may protest the award. What should you do?","explanation":"Correct answer: Escalate internally, because deadlines are short and decisions belong to management and counsel","points":1,"position":6,"options":[{"id":"a","label":"Point out the competitor's weaknesses so the buyer is prepared"},{"id":"b","label":"Encourage the protest, since a re-evaluation might help us"},{"id":"c","label":"Treat it as the buyer's business and take no further action"},{"id":"d","label":"Escalate internally, because deadlines are short and decisions belong to management and counsel"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"pf-m6-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"Which statement about local-preference programs is most accurate?","explanation":"Correct answer: They vary widely, so you should ask whether a buyer has one and how it works","points":1,"position":7,"options":[{"id":"a","label":"All entities use the same program, with the same percentages"},{"id":"b","label":"They vary widely, so you should ask whether a buyer has one and how it works"},{"id":"c","label":"They never apply to purchases below the formal bidding level"},{"id":"d","label":"Only federal buyers are allowed to use them"}],"correct_option_id":"b"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 7: The Federal Snapshot (GovCon)
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'The Federal Snapshot (GovCon)', '', 7)
  returning id into v_m;

  -- Lesson 7.1 -- How Federal Buying Differs
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'How Federal Buying Differs', '', 1, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'One rulebook, many agencies', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain, in plain terms, how federal buying differs from state and local buying, and why we treat it as a snapshot."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["State and local buying is a patchwork in which every entity sets its own rules (Module 3), and federal buying is closer to the opposite. A single government-wide regulation, the Federal Acquisition Regulation (FAR), governs most executive-branch purchasing, and agencies add their own supplements on top."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Rulebook. State / county / local: Many, different per entity. Federal: One main regulation (FAR) plus agency supplements.","Where opportunities post. State / county / local: Entity websites, bid portals, various. Federal: Largely one place: SAM.gov.","Scale. State / county / local: Wide range, usually smaller. Federal: Very large, with big multi-year vehicles.","Registration. State / county / local: Varies; often vendor registration with each entity. Federal: A government-wide registration is needed to receive awards.","Small business programs. State / county / local: Vary widely. Federal: Standardized national programs and goals."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What stays the same', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The Module 1 cycle, the Module 4 lifecycle, and the principles from Module 2 (competition, transparency, and accountability) all apply in federal buying as well. The underlying process is the same, though the rulebook around it is longer and the dollar amounts are larger."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why this is a snapshot', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Our product and our focus are state and local. The federal world is large, specialized, and changing, so this module teaches vocabulary and orientation and doesn't try to teach anyone how to win federal work."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l71-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is a structural difference of federal buying compared with state and local buying?","explanation":"Federal buying follows the same process as state and local buying, but under one large regulation and one main opportunity portal.","points":1,"position":1,"options":[{"id":"a","label":"Each agency writes completely separate rules from scratch"},{"id":"b","label":"One main government-wide regulation (the FAR) and largely one main opportunity portal (SAM.gov)"},{"id":"c","label":"Federal buyers aren't required to use competition"},{"id":"d","label":"Opportunities are posted only on local bid boards"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Federal buying is the same process under one large regulation and one main opportunity portal, and we keep it light because our focus is state and local."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer or prospect","tone":"info","body":"If someone says \"we want to do federal too,\" listen first. The honest answer is that federal is a different world with a longer runway, and our team shouldn't promise expertise we haven't built."}$j$::jsonb);

  -- Lesson 7.2 -- The FAR and the Federal Thresholds
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'The FAR and the Federal Thresholds', '', 2, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What the FAR is', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain what the FAR is, name the two thresholds that most often come up, and describe why the FAR is in motion right now."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The FAR is the main set of rules for how federal executive agencies acquire goods and services. It covers planning, solicitation, evaluation, contract types, small business programs, and administration, and agencies publish supplements for their own needs."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Two thresholds worth knowing', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Federal purchasing scales its formality by dollar size, as state and local buying does (Module 3), and two lines come up constantly."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Micro-purchase threshold: Below it, buyers can make small purchases with minimal competition requirements. Current figure (as of Oct. 1, 2025): $15,000 (was $10,000).","Simplified acquisition threshold (SAT): Below it, buyers can use streamlined, simplified procedures. Current figure (as of Oct. 1, 2025): $350,000 (was $250,000)."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["The FAR Council adjusts these thresholds for inflation periodically, so numbers that were right a few years ago may be stale. Other thresholds, such as the triggers for cost or pricing data and for subcontracting plans, were adjusted at the same time."]}$j$::jsonb),
    (v_p, 'callout', 4, $j${"title":"Do not repeat these in conversation as permanent facts.","tone":"warning","body":"If a federal figure matters to a decision, check acquisition.gov."}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The FAR is being rewritten', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The federal government has been carrying out what it calls the Revolutionary FAR Overhaul, which aims to streamline the regulation. Agencies have been applying the streamlined approach through temporary deviations, and in mid-2026 the formal rulemaking process began, with proposed rules released in batches and more still expected.","For us, that has three practical consequences. Specific FAR part language and procedures may shift, so change is the thing to expect. FAR part numbers are more likely to move than the general ideas, so it's wiser to teach only a few well-known ones. And for anything that matters, the right source is the current official one at acquisition.gov."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l72-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What is the difference between the micro-purchase threshold and the simplified acquisition threshold?","explanation":"Both thresholds are adjusted over time, so check current official sources such as acquisition.gov before relying on a figure.","points":1,"position":1,"options":[{"id":"a","label":"They are the same figure, and agencies use the two names interchangeably"},{"id":"b","label":"The micro-purchase line is lower and means minimal competition, while the simplified acquisition line is higher and allows streamlined procedures"},{"id":"c","label":"The micro-purchase line is the higher of the two, and it allows streamlined procedures"},{"id":"d","label":"Both thresholds apply only to state and local buyers, so federal buyers use neither"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"The FAR is the main federal rulebook, and because its thresholds are adjusted over time and the regulation itself is in the middle of a rewrite, current sources should be checked before relying on any specific."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer or prospect","tone":"info","body":"If a prospect quotes a federal rule or threshold, don't correct it from memory; say you'll confirm it against the current source."}$j$::jsonb);

  -- Lesson 7.3 -- Finding Federal Opportunities
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Finding Federal Opportunities', '', 3, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Three main routes', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can name the main routes into federal work and describe in one sentence what SAM.gov and contract vehicles are."}$j$::jsonb),
    (v_p, 'image', 2, jsonb_build_object(
      'alt', 'Federal opportunities come through SAM.gov postings, contract vehicles (GSA Multiple Award Schedule, GWACs and other multi-agency vehicles), and subcontracting and partnerships',
      'src', 'data:image/svg+xml;base64,' || replace(encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 290" font-family="sans-serif"><defs><marker id="a73" markerUnits="userSpaceOnUse" markerWidth="10" markerHeight="10" refX="9" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="330" y="10" width="240" height="50" rx="10" fill="#ede9fe" stroke="#6d28d9"/><text x="450" y="40" text-anchor="middle" font-size="15" font-weight="600" fill="#4c1d95">Federal opportunities</text><line x1="450" y1="60" x2="130" y2="106" stroke="#334155" stroke-width="2" marker-end="url(#a73)"/><rect x="10" y="110" width="240" height="56" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="130" y="134.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">SAM.gov</text><text x="130" y="151.16666666666666" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">postings</text><line x1="450" y1="60" x2="450" y2="106" stroke="#334155" stroke-width="2" marker-end="url(#a73)"/><rect x="330" y="110" width="240" height="56" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="450" y="134.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Contract</text><text x="450" y="151.16666666666666" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">vehicles</text><line x1="450" y1="60" x2="770" y2="106" stroke="#334155" stroke-width="2" marker-end="url(#a73)"/><rect x="650" y="110" width="240" height="56" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="770" y="134.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Subcontracting</text><text x="770" y="151.16666666666666" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">and partnerships</text><line x1="400" y1="168" x2="250" y2="214" stroke="#334155" stroke-width="2" marker-end="url(#a73)"/><line x1="500" y1="168" x2="650" y2="214" stroke="#334155" stroke-width="2" marker-end="url(#a73)"/><rect x="130" y="218" width="250" height="56" rx="10" fill="#dcfce7" stroke="#15803d"/><text x="255" y="242.33333333333334" text-anchor="middle" font-size="13" font-weight="600" fill="#14532d">GSA Multiple Award</text><text x="255" y="258.33333333333337" text-anchor="middle" font-size="13" font-weight="600" fill="#14532d">Schedule</text><rect x="520" y="218" width="250" height="56" rx="10" fill="#dcfce7" stroke="#15803d"/><text x="645" y="242.33333333333334" text-anchor="middle" font-size="13" font-weight="600" fill="#14532d">GWACs and other</text><text x="645" y="258.33333333333337" text-anchor="middle" font-size="13" font-weight="600" fill="#14532d">multi-agency vehicles</text></svg>$svg$, 'UTF8'), 'base64'), E'\n', '')
    )),
    (v_p, 'rich_text', 3, $j${"body":["SAM.gov. The central federal site where most contract opportunities are posted, and where businesses register to be eligible for awards. Registration steps change and are administered by the government, so always use the official site for current requirements.","Contract vehicles. Pre-competed agreements that agencies buy from (see Module 5). The GSA Multiple Award Schedule (MAS) is a long-running vehicle in which qualified businesses are pre-approved and agencies order from the list; it guarantees no sales. Typical entry requirements include time in business, financial statements, and past performance, with a startup pathway available. GWACs and other multi-agency contracts are governmentwide vehicles with limited proposal windows, and most are awarded to large businesses unless set aside for small ones.","Subcontracting and partnering. Smaller firms often enter federal work by supporting an existing prime contractor, through teaming, joint ventures, or mentor-protégé arrangements, with help from local Procurement Technical Assistance Centers (PTACs)."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A realistic framing', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Most newcomers don't start by winning large federal prime contracts. The common path is to learn the system, register, find smaller opportunities or subcontract roles, and build past performance over time."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l73-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What is a common way for a smaller firm to enter federal work?","explanation":"SAM.gov is the front door and vehicles are shortcuts for buyers, while subcontracting is a common on-ramp for newcomers.","points":1,"position":1,"options":[{"id":"a","label":"Winning a large governmentwide contract as a first award"},{"id":"b","label":"Skipping SAM.gov registration to save time"},{"id":"c","label":"Subcontracting or teaming with an existing prime contractor"},{"id":"d","label":"Relying on guaranteed sales from a GSA schedule listing"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"SAM.gov is the front door, vehicles are shortcuts for buyers, and subcontracting is a common on-ramp for newcomers."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer or prospect","tone":"info","body":"If a prospect asks how to get into federal work, point to SAM.gov and PTACs as starting points, and be candid that it's a long game."}$j$::jsonb);

  -- Lesson 7.4 -- Federal Small Business Programs
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Federal Small Business Programs', '', 4, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The goals', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe the federal small business goal, the \"Rule of Two,\" and the names of the main preference programs."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Federal agencies have government-wide goals for how much contracting goes to small businesses. As of the source below (updated July 2026), the overall goal is at least 23% of prime contract dollars to small businesses. There are also separate goals for small disadvantaged businesses (5%), women-owned small businesses (5%), service-disabled veteran-owned small businesses (5%), and HUBZone small businesses (3%). In fiscal 2025, small businesses received roughly 27.6% of prime dollars."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Set-asides and the Rule of Two', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Federal competition is generally \"full and open,\" but agencies can reserve certain contracts for small businesses. Under the Rule of Two, a contract is set aside when the contracting officer reasonably expects offers from at least two responsible small businesses that are competitive on price, quality, and delivery."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The main programs', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["8(a) Business Development: Firms owned and controlled by socially and economically disadvantaged individuals; set-asides, sole-source awards, and business development support, with a nine-year term.","HUBZone: Small businesses located in SBA-designated areas; set-asides, sole-source awards, and a price evaluation preference of up to 10%.","WOSB: Women-owned small businesses, in industries where women-owned firms are substantially underrepresented in federal contracting.","SDVOSB: Firms at least 51% owned and controlled by service-disabled veterans."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Do not advise a business on whether it qualifies.","tone":"warning","body":"Eligibility is determined through certification, and our role is to describe the programs, not to decide anyone's status."}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l74-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which statement about federal small business programs is accurate?","explanation":"Our role is to describe the programs and point to the official certification source, because certifying a business isn't something we do.","points":1,"position":1,"options":[{"id":"a","label":"Programs such as 8(a) and HUBZone are standardized nationally, and eligibility is determined through certification"},{"id":"b","label":"They vary from city to city, like local preference programs"},{"id":"c","label":"They guarantee a contract to any small business that applies"},{"id":"d","label":"A sales rep can decide whether a given business qualifies"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Federal small business programs are standardized and goal-driven, and our role is to describe them, since certifying a business is something only the official process can do."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer or prospect","tone":"info","body":"If a business asks about a program, explain what it is, point them to the official certification source, and stop there."}$j$::jsonb);

  -- MODULE 7 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 7 Check', '', 5, 9, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 7 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 7 Check","tone":"info","body":"Answer every question correctly to unlock Module 8."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-m7-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"What is a major structural difference between federal and state/local buying?","explanation":"Correct answer: Federal buying runs under one main government-wide regulation, the FAR","points":1,"position":1,"options":[{"id":"a","label":"Federal buying doesn't use competition between suppliers"},{"id":"b","label":"Federal buying runs under one main government-wide regulation, the FAR"},{"id":"c","label":"Federal buying is done without written contracts"},{"id":"d","label":"State and local buying is always funded by federal money"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-m7-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"Where are most federal contract opportunities posted?","explanation":"Correct answer: On SAM.gov","points":1,"position":2,"options":[{"id":"a","label":"In the legal notices of local newspapers"},{"id":"b","label":"On each buyer's private email list of approved suppliers"},{"id":"c","label":"Only on GSA schedule pages"},{"id":"d","label":"On SAM.gov"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"pf-m7-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"Why should our team avoid quoting federal dollar thresholds from memory?","explanation":"Correct answer: They are adjusted over time, so they must be checked against current sources","points":1,"position":3,"options":[{"id":"a","label":"They are adjusted over time, so they must be checked against current sources"},{"id":"b","label":"The thresholds are confidential and can't be shared"},{"id":"c","label":"They only apply to state and local buyers"},{"id":"d","label":"They have been the same for decades, so memory is unreliable"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"pf-m7-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"Does being on the GSA Multiple Award Schedule guarantee sales?","explanation":"Correct answer: No, it creates an opportunity to be ordered from","points":1,"position":4,"options":[{"id":"a","label":"Yes, because agencies are required to buy from it"},{"id":"b","label":"Yes, up to a fixed amount set when the supplier joins"},{"id":"c","label":"No, it creates an opportunity to be ordered from"},{"id":"d","label":"Only for large businesses with past performance"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"pf-m7-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"Which describes the Rule of Two?","explanation":"Correct answer: A contract is set aside for small business when the officer reasonably expects offers from at least two responsible, competitive small businesses","points":1,"position":5,"options":[{"id":"a","label":"A contract can be awarded only when two bidders respond"},{"id":"b","label":"Two agencies must approve each federal award"},{"id":"c","label":"A contract is set aside for small business when the officer reasonably expects offers from at least two responsible, competitive small businesses"},{"id":"d","label":"Each business may hold no more than two federal contracts"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"pf-m7-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"A prospect asks whether their company qualifies as a HUBZone business. What is the right response?","explanation":"Correct answer: Explain what the program is and point them to the official certification source","points":1,"position":6,"options":[{"id":"a","label":"Explain what the program is and point them to the official certification source"},{"id":"b","label":"Tell them yes if the business appears to be small"},{"id":"c","label":"Tell them no, since eligibility is rare"},{"id":"d","label":"Offer to fill out the application on their behalf"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"pf-m7-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"Which statement about the FAR is most accurate?","explanation":"Correct answer: It's being rewritten, so specifics should be checked against current official sources","points":1,"position":7,"options":[{"id":"a","label":"It's fixed and hasn't changed in decades"},{"id":"b","label":"It applies only to defense purchases"},{"id":"c","label":"It replaced all state procurement rules"},{"id":"d","label":"It's being rewritten, so specifics should be checked against current official sources"}],"correct_option_id":"d"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 8: End-to-End Walkthrough
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'End-to-End Walkthrough', '', 8)
  returning id into v_m;

  -- Lesson 8.1 -- The Scenario: Need, Planning and Method
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'The Scenario: Need, Planning and Method', '', 1, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Meet the buyer', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can follow a purchase from the first identified need through the choice of method, and name which earlier module each step comes from."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The City of Maple Ridge (fictional) is a mid-sized city with a purchasing office, a city manager, and a city council that meets twice a month. Its Records Department holds thousands of boxes of paper permits and property files, and staff keep receiving public records requests that take days to fulfill because the files are on paper."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Stage 1, Requirement (Modules 1 and 4)', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The Records Director defines the need: scan, index, and securely store about 400,000 pages, with searchable results and a way to retrieve files within one business day. She writes a scope of work with a delivery timeline of roughly nine months, and she adds a requirement that the supplier handle the paper securely and return or destroy it as directed."]}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Why it matters","tone":"info","body":"This is the stage that looks quiet and shapes everything after it, so the clearer the scope is here, the cleaner the rest of the procurement will be."}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Stage 2, Planning and budget (Module 4)', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Planning starts with money. The department confirms $200,000 in its adopted budget for the fiscal year (fictional), and staff gather reference pricing to estimate the cost at about $180,000. Purchasing then checks whether a cooperative or existing contract could be used, but none fits the city's security requirements, so a new solicitation is needed.","The city's policy (fictional) says that purchases above $75,000 require formal competition and that council approval is needed above $150,000. At about $180,000, this purchase triggers both."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Choosing the method (Module 5)', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'image', 1, jsonb_build_object(
      'alt', 'The need is to scan and index 400,000 pages. If price alone can decide, use a price-based IFB/ITB; if quality, security and approach matter, use a value-based RFP with evaluation criteria published up front.',
      'src', 'data:image/svg+xml;base64,' || replace(encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 760 378" font-family="sans-serif"><defs><marker id="a81" markerUnits="userSpaceOnUse" markerWidth="10" markerHeight="10" refX="9" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="230" y="10" width="300" height="50" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="380" y="31.166666666666668" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Need: scan and index</text><text x="380" y="48.16666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">400,000 pages</text><line x1="380" y1="62" x2="380" y2="92" stroke="#334155" stroke-width="2" marker-end="url(#a81)"/><polygon points="380,94 495,144 380,194 265,144" fill="#fef3c7" stroke="#b45309"/><text x="380" y="140.83333333333334" text-anchor="middle" font-size="13" font-weight="600" fill="#78350f">Can price alone</text><text x="380" y="155.83333333333334" text-anchor="middle" font-size="13" font-weight="600" fill="#78350f">decide?</text><polyline points="265,144 130,144 130,210" fill="none" stroke="#334155" stroke-width="2" marker-end="url(#a81)"/><text x="195" y="136" text-anchor="middle" font-size="11" fill="#334155">Yes: standard commodity</text><polyline points="495,144 630,144 630,210" fill="none" stroke="#334155" stroke-width="2" marker-end="url(#a81)"/><text x="565" y="114" text-anchor="middle" font-size="11" fill="#334155">No: quality, security,</text><text x="565" y="128" text-anchor="middle" font-size="11" fill="#334155">approach matter</text><rect x="10" y="214" width="240" height="56" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="130" y="238.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Price-based</text><text x="130" y="255.16666666666666" text-anchor="middle" font-size="11" font-weight="400" fill="#0c4a6e">IFB / ITB</text><rect x="510" y="214" width="240" height="56" rx="10" fill="#dcfce7" stroke="#15803d"/><text x="630" y="238.16666666666666" text-anchor="middle" font-size="14" font-weight="600" fill="#14532d">Value-based</text><text x="630" y="255.16666666666666" text-anchor="middle" font-size="11" font-weight="400" fill="#14532d">RFP</text><line x1="630" y1="272" x2="630" y2="304" stroke="#334155" stroke-width="2" marker-end="url(#a81)"/><rect x="510" y="308" width="240" height="56" rx="10" fill="#dcfce7" stroke="#15803d"/><text x="630" y="332.1666666666667" text-anchor="middle" font-size="14" font-weight="600" fill="#14532d">Evaluation criteria</text><text x="630" y="349.1666666666667" text-anchor="middle" font-size="11" font-weight="400" fill="#14532d">published up front</text></svg>$svg$, 'UTF8'), 'base64'), E'\n', '')
    )),
    (v_p, 'rich_text', 2, $j${"body":["Quality, security practices, and experience matter as much as price here, so purchasing chooses a Request for Proposals (RFP) and not a lowest-price bid. The planned contract structure is a unit price per page for scanning plus a fixed price for setup and indexing."]}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-l81-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"In the Maple Ridge scenario, what did the Records Director produce at the requirement stage?","explanation":"The requirement stage looks quiet but shapes everything after it, so the clearer the scope of work, the cleaner the rest of the procurement.","points":1,"position":1,"options":[{"id":"a","label":"A signed contract with a supplier"},{"id":"b","label":"A ranking of the scored proposals"},{"id":"c","label":"A decision on a protest"},{"id":"d","label":"A scope of work"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"By the time anything is published, the need, funding, method, and approvals path have already been decided, so a supplier's chance to shape the outcome is small once the solicitation is public."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"The earlier you understand the buyer's need, timing, and budget cycle, the more useful you can be, as long as you stay within their contact rules."}$j$::jsonb);

  -- Lesson 8.2 -- Solicitation, Evaluation and Award
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Solicitation, Evaluation and Award', '', 2, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Solicitation', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe what happens from publication of a solicitation through council approval, and what a supplier should and should not do at each step."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Maple Ridge publishes the RFP on its bid portal and in a public notice. The document gives the scope of work and the required security practices, a question deadline with a single contact for questions, and a proposal deadline. It also carries a no-contact rule, under which suppliers may communicate only with the named purchasing contact until the award is announced.","The evaluation criteria and weights (fictional) are published as well: technical approach 30%, security and data handling 25%, relevant experience 20%, and price 25%. Finally, the RFP states that proposals become public records after award, with instructions for marking genuine trade secrets.","A supplier asks a question about scanning formats. The city answers it in a written addendum sent to everyone who downloaded the RFP, not only to the supplier who asked, so that no bidder has an advantage."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What a supplier does here', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A well-run supplier reads the entire RFP and follows its instructions exactly, which is what makes a response responsive. Questions go only through the designated channel and before the deadline, and the proposal is written on the assumption that competitors will later read it. The supplier marks only genuine trade secrets, as instructed, and does not call the Records Director, the city manager, or council members."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Evaluation', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Five proposals arrive, and evaluation moves through four steps.","Compliance check: One proposal is rejected as non-responsive for missing a required form.","Evaluator disclosures: Each evaluator signs a conflict-of-interest disclosure. One evaluator discloses that her brother-in-law works for a bidder, and she is replaced.","Scoring: Evaluators score the four remaining proposals against the published criteria only, and they document their notes.","Ranking: The bidder with the lowest price ranks third overall because of weaker security and experience scores, which is a normal result under an RFP, where the lowest price doesn't automatically win."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Award', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The top-ranked proposal is about $176,000, which exceeds the council approval level, so purchasing places a recommendation on the council agenda. At a public meeting, the council approves the award. The city then notifies all bidders and, depending on its rules, offers debriefs."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A protest sidebar', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The third-ranked bidder believes the winner's scoring was unfair and files a protest within the city's deadline (fictional: a few business days). The city's purchasing director reviews it. Because evaluators scored strictly against the published criteria and documented everything, the protest is denied, and the paper trail is the reason the process held up."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l82-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What did the city's documented process allow it to show when the third-ranked bidder protested?","explanation":"The paper trail is the reason the process held up, since every score could be traced back to the published criteria.","points":1,"position":1,"options":[{"id":"a","label":"That council approval was never actually required for this award"},{"id":"b","label":"That the solicitation should be cancelled and issued again"},{"id":"c","label":"That evaluators scored strictly against the published criteria, so the protest could be denied"},{"id":"d","label":"That the protester's proposal should have won the award"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Fair process shows up at every step of this procurement, in the equal information, the disclosed conflicts, the scoring against published criteria, the public approval, and the records that can be defended."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"During an open solicitation, we communicate only through the designated channel. Relationships can be built before a solicitation opens, but not while it's open."}$j$::jsonb);

  -- Lesson 8.3 -- Delivery, Closeout and the Federal Contrast
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Delivery, Closeout and the Federal Contrast', '', 3, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Contract and administration', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe what happens after award, and explain in two or three sentences how the same purchase would differ at the federal level."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The city and supplier finalize the contract, including terms, security requirements, and pricing (unit price per page plus fixed setup). A contract administrator in the Records Department, who is a different person from the purchasing officer who ran the RFP, monitors progress, and the supplier submits invoices that the city reviews against delivered work before paying.","Halfway through, the city decides to add 40,000 more pages. That change is handled through a formal modification to the contract and not through a handshake, since the contract is the record both sides will be held to."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Closeout', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["At the end, the city accepts the final deliverables and checks that the paper has been returned or destroyed as required. The final invoice is paid and any retained amount is released. Records are filed and retained, because audits and records requests can come years later, and the supplier's performance is noted, which will influence how the city views them in future procurements. That is the loop from Module 1 closing."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The same purchase at the federal level', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["If a federal agency bought a similar service, the most visible difference would be the rulebook: it would follow the FAR, with agency supplements, in place of a local ordinance. The opportunity would most likely be posted on SAM.gov, and the supplier would need an active registration to receive an award. The agency might also use an existing contract vehicle, such as a GSA schedule, instead of running a new competition.","Two further differences affect who can compete and how formal the process must be. Federal small business set-aside rules, such as the Rule of Two, could limit who may compete, and federal thresholds such as the simplified acquisition threshold would determine the level of formality, with figures that belong to the federal government and not to the city.","The stages, the principles, and the importance of documentation stay the same, while the rulebook, the portal, and the scale are different."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The whole journey on one page', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Requirement: Records Director wrote a scope of work. Module: 1, 4.","Planning and budget: Funding confirmed, estimate built, method chosen. Module: 3, 4.","Solicitation: RFP published with criteria and no-contact rule. Module: 4, 5, 6.","Evaluation: Compliance check, disclosures, documented scoring. Module: 4, 6.","Award: Council approved in public. Module: 2, 3.","Protest: Reviewed and denied, thanks to documentation. Module: 6.","Administration: Contract administrator, modification, invoices. Module: 4.","Closeout: Acceptance, final payment, records retained. Module: 4."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-l83-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"If a federal agency bought the same service, which would stay the same?","explanation":"The stages, the principles, and the need for documentation stay the same, while the rulebook, the portal, and the scale are different.","points":1,"position":1,"options":[{"id":"a","label":"The importance of fair competition and documentation"},{"id":"b","label":"The governing rulebook"},{"id":"c","label":"The portal where the opportunity is posted"},{"id":"d","label":"The thresholds that set how formal the process must be"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Every purchase follows the same journey, and the size, rulebook, and approval path change while fairness, competition, and documentation stay constant."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're talking to a buyer","tone":"info","body":"Knowing which stage a buyer is in, and what rules they are under, tells you what they need from you right now and what you must not do."}$j$::jsonb);

  -- MODULE 8 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 8 Check', '', 4, 9, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 8 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 8 Check","tone":"info","body":"Answer every question correctly to finish the course lessons."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"pf-m8-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"In the scenario, why did Maple Ridge use an RFP instead of an IFB?","explanation":"Correct answer: Quality, security, and approach mattered as much as price","points":1,"position":1,"options":[{"id":"a","label":"The purchase was too small to justify an IFB"},{"id":"b","label":"Quality, security, and approach mattered as much as price"},{"id":"c","label":"State law prohibits IFBs for services of any kind"},{"id":"d","label":"The city council had directed the use of an RFP"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"pf-m8-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"A supplier asks a question during the solicitation. How did the city handle the answer?","explanation":"Correct answer: It issued a written addendum to all suppliers","points":1,"position":2,"options":[{"id":"a","label":"It answered only the supplier who asked"},{"id":"b","label":"It issued a written addendum to all suppliers"},{"id":"c","label":"It held the question until after the proposal deadline"},{"id":"d","label":"It cancelled the solicitation and started over"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"pf-m8-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"The lowest-priced bidder ranked third. Why?","explanation":"Correct answer: Under an RFP, the published criteria weigh more than price alone","points":1,"position":3,"options":[{"id":"a","label":"The city made an error in the scoring"},{"id":"b","label":"Price isn't considered in an RFP evaluation"},{"id":"c","label":"The bidder's proposal arrived after the deadline"},{"id":"d","label":"Under an RFP, the published criteria weigh more than price alone"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"pf-m8-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"What was the right response when an evaluator had a family tie to a bidder?","explanation":"Correct answer: Have her disclose it and replace her as an evaluator","points":1,"position":4,"options":[{"id":"a","label":"Have her disclose it and replace her as an evaluator"},{"id":"b","label":"Allow her to continue, since the tie was distant"},{"id":"c","label":"Let her score only the related bidder's proposal"},{"id":"d","label":"Cancel the solicitation and issue a new one"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"pf-m8-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"The city added 40,000 pages mid-contract. What is the proper way to handle it?","explanation":"Correct answer: A formal modification to the contract","points":1,"position":5,"options":[{"id":"a","label":"A verbal agreement between the two administrators"},{"id":"b","label":"A new solicitation started right away for the extra pages"},{"id":"c","label":"A formal modification to the contract"},{"id":"d","label":"Absorbing the pages into the existing price with no change"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"pf-m8-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"Which of these would differ in a federal version of the same purchase?","explanation":"Correct answer: The governing rulebook and the portal where it is posted","points":1,"position":6,"options":[{"id":"a","label":"The importance of documenting decisions"},{"id":"b","label":"The principle of fair competition"},{"id":"c","label":"The governing rulebook and the portal where it is posted"},{"id":"d","label":"The need for a scope of work"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"pf-m8-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"During the open solicitation, who may a supplier contact?","explanation":"Correct answer: Only the designated purchasing contact","points":1,"position":7,"options":[{"id":"a","label":"Only the designated purchasing contact"},{"id":"b","label":"The Records Director, who wrote the scope of work"},{"id":"c","label":"The city manager, who oversees the department"},{"id":"d","label":"Any council member who will vote on the award"}],"correct_option_id":"a"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- Course-end cumulative review: exam (80% to pass) + quick_review that
  -- samples from the exam's pool (see 0013_study_center_schema.sql).
  ------------------------------------------------------------------
  insert into public.assessments (course_id, assessment_type, title, passing_score, question_count, status)
  values (v_course_id, 'exam', 'Procurement Foundations Cumulative Review', 80, 12, 'published')
  returning id into v_exam_id;

  insert into public.assessments (course_id, assessment_type, title, question_count, status)
  values (v_course_id, 'quick_review', 'Procurement Foundations Quick Review', 7, 'published');

  insert into public.assessment_questions (assessment_id, question_type, prompt, explanation, points, position, data) values
    (v_exam_id, 'multiple_choice', 'Procurement is best described as:', 'Correct answer: The full process from identifying a need to payment and closeout (Module 1)', 1, 1, $j${"options":[{"id":"a","label":"Placing an order with a supplier"},{"id":"b","label":"Paying a supplier's invoice"},{"id":"c","label":"Comparing the prices of two suppliers"},{"id":"d","label":"The full process from identifying a need to payment and closeout"}],"correct_option_id":"d"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'Which three principles drive most differences between public and private buying?', 'Correct answer: Competition, transparency, and accountability (Module 2)', 1, 2, $j${"options":[{"id":"a","label":"Speed, price, and convenience"},{"id":"b","label":"Competition, transparency, and accountability"},{"id":"c","label":"Loyalty, discretion, and volume"},{"id":"d","label":"Branding, reputation, and timing"}],"correct_option_id":"b"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'A rep wants to tell a buyer their formal bidding threshold. What is the best practice?', 'Correct answer: Ask what the buyer''s current policy says (Module 3)', 1, 3, $j${"options":[{"id":"a","label":"State the national figure, since it applies everywhere"},{"id":"b","label":"Ask what the buyer's current policy says"},{"id":"c","label":"Assume it matches the threshold of a neighboring city"},{"id":"d","label":"Avoid the topic of thresholds entirely"}],"correct_option_id":"b"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'Piggybacking means:', 'Correct answer: Using a contract another entity already competed, where local rules allow (Module 3)', 1, 4, $j${"options":[{"id":"a","label":"Splitting a purchase into smaller pieces"},{"id":"b","label":"Awarding a contract without any competition"},{"id":"c","label":"Combining two solicitations into one"},{"id":"d","label":"Using a contract another entity already competed, where local rules allow"}],"correct_option_id":"d"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'The stage that largely determines a procurement''s success is:', 'Correct answer: Requirement and planning (Module 4)', 1, 5, $j${"options":[{"id":"a","label":"Requirement and planning"},{"id":"b","label":"Closeout, when records are filed"},{"id":"c","label":"Invoicing, when payment is processed"},{"id":"d","label":"Protest, when an award is challenged"}],"correct_option_id":"a"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'An IFB or ITB is typically awarded to:', 'Correct answer: The lowest responsive and responsible bidder (Module 5)', 1, 6, $j${"options":[{"id":"a","label":"The firm with the strongest presentation"},{"id":"b","label":"The most experienced firm among the bidders"},{"id":"c","label":"The lowest responsive and responsible bidder"},{"id":"d","label":"The first supplier to respond"}],"correct_option_id":"c"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'Under a firm fixed-price contract, cost-overrun risk is carried mainly by:', 'Correct answer: The supplier (Module 5)', 1, 7, $j${"options":[{"id":"a","label":"The buyer"},{"id":"b","label":"The auditor"},{"id":"c","label":"The supplier"},{"id":"d","label":"The council that approved the award"}],"correct_option_id":"c"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'A supplier marks every page "CONFIDENTIAL." This:', 'Correct answer: Does not by itself protect information, since only genuine trade secrets may qualify (Module 6)', 1, 8, $j${"options":[{"id":"a","label":"Does not by itself protect information, since only genuine trade secrets may qualify"},{"id":"b","label":"Guarantees that nothing will be released"},{"id":"c","label":"Is required in every proposal"},{"id":"d","label":"Prevents any records request from succeeding"}],"correct_option_id":"a"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'A buyer mentions a possible protest. The right move is to:', 'Correct answer: Escalate internally to management and counsel (Module 6)', 1, 9, $j${"options":[{"id":"a","label":"Discuss the competitors' weaknesses with the buyer"},{"id":"b","label":"Encourage the protest"},{"id":"c","label":"Take no action, since it's the buyer's matter"},{"id":"d","label":"Escalate internally to management and counsel"}],"correct_option_id":"d"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'Where are most federal contract opportunities posted?', 'Correct answer: On SAM.gov (Module 7)', 1, 10, $j${"options":[{"id":"a","label":"In the legal notices of local newspapers"},{"id":"b","label":"On SAM.gov"},{"id":"c","label":"On each agency's private email list"},{"id":"d","label":"On city bid portals"}],"correct_option_id":"b"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'Why should we avoid quoting federal thresholds from memory?', 'Correct answer: They are adjusted over time and must be checked against current sources (Module 7)', 1, 11, $j${"options":[{"id":"a","label":"They have never changed since the FAR was written"},{"id":"b","label":"They are adjusted over time and must be checked against current sources"},{"id":"c","label":"They apply only to cities and counties"},{"id":"d","label":"They are confidential and can't be shared"}],"correct_option_id":"b"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'During an open solicitation, communication with the buyer should go:', 'Correct answer: Only through the designated contact (Module 8)', 1, 12, $j${"options":[{"id":"a","label":"To whoever answers the department's phone"},{"id":"b","label":"Through council members who will vote on the award"},{"id":"c","label":"Only after the award has been announced"},{"id":"d","label":"Only through the designated contact"}],"correct_option_id":"d"}$j$::jsonb);


  ------------------------------------------------------------------
  -- Glossary: scoped to this course via glossary_terms.course_id (0017).
  -- on conflict guards against a term another course already seeded --
  -- normalized_term is still globally unique.
  ------------------------------------------------------------------
  insert into public.glossary_terms (term, definition, category, course_id, status) values
  ('Procurement', 'The full process an organization follows to acquire goods and services, from identifying the need to paying for it', 'Procurement: Fundamentals', v_course_id, 'published'),
  ('Purchasing', 'The transactional part of acquiring something: ordering and paying', 'Procurement: Fundamentals', v_course_id, 'published'),
  ('Buyer', 'An organization that acquires goods or services', 'Procurement: Fundamentals', v_course_id, 'published'),
  ('Supplier / Vendor / Contractor', 'A party that provides goods or services to a buyer', 'Procurement: Fundamentals', v_course_id, 'published'),
  ('Requester / End user', 'A person or department that has a need and starts a purchase', 'Procurement: Fundamentals', v_course_id, 'published'),
  ('Purchase order (PO)', 'A document a buyer issues to authorize a purchase from a supplier', 'Procurement: Fundamentals', v_course_id, 'published'),
  ('Invoice', 'A bill a supplier sends for goods or services delivered', 'Procurement: Fundamentals', v_course_id, 'published'),
  ('Sourcing', 'The work of finding and evaluating potential suppliers', 'Procurement: Fundamentals', v_course_id, 'published'),
  ('Award', 'The buyer''s decision to select a supplier', 'Procurement: Fundamentals', v_course_id, 'published'),
  ('Public sector', 'The part of the economy made up of government and publicly funded bodies', 'Procurement: Public Landscape', v_course_id, 'published'),
  ('Public procurement', 'Procurement carried out by public entities using public funds', 'Procurement: Public Landscape', v_course_id, 'published'),
  ('Competition', 'A principle that gives qualified suppliers a fair chance to win', 'Procurement: Public Landscape', v_course_id, 'published'),
  ('Transparency', 'A principle that keeps buying decisions open to public view', 'Procurement: Public Landscape', v_course_id, 'published'),
  ('Accountability', 'A principle that requires decisions to be documented and justified', 'Procurement: Public Landscape', v_course_id, 'published'),
  ('Governing body', 'The council, board, or commission that sets policy and approves spending', 'Procurement: Public Landscape', v_course_id, 'published'),
  ('Special district / authority', 'A single-purpose public entity, such as one for water or transit', 'Procurement: Public Landscape', v_course_id, 'published'),
  ('Protest', 'A formal challenge to an award or solicitation', 'Procurement: Public Landscape', v_course_id, 'published'),
  ('Public funds', 'Money that comes from taxes, fees, and public grants', 'Procurement: Public Landscape', v_course_id, 'published'),
  ('Threshold', 'A dollar level at which the required process changes', 'Procurement: State & Local Buying', v_course_id, 'published'),
  ('Informal quotes', 'A lighter process in which staff gather several price quotes', 'Procurement: State & Local Buying', v_course_id, 'published'),
  ('Formal competition', 'A published, scored, and documented competitive process', 'Procurement: State & Local Buying', v_course_id, 'published'),
  ('Sole source', 'An award to one supplier because no competition is practical', 'Procurement: State & Local Buying', v_course_id, 'published'),
  ('Emergency purchase', 'An urgent purchase made through a streamlined process and documented afterward', 'Procurement: State & Local Buying', v_course_id, 'published'),
  ('Cooperative purchasing', 'An arrangement in which public entities share a competitively awarded contract', 'Procurement: State & Local Buying', v_course_id, 'published'),
  ('Piggybacking', 'A way of using another entity''s already-competed contract', 'Procurement: State & Local Buying', v_course_id, 'published'),
  ('Lead agency', 'The entity that runs a shared solicitation', 'Procurement: State & Local Buying', v_course_id, 'published'),
  ('Ordinance / code', 'A set of local legal rules adopted by a city or county', 'Procurement: State & Local Buying', v_course_id, 'published'),
  ('Delegated authority', 'Approval power that a governing body gives to staff up to a set level', 'Procurement: State & Local Buying', v_course_id, 'published'),
  ('Requirement', 'The defined need that a purchase must satisfy', 'Procurement: Lifecycle', v_course_id, 'published'),
  ('Scope of work', 'A description of the services and deliverables a buyer expects', 'Procurement: Lifecycle', v_course_id, 'published'),
  ('Specifications', 'A description of the goods or technical standards a buyer expects', 'Procurement: Lifecycle', v_course_id, 'published'),
  ('Solicitation', 'A published request that invites supplier responses', 'Procurement: Lifecycle', v_course_id, 'published'),
  ('Addendum', 'A written change or clarification issued to all suppliers', 'Procurement: Lifecycle', v_course_id, 'published'),
  ('Evaluation criteria', 'The published factors used to judge responses', 'Procurement: Lifecycle', v_course_id, 'published'),
  ('Contract administration', 'The work of overseeing performance after award', 'Procurement: Lifecycle', v_course_id, 'published'),
  ('Modification / amendment', 'A formal change to a contract', 'Procurement: Lifecycle', v_course_id, 'published'),
  ('Closeout', 'The final stage, in which a contract is completed and documented', 'Procurement: Lifecycle', v_course_id, 'published'),
  ('Fiscal year', 'The 12-month budgeting period an entity uses', 'Procurement: Lifecycle', v_course_id, 'published'),
  ('RFI', 'A request for information that gathers market information', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('RFQ', 'A request for quotes (price-based) or for qualifications (qualification-based), depending on the entity', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('IFB / ITB', 'An invitation for bid, or to bid, awarded to the lowest responsive and responsible bidder', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('RFP', 'A request for proposal, awarded on best overall value', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('Responsive', 'Describes a bid that follows instructions and meets requirements', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('Responsible', 'Describes a bidder that is capable of performing the work', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('Fixed price', 'A pricing type with a set price regardless of actual cost', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('Time and materials', 'A pricing type with hourly labor rates plus materials, typically capped', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('Cost-reimbursement', 'A pricing type in which the buyer reimburses allowed costs plus a fee', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('Unit price', 'A pricing type with a set price per unit, so the total depends on quantity', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('Master / price agreement', 'An arrangement with pre-negotiated terms for repeated orders', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('On-call contract', 'An agreement that keeps a supplier available as needs arise', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('IDIQ', 'An indefinite delivery, indefinite quantity contract', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('Task / delivery order', 'A specific order placed under an indefinite-quantity contract', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('Single / multiple award', 'A choice between one supplier and several qualified suppliers on a vehicle', 'Procurement: Solicitations & Contracts', v_course_id, 'published'),
  ('Conflict of interest', 'A personal or financial interest that could affect, or appear to affect, a decision', 'Procurement: Ethics & Compliance', v_course_id, 'published'),
  ('Gift / gratuity', 'Anything of value offered to someone involved in a purchase', 'Procurement: Ethics & Compliance', v_course_id, 'published'),
  ('No-contact / cone of silence', 'A period during which contact with staff and officials is restricted to the designated channel', 'Procurement: Ethics & Compliance', v_course_id, 'published'),
  ('Collusion', 'An agreement in which competitors coordinate their bids or prices', 'Procurement: Ethics & Compliance', v_course_id, 'published'),
  ('Public record', 'A document that the public may request and inspect', 'Procurement: Ethics & Compliance', v_course_id, 'published'),
  ('Trade secret', 'Valuable, non-public business information that its owner protects', 'Procurement: Ethics & Compliance', v_course_id, 'published'),
  ('Redaction', 'The removal of protected information before a document is released', 'Procurement: Ethics & Compliance', v_course_id, 'published'),
  ('Certification', 'Official recognition that a business qualifies for a program', 'Procurement: Ethics & Compliance', v_course_id, 'published'),
  ('Set-aside', 'A purchase reserved for qualifying businesses', 'Procurement: Ethics & Compliance', v_course_id, 'published'),
  ('Preference', 'An advantage given to qualifying bidders in evaluation', 'Procurement: Ethics & Compliance', v_course_id, 'published'),
  ('FAR', 'The Federal Acquisition Regulation, which is the main federal buying rulebook', 'Procurement: Federal Snapshot', v_course_id, 'published'),
  ('Revolutionary FAR Overhaul', 'The ongoing federal effort to rewrite and streamline the FAR', 'Procurement: Federal Snapshot', v_course_id, 'published'),
  ('SAM.gov', 'The federal portal for registration and most contract opportunities', 'Procurement: Federal Snapshot', v_course_id, 'published'),
  ('Micro-purchase threshold', 'A dollar level below which small purchases face minimal competition requirements', 'Procurement: Federal Snapshot', v_course_id, 'published'),
  ('Simplified acquisition threshold (SAT)', 'A dollar level below which streamlined procedures can be used', 'Procurement: Federal Snapshot', v_course_id, 'published'),
  ('GSA MAS', 'The GSA Multiple Award Schedule, a long-term list of pre-approved vendors', 'Procurement: Federal Snapshot', v_course_id, 'published'),
  ('GWAC', 'A governmentwide acquisition contract', 'Procurement: Federal Snapshot', v_course_id, 'published'),
  ('Rule of Two', 'A test used to decide when to set a contract aside for small business', 'Procurement: Federal Snapshot', v_course_id, 'published'),
  ('8(a), HUBZone, WOSB, SDVOSB', 'The names of the main federal small business programs', 'Procurement: Federal Snapshot', v_course_id, 'published'),
  ('PTAC', 'A Procurement Technical Assistance Center, which offers free or low-cost local help for contractors', 'Procurement: Federal Snapshot', v_course_id, 'published'),
  ('Prime / subcontractor', 'The company that holds a contract / a company that works under it', 'Procurement: Federal Snapshot', v_course_id, 'published')
  on conflict (normalized_term) do nothing;
end $$;

commit;
