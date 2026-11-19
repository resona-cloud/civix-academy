begin;

-- Seeds the Sales Essentials course from the revised source modules under
-- Courses/Sales Essentials/Revised/ (generated from those files, then reviewed).
-- Same content model as 0011 and 0018: courses > modules > lessons
-- > lesson_pages > content_blocks, with module checks modeled as ordinary
-- lessons flagged is_check.
--
-- Decisions (same as Procurement Foundations, 0018):
--   * Every activity gates at 100% (gates_progress = true), including each
--     question of every module check. The 80% in the source markdown was a
--     placeholder.
--   * The source's open-ended retrieval prompts ("in your own words...") can't
--     be graded by the activity engine, so each lesson gets one gated
--     multiple-choice retrieval question instead.
--   * No auto-enrollment. Enrollments are assigned manually; can_access_course()
--     still requires Resona Foundations to be complete first, and admin /
--     zone_manager bypass as usual.
--   * Seeded as published, but unreachable by learners until someone is
--     enrolled. Open items (named role for special requests, written contact
--     policy, approved-claims list, published plan names, counsel review of
--     Modules 2.2, 3.4, 5.3, 7.3 and 8.1 to 8.3) are listed in BUILD_LOG.
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
    'sales-essentials',
    'Sales Essentials',
    'An honest, plain-language guide to talking with small business owners about buying: what selling is, preparing, opening and rapport, discovery, presenting value, objections, closing and commitment, and follow-up and conduct.',
    null,
    'published',
    (select coalesce(max(position), 0) + 1 from public.courses),
    293
  )
  returning id into v_course_id;

  ------------------------------------------------------------------
  -- MODULE 1: What Selling Is (and Is Not)
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'What Selling Is (and Is Not)', '', 1)
  returning id into v_m;

  -- Lesson 1.1 -- Selling as Helping Someone Decide
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Selling as Helping Someone Decide', '', 1, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A working definition', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain what selling is in plain terms, describe how a seller-first conversation differs from a buyer-first one, and say why the buyer's problem comes before the product."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Selling is helping a person decide whether a product or service solves a problem they have.","Three things follow from that definition. The person has a problem or goal, because without one there is nothing to sell. Deciding is their job and not yours, so you inform, ask, and clarify without deciding for them. And \"no\" is a valid result: if the product doesn't fit, a good conversation ends with a respectful no."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Two kinds of conversation', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Starts with. Seller-first: The product and its features. Buyer-first: The person's situation and goal.","Talks about. Seller-first: What we offer. Buyer-first: What matters to them.","Questions are used to. Seller-first: Steer toward a pitch. Buyer-first: Understand the problem.","Ends when. Seller-first: The seller gets a yes or gives up. Buyer-first: The person has what they need to decide.","How the person feels. Seller-first: Handled, rushed, or talked at. Buyer-first: Heard and in control."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Small business owners are busy, and many don't enjoy being sold to. A 2014 survey by a business-coaching company, covering 401 owners (mostly with fewer than 50 employees), found that 57% said vendor information is \"too sales-oriented,\" and that owners were more influenced by other owners using a product than by the vendor itself. That survey is old, comes from a single self-selected source, and published no method, so it's best read as a hint about attitudes and not as a measurement.","The practical point doesn't depend on any statistic: the less a conversation feels like a pitch, the more the person engages."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why the problem comes first', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A product only has value in relation to a problem. Consider two openings with the same business owner, a fictional bakery owner named Dana."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Seller-first: \"Hi, I'm with a company that offers a tool with scheduling, reporting, and automated reminders. Let me walk you through the features.\"","Buyer-first: \"Hi Dana, I work with small shops like yours. Can I ask what takes up most of your time each week that you wish didn't?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["The first opening hands Dana a list to evaluate, while the second gives her a reason to talk. If Dana's real problem is late supplier orders, a scheduling tool is the wrong answer, and the only way to find that out is to ask."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What selling is not', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Selling isn't convincing, since having to talk someone into a purchase is a sign that the product may be wrong for that person. It isn't tricking either, because a sale built on a misunderstanding comes back as a refund, a complaint, or a bad review. Strong sellers also spend more time asking and listening than presenting, so selling isn't talking. And it isn't a one-time event: the sale starts a relationship, and the customer's experience afterward is part of the job."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l11-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"A seller opens a call by listing features. Why does starting with the person's problem work better?","explanation":"A product only has value in relation to a problem, so a conversation that starts with the person's situation gives everything you say later something to attach to.","points":1,"position":1,"options":[{"id":"a","label":"Features are confusing and should never be mentioned"},{"id":"b","label":"A product only has value in relation to a problem the person has"},{"id":"c","label":"Starting with a problem makes the sale close faster"},{"id":"d","label":"People always prefer shorter conversations"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Selling is helping someone decide, which is why the conversation starts with their problem and why a respectful \"no\" can be the right outcome."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before you say anything about the product, ask yourself whether you know what this person is trying to fix or achieve, and if you don't, ask first."}$j$::jsonb);

  -- Lesson 1.2 -- The Buyer's Journey
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'The Buyer''s Journey', '', 2, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'People do not buy in one step', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe the three common stages of a buying decision, explain what a small business owner needs at each stage, and recognize where a conversation is likely to stall."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Before anyone buys, they usually move through stages. A common model has three, and many sales trainers use some version of it."]}$j$::jsonb),
    (v_p, 'image', 3, jsonb_build_object(
      'alt', 'The buyer''s journey: awareness (something is not working or could be better), consideration (what kinds of solutions exist), decision (which one, and from whom), after the buy (does it work as promised), with word of mouth feeding back to awareness',
      'src', 'data:image/svg+xml;base64,' || replace(encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 940 200" font-family="sans-serif"><defs><marker id="a12" markerUnits="userSpaceOnUse" markerWidth="10" markerHeight="10" refX="9" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="10" y="20" width="200" height="84" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="110" y="49" text-anchor="middle" font-size="15" font-weight="600" fill="#0c4a6e">Awareness</text><text x="110" y="67" text-anchor="middle" font-size="12" font-weight="400" fill="#0c4a6e">Something is not working</text><text x="110" y="85" text-anchor="middle" font-size="12" font-weight="400" fill="#0c4a6e">or could be better</text><line x1="212" y1="62" x2="240" y2="62" stroke="#334155" stroke-width="2" marker-end="url(#a12)"/><rect x="242" y="20" width="200" height="84" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="342" y="49" text-anchor="middle" font-size="15" font-weight="600" fill="#0c4a6e">Consideration</text><text x="342" y="67" text-anchor="middle" font-size="12" font-weight="400" fill="#0c4a6e">What kinds of</text><text x="342" y="85" text-anchor="middle" font-size="12" font-weight="400" fill="#0c4a6e">solutions exist?</text><line x1="444" y1="62" x2="472" y2="62" stroke="#334155" stroke-width="2" marker-end="url(#a12)"/><rect x="474" y="20" width="200" height="84" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="574" y="49" text-anchor="middle" font-size="15" font-weight="600" fill="#0c4a6e">Decision</text><text x="574" y="67" text-anchor="middle" font-size="12" font-weight="400" fill="#0c4a6e">Which one,</text><text x="574" y="85" text-anchor="middle" font-size="12" font-weight="400" fill="#0c4a6e">and from whom?</text><line x1="676" y1="62" x2="704" y2="62" stroke="#334155" stroke-width="2" marker-end="url(#a12)"/><rect x="706" y="20" width="200" height="84" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="806" y="49" text-anchor="middle" font-size="15" font-weight="600" fill="#0c4a6e">After the buy</text><text x="806" y="67" text-anchor="middle" font-size="12" font-weight="400" fill="#0c4a6e">Does it work</text><text x="806" y="85" text-anchor="middle" font-size="12" font-weight="400" fill="#0c4a6e">as promised?</text><path d="M 818 106 C 818 190, 110 190, 110 110" fill="none" stroke="#334155" stroke-width="2" stroke-dasharray="5 4" marker-end="url(#a12)"/><text x="464" y="182" text-anchor="middle" font-size="11" fill="#334155">Word of mouth</text></svg>$svg$, 'UTF8'), 'base64'), E'\n', '')
    )),
    (v_p, 'rich_text', 4, $j${"body":["The model is a simplification. Real journeys involve going back and forth, skipping steps, or stopping altogether, and one sales-software vendor's guide describes them as \"winding\" and not as a straight funnel. The stages are more useful as a way to ask better questions than as a track the customer must follow."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What the person needs at each stage', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Awareness: They feel a problem or see an opportunity, but may not know their options or whom to trust. What they need: To understand the problem and that solutions exist. What helps: Clear explanation, credible examples, no pressure.","Consideration: They are comparing kinds of solutions (for example, hire someone, use a tool, or do nothing) and worry about choosing wrong. What they need: Help comparing options and the tradeoffs. What helps: Honest comparisons, including cases where our product is not the best fit.","Decision: They have a type of solution in mind and are choosing a specific one. What they need: Confidence that this choice will work for their situation. What helps: Evidence tied to their problem, clear terms, easy next steps.","After the buy: They discover whether it works. What they need: Support and follow-through. What helps: Prompt help, expectations kept."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The stage names and the \"what helps\" column follow an article from Close, a sales-software vendor, adapted for this course. The article is vendor content and its supporting statistics haven't been independently verified, so none of them are used here."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A small business owner''s version', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Small business owners tend to decide alone or with one other person, such as a partner or key employee, so the journey can be fast. They wear many hats, which makes time the scarce resource, and they weigh cash carefully because a purchase may come from money they feel directly. Other owners are a strong influence on them, so referrals and reviews matter; the 2014 survey mentioned earlier found peers were the most-cited influence. Finally, they need a purchase to work on day one, since they usually have no one to troubleshoot for them.","All of this is why a short, clear, honest conversation tends to beat a long pitch."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Where conversations stall', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["\"I'm not sure we need this\": Awareness: the problem is not felt yet. What to try: Ask about their current situation instead of pitching more.","\"I'm looking at a few options\": Consideration: comparing. What to try: Offer an honest comparison and the questions they should ask any seller.","\"I need to think about it\": Decision: unresolved worry. What to try: Ask what they would want to be sure about.","\"Sounds good\" followed by silence: Interest without commitment. What to try: Agree on a specific next step.","\"It's not what I expected\": After the buy: expectations missed. What to try: Listen, fix what you can, and learn from it."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'You do not control the journey', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["You can't speed up someone's thinking. What you can do is make each stage easier by being clear, honest, and available, and by not pushing the person past where they are."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l12-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"A business owner says, \"I'm not sure we need this.\" Which stage are they most likely in, and what helps?","explanation":"When the problem isn't felt yet, more pitching doesn't help, whereas questions about their current situation do, because the person is still at the awareness stage.","points":1,"position":1,"options":[{"id":"a","label":"Decision; offer a deadline so they act"},{"id":"b","label":"Consideration; point out every competitor's weaknesses"},{"id":"c","label":"Awareness; ask about their current situation instead of pitching more"},{"id":"d","label":"After the buy; offer a refund to settle doubts"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"People move through awareness, consideration, and decision at their own pace, so the useful question is which stage this person is in and what would help them at that point."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"If you can't tell which stage a person is in, ask a question that would reveal it, such as \"How long has this been on your mind?\""}$j$::jsonb);

  -- Lesson 1.3 -- Trust Is the Real Product
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Trust Is the Real Product', '', 3, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why trust comes first', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe four ingredients of trust, say which one salespeople most often get wrong, and list everyday habits that build or erode it."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Customers can't fully inspect a product before buying, so they rely on whether they trust the person and the company behind it. A small business owner who has been burned before is especially careful.","Trust is built from what you do and not from what you say about yourself. It builds slowly and can break quickly."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The Trust Equation', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The authors of a well-known book on advisors proposed a simple model called the Trust Equation. It's a practitioner framework and not peer-reviewed research, and the firm that publishes it sells training, so it works best as a checklist.","Trust = (Credibility + Reliability + Intimacy) ÷ Self-Orientation"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Credibility: Do I believe what you say, and do you know your subject? In a sales conversation: Accurate, specific answers; saying \"I don't know, let me find out.\"","Reliability: Do you do what you say you will? In a sales conversation: Showing up on time, sending what you promised, returning calls.","Intimacy: Is it safe to tell you something sensitive? In a sales conversation: Keeping confidences; not repeating what you hear to others.","Self-Orientation: Whose interests are you focused on, theirs or yours? In a sales conversation: The one that lowers trust the most when it is high."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["The same source argues that self-orientation is the factor that most often undermines sellers. Because it sits in the denominator, a high number shrinks everything else: a person can sound credible, show up on time, and keep confidences, yet if the customer senses that you care mostly about your commission, trust drops."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Signs of high and low self-orientation', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Looks like high self-orientation: Steering every topic back to the product. Looks like low self-orientation: Following the customer's concerns, even when they point away from a sale.","Looks like high self-orientation: Checking the clock or phone. Looks like low self-orientation: Full attention.","Looks like high self-orientation: Interrupting. Looks like low self-orientation: Letting them finish.","Looks like high self-orientation: Pushing past a hesitation. Looks like low self-orientation: Asking what the hesitation is.","Looks like high self-orientation: Talking about your goals (\"I'm trying to hit my number\"). Looks like low self-orientation: Talking about theirs.","Looks like high self-orientation: Exaggerating to close. Looks like low self-orientation: Admitting limits."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Small habits that build trust', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A handful of small habits do most of the work. Being early, or at least on time, shows respect, and if you're going to be late, saying so before it happens keeps the habit intact. Doing what you said you would do, by when you said you would do it, is the core of reliability, and putting promises in writing (an email or a text) means both people remember the same thing. Saying \"I don't know\" and then finding out builds credibility, and admitting mistakes quickly and fixing them does the same. Respecting a \"no\" without a guilt trip, and keeping private what you hear, including what one customer tells you about their business, complete the list."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Things that erode trust fast', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Several behaviors damage trust quickly: overstating what the product does, hiding costs, terms, or limits, and speaking badly about competitors. Fake urgency (\"this price ends tonight\") when it isn't true has the same effect, as does contacting someone again and again after they said no, or making a promise you can't keep, even a small one."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l13-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"In the Trust Equation, why does high self-orientation do so much damage?","explanation":"Because self-orientation divides the other three ingredients, a customer who senses the seller cares mostly about their own goals trusts less, even when the seller is knowledgeable and punctual.","points":1,"position":1,"options":[{"id":"a","label":"It sits in the denominator, so it shrinks credibility, reliability, and intimacy"},{"id":"b","label":"It is the only ingredient customers can observe directly"},{"id":"c","label":"It makes the seller sound less confident"},{"id":"d","label":"It is added to the other three, which cancels them out"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Customers buy from people they trust, and because self-orientation divides the other three ingredients, focusing on yourself can undo credibility, reliability, and discretion at once."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before you leave a conversation, check what you promised, whether it's written down, and when you'll do it, and then do it early."}$j$::jsonb);

  -- Lesson 1.4 -- Your Role and Its Boundaries
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Your Role and Its Boundaries', '', 4, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Your role', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can state what you do and do not do in a sales conversation, list common pressure tactics to avoid and why, and describe when to escalate."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["In a sales conversation you are a guide and a source of accurate information. You ask questions to understand the person's situation, explain what the product does and doesn't do in plain language, and show how it would fit their situation with honest evidence. You answer concerns truthfully, offer clear next steps and let the person decide, and follow through on every commitment."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What you never do', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["These are firm rules, and they are worded without exceptions.","Overstate. Do not claim results, features, or savings that are not true and provable.","Hide. Do not leave out costs, terms, limits, or conditions the customer would want to know.","Pressure. Do not use the tactics listed below.","Promise outcomes. No one can guarantee how a customer's business will do.","Give advice you are not qualified to give. Legal, tax, financial, and accounting questions go to the customer's own professionals.","Misuse what you learn. What a customer tells you about their business stays confidential.","Make commitments outside your authority. Pricing is set in advance as a subscription plan, so you do not negotiate, invent, or promise a different price. You offer the published plans and any official promotions, and nothing else. Custom terms, special promises, and any request outside the published plans go to the right person at Resona."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Pressure tactics to avoid', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A sales-software vendor's article lists tactics it calls high-pressure. The list comes from a vendor blog and reflects that company's view, but the tactics are widely recognized as harmful to trust."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Fake or tight deadlines (\"price ends today\"): Feels manipulative, and can be deceptive if the deadline is not real.","\"Act now or miss out\" language: Rushes a decision the person is not ready to make.","Excessive contact (repeated calls, texts, or emails): Reads as desperate and can lead people to block you.","Irrelevant add-ons: Signals you care about the total, not their need.","Attacking competitors: Sounds petty, and false statements can create legal risk.","Ignoring a clear \"no\": Ends the relationship and harms reputation.","Guilt or passive-aggressive remarks: Damages trust immediately.","Making it hard to cancel or opt out: Turns a customer into an angry critic."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["The source is a 2023 Close blog post, updated in 2026. It also cites several statistics with no published methods, and those are not used here.","A simple test applies to all of these: would you be comfortable if the customer could see exactly what you were thinking and why you said it? If the answer is no, don't do it."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'When you are unsure', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["When you're unsure, stop and ask. There are several good moments to escalate: when the customer asks for something outside what you can offer, when a claim or promise is requested that you can't verify, or when the customer seems confused, upset, or vulnerable. The same goes for any legal, billing, or safety concern from a customer, and for any time you think you made a mistake.","A reply such as \"That's a good question. Let me check and get back to you by Thursday\" keeps the conversation honest, as long as you then do exactly that."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why the boundaries help you', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Staying in role protects you as much as the customer. When claims are true and provable, customers stay, refunds drop, and referrals come. Avoiding pressure means people return your calls, escalating what is beyond you keeps problems small, and keeping confidences leads owners to tell you what they really need.","Small business owners talk to each other, so a reputation for being straight with people travels and helps every conversation afterward."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l14-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which of these is outside your role in a sales conversation?","explanation":"Pricing is set in advance as a subscription, so you offer the published plans and official promotions and nothing else; custom terms go to the right person at Resona.","points":1,"position":1,"options":[{"id":"a","label":"Explaining what the product does and does not do"},{"id":"b","label":"Escalating a request you cannot verify"},{"id":"c","label":"Following through on every commitment you make"},{"id":"d","label":"Offering a different price than the published plans"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"You are a guide and a source of accurate information, which is why staying truthful, avoiding pressure, keeping promises, and escalating what is beyond you protect both the customer and your own reputation."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Keep a short note of every promise you make and when it's due, and check it before every follow-up."}$j$::jsonb);

  -- MODULE 1 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 1 Check', '', 5, 10, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 1 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 1 Check","tone":"info","body":"Answer every question correctly to unlock Module 2."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-m1-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"Which best describes selling in this course?","explanation":"Correct answer: Helping a person decide whether a product solves a problem they have","points":1,"position":1,"options":[{"id":"a","label":"Convincing people to buy once they've heard the full pitch"},{"id":"b","label":"Presenting every feature so the buyer has complete information"},{"id":"c","label":"Helping a person decide whether a product solves a problem they have"},{"id":"d","label":"Closing as quickly as possible while interest is high"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-m1-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"A seller opens with a list of product features before asking anything. Which approach is this?","explanation":"Correct answer: Seller-first","points":1,"position":2,"options":[{"id":"a","label":"Seller-first"},{"id":"b","label":"Buyer-first, because the buyer hears the full picture"},{"id":"c","label":"Consultative, because the seller is offering expertise"},{"id":"d","label":"After-the-buy, because the seller is describing what the product does"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-m1-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"A business owner says, \"I'm looking at a few options.\" Which stage are they most likely in, and what helps most?","explanation":"Correct answer: Consideration; an honest comparison and the questions they should ask any seller","points":1,"position":3,"options":[{"id":"a","label":"Awareness; a long product demo to explain the problem"},{"id":"b","label":"Decision; a deadline that encourages them to act"},{"id":"c","label":"After the buy; a quick refund to remove any doubt"},{"id":"d","label":"Consideration; an honest comparison and the questions they should ask any seller"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"se-m1-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"In the Trust Equation, which ingredient lowers trust when it is high?","explanation":"Correct answer: Self-orientation","points":1,"position":4,"options":[{"id":"a","label":"Credibility"},{"id":"b","label":"Self-orientation"},{"id":"c","label":"Reliability"},{"id":"d","label":"Intimacy"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"se-m1-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer asks, \"Will this double my revenue?\" You cannot know. What is the best response?","explanation":"Correct answer: \"I can't promise results, but I can show you what I know and what other owners have reported.\" (Only if true and provable.)","points":1,"position":5,"options":[{"id":"a","label":"\"Absolutely, that's what most of our customers see.\""},{"id":"b","label":"\"I can't promise results, but I can show you what I know and what other owners have reported.\" (Only if true and provable.)"},{"id":"c","label":"\"Most customers do, so I'd expect you to as well.\""},{"id":"d","label":"\"Don't worry about that, it's a small risk.\""}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"se-m1-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is a high-pressure tactic to avoid?","explanation":"Correct answer: Telling someone a price \"ends tonight\" when it does not","points":1,"position":6,"options":[{"id":"a","label":"Following up once, as promised"},{"id":"b","label":"Explaining an actual end date for an offer"},{"id":"c","label":"Asking what is on their mind"},{"id":"d","label":"Telling someone a price \"ends tonight\" when it does not"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"se-m1-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer asks a tax question about how the purchase will be treated. What do you do?","explanation":"Correct answer: Suggest they ask their own accountant, and stay within what you can state accurately about the product","points":1,"position":7,"options":[{"id":"a","label":"Suggest they ask their own accountant, and stay within what you can state accurately about the product"},{"id":"b","label":"Give your best guess, since you've seen similar cases"},{"id":"c","label":"Say it's always deductible, to keep things simple"},{"id":"d","label":"Change the subject to the product's features"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 9, $j${"gates_progress":true,"question":{"id":"se-m1-check-8","assessment_id":null,"question_type":"multiple_choice","prompt":"You promised to send information by Friday and cannot. What is the best approach?","explanation":"Correct answer: Tell the customer before Friday, give a new date, and keep it","points":1,"position":8,"options":[{"id":"a","label":"Send it next week without comment"},{"id":"b","label":"Hope the customer has forgotten about it"},{"id":"c","label":"Tell the customer before Friday, give a new date, and keep it"},{"id":"d","label":"Cancel the follow-up so no date is missed"}],"correct_option_id":"c"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 2: Preparing Before You Talk
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Preparing Before You Talk', '', 2)
  returning id into v_m;

  -- Lesson 2.1 -- Know What You Offer
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Know What You Offer', '', 1, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why product knowledge is a trust issue', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe who a product helps and who it does not, separate claims you can prove from claims you cannot, and say \"I don't know\" the right way."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Trust grows from credibility, and credibility comes from knowing your subject and being accurate about it. A salesperson who guesses, exaggerates, or contradicts themselves loses a small business owner quickly, and that owner may tell other owners.","You don't need to know everything. What you need to know is what is true, what isn't, and what you would have to check."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Five things to know cold', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["What it does, in one or two plain sentences: A customer should understand it without jargon.","Who it helps most: Shows where it truly fits.","Who it does not help: Lets you say \"this probably isn't right for you\" with confidence.","What it costs and what is included, including terms, limits, and anything extra: No surprises later.","What happens after the purchase: onboarding, support, what the customer has to do: Sets honest expectations."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Who it fits and who it does not', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Every product has a best-fit customer and customers it won't serve well. Sellers sometimes avoid thinking about the second group, yet it matters for three reasons. It lets you qualify politely and not waste the customer's time, it protects against refunds, complaints, and bad reviews from customers who were never a fit, and it makes your \"yes, this fits\" more believable.","A venture investor's article on selling argues that spotting poor-fit customers early saves time for everyone and builds trust. The article is practitioner opinion with no data behind that claim, and it's written about larger business sales, so the idea carries over better than its specifics do.","For your own preparation, complete two sentences for the product you sell, drawing the answers from your trainers and product materials and not from this course: \"This is a good fit for people who ___,\" and \"This is probably not a good fit for people who ___.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The claims inventory', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Every statement you make about a product is either provable or it isn't. Before you talk to customers, sort what you say into three groups."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Provable and current: Features you can show, terms in writing, results the company can document. What you do: Say it plainly.","True for some, not all: A result a few customers had; an example. What you do: Say it as an example and not as the norm (\"one owner told us...\").","Not provable or not sure: A hope, a guess, something you heard. What you do: Do not say it as fact. Say \"I'm not sure, let me check.\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["This follows the federal government's guidance on endorsements and claims, which says that statements must be truthful, that claims needing proof must have it, and that an unusual result shouldn't be presented as typical. That summary comes from the FTC's public endorsement-guidance page and isn't legal advice. Module 5 covers claims in more detail."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Saying "I don''t know"', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Customers forgive not knowing, but they don't forgive being misled. A good answer sounds like this:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"That's a good question and I don't want to guess. Let me find out and email you the answer by tomorrow afternoon.\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["The follow-through matters as much as the answer: do it, and do it early. This one habit does more for your credibility than any amount of memorized product detail."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Know the limits of your authority', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Know in advance what you can and cannot offer. Pricing is set in advance as a subscription plan, so there is no price to negotiate. You explain the published plans and any official promotions, and that is all. Custom terms, special promises, and timelines you cannot confirm are not yours to offer, and if you are not sure, you do not promise; you say you will check.","A fixed price is an advantage, because it removes haggling and lets you be completely clear about cost from the first conversation. It also means that a customer who asks \"can you do better on price?\" gets a straight answer and not a maybe, a situation Module 6 covers under price objections."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l21-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why does saying \"I don't know, let me find out\" help your credibility?","explanation":"Customers forgive not knowing but not being misled, so an honest answer followed by a prompt reply builds credibility.","points":1,"position":1,"options":[{"id":"a","label":"It lets you avoid answering hard questions"},{"id":"b","label":"It shows the product is too complicated to explain"},{"id":"c","label":"Customers forgive not knowing but not being misled, and the follow-through shows reliability"},{"id":"d","label":"It gives the customer time to compare competitors"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Knowing what is true, who the product fits, and where it falls short lets you answer with confidence, and saying so plainly when you're unsure is what keeps that confidence believable."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before each conversation, write down the one claim you're most tempted to stretch, and decide now how you'll say it truthfully."}$j$::jsonb);

  -- Lesson 2.2 -- Know the Person
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Know the Person', '', 2, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why prepare at all', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe what is useful to learn about a person before contact, how much time to spend, and what to leave alone."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A few minutes of preparation lets you ask better questions and avoid wasting a busy owner's time. It also prevents mistakes such as asking something they have already answered or pitching something that obviously doesn't apply.","Preparation has limits, though. It isn't a way to appear to know more than you do, and it isn't a license to dig into someone's private life."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What is useful to learn', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["For a small business owner, the helpful basics usually are these."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["What the business does: Type of business, what they sell, who they serve.","Size and shape: Rough size, one location or several, owner-run or staffed.","Anything recent and relevant: New location, new hire, a seasonal rush, a recent announcement they made publicly.","Past contact with us: Earlier conversations, notes, what they said they wanted, any promises we made.","Their role: Owner, manager, employee (and who makes the decision)."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Start with your own notes, in the CRM or other records, because earlier conversations are the most valuable source and the one most often skipped. After that, check public business information: the business's own website, public listings, and public reviews. If you're meeting in person, you can also notice things at the location itself, such as signage, hours, and how busy it is."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'How long to spend', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A lead-generation agency's blog suggests a short time box of about five to ten minutes for small businesses, with the first ten to fifteen minutes giving most of the value for any prospect. That agency sells outreach services, and the numbers are its own rule of thumb and not research. The principle matters more than the numbers: stop when you have two or three useful points you'll actually use, because information you won't use is just trivia."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Use it to ask, not to impress', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The same source suggests using what you learn to ask sharper questions and not to show off. Compare the two approaches."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Showing off: \"I saw you opened a second location in March and your reviews mention slow service.\"","Asking: \"I understand you recently opened a second location. How is that going so far?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["The second version invites the owner to tell their story, whereas the first can feel like surveillance."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What to leave alone', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Keep to professional, business-relevant, publicly shared information. These are firm limits.","Do not search for or mention personal details (family, home, health, personal social media, finances) that the person has not shared with you or made public for business purposes.","Do not bring up information that a third party told you in confidence.","Do not collect or store personal information you do not need.","Do not pretend to a connection you do not have.","Do not use information obtained in a way you would not want to explain.","If something personal comes up on its own, such as a customer telling you about their family, listen warmly and do not use it to pressure them. You can note what they chose to share for the next conversation, such as \"mentioned a daughter starting school in the fall,\" if it's the kind of thing a friendly acquaintance would remember.","Resona keeps customer information in the company database, limited to non-sensitive information, and purges it after 365 days of no subscription. Keep to that standard by collecting only what you need to help the customer, and do not ask for or record anything sensitive. If a customer volunteers something sensitive, do not write it down, and tell your leader if you are unsure how to handle it.","Privacy and data rules vary by place, and counsel may want to confirm the retention rule and the wording customers are given."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Write it down', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["After each contact, write a short note covering what they said they want, what concerns they raised, what you promised, and the next step with a date. Notes are what make the next conversation feel like a continuation and not a restart."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l22-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which of these should you leave alone when preparing to contact a business owner?","explanation":"Preparation stays with professional, business-relevant, publicly shared information, and personal details the person hasn't shared aren't yours to search for or mention.","points":1,"position":1,"options":[{"id":"a","label":"Personal details about their family that they haven't shared for business purposes"},{"id":"b","label":"Your own notes from earlier conversations"},{"id":"c","label":"The business's public website and reviews"},{"id":"d","label":"What the business sells and whom it serves"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"A few minutes of focused, respectful preparation helps you ask better questions, provided you stick to business-relevant, public information."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before you go in, pick two facts you'll use and one question that grows from them, and leave the rest."}$j$::jsonb);

  -- Lesson 2.3 -- Set a Goal for the Conversation
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Set a Goal for the Conversation', '', 3, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why a goal helps', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can write a specific goal for a conversation, explain why the goal is usually a next step and not a sale, and use a one-minute plan."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A sales trainer's open textbook says that without a goal set before the call, it's hard to know what to say, and that clear goals make a salesperson more confident and organized while respecting the customer's time. A goal also lets you tell afterward whether the conversation worked."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Success is not always a sale', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["For many small purchases, a decision can happen in one conversation, but often it doesn't, and that's fine. The same textbook notes that a first call may aim to build trust, learn how the person decides, or find out about their current situation, and that \"success doesn't always mean closing.\" It also warns that overreaching, such as trying to close a major sale on the first call, sets you up for failure.","One way to think about it is in three levels."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Minimum: the least that would make this conversation worthwhile: \"Learn the owner's top frustration and permission to follow up.\"","Target: what you realistically want: \"Agree on a short follow-up conversation with a specific date.\"","Stretch: a bonus if it goes very well: \"The owner decides to start today.\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["The three levels are a teaching device for this course and don't come from the textbook. The advice to set a realistic, specific goal does."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Make the goal specific', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The textbook gives a set of qualities for a good objective, often called SMART: it's specific, which means it names the action or information, and measurable, so you can tell afterward whether you got there. It's also actionable, because you can influence it, realistic for the stage you're at, and time-bound, with a \"by when.\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Vague: \"Find out about their business.\" Specific: \"By the end of the conversation, learn what takes up most of the owner's week and what they have tried before.\"","Vague: \"Make a sale.\" Specific: \"Agree on one next step with a date.\"","Vague: \"Build rapport.\" Specific: \"Learn one thing about the owner that is not about our product, and use it in the follow-up.\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["According to the same source, writing the goal down helps."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The goal belongs to the customer too', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A goal is a direction and not a trap, so if the customer's needs lead somewhere else, follow them. A conversation that ends with \"this isn't a fit\" and mutual respect has still met a good goal, because you learned something true and the person's time wasn't wasted."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A one-minute plan', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Before each conversation, write four lines. The first covers who you're talking to and what you know, which should be two or three facts. The second is your goal at the minimum, target, and stretch levels. The third is your first question, an opening that invites them to talk, and the fourth is the commitment you'll ask for at the end, which should be a specific next step.","Here is an example, which is fictional."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Who: Marco runs a three-person plumbing shop. Opened a second truck this spring. Spoke once; he said scheduling is a headache.","Goal: Minimum: learn what he's using now. Target: book a 20-minute follow-up this week. Stretch: he signs up today.","First question: \"Last time you mentioned scheduling is a headache. What's the hardest part this month?\"","Ask at the end: \"Can I send you a short walk-through and call Thursday at 3?\""]}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-l23-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why is the goal for a conversation often a next step and not a sale?","explanation":"For many decisions a first conversation can't carry the whole sale, so a specific next step with a date is a realistic target that respects the customer's pace.","points":1,"position":1,"options":[{"id":"a","label":"Sales aren't allowed in a first conversation"},{"id":"b","label":"A next step is easier to keep from your leader"},{"id":"c","label":"Customers only decide on a second call"},{"id":"d","label":"Many decisions take more than one conversation, and overreaching can set you up to fail"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"A specific, realistic goal, usually a next step, keeps a conversation focused, and following the customer when they lead somewhere else is part of meeting it."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Write your goal on paper before you walk in or dial, and when the conversation ends, check it and note what you learned."}$j$::jsonb);

  -- Lesson 2.4 -- Your Own Readiness
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Your Own Readiness', '', 4, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Everyone feels it', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe how nerves and avoidance show up in selling, use practical habits to get started, and know when to ask for help."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Talking with strangers about buying is uncomfortable for many people, including experienced salespeople. Feeling nervous doesn't mean you're unsuited to the work; it means you're doing something that matters to you."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'When nerves become avoidance', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A research report from Baylor University's Keller Center (2010) looked at sales call reluctance, which is emotional discomfort that gets in the way of reaching out to enough people. It surveyed 3,319 real estate agents and described twelve ways the discomfort shows up, including avoiding calls to people you know, hesitating to use the phone, over-preparing instead of calling, resisting coaching, and waiting for the \"right moment.\" Agents with higher reluctance scores made fewer prospecting contacts the previous week, and the report's authors suggest that awareness alone may be enough for many people.","The source needs care. The authors sell the assessment used in the survey and related books, the study covered one profession (real estate) in 2010, and it shows association and not cause. This lesson uses it only for the list of avoidance behaviors, which many people recognize in themselves."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Spot your own pattern', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Polishing notes or materials instead of reaching out: Over-preparing. Try...: Set a timer; when it ends, make the first contact.","Waiting for a better moment: Avoiding. Try...: Pick a fixed time and protect it.","Skipping people you know: Social discomfort. Try...: Start with a simple, honest conversation, not a pitch.","Dreading the worst outcome: Expecting rejection. Try...: Remember the likely outcome is \"not now,\" not an insult.","Needing every answer first: Fear of looking unprepared. Try...: Practice saying \"let me find out.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Practical habits that help', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Starting small makes the first contact easy, since a short, friendly opener asks little of you. A fixed block of time for outreach, protected like an appointment, takes away the daily decision about when to begin, and saying your opener out loud once or twice beforehand warms you up. A modest, specific goal is also easier to start than a large one.","Reframing a no helps as well, because a no is information: it usually means \"not this, not now,\" and it tells you what to adjust. It's better to review after a batch of contacts than during it, so make three contacts and then look at what you learned. Looking after the basics matters too, meaning sleep, food, and a short break between conversations, and talking with a teammate or leader who has been through it can make the whole thing feel more ordinary."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'When to ask for help', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Ask your leader or trainer if you keep avoiding contact despite wanting to reach out, or if you dread it so much that it's affecting your sleep or mood. The same applies if you feel pressure to cross a line to hit a number, or if you're unsure what to say and have no one to practice with.","Asking for help is a normal part of learning the job. If stress or anxiety feels overwhelming, a doctor or counselor is the right place to turn, and it's fine to say so to your leader."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l24-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"You notice you keep polishing your notes instead of making the first call. Which habit helps?","explanation":"Over-preparing is a common way avoidance shows up, and a fixed time limit turns preparation back into action.","points":1,"position":1,"options":[{"id":"a","label":"Wait until you feel completely ready"},{"id":"b","label":"Set a timer, and make the first contact when it ends"},{"id":"c","label":"Send a long email instead of calling"},{"id":"d","label":"Add more research until you have every answer"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Nerves are normal, and starting small, protecting outreach time, and asking for help early keep them from turning into avoidance."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before your first contact of the day, say your opener aloud once, and then make the contact before you can talk yourself out of it."}$j$::jsonb);

  -- MODULE 2 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 2 Check', '', 5, 10, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 2 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 2 Check","tone":"info","body":"Answer every question correctly to unlock Module 3."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-m2-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"Why is it useful to know who a product does not fit?","explanation":"Correct answer: It lets you qualify politely, avoid mismatches and complaints, and makes your \"yes, this fits\" more believable","points":1,"position":1,"options":[{"id":"a","label":"It lets you avoid conversations with people who ask hard questions"},{"id":"b","label":"It lets you lower the price for customers who are a weaker fit"},{"id":"c","label":"It lets you qualify politely, avoid mismatches and complaints, and makes your \"yes, this fits\" more believable"},{"id":"d","label":"It is mainly useful for managers who review the sales numbers"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-m2-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"You hear a customer got an extraordinary result and are tempted to say \"customers usually get this.\" What is the right approach?","explanation":"Correct answer: Describe it as one example, not as typical, and only if it is true","points":1,"position":2,"options":[{"id":"a","label":"Describe it as one example, not as typical, and only if it is true"},{"id":"b","label":"Say it, since a strong result makes the product sound good"},{"id":"c","label":"Quote a larger number so the result sounds more believable"},{"id":"d","label":"Avoid answering the question about results"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-m2-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer asks something you do not know. What is the best response?","explanation":"Correct answer: Say you will find out and give them a time, then do it early","points":1,"position":3,"options":[{"id":"a","label":"Give your best guess with confidence"},{"id":"b","label":"Change the subject to something you know well"},{"id":"c","label":"Say the company will email them at some point"},{"id":"d","label":"Say you will find out and give them a time, then do it early"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"se-m2-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is the most valuable thing to check before contacting a returning prospect?","explanation":"Correct answer: Your own notes from earlier conversations","points":1,"position":4,"options":[{"id":"a","label":"Their personal social media accounts"},{"id":"b","label":"Your own notes from earlier conversations"},{"id":"c","label":"Details about their family"},{"id":"d","label":"Their home address"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"se-m2-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is the better way to use something you learned about a business before a call?","explanation":"Correct answer: Use it to ask an open question that invites the owner to tell their story","points":1,"position":5,"options":[{"id":"a","label":"Recite everything you found, to show you did your homework"},{"id":"b","label":"Use it to ask an open question that invites the owner to tell their story"},{"id":"c","label":"Hold it back so you can use it for pressure later"},{"id":"d","label":"Share it with other customers as a talking point"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"se-m2-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"Which goal is specific?","explanation":"Correct answer: By the end of the call, learn what takes the most time in their week and agree on a follow-up date","points":1,"position":6,"options":[{"id":"a","label":"Find out about their business"},{"id":"b","label":"Make a good impression"},{"id":"c","label":"Sell something"},{"id":"d","label":"By the end of the call, learn what takes the most time in their week and agree on a follow-up date"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"se-m2-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is a sign of sales call reluctance as described in this lesson?","explanation":"Correct answer: Polishing materials again and again instead of reaching out","points":1,"position":7,"options":[{"id":"a","label":"Polishing materials again and again instead of reaching out"},{"id":"b","label":"Making a plan and then contacting people"},{"id":"c","label":"Taking a break between conversations"},{"id":"d","label":"Asking a teammate for help"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 9, $j${"gates_progress":true,"question":{"id":"se-m2-check-8","assessment_id":null,"question_type":"multiple_choice","prompt":"What should you do if you feel pressure to cross a line to hit a number?","explanation":"Correct answer: Talk to your leader and decline to do anything misleading or pushy","points":1,"position":8,"options":[{"id":"a","label":"Cross it just this once to reach the number"},{"id":"b","label":"Keep the pressure to yourself and hope it passes"},{"id":"c","label":"Talk to your leader and decline to do anything misleading or pushy"},{"id":"d","label":"Blame the customer if the number is missed"}],"correct_option_id":"c"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 3: Opening and Rapport
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Opening and Rapport', '', 3)
  returning id into v_m;

  -- Lesson 3.1 -- The First Thirty Seconds
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'The First Thirty Seconds', '', 1, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What an opening has to do', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can open a conversation by saying who you are, why you are there, and asking permission to continue, and you can name common openers that backfire."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A small business owner is usually in the middle of something when you appear, and in the first moments they are silently asking three questions: who you are, what you want, and how long this will take. A good opening answers all three quickly, honestly, and politely, and then asks permission to continue. It doesn't try to sell anything yet."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A simple structure', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Name: Your name and company. Example (fictional): \"Hi, I'm Jordan with Resona.\"","Reason: Why you are reaching out, in one sentence. Example (fictional): \"I'm talking with local shop owners about how they handle their appointment scheduling.\"","Why them (optional): One fact from your preparation. Example (fictional): \"I saw you opened a second chair this year.\"","Permission and time: Ask whether now works and say how long. Example (fictional): \"Do you have two minutes, or is there a better time?\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["That's the whole structure, and once you've said it, the owner decides what happens next."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Details that matter', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A Canadian open textbook on selling (Selling for Success, NSCC, 2023) lists habits that apply to every kind of opening. Getting the name right matters, because spelling and pronunciation errors signal that you didn't care enough to check. The textbook also quotes the advice \"Don't be interesting; be interested,\" since questions and follow-ups show real interest, and it recommends having a one-minute description of what you do ready, so you can answer \"what is this about?\" without rambling.","For phone openings, the same textbook suggests stating your name and purpose within about 20 seconds, using a prepared script. It also advises asking \"Is this a good time?\" and not a question that invites an easy no, such as \"Did I catch you at a bad time?\" It recommends skipping \"How are you today?\" as a cold opener, because it sounds like a script, and something like \"Thanks for taking my call\" works better. Long explanations are best avoided, since busy decision-makers see cold calls as interruptions."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Openers that backfire', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["\"I'm not trying to sell you anything\" (when you are): Misleading, and people hear it as a sales line.","\"How are you today?\" read in a flat voice: Signals a script.","A long description of the company: Makes the person wait to learn why you are there.","\"Is the owner in?\" with no name or reason: Gatekeepers hear it as a pitch and the owner hears it as an interruption.","An unrelated compliment you do not mean: Fake rapport.","Launching into features: Skips the person completely."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'If the answer is "not now"', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["\"Not now\" is a complete, fair answer, and a good reply sounds like this:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"No problem at all. When would be better, or would you rather I send a short note first?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Then do exactly what you offered. A person who is treated well when they say \"not now\" is much more likely to say yes later."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Practice the opener', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Write yours in two sentences, say it aloud, and time it. If it takes more than about twenty seconds, cut it."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l31-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why does a good opening end with a request for permission?","explanation":"Asking whether now works and how long you need respects the owner's time, and it leaves the decision about what happens next with them.","points":1,"position":1,"options":[{"id":"a","label":"It prevents the person from saying no"},{"id":"b","label":"It gives the person control over whether and when the conversation continues"},{"id":"c","label":"It lets the seller skip the introduction"},{"id":"d","label":"It lets the seller start the pitch sooner"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"A good opening says who you are and why you're there and then asks permission, which leaves the decision about what happens next with the person you're talking to."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Write your opener, read it aloud, and cut every word the person doesn't need in the first twenty seconds."}$j$::jsonb);

  -- Lesson 3.2 -- Rapport Without Fakery
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Rapport Without Fakery', '', 2, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What rapport is', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can describe how rapport is built from real interest, listening, and respect, and say why technique-driven tricks tend to backfire."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Rapport is the sense that the other person is comfortable with you and that you're on the same side. It isn't charm or a trick; it grows when a person feels heard, respected, and not rushed.","High self-orientation lowers trust, and rapport works in the same way: the less you appear to be working an angle, the more people relax."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What builds it', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Genuine interest: Asking about their business and caring about the answer.","Listening fully: Not interrupting; not planning your reply while they talk.","Using their name: Spelled and pronounced correctly.","Matching their pace: Brief with a busy owner, more relaxed with someone who wants to talk.","Respecting their time: Saying how long you need, and keeping to it.","Finding real common ground: Noticing something you actually share, such as a neighborhood or a shared challenge.","Warmth and humor, naturally: A smile, a light comment, but never at their expense.","Following through: Doing what you said you would do."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Listening that shows', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["People can tell whether you're listening, and a few simple habits make it visible. Pausing for a second before you answer tells the person that you thought about what they said. Saying back the key point (\"So the biggest headache is the Monday schedule changes\") confirms you heard it, and a follow-up question proves you caught the detail. Putting the phone away and facing the person helps, as does taking a brief note and saying so: \"Mind if I jot that down?\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A caution about mirroring and other techniques', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["You'll meet advice to copy the other person's posture, gestures, and speech to create rapport, and some of it is harmless. A former FBI behavioral analyst writing in Psychology Today describes people naturally mirroring each other when they're comfortable. That article is a blog post based on anecdotes, it cites no studies, and a number of its claims have no support, so it's best treated as a description of what comfort sometimes looks like and not as a method.","There are three reasons not to rely on technique. Forced mimicry looks odd, and people notice. It also shifts your attention to yourself instead of the customer, which raises self-orientation. And gestures are ambiguous, since crossed arms can mean discomfort, a cold room, or simple habit. If you want one rule, it's to be natural, be interested, and let your body language follow your attention."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Small talk, in measure', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Small talk works when it's short, relevant, and optional. A comment about something visible and positive (\"Great storefront\") is fine, and you should move on if the person is busy. Follow their lead: if they want to chat, chat for a minute, and if they're watching the door, get to the point. Avoid sensitive subjects such as politics, religion, and personal matters, and do not flatter falsely. If you can't say it honestly, don't say it."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Respect is the foundation', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Respect shows in small things: arriving when you said, not interrupting their work with customers, not touching their things, and accepting a no gracefully. Rapport that rests on respect survives disagreement, whereas rapport that rests on technique does not."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l32-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why does forced mirroring tend to backfire?","explanation":"Rapport comes from real interest and listening, and copying someone's posture on purpose shifts your attention to technique and away from the customer.","points":1,"position":1,"options":[{"id":"a","label":"It is against company policy"},{"id":"b","label":"It only works with people you already know"},{"id":"c","label":"It turns your attention to yourself, which raises self-orientation, and people notice"},{"id":"d","label":"It makes the conversation too long"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Real interest, full listening, and respect build rapport that lasts, whereas tricks tend to backfire because they shift your attention from the customer to yourself."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"In your next conversation, count how many times you say back something the person said, and aim for at least two."}$j$::jsonb);

  -- Lesson 3.3 -- Reading Signals
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Reading Signals', '', 3, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Signals are clues, not answers', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can recognize common signs of interest, hesitation, and \"not now,\" and respond by checking in instead of guessing."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["People show how they feel through words, tone, pace, and body language. These are clues, and they can be misread, so the best practice is to notice and then check.","The Psychology Today article from the previous lesson lists cues such as leaning in, open posture, and nodding as signs of comfort, and crossed arms or objects placed between people as signs of distance. Its evidence is anecdotal, and the author's own examples show many exceptions, so the cues are best used only to prompt a question."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A signal guide', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Asks questions about details or how it works: Interest. A good response: Answer simply, then ask what matters most to them.","Leans in, nods, says \"go on\": Engaged. A good response: Keep going, and invite their view.","Short answers, looking away, checking the time: Rushed or uninterested. A good response: Say: \"I can see you're busy. Should I come back, or give you the one-minute version?\"","Interrupts you: Impatient or has a concern. A good response: Stop and ask what they were about to say.","Silence: Thinking, or lost. A good response: Wait a few seconds, then: \"What's on your mind?\"","Long list of \"what ifs\": Worry. A good response: Ask which worry matters most.","Polite but vague (\"sounds interesting\"): Possibly no, softly. A good response: Ask: \"What would you want to see to know if it's worth a closer look?\"","Glances at customers, employees, or the door: Their attention is elsewhere. A good response: Offer to pause or follow up.","Warmth and humor: Comfort. A good response: Stay natural and do not push."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Check in out loud', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["You don't have to guess. Short check-ins are respectful and effective, and a few examples are \"Is this useful so far?\", \"Am I explaining this clearly?\", \"What questions come to mind?\", and \"Would it help to stop here and pick it up another time?\"","A check-in gives the person an easy way to steer you. Many people will say \"I'm just busy right now,\" and you'll learn it isn't a no."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Hear the real "no"', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A polite owner may not say no directly. Several phrases often mean \"no, thank you\": \"Send me some information\" with nothing more, \"Let me think about it\" with no question asked, \"Maybe next quarter\" with no reason, and not returning calls after a clear interest.","These are best treated as honest signals and not as tricks. Ask once, kindly, and respect the answer: \"It sounds like this may not be the right time or fit. Is that fair to say?\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Take your own signals seriously', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Notice yourself too. If you feel the urge to speed up, talk more, or push, that's a signal to slow down and ask a question."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l33-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"A prospect gives short answers and keeps checking the time. What is the best response?","explanation":"Signals are clues and not answers, so noticing them and then checking in out loud respects the person's time and lets them steer.","points":1,"position":1,"options":[{"id":"a","label":"Say you can see they're busy and ask whether to come back or give the one-minute version"},{"id":"b","label":"Speed up and cover every feature quickly"},{"id":"c","label":"Keep going, since they haven't said no"},{"id":"d","label":"Treat it as proof they aren't interested and leave"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Signals are clues and not answers, so noticing them and then checking in out loud works better than guessing, and a soft no deserves to be treated as a real answer."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"If you're unsure how a person feels, say so kindly: \"I can't tell if this is useful. Can you tell me honestly?\""}$j$::jsonb);

  -- Lesson 3.4 -- Different Settings
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Different Settings', '', 4, 8, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'In person', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can adapt your opening to in-person, phone, video, and written contact, and describe the basic rules about unsolicited calls and texts."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Walking into someone's business makes you a guest in their workplace, so start by reading the room. A line of customers or a rush is the wrong time, and the right move is to offer to come back. Never interrupt a customer interaction to talk to the owner. Ask for the right person politely (\"Is the owner or manager available for two minutes?\") and respect the answer, then introduce yourself briefly with your name, company, and purpose.","If they ask, leave something simple behind, such as a card or short note with your contact details and what to expect. Noticing the setting, including the space, the hours, and how things work, helps you ask better questions later. And be easy to leave: thank them and go when they signal they're done."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Phone', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The same open textbook recommends being brief and direct on the phone, since rapport is harder without visual cues. State your name and purpose within about 20 seconds, ask whether it's a good time and offer to call back, and avoid long explanations. A few practical points add to that: stand or sit upright, because it affects your voice, speak a bit slower than feels natural, and have your goal and notes in front of you."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Video', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A marketing agency's guide to video sales calls (the agency sells inbound-marketing training, and the post dates from 2020) gives practical points that are common sense for any video call. Test your setup first, including the camera, microphone, and meeting link, and face your light source, since a window behind you leaves you in shadow. Sit upright and frame yourself so your face is visible, and smile and look at the camera sometimes, because on video a neutral face can look serious. If the person is unsure how the tool works, explain it, use their name, and invite them into the conversation. Address distractions politely and keep to the time you said.","The post claims that close rates are higher with cameras on but cites no source, so that claim isn't used here. Do not require a customer to turn on their camera. Offering is fine, and some people can't or prefer not to."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Email, text, and social', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["According to the open textbook, written first contact is a first impression. Proofread, use the person's name correctly, and personalize every message so it doesn't look like a template. Keep it short, with one clear ask. Persistence is fine and pestering is not, so space out follow-ups and stop when asked. On social networks, personalize connection requests, contribute value before pitching, and remember that anything you post can be seen by customers."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Rules about unsolicited calls and texts', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Rules about phone calls, text messages, and email to people you haven't spoken with before exist, and they can be strict. This is a legal area, and what follows is a general orientation and not legal advice. The rules vary and change, and the primary sources were not read for this course.","Three things came out of the sources that were read. A 2024 law-firm update says the Federal Trade Commission's Telemarketing Sales Rule was amended so that its ban on false or misleading statements now applies to business-to-business calls as well as consumer calls. This matters because most Resona customers are businesses, and the simple rule that follows is that everything you say on a sales call must be true.","A compliance-software vendor's page states that business-to-business marketing is not exempt from all rules. It says that sending marketing calls or texts to a mobile number using an automatic dialing system generally requires the recipient's prior express written consent, whether the recipient is a business or a consumer. The vendor sells compliance products, and the page didn't say who qualifies, how the rules apply to small business owners' personal mobile numbers, or what the penalties are. Finally, the details of Do Not Call rules for business numbers weren't clear in the material that was read.","Until management sets a written rule, our practice is as follows.","Use only company-approved tools and templates for calls, texts, and emails.","Do not send marketing texts to a mobile number unless the person has given consent through an approved process.","Do not use automated dialing or messaging tools unless they are company-approved.","Honor \"stop,\" \"unsubscribe,\" and \"do not contact\" immediately, and record it.","Ask your leader whenever you are unsure.","A written contact policy covering calls, texts, and email, including consent and opt-outs, is an open item for management and counsel."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l34-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Until management sets a written contact policy, what is the practice for marketing texts?","explanation":"Rules on texts and automated tools can be strict and the primary sources weren't reviewed for this course, so the safe practice is approved tools, approved consent processes, and asking your leader when unsure.","points":1,"position":1,"options":[{"id":"a","label":"Send them to business numbers, since business-to-business is exempt"},{"id":"b","label":"Send them from your own phone for speed"},{"id":"c","label":"Send them only after the person ignores an email"},{"id":"d","label":"Do not send them unless the person has given consent through an approved process"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Each setting asks for a slightly different approach, but respecting the person's time, following the contact rules, and saying only what is true apply to all of them."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before each contact, ask whether this is the right moment and the right channel for this person, and if you're not sure, ask first."}$j$::jsonb);

  -- MODULE 3 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 3 Check', '', 5, 10, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 3 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 3 Check","tone":"info","body":"Answer every question correctly to unlock Module 4."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-m3-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"Which opening best follows the structure in this module?","explanation":"Correct answer: \"Hi, I'm Jordan with Resona. I'm talking with local shop owners about scheduling. Do you have two minutes, or is there a better time?\"","points":1,"position":1,"options":[{"id":"a","label":"\"How are you today? Let me tell you about our features.\""},{"id":"b","label":"\"I'm not selling anything. Is the owner in?\""},{"id":"c","label":"\"Hi, I'm Jordan with Resona. I'm talking with local shop owners about scheduling. Do you have two minutes, or is there a better time?\""},{"id":"d","label":"\"Great place! What can I show you first?\""}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-m3-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"Why is \"Is this a good time?\" better than \"Did I catch you at a bad time?\"","explanation":"Correct answer: The second invites an easy \"yes, it's bad\"; the first asks for a real answer and a better time","points":1,"position":2,"options":[{"id":"a","label":"The second invites an easy \"yes, it's bad\"; the first asks for a real answer and a better time"},{"id":"b","label":"It is longer, so it sounds more polite"},{"id":"c","label":"It is legally required for sales calls"},{"id":"d","label":"It sounds more formal to a business owner"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-m3-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"A business owner says \"not now.\" What is the best response?","explanation":"Correct answer: Say no problem, ask when would be better, and do what you offered","points":1,"position":3,"options":[{"id":"a","label":"Keep talking, since they have not actually said no"},{"id":"b","label":"Argue that now is the best time to decide"},{"id":"c","label":"Leave and never contact them again"},{"id":"d","label":"Say no problem, ask when would be better, and do what you offered"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"se-m3-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is the strongest way to build rapport?","explanation":"Correct answer: Show real interest, listen fully, and respect their time","points":1,"position":4,"options":[{"id":"a","label":"Copy their posture and speech exactly"},{"id":"b","label":"Show real interest, listen fully, and respect their time"},{"id":"c","label":"Compliment them on something you do not mean"},{"id":"d","label":"Talk about yourself so they get to know you better"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"se-m3-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer crosses their arms. What is the best approach?","explanation":"Correct answer: Treat it as a clue only, and check in out loud (\"Is this useful so far?\")","points":1,"position":5,"options":[{"id":"a","label":"Assume they dislike you and end the conversation"},{"id":"b","label":"Treat it as a clue only, and check in out loud (\"Is this useful so far?\")"},{"id":"c","label":"Ignore it and continue as planned"},{"id":"d","label":"Cross your arms too, to build rapport"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"se-m3-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"Which of these usually means \"no, thank you\" in polite form?","explanation":"Correct answer: \"Maybe next quarter,\" with no reason and no follow-up question","points":1,"position":6,"options":[{"id":"a","label":"\"Tell me more about the setup.\""},{"id":"b","label":"\"What does it cost?\""},{"id":"c","label":"\"Can you show me how it works?\""},{"id":"d","label":"\"Maybe next quarter,\" with no reason and no follow-up question"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"se-m3-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"You walk into a shop and a line of customers is waiting. What should you do?","explanation":"Correct answer: Offer to come back later, or leave a card without interrupting the customers","points":1,"position":7,"options":[{"id":"a","label":"Offer to come back later, or leave a card without interrupting the customers"},{"id":"b","label":"Ask for the owner anyway, since you only need a minute"},{"id":"c","label":"Wait at the counter and speak louder to get attention"},{"id":"d","label":"Start a short demo to show why you're there"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 9, $j${"gates_progress":true,"question":{"id":"se-m3-check-8","assessment_id":null,"question_type":"multiple_choice","prompt":"A coworker wants to send a marketing text to a prospect's mobile phone with an automated tool you have not seen before. What do you do?","explanation":"Correct answer: Hold off, use only approved tools and consent processes, and ask your leader","points":1,"position":8,"options":[{"id":"a","label":"Let them, since business-to-business messages are exempt"},{"id":"b","label":"Send it from your own phone instead"},{"id":"c","label":"Hold off, use only approved tools and consent processes, and ask your leader"},{"id":"d","label":"Send it twice to make sure it arrives"}],"correct_option_id":"c"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 4: Discovery
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Discovery', '', 4)
  returning id into v_m;

  -- Lesson 4.1 -- Why Questions Beat Pitches
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Why Questions Beat Pitches', '', 1, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What discovery is', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain what discovery is for, describe what you are trying to learn, and say why investigating before presenting makes a conversation better for both people."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Discovery is the part of the conversation where you learn whether, and how, what you offer fits this person's situation. It happens after the opening and before you present anything.","It serves two purposes. For the customer, it's a chance to describe their situation and realize what matters to them, often for the first time out loud. For you, it's how you learn enough to give honest, relevant help, or to learn that you can't."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The problem with pitching first', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Compare two moments with the same owner, a fictional hair-salon owner named Lena."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Pitch first:","\"Our platform handles scheduling, reminders, reporting, and payments in one place.\"","Lena's silent reaction: \"I already use a paper book and it works fine. What does this have to do with me?\"","Question first:","\"What's the most frustrating part of running the schedule right now?\"","Lena's reaction: \"Honestly? No-shows. I lose about a chair a day when someone doesn't come.\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["In the first version Lena has to decide, alone, whether any of the features matter. In the second she names the problem herself, and everything you say later has something to attach to."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Sellers who investigate first', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["An open textbook on selling (Selling for Success, Nova Scotia Community College) teaches a four-part flow for a call: opening, investigating, demonstrating capability, and obtaining commitment. It says the investigation has to come before the presentation, \"or the pitch will miss.\" The textbook builds that flow on the SPIN research described in the next lesson, so it's a well-organized teaching model and not independent proof. A search for independent studies of questioning in small-sale selling turned up no source reliable enough to cite, so this course teaches discovery on the strength of practice and common sense: it's hard to help someone you haven't listened to."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What you are trying to learn', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["For a small business owner, discovery usually covers six things, though you won't need all of them in one conversation."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Situation: how things work today: \"Walk me through how a typical week goes.\"","Problem: what is not working: \"What's the most frustrating part of that?\"","Impact: what it costs them (time, money, stress, customers): \"What does that cost you when it happens?\"","Goal: what better would look like: \"If that were fixed, what would be different?\"","Constraints: what limits their choices: \"Is there anything that would make a change hard right now?\"","Decision: who decides, and how: \"Who else would weigh in on something like this?\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Honest discovery', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Discovery isn't a tool for finding a lever to pull, and two rules keep it honest. Ask because you want to know and not to steer, since if you've already decided what the answer should be, you're pitching with question marks. And be ready for answers that point away from your product: \"My real problem is hiring\" is useful and true, and it may mean you aren't the right help, which is worth saying plainly."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l41-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why does a question-first opening work better than a pitch-first opening?","explanation":"When the owner describes the problem in their own words, your later explanation answers something they said and not something you assumed.","points":1,"position":1,"options":[{"id":"a","label":"It lets you avoid talking about the product altogether"},{"id":"b","label":"It is always shorter than a pitch"},{"id":"c","label":"The person names their own problem, so everything you say later has something to attach to"},{"id":"d","label":"It gives the seller a chance to steer toward a yes"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Learning the person's situation, problem, and goal before presenting gives everything you say later something to attach to, which is why the questions have to be asked because you want to know."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before presenting anything, ask yourself whether you could explain this person's biggest frustration in their own words, and if you can't, ask more."}$j$::jsonb);

  -- Lesson 4.2 -- A Question Toolkit
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'A Question Toolkit', '', 2, 8, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Three kinds of question', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can use open, closed, and probing questions on purpose, apply the four SPIN question types with their limits, and avoid leading, loaded, or interrogating questions."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Open: Cannot be answered with yes or no; invites explanation. Good for: Getting the story. Example: \"How do you handle appointment changes now?\"","Closed: Short answer: yes, no, a number. Good for: Confirming facts; narrowing. Example: \"Do you have more than one location?\"","Probing: Follows up on something they just said. Good for: Going deeper; clarifying. Example: \"You said Mondays are chaotic. What happens?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["A useful rule of thumb is to start open, probe to understand, and then close to confirm. Closed questions shouldn't be used to steer (\"You'd like to save time, wouldn't you?\"), because that isn't discovery."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The SPIN framework', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Neil Rackham and colleagues developed a well-known framework for questions from observations of sales calls. It sorts questions into four kinds, and the open textbook gives examples."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Situation: Learn basic facts about their current setup. Example (fictional salon): \"How many stylists work here, and how do they book clients?\"","Problem: Help them name a difficulty or dissatisfaction. Example (fictional salon): \"What's hardest about handling the booking book?\"","Implication: Explore what the problem leads to. Example (fictional salon): \"When someone no-shows, what happens to the rest of that day?\"","Need-payoff: Let them say what a solution would be worth. Example (fictional salon): \"If you could fill that gap, what would that mean for you?\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Using SPIN well, and its limits', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["SPIN gets some things right. It moves from facts to difficulties, then to consequences, and then to benefits, and it lets the customer state the value. It also encourages you to ask more and tell less.","There are limits to keep in mind, drawn from the open textbook's cautions and from this course's own. Situation questions work best sparingly, because too many bore people, and doing the research first means you don't ask what you could have looked up. Don't assume the person sees the problem just because you do; ask and don't tell, and investigate before presenting benefits, or the pitch will miss.","Implication questions must be honest. They exist to help a person see real consequences and not to create fear or inflate a problem, and if you're exaggerating to build pressure, stop, because that is the pressure tactic covered in Module 1.","The research behind SPIN has limits as well. The best-known source is the framework's own training company, which describes the original research as concerning major, high-value sales and not small ones, and it gives few statistical details, so its claims can't be checked. SPIN is therefore best treated as a useful way to organize questions and not as proven science or a script. A conversation with a small business owner often takes two or three minutes of questions and not a full SPIN sequence."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Questions that go wrong', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Leading (suggests the answer): \"Wouldn't you agree your schedule is a mess?\" Better: \"How would you describe your schedule right now?\"","Loaded (assumes something): \"When did you start losing money on no-shows?\" Better: \"How much of an issue are no-shows?\"","Stacked (several at once): \"How many stylists, and what software, and what's your budget?\" Better: One at a time.","Interrogating (rapid-fire): A string of questions with no response in between. Better: Pause, acknowledge, then ask.","Closed when you needed open: \"Do you have scheduling problems?\" Better: \"What scheduling challenges come up?\"","Too personal or not your business: \"What do you earn?\" Better: Ask about the business need, not private finances."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Questions that open people up', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Some prompts work well because they're natural. \"Tell me more about that\" invites detail, and \"What does a good week look like? And a bad one?\" gets at the range of their experience. \"What have you tried before?\" followed by \"What happened?\" shows what they already know, and \"What's the one thing you'd change if you could?\" surfaces priorities. Two others are \"What would make this worth looking at, and what would make it not worth your time?\" and \"Is there something I should be asking that I haven't?\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A short fictional exchange', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Jordan: \"Lena, thanks for the time. Before I say anything about us, can I ask a few questions about how you run the schedule?\"","Lena: \"Sure.\"","Jordan: \"How do clients book with you today?\"","Lena: \"Phone, text, walk-ins. I write it in a book.\"","Jordan: \"What's the most frustrating part of that?\"","Lena: \"No-shows. I lose a chair a day, sometimes.\"","Jordan: \"That sounds painful. What happens to the rest of that day when it happens?\"","Lena: \"I end up scrambling, and I'm there late.\"","Jordan: \"If you didn't have to scramble, what would that give you?\"","Lena: \"My evenings back.\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Jordan never mentioned a product, and Lena still named the problem, its effect, and what she wants."]}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-l42-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which question is leading and should be rewritten?","explanation":"A leading question suggests the answer you want, whereas an open version such as \"How would you describe your schedule right now?\" lets the person say what is true for them.","points":1,"position":1,"options":[{"id":"a","label":"\"Wouldn't you agree your schedule is a mess?\""},{"id":"b","label":"\"How would you describe your schedule right now?\""},{"id":"c","label":"\"What have you tried before?\""},{"id":"d","label":"\"What takes the most time each week?\""}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Starting open, probing, and then confirming gives you the person's story, and SPIN can organize the questions as long as you ask honestly and never manufacture pressure."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Prepare three open questions for the next conversation, and write them where you can see them."}$j$::jsonb);

  -- Lesson 4.3 -- Listening for the Real Need
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Listening for the Real Need', '', 3, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What people say and what they need', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can use paraphrasing, summarizing, and clarifying to confirm you understood, and tell the difference between what someone says and what they need."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The first answer is often not the whole answer."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["\"It's too expensive.\": \"I'm not sure it will work for me.\"","\"We're fine.\": \"I haven't thought about it.\" or \"Not now.\"","\"I need to talk to my partner.\": A real second decision-maker, or a polite no.","\"We tried something like this.\": \"It went badly, and I'm wary.\"","\"Can you send me information?\": Interest, or a polite way to end the call."]}$j$::jsonb),
    (v_p, 'rich_text', 4, $j${"body":["You find out by asking kindly (\"What happened last time?\") and not by assuming."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Active listening skills', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A counselor-written overview of active listening lists these core skills, which transfer well to sales."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Paraphrasing: Restate what you heard in your own words. Example: \"So no-shows are your biggest drain.\"","Summarizing: Pull together the key points. Example: \"Let me check I've got it: bookings come by phone and text, no-shows cost you a chair a day, and you'd like your evenings back.\"","Reflecting: Repeat the essence, including the feeling, without parroting. Example: \"It sounds like that's stressful.\"","Clarifying: Ask about anything vague. Example: \"When you say 'a mess,' what does that look like?\"","Open questions and encouragers: Keep them talking. Example: \"Tell me more.\" \"And then?\"","Attending to tone and body language: Notice how it is said, as a clue. Example: \"I noticed you slowed down there. Is that a sore spot?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["The overview comes from a counselor's website and draws on counseling and communication research, most of which concerns counseling and healthcare and not sales. The skills are widely taught, so it's reasonable to use them here."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Say it back', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Saying back what you heard does three things: it shows you're listening, it corrects misunderstandings early, and it often prompts the person to add something important. A simple form makes it a habit:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"Let me make sure I have this right. [Their situation.] [Their problem.] [What they want.] Did I get that right?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["If they say \"not exactly,\" that's useful, and you can ask, \"What did I miss?\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Habits that get in the way', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Several habits get in the way of listening. Planning your answer while they talk means you miss the second half, and finishing their sentences feels presumptuous. Jumping to a solution the moment you hear a problem cuts the discovery short, and correcting someone when what they said is not quite right can derail them, so it's usually better to note it and move on unless it matters. Filling silences is another, since a pause often leads to the most honest part of the answer, and checking a phone or the room tells the person they don't have your attention."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Take notes, and say you are', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Write down what matters: their words, the problem, what they want, and any worries. Saying \"Mind if I jot that down?\" shows respect, and the notes make your follow-up specific. Record only business-relevant, non-sensitive information."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Listen for what limits their choices', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Besides the problem, listen for what limits their choices. Time shows up in remarks like \"We can't take anything on until after the holidays,\" and money in general terms in \"Cash is tight right now.\" Price is fixed, so you don't negotiate it, but you can be honest about what the plan costs and when it starts. People matter too (\"My staff hates new tools\"), as does history (\"We got burned by a contract\"), and so does the decision process (\"I run everything past my accountant\").","These limits tell you how to present honestly and what to avoid promising."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l43-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer says, \"We tried something like this before.\" What is the best next step?","explanation":"The first answer is often not the whole answer, and asking what happened last time shows what they need to hear before they can consider anything new.","points":1,"position":1,"options":[{"id":"a","label":"Assume they are not interested and move on"},{"id":"b","label":"Explain why your product is different, without asking"},{"id":"c","label":"Point out that earlier tools were poorly made"},{"id":"d","label":"Ask kindly what happened last time, since it may reveal a worry about repeating a bad experience"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"The need behind the words only comes out when you listen, say it back, and ask kindly about anything unclear."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"After the person finishes describing their situation, pause, summarize it in two sentences, and ask, \"Did I get that right?\""}$j$::jsonb);

  -- Lesson 4.4 -- When to Stop Asking
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'When to Stop Asking', '', 4, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'When you have enough', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can tell when you have learned enough, check whether the product truly fits, move from discovery to presenting with permission, and end politely when it does not fit."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["You don't need to ask forever. You can stop asking when you can honestly say that you understand their situation and the problem they care about, and that you know what they would like to change. You also need to know whether this could fit and what to avoid promising, and who decides and when. Over-asking turns a conversation into an interrogation and uses up their time."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A quick fit check', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Use what you know about who the product helps and who it doesn't, and ask yourself the following questions."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A real problem?: Did they describe something that matters to them?","A fit?: Does what we offer actually address it?","The right person?: Are they the one who decides, or will someone else weigh in?","Timing?: Is this a now thing, a later thing, or never?","Able and willing to commit?: The plan is a fixed-price subscription. Does that work for them in general terms, without you probing their finances?","Reasonable expectations?: Do they expect something we cannot honestly deliver?"]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["A venture investor's article argues that spotting poor-fit customers early saves time and builds trust. It's opinion with no data and it's written about larger business sales, so only the idea carries over."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Moving from discovery to presenting', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Before you present, summarize and ask permission:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"Based on what you've told me, it sounds like [situation, problem, goal]. Would it be useful if I showed you how some owners handle that, and you tell me whether it fits?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["This keeps the person in control and signals that what comes next is tied to their words."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'When it is not a fit', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Saying \"this is probably not right for you\" is a strength, because it earns trust and saves everyone time. It works best when done kindly and clearly:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"Based on what you've told me, I don't think this is the right fit. Your biggest challenge is hiring, and that isn't something we help with. I'd rather tell you now than waste your time. If something changes, I'm happy to talk again.\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Where you can, point to a better resource, such as a type of provider or a general source of help, without recommending a specific company unless Resona has an approved referral. Do not leave a poor-fit customer with a sale they'll regret, since it leads to refunds, complaints, and a bad name."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'When it is a fit but not now', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["When it's a fit but the timing is wrong, agree on a specific next step with a date, and note what the person said they need to see before deciding. Don't push, and follow up as agreed."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Record what you learned', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Write a short note right after the conversation covering their situation, the problem in their words, what they want, their constraints, who decides, and the next step. Keep it business-relevant and non-sensitive, and store it in the approved system."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l44-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What do you do before moving from discovery to presenting?","explanation":"A short summary followed by a request for permission keeps the person in control and ties what comes next to their own words.","points":1,"position":1,"options":[{"id":"a","label":"Quote the price so they know what to expect"},{"id":"b","label":"Summarize what you heard and ask permission to show how it might help"},{"id":"c","label":"Begin with the product's full feature list"},{"id":"d","label":"Ask three more closed questions to confirm interest"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Asking until you understand, checking the fit honestly, and being willing to say \"not a fit\" is what lets you ask permission to present with confidence."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"End each discovery with a two-sentence summary and a question: \"Did I get that right? May I show you how this might help?\""}$j$::jsonb);

  -- MODULE 4 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 4 Check', '', 5, 10, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 4 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 4 Check","tone":"info","body":"Answer every question correctly to unlock Module 5."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-m4-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"What is the main purpose of discovery?","explanation":"Correct answer: To learn whether and how the product fits the person's situation","points":1,"position":1,"options":[{"id":"a","label":"To find the person's weak spot so you can address it"},{"id":"b","label":"To fill time before the presentation begins"},{"id":"c","label":"To learn whether and how the product fits the person's situation"},{"id":"d","label":"To qualify the person's finances before going further"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-m4-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is an open question?","explanation":"Correct answer: \"How do you handle appointment changes now?\"","points":1,"position":2,"options":[{"id":"a","label":"\"How do you handle appointment changes now?\""},{"id":"b","label":"\"Do you have more than one location?\""},{"id":"c","label":"\"You'd like to save time, wouldn't you?\""},{"id":"d","label":"\"Is your schedule a mess?\""}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-m4-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is a leading question?","explanation":"Correct answer: \"Wouldn't you agree your schedule is a mess?\"","points":1,"position":3,"options":[{"id":"a","label":"\"How would you describe your schedule?\""},{"id":"b","label":"\"What takes the most time each week?\""},{"id":"c","label":"\"What have you tried before?\""},{"id":"d","label":"\"Wouldn't you agree your schedule is a mess?\""}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"se-m4-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"In SPIN, which type of question explores the consequences of a problem?","explanation":"Correct answer: Implication","points":1,"position":4,"options":[{"id":"a","label":"Situation"},{"id":"b","label":"Implication"},{"id":"c","label":"Problem"},{"id":"d","label":"Need-payoff"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"se-m4-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"Which statement about implication questions is most accurate?","explanation":"Correct answer: They should help a person see real consequences and never be used to create fear or inflate a problem","points":1,"position":5,"options":[{"id":"a","label":"They should exaggerate a problem so the person feels some pressure"},{"id":"b","label":"They should help a person see real consequences and never be used to create fear or inflate a problem"},{"id":"c","label":"They should be asked before any other kind of question"},{"id":"d","label":"They are only useful with large companies"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"se-m4-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer says, \"It's too expensive,\" but the plan price is fixed. What is the best first step?","explanation":"Correct answer: Ask kindly what is behind the concern, since it may be doubt about whether it will work for them","points":1,"position":6,"options":[{"id":"a","label":"Offer a discount to keep the conversation going"},{"id":"b","label":"Argue that the plan is a bargain for what it includes"},{"id":"c","label":"End the conversation, since the price can't change"},{"id":"d","label":"Ask kindly what is behind the concern, since it may be doubt about whether it will work for them"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"se-m4-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"What does summarizing do?","explanation":"Correct answer: It pulls together the key points and checks that you understood","points":1,"position":7,"options":[{"id":"a","label":"It pulls together the key points and checks that you understood"},{"id":"b","label":"It replaces the need to listen closely"},{"id":"c","label":"It moves the conversation toward price"},{"id":"d","label":"It ends discovery without any agreement"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 9, $j${"gates_progress":true,"question":{"id":"se-m4-check-8","assessment_id":null,"question_type":"multiple_choice","prompt":"Based on discovery, you conclude the customer's main problem is something you do not help with. What is the best response?","explanation":"Correct answer: Tell them kindly that it is probably not a fit, and point to a better kind of resource where possible","points":1,"position":8,"options":[{"id":"a","label":"Pitch anyway, since the customer may change their mind"},{"id":"b","label":"Quietly drop the conversation without explanation"},{"id":"c","label":"Tell them kindly that it is probably not a fit, and point to a better kind of resource where possible"},{"id":"d","label":"Promise that the product will help indirectly"}],"correct_option_id":"c"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 5: Presenting Value
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Presenting Value', '', 5)
  returning id into v_m;

  -- Lesson 5.1 -- Features, Benefits, and the Need They Answer
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Features, Benefits, and the Need They Answer', '', 1, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Presenting comes after discovery', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can turn a product feature into a benefit that answers something the customer said, choose a few points instead of listing everything, and avoid presenting before you have investigated."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Discovery tells you what the person's situation, problem, and goal are. Presenting is where you connect what you offer to what they told you, and it isn't a tour of everything the product does.","The open textbook Selling for Success (NSCC) makes the same point: investigate first, then show how your product addresses the stated need, because benefits work better than generic advantages when they're tailored to the buyer. It also notes that two buyers may buy the same product for different reasons."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Features and benefits', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Feature: What the product is or does. Example (fictional scheduling tool for a salon): \"It sends text reminders to clients.\"","Benefit: What that does for this person. Example (fictional scheduling tool for a salon): \"So fewer clients forget, and you don't lose a chair a day.\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A widely taught version of this idea is called features, advantages, and benefits (FAB), which covers what the product is, what it does, and what that means for the customer. The textbook used for this course doesn't use the FAB label, so the course uses the simpler pair of feature and benefit and adds one test."]}$j$::jsonb),
    (v_p, 'callout', 3, $j${"title":"The \"so what?\" test","tone":"info","body":"After every feature you mention, ask yourself, \"So what does that mean for them?\" If you can't answer in their words, leave the feature out."}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Connect it to their words', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A benefit is strongest when it echoes what the customer said. Lena said that no-shows cost her a chair a day and that she wants her evenings back."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Weak (generic): \"Our platform has automated reminders.\" Strong (tied to what she said): \"You mentioned no-shows cost you a chair a day. Reminders go out automatically, so fewer clients forget, which could get you home on time more evenings.\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["The wording in the strong version is careful: it says \"could\" and not \"will.\" You can describe what the product is designed to do and what other customers have experienced, but you can't promise Lena's results, a limit the claims lesson below explains."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Choose a few points', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A pitch that covers twenty features sounds like noise, so it helps to work in three steps. List what they told you matters, which is usually two or three things, then match one feature to each and say the benefit in their terms. After that, stop and ask whether it addresses what they care about.","If a feature doesn't connect to anything they said, don't mention it unless they ask. You can always say, \"There's more, and I'm happy to show you anything you're curious about.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Speak to different people differently', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["An owner who cares about time wants to hear about hours saved, and one who cares about reputation wants to hear about customer experience. One who is wary wants to hear what happens if it doesn't work. It's the same product with different benefits, chosen from what each person told you."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Be honest about limits', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Presenting value includes saying what the product does not do:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"This helps with reminders and bookings. It doesn't handle payroll, so you'd keep using your current tool for that.\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["That honesty builds credibility and prevents refunds and complaints."]}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-l51-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why say \"could\" and not \"will\" when describing a benefit?","explanation":"A promise of results is a claim you would have to prove, so benefits are worded as what the product is designed to do or what other customers have experienced.","points":1,"position":1,"options":[{"id":"a","label":"\"Will\" is too informal for a business conversation"},{"id":"b","label":"You can describe what the product is designed to do, but you can't promise a specific customer's results"},{"id":"c","label":"Customers prefer vague statements"},{"id":"d","label":"\"Could\" lets you skip explaining the feature"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Matching a few features to what the customer said and stating the benefit in their words keeps a presentation relevant, and being honest about limits keeps it credible."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before presenting, write the two or three things the customer said matter most, match one feature to each, and present only those."}$j$::jsonb);

  -- Lesson 5.2 -- Proof: Examples, Evidence, and Honest Comparisons
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Proof: Examples, Evidence, and Honest Comparisons', '', 2, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why proof matters', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can offer proof that is real and relevant, quantify value using the customer's own numbers, and compare to alternatives without misleading."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Saying a product helps is easy, and a small business owner has heard it before. Proof is what makes it believable, and good proof has five qualities: it's real, meaning it actually happened, and relevant, meaning it resembles this customer's situation. It's also specific, with details and not adjectives, current, and not out of date, and checkable, so they could verify it if they wanted."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Types of proof', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Demonstration: Showing the product doing the thing, ideally with the customer's own situation. Watch out for: Staged examples that hide limits.","Customer example: What another business did and what happened. Watch out for: Must be true, relevant, with permission, and not the unusual best case.","Documented results: Numbers the company can substantiate. Watch out for: Must be accurate, current, and not overstated.","Trial or sample: Letting them try it. Watch out for: Terms must be clear.","Third-party review or recognition: What others have said or awarded. Watch out for: Must be genuine and properly disclosed."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The open textbook's guidance is that letting a prospect experience the product is one of the strongest forms of proof, since it educates, involves them, and shows performance."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Use the customer''s own numbers', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The same textbook suggests quantifying value, such as return on investment (ROI), using a worked example of a purchase with a cost and annual savings. That example is written for general products and uses invented figures, so it shouldn't be reused.","The safest way to quantify value in this work is to use the customer's numbers and not yours. Ask, then calculate together:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"You said you lose about one chair a day to no-shows. If a chair is worth about [your number] a day, that's roughly [their number] a week. Does that sound right?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Then make an if/then statement and leave the conclusion to them:"]}$j$::jsonb),
    (v_p, 'rich_text', 4, $j${"body":["\"If reminders cut that in half, what would that be worth to you?\""]}$j$::jsonb),
    (v_p, 'rich_text', 5, $j${"body":["Do not supply a figure for what they will save. You don't know their business, and a number you invent is a claim you would have to prove."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Honest comparisons', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Customers will compare you to other options, including doing nothing. A fair comparison names the alternatives accurately, including a spreadsheet, a paper book, or hiring help, and it says what each does well and not only what it does badly. It also avoids attacking competitors, since a vendor article on pressure tactics and the FTC's rules both warn that false statements about a competitor can create legal risk, and even true attacks sound petty. Finally, it compares like with like and doesn't claim \"best\" or \"only\" unless you can prove it."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"Plenty of owners start with a paper book, and if you have two or three clients a day, that works. When it gets to fifteen, it gets hard to keep track. That's where this helps.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'If you do not have proof', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Say so. \"I don't have an example from a shop like yours, but I can show you how it works and you can judge\" is a fair answer, and so is offering a trial if the company has one. Do not stretch an example to fit."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Permission and privacy', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Before mentioning a customer's name or results to another customer, make sure you have their permission, and use only what they agreed to share. Do not share what a customer told you in confidence. If you're not sure you have permission, describe the example without identifying details, or leave it out."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l52-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"You don't have an example that resembles the prospect. What do you say?","explanation":"Proof has to be real and relevant, so an honest \"I don't have one like yours\" is better than stretching an example to fit.","points":1,"position":1,"options":[{"id":"a","label":"Describe an example from another industry as though it fits"},{"id":"b","label":"Adjust a real example so it sounds closer to their situation"},{"id":"c","label":"That you don't have one like theirs, and offer to show how it works so they can judge"},{"id":"d","label":"Say that every customer has seen the same result"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Real, relevant, specific proof carries more weight than adjectives, and using the customer's own numbers and comparing fairly keeps it honest."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before using a customer story, check three things: whether it's true, whether it resembles this person, and whether you have permission to share it."}$j$::jsonb);

  -- Lesson 5.3 -- Claims, Testimonials, and Disclosure
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Claims, Testimonials, and Disclosure', '', 3, 9, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The basic rule', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain the \"reasonable basis\" rule for claims, why a \"results may vary\" note does not fix an unrepresentative testimonial, and what you may and may not do about reviews."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"Note","tone":"warning","body":"This lesson summarizes public guidance from the U.S. Federal Trade Commission (FTC) and law-firm summaries of a 2024 rule. It is not legal advice. State laws can add more. The lesson ends with an open item for Resona and counsel."}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["In the United States, a business that makes objective claims about its product, such as \"reduces no-shows\" or \"saves five hours a week,\" is expected to have a reasonable basis for the claim before making it. The FTC's policy statement on advertising substantiation says that failing to have and rely on a reasonable basis for objective claims is an unfair and deceptive practice. The rule reaches claims made in conversation by salespeople as well as in ads, because what matters is whether a claim misleads.","The policy statement makes three points that matter here. If you make an express claim such as \"tests prove,\" \"studies show,\" or \"most customers,\" you need at least that level of support. A statement can also imply more than it says, so you need support for what the customer will reasonably take from it. And when no level of support is stated, customers still expect a reasonable basis, with what counts depending on the type of claim, the product, the consequences of being wrong, and what experts in the field would consider reasonable.","The statement dates from 1983, and the copy reviewed for this course was a 2009 printout, so check that it is still current before relying on it."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What this means for you', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Every statement about results needs a source."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"It reduces no-shows.\": A basis, such as documented results or testing the company can show.","\"Most customers save time.\": Proof that most do, not that some did.","\"You'll see results in a week.\": Proof that this is typical, or do not say it.","\"Customers love it.\": A real basis, such as review data, and not one or two stories.","\"The only tool that does X.\": Proof that nothing else does, which is hard, so avoid it."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["If you don't have the basis, say what you do know: what the product does, what the plan includes, and how it works."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Testimonials and typical results', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A customer story can mislead if it describes an unusual result. The FTC's Endorsement Guides FAQ (2015) makes three points. People usually read a specific testimonial as typical, and \"individual results may vary\" doesn't change that reading. The business must either have proof that the result is typical or clearly disclose what results are generally expected. And older testimonials must still be accurate, because if the product has changed, the story may no longer be fair.","The Endorsement Guides were revised in 2023. The FTC page reviewed for this course confirms that the Guides aren't regulations, but that practices inconsistent with them can lead to enforcement under the FTC Act.","For you, that means never presenting a customer's best result as what a new customer should expect. A fair way to say it is, \"That was one owner's experience. It's not a promise of what you'll see.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Connections must be disclosed', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["If you recommend or review a product and you have a relationship with the seller that could affect how people weigh your view, such as being paid, being an employee, or receiving free product, that connection must be disclosed clearly. The FTC FAQ states that employees must disclose they work for the company when endorsing its products, and that a note buried in a profile is not enough.","You work with or for Resona, so when you tell someone a product is good, that is a sales conversation and they know it. Do not post reviews or recommendations of Resona products on public sites, forums, or social media as though you were an independent user. If you post about your work, say who you are."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Reviews: a 2024 rule', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The FTC finalized a rule on consumer reviews and testimonials, effective October 21, 2024. According to a law-firm summary of the rule, it prohibits fake or false reviews and testimonials, including ones that misrepresent whether the reviewer used the product or what happened. It also prohibits paying for reviews with a particular sentiment: offering a discount for a review isn't unlawful in itself, but tying it to a positive (or negative) review is. The remaining prohibitions cover undisclosed reviews by insiders such as officers, managers, and employees, and company-controlled review sites presented as independent. The rule also covers suppressing negative reviews, with narrow exceptions, and presenting selected favorable reviews as representative, and fake social media followers, likes, or views used to misrepresent influence.","The rule carries civil penalties per violation. The summary reviewed gave an amount as of 2024, and it's adjusted yearly, so do not quote a number.","These practical rules apply to our team.","Never write, post, or ask for a fake review.","Never offer a discount, credit, or gift in exchange for a positive review.","You may invite honest feedback from real customers after real use, without telling them what to say.","Do not ask a customer to remove an honest negative review. Fix the problem and tell your leader.","Employees and contractors do not review the company's products as though independent.","Do not buy followers, likes, or views."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'When you are unsure', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Ask before you say or post it. A good question to put to your leader is this:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"Do we have proof for this statement, and is it okay to say it to customers?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["An open item remains for Resona and counsel: a short written list of approved claims, with the proof behind each one, and a written reviews and testimonials policy covering who may post what and how customer stories are approved and disclosed. Until then, say only what the product plainly does and what the plan includes."]}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-l53-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why shouldn't you post a recommendation of a Resona product as though you were an independent user?","explanation":"A material connection, such as being an employee, must be disclosed clearly, and hiding it can make a recommendation misleading.","points":1,"position":1,"options":[{"id":"a","label":"A relationship with the seller must be clearly disclosed, and employees must say they work for the company"},{"id":"b","label":"The forum's owner will remove it"},{"id":"c","label":"Only managers may speak about the product"},{"id":"d","label":"Reviews are only allowed on the company's own site"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Every claim needs a reasonable basis, and testimonials have to be fair, connections disclosed, and reviews real, because each of these protects the customer from being misled."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before you say \"customers usually\" or \"most people,\" ask yourself whether the company can show that, and if it can't, describe a real example as one example or leave it out."}$j$::jsonb);

  -- Lesson 5.4 -- Making It Easy to Understand
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Making It Easy to Understand', '', 4, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Clear beats clever', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain things in plain language, show instead of tell, check understanding as you go, and keep a presentation short and focused on the customer."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["An owner who doesn't understand something won't buy it, and will rarely say so. Short sentences and everyday words help, so say \"send reminders\" and not \"leverage automated notification workflows.\" Keep to one idea at a time, use their words from discovery, and explain any term you must use once and simply. A concrete example from their business works better than an abstract one."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Show instead of tell', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The open textbook says that letting prospects experience the product is among the most powerful tools, since it educates them and proves performance. In practice, that means showing the one thing that matters most to them first and not giving a tour from the top menu. It also means using their situation (\"Let's say Lena books a haircut for Tuesday at 2. Here's what she sees\"), letting them touch it or tell you what to try, and showing the limits too, so there are no surprises later.","A full demonstration structure for Resona products is taught in the Resona Product Demo course. This lesson covers the basics that apply to any conversation."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Check understanding as you go', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Short questions keep you honest about whether you've been clear: \"Does that make sense so far?\", \"How would that work in your shop?\", and \"What questions come to mind?\" The most revealing is \"In your own words, what would that change for you?\" because if they can't say it back, you haven't made it clear yet."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Keep it short', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The textbook offers a rule attributed to a well-known author for slide presentations: no more than 10 slides, about 20 minutes, and a large font. It's best taken as a reminder to be brief. For a small business owner, a presentation is often a few minutes, and a slide deck may not be needed at all.","Customers want you and not a recitation, so don't rely on slides or a script. Face the customer instead of hiding behind a screen, and give them a short, useful leave-behind and not a stack of pages. Clutter, gimmicks, and distracting transitions are better avoided."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Video and phone presentations', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A video call deserves the same care as an in-person meeting: be prepared, minimize distractions, and close with next steps. On the phone, use simple words and check in more often, since you can't see their face. In both, avoid multitasking, because they can tell."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'After you present', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Don't rush to close. Ask instead:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"How does this compare with what you were hoping for?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Their answer tells you whether to move to a next step, address a concern, or stop."]}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-l54-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"After presenting, which question best shows whether the customer understood?","explanation":"If a person can say it back in their own words, you've been clear, and if they can't, you know to explain it differently.","points":1,"position":1,"options":[{"id":"a","label":"\"Does that make sense?\" asked quickly as you move on"},{"id":"b","label":"\"Are you ready to sign up?\""},{"id":"c","label":"\"Did I cover everything on the list?\""},{"id":"d","label":"\"In your own words, what would this change for you?\""}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Plain words, one clear demonstration of what matters most, and regular checks for understanding keep a presentation short and keep it about the customer."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"After presenting, ask \"In your own words, what would this change for you?\" and listen carefully to the answer."}$j$::jsonb);

  -- MODULE 5 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 5 Check', '', 5, 10, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 5 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 5 Check","tone":"info","body":"Answer every question correctly to unlock Module 6."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-m5-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"Which best describes a benefit?","explanation":"Correct answer: What a feature does for this particular customer, in their terms","points":1,"position":1,"options":[{"id":"a","label":"What the product is made of"},{"id":"b","label":"A technical specification of the product"},{"id":"c","label":"What a feature does for this particular customer, in their terms"},{"id":"d","label":"A list of everything the product can do"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-m5-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"After you mention a feature, what should you ask yourself?","explanation":"Correct answer: \"So what does that mean for them?\"","points":1,"position":2,"options":[{"id":"a","label":"\"So what does that mean for them?\""},{"id":"b","label":"\"Can I say more about it?\""},{"id":"c","label":"\"Is this longer than my competitor's description?\""},{"id":"d","label":"\"Have I covered the whole menu?\""}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-m5-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"The customer said no-shows cost them a chair a day. Which statement is the best way to connect a feature to that?","explanation":"Correct answer: \"Reminders go out automatically, so fewer clients forget, which could help with the no-shows you mentioned.\"","points":1,"position":3,"options":[{"id":"a","label":"\"Our platform has many features.\""},{"id":"b","label":"\"You'll never have a no-show again.\""},{"id":"c","label":"\"Most customers love reminders.\""},{"id":"d","label":"\"Reminders go out automatically, so fewer clients forget, which could help with the no-shows you mentioned.\""}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"se-m5-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"What is the safest way to quantify value for a customer?","explanation":"Correct answer: Use the customer's own numbers, ask them to confirm, and let them reach the conclusion","points":1,"position":4,"options":[{"id":"a","label":"Give them a savings figure that sounds impressive"},{"id":"b","label":"Use the customer's own numbers, ask them to confirm, and let them reach the conclusion"},{"id":"c","label":"Quote an average from a different industry"},{"id":"d","label":"Avoid mentioning numbers at all"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"se-m5-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"What does the FTC policy statement say about objective claims?","explanation":"Correct answer: A business should have a reasonable basis for an objective claim before making it","points":1,"position":5,"options":[{"id":"a","label":"Claims need no support if they are made in conversation"},{"id":"b","label":"A business should have a reasonable basis for an objective claim before making it"},{"id":"c","label":"Claims are acceptable whenever the customer asks for them"},{"id":"d","label":"Only written claims need support"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"se-m5-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer's testimonial describes an unusual result. What does the guidance say about a \"results may vary\" note?","explanation":"Correct answer: It generally does not change how people read the testimonial; the business needs proof the result is typical or a clear statement of what is generally expected","points":1,"position":6,"options":[{"id":"a","label":"It fixes the problem"},{"id":"b","label":"It is required on every testimonial"},{"id":"c","label":"It is only needed when the testimonial is in writing"},{"id":"d","label":"It generally does not change how people read the testimonial; the business needs proof the result is typical or a clear statement of what is generally expected"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"se-m5-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"A teammate suggests offering a discount to customers who leave a five-star review. What is the right response?","explanation":"Correct answer: Decline; tying a reward to a positive review is a problem, and inviting honest feedback is fine","points":1,"position":7,"options":[{"id":"a","label":"Decline; tying a reward to a positive review is a problem, and inviting honest feedback is fine"},{"id":"b","label":"Agree, since it is a standard tactic"},{"id":"c","label":"Offer it only to loyal customers"},{"id":"d","label":"Offer it, but keep it off the record"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 9, $j${"gates_progress":true,"question":{"id":"se-m5-check-8","assessment_id":null,"question_type":"multiple_choice","prompt":"You are asked \"Is this the only tool that does this?\" and you do not know. What do you say?","explanation":"Correct answer: \"I don't know every other option. Here's what this does, and you can compare.\"","points":1,"position":8,"options":[{"id":"a","label":"\"Yes, it's the only one.\""},{"id":"b","label":"\"Definitely, nobody else does.\""},{"id":"c","label":"\"I don't know every other option. Here's what this does, and you can compare.\""},{"id":"d","label":"\"Don't worry about other tools.\""}],"correct_option_id":"c"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 6: Objections
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Objections', '', 6)
  returning id into v_m;

  -- Lesson 6.1 -- What an Objection Really Is
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'What an Objection Really Is', '', 1, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Objections are normal and useful', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain what an objection is, see it as information and not an attack, and name common types."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["An objection is a concern, question, or hesitation a person raises about buying, and it isn't rudeness. It usually turns out to be one of three things."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["A question: \"How long does setup take?\" What the person wants: An answer.","A worry: \"What if my staff won't use it?\" What the person wants: Reassurance backed by facts.","A real no: \"We're not interested.\" What the person wants: Respect."]}$j$::jsonb),
    (v_p, 'rich_text', 4, $j${"body":["People who aren't interested rarely bother raising concerns; they just stop answering. An objection therefore often means that the person is still engaged and needs something to decide."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Treat it as a question', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["An open textbook on selling (Selling for Success, NSCC) lists six habits for handling almost any objection. The first and most useful is to view the objection as a question and not as a personal attack. The other five are to respond with a question to understand it, restate the objection before answering, and pause before you respond. The textbook also recommends using real examples and testimonials where they fit, and never arguing with the person.","The textbook draws on practitioner and trade sources and not on studies, so it makes a good checklist but isn't proof."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Six common types', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The same textbook groups objections into six categories, which make a good starting map."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Product: \"Will it work for my kind of shop?\" What is often underneath: A doubt about fit or risk.","Source: \"I've never heard of your company.\" What is often underneath: A question about trust.","Price: \"That's more than I expected.\" What is often underneath: A doubt about value, or habit.","Money: \"Cash is tight right now.\" What is often underneath: A real limit on affordability or timing.","Already satisfied: \"We're fine with what we have.\" What is often underneath: Possibly a hidden concern, or no felt need.","\"I need to think about it\": \"Let me get back to you.\" What is often underneath: A worry not yet spoken, or a soft no."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Hidden objections', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The spoken objection may not be the real one. \"It's too expensive\" can mean \"I don't believe it will work,\" and \"Let me think about it\" can mean \"I'm worried about something and I don't want to say.\" The next lesson shows how to ask kindly to find out."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What not to do', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The textbook's cautions match common sense. Do not argue, call the person wrong, or get defensive, and do not criticize competitors or your own company or product. Do not lie: if you don't know, say so and follow up. And do not ignore an objection or talk over it. This course adds one more: do not use pressure to push past a concern."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l61-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why can an objection be a sign of engagement?","explanation":"A concern usually means the person still wants something to decide, which makes it information to explore and not an attack to answer.","points":1,"position":1,"options":[{"id":"a","label":"Objections only come from customers who intend to buy"},{"id":"b","label":"An objection means the person has decided to say no"},{"id":"c","label":"People who aren't interested rarely raise concerns; they usually just stop answering"},{"id":"d","label":"Customers who object have already read the terms"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"An objection gives you information about what the person still needs in order to decide, which is why it's best treated as a question to understand and not an attack to answer."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"When a concern comes up, pause briefly and restate it as a question, such as \"So you're wondering whether your staff would actually use it?\", before offering any answer."}$j$::jsonb);

  -- Lesson 6.2 -- A Simple Process
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'A Simple Process', '', 2, 8, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The five steps', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can handle an objection using five steps: listen, acknowledge, explore, respond, and check."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A common training model is called LAER: Listen, Acknowledge, Explore, Respond. Sales trainers teach it, and several consulting and training sites describe it, but none of them provide independent evidence that it works better than other approaches. It's a sensible structure, and this course adds a fifth step, Check, because an answer is only useful if it landed."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["1. Listen: Let them finish. Do not interrupt. Notice tone and feeling. Example (fictional): (Silence, nodding).","2. Acknowledge: Show you heard it. This is not agreeing. Example (fictional): \"That's a fair concern.\"","3. Explore: Ask an open question to find the real issue. Example (fictional): \"Can you tell me more about what worries you?\"","4. Respond: Answer what the exploring showed, truthfully and briefly. Example (fictional): \"Here's how setup works for most shops.\"","5. Check: Ask whether it answered the concern. Example (fictional): \"Does that address it, or is there more?\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why explore before answering', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A common mistake in handling objections is to answer the words a customer used and not the concern behind them. When a customer says, \"That's too much for us,\" the instinctive response is to defend the price, yet those few words can carry quite different meanings. The monthly amount may truly be beyond the budget, the customer may not yet be convinced the product will pay for itself, or the decision may rest with someone else whose objection the customer is anticipating. Each calls for a different reply, and from the outside there's no way to tell which one you're facing.","That's why exploring comes before responding. A question such as \"When you say it's too much, is it the monthly amount, or are you not sure yet that it would pay off?\" accomplishes two things at once: it shows the customer the comment was taken seriously, and it invites them to say what they meant."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Customer: \"That's too much for us.\"","Weak: \"But it saves you so much time!\"","Better: \"Understood. When you say it's too much, is it the monthly cost, or are you not sure yet it would pay off?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["The weak reply isn't rude, but it answers a question the customer never asked. A consulting-site article on LAER gives the same caution, that confidence you already know the real concern deserves suspicion, though it cites no data, so it's best read as practical advice. If the concern turns out to be cost, that's one conversation, covered in the next lesson, whereas if it's doubt, you may need to show how the product works."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Useful phrases', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Acknowledge: \"That makes sense.\" \"I'm glad you said that.\" \"A lot of owners ask that.\"","Restate: \"So you're worried your team won't use it. Have I got that right?\"","Explore: \"What would you need to see to feel comfortable?\" \"What's behind that?\"","Respond: \"Here's what I know...\" \"Here's what I don't know yet, and I'll find out.\"","Check: \"Is that helpful?\" \"What else is on your mind?\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Keep the pace calm', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Pausing before you answer helps, and the textbook advises it so that you don't oversell. Keeping your voice level matters too, since defensiveness sounds like pressure, and it's better not to rush to fill silence, because a pause after your answer often brings out the real concern. Handle one concern at a time, and ask \"Is there anything else?\" so that you don't discover a second concern after solving the first."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Honest answers only', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["These limits apply when you respond. You may not invent urgency (\"This price ends today\") unless it's a real, published end date, and you may not promise outcomes you can't prove. You may not pretend to know something you don't, and you may not minimize a real limit: if the concern is valid, say so.","A valid concern that the product cannot answer isn't a failure. It's the point where you may say, \"This might not be right for you.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A short fictional exchange', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Lena: \"I'm not sure my staff will actually use it.\"","Jordan: \"That's a fair worry. Can you tell me more about what's happened with new tools in the past?\"","Lena: \"We tried an app once. Nobody opened it after a week.\"","Jordan: \"That's helpful to know. What made it hard to use?\"","Lena: \"Too many steps.\"","Jordan: \"Then let me show you what a booking takes here, and you tell me if it's too many steps.\" (demonstrates) \"How does that compare?\"","Lena: \"That's simpler. I'd want my front desk to try it.\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Jordan neither argued nor promised anything. Lena's concern was fear of repeating a bad experience, and showing her was the answer."]}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-l62-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why explore before answering an objection like \"That's too much for us\"?","explanation":"Answering the first words risks answering a question the customer never asked, so a short, open question shows you took the comment seriously and invites them to say what they meant.","points":1,"position":1,"options":[{"id":"a","label":"The same words can mean cost, doubt about value, or someone else's decision, and each needs a different reply"},{"id":"b","label":"Exploring gives you time to prepare a discount"},{"id":"c","label":"The customer is probably testing your patience"},{"id":"d","label":"Price objections are always about the monthly amount"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Listening, acknowledging, exploring, responding, and checking keeps the answer tied to the person's real concern, and a calm, honest pace keeps it from sounding like pressure."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"When you hear an objection, say it back before you answer: \"So your concern is ___. Is that right?\""}$j$::jsonb);

  -- Lesson 6.3 -- Common Objections
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Common Objections', '', 3, 8, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Price', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can respond honestly to price, money, trust, fit, \"we're fine,\" and \"I need to think about it\" objections, and handle requests that involve someone else."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["These are patterns and not scripts. Say them in your own words, and only say what is true."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Fixed pricing changes this objection. Because pricing is set in advance as a subscription, there is nothing to negotiate, and you do not make up discounts or promise a different price. That makes the conversation simpler and more honest.","An open textbook says price objections are often a habit or a negotiating tactic, and that the response is to probe the concern and build the case for value and not to cut the price. With a fixed price, that's the only option anyway."]}$j$::jsonb),
    (v_p, 'rich_text', 4, $j${"body":["\"That's more than I expected.\": Acknowledge. Ask what they expected and what they are comparing it to.","\"Can you do better on price?\": Be straight: \"The price is the same for everyone. What I can do is make sure the plan fits what you need.\"","\"Why is it this much?\": Explain what the plan includes and what it replaces, using their own numbers if they gave them.","\"Your competitor is cheaper.\": Do not attack. Ask what is included, and compare fairly."]}$j$::jsonb),
    (v_p, 'rich_text', 5, $j${"body":["You may explain the published plans and point out a plan that fits their needs better, and you may mention official, published promotions if they apply. You may also be clear about what the price includes and doesn't include, and when it starts.","You may not invent a discount or a \"special\" price, promise a price change later, or imply that the price is negotiable when it is not."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Money and timing', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["\"Cash is tight\" and \"not this quarter\" are real concerns, and they shouldn't be argued with. Ask instead:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"That makes sense. Is it more about the amount, or about when the money comes in?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Then be honest about what the commitment is: the cost, when billing starts, how to cancel, and anything else they should know. If now isn't right, agree on a later date and keep it."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Trust and "I''ve never heard of you"', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["This is a fair concern about a company they don't know, and it deserves an honest answer. Say who Resona is in plain terms, without exaggerating size, history, or customer numbers. Offer proof that is real and permitted, and offer a way to try or verify if the company has one. Do not say \"everyone knows us.\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"Fair question. We're a newer company, and I'd rather be upfront about that. Here's what we do and how you can check it out for yourself.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Product and fit', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["\"Will it work for my business?\" is a good question. Explore what they mean, show how it works in their situation, and say honestly what the product does not do. If it doesn't fit, say so, and don't stretch an example to make it seem like it does."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, '"We''re fine with what we have" (already satisfied)', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The textbook notes that this can be a hidden objection. Don't argue; ask with curiosity:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"Good to hear. What do you like most about how it works now? Is there anything you wish were easier?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Do not criticize their current tool or provider. If nothing is wrong, respect that, and offer to check back at a better time if they would like."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, '"I need to think about it"', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The open textbook says this is usually a stall that hides a worry. A sales trainer's blog, which is practitioner opinion with no data, says it can be a \"slow no\" or a \"pending yes\" and advises finding out which. A practical approach has four parts. Agree kindly (\"Of course. It's a decision worth thinking about\"), then ask what they will be weighing (\"What are you thinking through? Is there something I could clear up now?\"). Offer a specific next step, such as a short follow-up on a date or a summary they can review, and do not pressure them: if they want time, give it.","If there is a hidden worry, a calm question often brings it out, and if there isn't, you have shown respect."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, '"I need to talk to my partner" or "my accountant"', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["This may be true, a polite no, or both, and the helpful response is to work with it. Offer to include them (\"Would it help if I joined a short call with your partner?\"), offer a clear summary they can share, and agree on a follow-up date. Do not try to bypass the other person, because the decision may be shared."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'When the objection is a real complaint', 8) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Sometimes the objection points to a genuine limitation or problem with the product or company. Do not defend it. Thank the person, be honest, and pass it to the team so it's heard, since customer feedback helps the company improve."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l63-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which of these may you do when a customer raises a price objection?","explanation":"Pricing is set in advance as a subscription, so you can explain the published plans and any official promotions, but you can't invent or imply a different price.","points":1,"position":1,"options":[{"id":"a","label":"Offer a one-time special price to keep the conversation going"},{"id":"b","label":"Promise a price change later"},{"id":"c","label":"Imply the price may be negotiable"},{"id":"d","label":"Explain the published plans and point out one that fits their needs better"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 9) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Responding to the real concern, being straight about price and limits, and passing real complaints on keeps each objection conversation honest."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before your next conversation, write your honest answer to \"Can you do better on price?\" in one sentence, and say it aloud."}$j$::jsonb);

  -- Lesson 6.4 -- Respecting a No
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Respecting a No', '', 4, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A no is an answer', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can recognize a clear no, leave gracefully, follow up only as permitted, and learn from objections and refusals."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Not every conversation ends in a yes, and it shouldn't. A person who says no after hearing honest information has made a decision, and that decision deserves respect.","A real no takes several forms: a direct \"We're not interested,\" a repeated no after you've explored and responded, or silence after follow-ups you sent as agreed. A request to stop contacting them is also a real no."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'How to leave well', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["\"I appreciate your time, and thank you for being straight with me. If things change, I'd be glad to help. Would it be okay if I check back in a few months, or would you rather I didn't?\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Leaving well means thanking them genuinely, without guilt, argument, or sighing. It also means asking permission to follow up once and accepting the answer, and not making a last-minute offer or inventing urgency.","A person who is treated well when they say no is more likely to say yes later, or to recommend you."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Honor requests to stop', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["If someone asks you to stop contacting them, stop, and record it in the approved system so that no one else on the team contacts them. This is basic respect, and rules on contact exist. Counsel and management will set the written policy."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Mixed signals: a soft no', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A \"soft no\" is vague: \"maybe later,\" \"send me information,\" or no reply. Ask once, kindly:"]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"It sounds like this may not be the right time. Is that fair to say?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["If they say yes, thank them and leave, and if they say it's just busy, agree on a clear date."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Learn from every objection', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Keep a simple log of the objections you hear, in plain words. Each entry notes what was said, what it turned out to be (a question, a worry, or a no), what helped, and what the company could do to address it, such as clearer information or a product limit.","Share patterns with your leader. If many people ask the same question, the company can answer it earlier, improve materials, or fix the product, and a rep who hears the same objection ten times is holding useful information."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Your own reaction to a no', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A no is not a verdict on you. After a hard one, take a minute to walk, breathe, or talk to a teammate, and write down one thing you learned. Then reset before the next contact. If you find yourself dreading or avoiding contact, talk to your leader."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l64-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why keep a log of the objections you hear?","explanation":"A rep who hears the same objection ten times is holding useful information, and sharing it with your leader lets the company respond.","points":1,"position":1,"options":[{"id":"a","label":"It helps you show customers that others objected too"},{"id":"b","label":"Patterns show where the company can answer questions earlier, improve materials, or fix the product"},{"id":"c","label":"It lets you identify which customers to stop contacting"},{"id":"d","label":"It replaces the need to follow up with each customer"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"A customer who says no after hearing honest information has made a decision, and the professional response is to leave graciously, honor any request to stop contact, and use what the conversation revealed to improve the next one."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"After each conversation, write the objection you heard in one line, along with what turned out to matter."}$j$::jsonb);

  -- MODULE 6 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 6 Check', '', 5, 10, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 6 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 6 Check","tone":"info","body":"Answer every question correctly to unlock Module 7."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-m6-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"What is the best way to view an objection?","explanation":"Correct answer: As a question or concern that gives you information","points":1,"position":1,"options":[{"id":"a","label":"As a personal attack"},{"id":"b","label":"As proof the person is not interested"},{"id":"c","label":"As a question or concern that gives you information"},{"id":"d","label":"As a negotiating trick"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-m6-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"Which is the best response to \"That's too much for us\"?","explanation":"Correct answer: \"Understood. When you say it's too much, is it the monthly cost, or are you not sure yet it would pay off?\"","points":1,"position":2,"options":[{"id":"a","label":"\"Understood. When you say it's too much, is it the monthly cost, or are you not sure yet it would pay off?\""},{"id":"b","label":"\"But it saves you so much time!\""},{"id":"c","label":"\"I can give you a discount.\""},{"id":"d","label":"\"Everyone says that at first.\""}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-m6-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"What does \"Check\" mean in the five-step process?","explanation":"Correct answer: Ask whether your answer addressed the concern","points":1,"position":3,"options":[{"id":"a","label":"Check the customer's credit before going on"},{"id":"b","label":"Check the clock to keep the conversation short"},{"id":"c","label":"Check competitors' prices for a comparison"},{"id":"d","label":"Ask whether your answer addressed the concern"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"se-m6-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer asks, \"Can you do better on price?\" Pricing is set as a subscription. What is the best response?","explanation":"Correct answer: \"The price is the same for everyone. What I can do is make sure the plan fits what you need.\"","points":1,"position":4,"options":[{"id":"a","label":"\"Let me see what I can do.\""},{"id":"b","label":"\"The price is the same for everyone. What I can do is make sure the plan fits what you need.\""},{"id":"c","label":"\"Sign today and I'll lower it.\""},{"id":"d","label":"\"I'll ask my manager to call you with a better price.\""}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"se-m6-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer says \"I need to think about it.\" What is the best approach?","explanation":"Correct answer: Agree kindly, ask what they will be weighing, and offer a specific next step without pressure","points":1,"position":5,"options":[{"id":"a","label":"Press harder before they leave"},{"id":"b","label":"Agree kindly, ask what they will be weighing, and offer a specific next step without pressure"},{"id":"c","label":"Say \"Fine,\" and end the conversation without any next step"},{"id":"d","label":"Tell them the offer expires tonight"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"se-m6-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer says, \"We're fine with what we have.\" What is the best response?","explanation":"Correct answer: Respond with curiosity, such as asking what they like and whether anything could be easier, and respect it if there is no need","points":1,"position":6,"options":[{"id":"a","label":"Explain why their current tool is poor"},{"id":"b","label":"Say they will regret not changing"},{"id":"c","label":"Leave and never return"},{"id":"d","label":"Respond with curiosity, such as asking what they like and whether anything could be easier, and respect it if there is no need"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"se-m6-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer says, \"Please stop contacting me.\" What do you do?","explanation":"Correct answer: Stop, thank them, and record the request so the team does not contact them","points":1,"position":7,"options":[{"id":"a","label":"Stop, thank them, and record the request so the team does not contact them"},{"id":"b","label":"Contact them once more to confirm the request"},{"id":"c","label":"Ask them to reconsider"},{"id":"d","label":"Send a final discount as a goodbye"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 9, $j${"gates_progress":true,"question":{"id":"se-m6-check-8","assessment_id":null,"question_type":"multiple_choice","prompt":"Many customers raise the same objection about a real limitation of the product. What should you do?","explanation":"Correct answer: Be honest with them and share the pattern with your leader so the company can respond","points":1,"position":8,"options":[{"id":"a","label":"Tell them they are mistaken about the limitation"},{"id":"b","label":"Ignore it, since most customers still buy"},{"id":"c","label":"Be honest with them and share the pattern with your leader so the company can respond"},{"id":"d","label":"Downplay the limitation when it comes up"}],"correct_option_id":"c"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 7: Closing and Commitment
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Closing and Commitment', '', 7)
  returning id into v_m;

  -- Lesson 7.1 -- Closing as a Natural Next Step
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Closing as a Natural Next Step', '', 1, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Closing starts at the beginning', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain closing as a normal, honest next step, and ask for a commitment clearly and without pressure."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["A closing isn't a trick at the end. Closing is the point where you and the customer agree on what happens next, which may be signing up, a second meeting, a trial, or \"not now.\"","An open sales textbook (Selling for Success, NSCC) makes the same point: closing is a series of steps that starts when you qualify the customer, and it isn't a single moment. Good questions, honest fit checks, and clear value do most of the work, so if those were done well, asking is simple."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why you should ask', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The textbook says customers expect to be asked once you've earned the right through trust and value. A person who needs to decide can't do so if you never say what the decision is, and not asking isn't polite, because it leaves the customer guessing.","Asking can be calm."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Ready to sign up: \"Would you like to get started with the plan we talked about?\"","Needs a step first: \"The next step is a short setup call. Would Thursday or Friday work?\"","Unsure: \"Where would you like to leave this? We can go ahead, talk again, or stop here.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Choices that are honest', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The textbook lists several closing styles: a direct request, a summary of benefits, an assumptive close, an alternative-choice close, and a compliment close. The table shows how to use each of them honestly in this company."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Direct ask: \"Would you like to go ahead?\" Use it honestly: Always fine.","Summary: Recap what they said mattered, then ask. Use it honestly: Use their words and not yours.","Alternative choice: Offers two options that both say yes. Use it honestly: Only between real, published plans or real dates. Never between \"yes\" and \"yes\" when \"no\" is a real answer.","Assumptive: Speaks as if the decision is made. Use it honestly: Use with caution. Do not assume when the customer has not said yes. Ask, do not tell.","Compliment: Praises the customer's choice. Use it honestly: Only if sincere, and never as a lever."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Do not use any style to rush, trap, or hide a \"no.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What closing is not', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["These tactics stay off limits, as they did in the first module. Do not invent deadlines (\"This price ends today\"), and do not use guilt, fear, or pressure to force a decision. Do not ignore a clear no, and do not offer a special price: pricing is fixed, and you offer published plans and official promotions only.","The textbook says the same, that closing should not involve high-pressure tactics, trickery, or manipulation."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Keep it brief', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The textbook advises keeping the request short and focused on the customer's biggest problem. After you ask, stop talking. Silence lets the person think, and filling it often leads to talking them out of their own decision."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l71-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why stop talking right after you ask for a commitment?","explanation":"After a clear ask, the next move belongs to the customer, and giving them room to answer respects their right to decide.","points":1,"position":1,"options":[{"id":"a","label":"Silence shows the customer you are confident"},{"id":"b","label":"Silence lets the person think, and filling it often talks them out of their own decision"},{"id":"c","label":"It prevents the customer from asking questions"},{"id":"d","label":"Stopping makes it harder for them to say no"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Closing is the point where you and the customer agree on the next step, so asking clearly, keeping it honest, and then letting the silence work respects their right to decide."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before a conversation, write the one sentence you'll use to ask for the next step, and say it aloud."}$j$::jsonb);

  -- Lesson 7.2 -- Reading Readiness and Trial Questions
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Reading Readiness and Trial Questions', '', 2, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Signs of readiness', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can notice signs of readiness, use a trial question to check where a customer stands, and respond to the answer."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The textbook lists moments that suggest a customer may be ready. They ask questions about how it works, timing, or setup, or they share more about their business or react warmly. They may also ask about next steps, delivery, or start dates, or bring in someone else who will use it or decide. Another moment is right after you resolve an objection, when they have what they need to decide.","These are clues and not proof, so check before you assume, just as with body language."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Signs they are not ready', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Several signs suggest a customer isn't ready: short, flat answers, or \"looks good so far\" with no energy, and \"Let me think about it\" or a need to involve others. Concerns that haven't been answered and silence after you ask point the same way.","A vendor article (Rework, a sales-software company) groups responses into strong positive, soft positive, neutral, and objection signals, and says that neutral ones usually mean an unanswered concern. The article cites no research, so the grouping is best read as practical advice."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Trial questions', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A trial close asks for an opinion and not a decision. It's a low-pressure way to see where the person stands, and the textbook says it lowers pressure \"for both of you.\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Opinion: \"What stands out to you so far?\"","Scale: \"On a scale of 1 to 10, how well does this fit what you need?\"","Priority: \"What's most important to you in choosing?\"","Concern check: \"Is there anything that would hold you back?\"","Timing: \"What's your timeline for putting something in place?\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["What you do next matters more than the question. If someone says \"6,\" ask, \"What would make it a 9?\" because their answer is the next conversation."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Reading the answer', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Positive and specific: Move to a clear ask.","Positive but vague: Probe: \"What would be the next step for you?\"","Negative or hesitant: The textbook calls this a signal to change your approach and not to push, so explore the concern.","No answer: Slow down and ask what is on their mind."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The vendor article adds two cautions that match common sense: don't ask so often that it feels like pressure, and don't move past a negative answer."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Do not close too early', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The textbook warns that closing too early can make a customer disengage. If you haven't asked about their needs or shown value, your ask will feel pushy because it's premature, and the better move is to go back and ask another question."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A short fictional exchange', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Jordan: \"What stands out to you so far?\"","Marco: \"The scheduling part. That's where I lose time.\"","Jordan: \"On a scale of 1 to 10, how well does this cover that?\"","Marco: \"Maybe a 7.\"","Jordan: \"What would make it a 9?\"","Marco: \"I'd want to see how my techs would use it on their phones.\"","Jordan: \"Fair. Would it help if I showed you that now?\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Jordan didn't close. Jordan found the real gap, and the next step became obvious."]}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-l72-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What is the difference between a trial question and a closing question?","explanation":"A trial close checks where the person stands with little pressure, which tells you whether to ask for a decision, address a concern, or keep exploring.","points":1,"position":1,"options":[{"id":"a","label":"A trial question is asked at the very end of a conversation"},{"id":"b","label":"A closing question is always about price"},{"id":"c","label":"A trial question asks for an opinion, while a closing question asks for a decision"},{"id":"d","label":"A trial question asks the customer to confirm they will buy"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Signs of readiness are clues, so a trial question that asks for an opinion shows where the customer actually stands, and following the answer matters more than hurrying toward a close."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Ask one trial question midway through each conversation, and write down what you learned."}$j$::jsonb);

  -- Lesson 7.3 -- Clear Terms and Consumer Protections
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Clear Terms and Consumer Protections', '', 3, 9, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The standard we hold', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can explain terms plainly before a customer commits, describe how cancellation works, and know where legal rules may apply and when to ask for help."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["This lesson is general education and not legal advice. The company's counsel decides how rules apply to Resona. When in doubt, ask your leader."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Whatever the law requires, the standard in this company is simple: no surprises. Before a customer says yes, they should be able to say back to you each of the items in the table."]}$j$::jsonb),
    (v_p, 'rich_text', 4, $j${"body":["What they are buying: \"The plan includes X and Y, and does not include Z.\"","What it costs: \"It's [published price] per [month/year], billed on [date].\"","When billing starts: \"You'll be charged on [date], not before.\"","How it renews: \"It renews each [period] unless you cancel.\"","How to cancel: \"You can cancel by [published method]. Here's what happens to your data and billing.\"","Who to contact: \"If something goes wrong, contact [published channel].\""]}$j$::jsonb),
    (v_p, 'rich_text', 5, $j${"body":["Use the company's actual terms. If you don't know one, say so and find out before the customer commits, and never guess about terms."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why subscriptions need extra care', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Subscriptions repeat. A customer who doesn't clearly understand the renewal and cancellation terms can feel trapped, and regulators have focused on exactly this.","ROSCA (the Restore Online Shoppers' Confidence Act, 2010) is a federal law about online sales with recurring charges. According to a May 2026 law-firm summary, it requires sellers to clearly disclose material terms before collecting billing information, to get express informed consent before charging, and to offer a simple way to stop the charges.","The FTC's 2024 \"click-to-cancel\" rule was vacated by a federal appeals court in 2025 on procedural grounds. According to the same summary, the FTC began a new rulemaking in March 2026, and no new final rule had been issued as of that article. The FTC continues to bring cases under existing laws. The summary doesn't say whether ROSCA applies to sales to businesses, which is a question for counsel.","You don't need to memorize these. What you need to know is that clear terms, clear consent, and easy cancellation are what regulators look for, and they're also what keeps customers."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The Cooling-Off Rule, and why it probably does not apply here', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The FTC's Cooling-Off Rule gives buyers three business days to cancel certain sales made away from the seller's place of business, such as at the buyer's home, workplace, or a temporary location like a hotel or fairground. The highlights below come from FTC consumer guidance and the rule's definitions.","The rule covers consumer goods and services, defined as bought mainly for personal, family, or household purposes, and goods and services not mainly for those purposes aren't covered. The rule's definition adds that courses of instruction or training are covered whatever the reason someone takes them. It has dollar thresholds of $25 or more at the buyer's home and $130 or more at other locations, and it doesn't cover sales made entirely by phone, mail, or online, or sales made after the buyer negotiated at the seller's permanent place of business. When it applies, the seller must tell the buyer about the cancel right, provide two copies of a cancellation form, and give a dated contract or receipt, and the seller must refund within 10 days of a valid cancellation.","For us, this means that because our customers are small business owners buying for business use, the rule generally would not cover most of our sales. Three cautions apply, though.","\"Generally\" is not \"never.\" Some offerings, such as training, are covered whatever the reason, and some sole proprietors blur personal and business use.","State laws differ and may cover more. The FTC says the rule doesn't replace state cooling-off laws, according to the rule text and a 2013 FTC notice.","The company decides policy, not individual reps. If a customer asks about a cancellation right you don't know, do not guess. Say: \"Good question. Let me get you the exact terms.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Practical habits', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Put the terms in writing and send them, so that nothing rests on memory. Make cancellation easy to find and describe it honestly, and never hint that it's hard. Never rush a signature, because if someone wants time, they get it, and never hide terms in fine print or skip over them.","Confirm in their words: \"Just to be sure, you understand it renews each month and you can cancel at any time by [method]. Is that right?\" Then record what you told them, keeping to non-sensitive information."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'When to stop and ask', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Stop and ask your leader, who may involve counsel, when a customer asks for special terms, a refund outside the published policy, or a different contract. The same applies when a customer says they're buying mainly for personal or household use, or asks how a law applies to them. Stop and ask also when a customer says they didn't understand the terms after signing, or when you aren't sure what you told them is accurate.","None of this is a reason to avoid selling. It's why we can sell with confidence."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l73-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer asks about a cancellation right you don't know. What do you say?","explanation":"The company decides policy and counsel decides how the law applies, so a rep shouldn't guess about terms and should find the exact answer.","points":1,"position":1,"options":[{"id":"a","label":"\"Good question. Let me get you the exact terms.\""},{"id":"b","label":"\"The rule probably doesn't apply, so you're fine.\""},{"id":"c","label":"\"Everyone has three days to cancel.\""},{"id":"d","label":"\"Cancellation rights depend on which rep sold it.\""}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Explaining terms plainly, making cancellation easy, and asking for help when the law is unclear protects the customer from surprises and the company from the problems that follow them."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before asking for a yes, say aloud the price, billing date, renewal, and how to cancel, and if you can't say one of them, find out first."}$j$::jsonb);

  -- Lesson 7.4 -- After the Yes
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'After the Yes', '', 4, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The yes is the start', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can confirm a commitment, set honest expectations, and support a customer through their first week."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The textbook describes closing as part of an ongoing relationship and not as an end. A customer who signs up and then hears nothing may regret it, whereas one who is welcomed well is more likely to stay, use the product, and recommend you."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Confirm clearly', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Within a short time after the yes, thank them sincerely and recap what they chose, including the plan, price, billing date, and renewal. State what happens next, with dates when possible (\"You'll get an email today. Setup is [step]. I'll check in on [date]\"), say how to reach help, and send it all in writing."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Set honest expectations', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Overpromising now creates the complaint later, so review what you said in the conversation. Don't add promises to keep the customer happy, and do correct anything you said that was unclear, now and not later. It also helps to be honest about the first weeks: \"Most people take a little while to settle in. Here's what's normal.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The first week', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Day 1: Confirmation sent; they know the next step.","First few days: Check that setup works; answer questions.","End of week one: A short check-in: \"How is it going? Anything confusing?\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The goal is for the customer to get early value. If they hit a problem, handle it quickly, and pass product problems to the right team."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Do not use the sale to ask for more', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Right after a yes, don't immediately push extras, referrals, or reviews. Let the customer experience the product first, because referrals and reviews come later, and with care."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'If they change their mind', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Some customers cancel, and it's best treated the way you'd treat a no. Thank them and be gracious, explain the cancellation process honestly, and follow the published terms. Ask once and kindly whether you could have done something better, and record the answer. Never use guilt, delay, or difficulty to keep them."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l74-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Why not ask for a referral right after a customer says yes?","explanation":"A yes starts the relationship, and waiting until the customer has experienced value makes a referral request natural and easy to decline.","points":1,"position":1,"options":[{"id":"a","label":"Referrals are only allowed after a full year"},{"id":"b","label":"It is against the law to ask within a week"},{"id":"c","label":"Customers are less likely to remember the product"},{"id":"d","label":"The customer hasn't yet experienced the product, so referrals and reviews come later and with care"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"The yes starts the relationship, which is why a clear confirmation, honest expectations, and real help in the first week matter as much as the sale itself."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"After every yes, send a short written recap the same day."}$j$::jsonb);

  -- MODULE 7 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 7 Check', '', 5, 10, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 7 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 7 Check","tone":"info","body":"Answer every question correctly to unlock Module 8."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-m7-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"What is the best description of closing?","explanation":"Correct answer: Agreeing with the customer on the next step, which may be a sale or may be \"not now\"","points":1,"position":1,"options":[{"id":"a","label":"A technique for getting a signature"},{"id":"b","label":"Pushing until the customer gives in"},{"id":"c","label":"Agreeing with the customer on the next step, which may be a sale or may be \"not now\""},{"id":"d","label":"Something done only at the very end of a conversation"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-m7-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"When is an alternative-choice close honest?","explanation":"Correct answer: When it offers real, published plans or real dates, and \"no\" remains an open answer","points":1,"position":2,"options":[{"id":"a","label":"When it offers real, published plans or real dates, and \"no\" remains an open answer"},{"id":"b","label":"When both choices are \"yes\" and \"no\" isn't allowed"},{"id":"c","label":"When you invent a second price to compare"},{"id":"d","label":"Never, under any circumstances"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-m7-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"What is a trial close?","explanation":"Correct answer: A question that asks for an opinion, not a decision, to see where the customer stands","points":1,"position":3,"options":[{"id":"a","label":"A free sample of the product"},{"id":"b","label":"A request for payment"},{"id":"c","label":"A deadline that creates urgency"},{"id":"d","label":"A question that asks for an opinion, not a decision, to see where the customer stands"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"se-m7-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer rates fit \"6 out of 10.\" What is the best next question?","explanation":"Correct answer: \"What would make it a 9?\"","points":1,"position":4,"options":[{"id":"a","label":"\"Great, so should I send the contract?\""},{"id":"b","label":"\"What would make it a 9?\""},{"id":"c","label":"\"Why is it so low?\" asked sharply"},{"id":"d","label":"\"Let me give you a discount.\""}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"se-m7-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"Which should a customer be able to say back before committing to a subscription?","explanation":"Correct answer: What they get, the price, when billing starts, how it renews, and how to cancel","points":1,"position":5,"options":[{"id":"a","label":"Only the monthly price"},{"id":"b","label":"What they get, the price, when billing starts, how it renews, and how to cancel"},{"id":"c","label":"Only how to get started"},{"id":"d","label":"Nothing, since they can read the terms later"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"se-m7-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"Why does the Cooling-Off Rule probably not cover most of our sales, and what is still uncertain?","explanation":"Correct answer: It applies mainly to consumer goods bought for personal, family, or household use, but some offerings and state laws may differ, so the company decides policy","points":1,"position":6,"options":[{"id":"a","label":"It covers every sale, so nothing is uncertain"},{"id":"b","label":"It only applies on certain days of the week"},{"id":"c","label":"It was repealed, so no cancellation rules apply"},{"id":"d","label":"It applies mainly to consumer goods bought for personal, family, or household use, but some offerings and state laws may differ, so the company decides policy"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"se-m7-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer asks, \"What's your refund policy if I cancel in week one?\" and you do not know. What should you do?","explanation":"Correct answer: Say you will get the exact terms, find them, and reply","points":1,"position":7,"options":[{"id":"a","label":"Say you will get the exact terms, find them, and reply"},{"id":"b","label":"Make up an answer that sounds reasonable"},{"id":"c","label":"Say \"Don't worry about it\""},{"id":"d","label":"Avoid the question until they stop asking"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 9, $j${"gates_progress":true,"question":{"id":"se-m7-check-8","assessment_id":null,"question_type":"multiple_choice","prompt":"What is a good thing to do right after a customer says yes?","explanation":"Correct answer: Thank them, recap what they chose and what happens next, and send it in writing","points":1,"position":8,"options":[{"id":"a","label":"Ask for three referrals immediately"},{"id":"b","label":"Wait until renewal to contact them again"},{"id":"c","label":"Thank them, recap what they chose and what happens next, and send it in writing"},{"id":"d","label":"Add promises to keep them happy"}],"correct_option_id":"c"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- MODULE 8: Follow-Up, Referrals and Professional Conduct
  ------------------------------------------------------------------
  insert into public.modules (course_id, title, description, position)
  values (v_course_id, 'Follow-Up, Referrals and Professional Conduct', '', 8)
  returning id into v_m;

  -- Lesson 8.1 -- Follow-Up That Helps
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Follow-Up That Helps', '', 1, 7, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why follow up', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can follow up in a way that is useful and respectful, and know the contact rules that apply to email, calls, and texts."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Contact rules in this lesson are general education and not legal advice. Counsel and management decide the written policy. When unsure, ask before you send."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Most decisions don't happen in one conversation, because people get busy, need to check with someone, or forget. A good follow-up keeps the conversation alive only if the person still wants it, which makes follow-up a service when it helps and a nuisance when it doesn't."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Make every contact useful', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A sales-software blog (HubSpot, updated April 2025) advises against empty messages like \"just checking in.\" It suggests that each follow-up do one of four things."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Restate the value they cared about: \"You said missed bookings were your biggest headache. Here's how the plan handles that.\"","Share something useful: \"You asked about setup time. Here's what the first week looks like.\"","Answer an open question: \"You asked about [topic]. Here's the answer I promised.\"","Share relevant news: \"Something changed that matters for your plan: [fact].\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["That blog is vendor content, and its numbers, such as its \"seven or more touches\" claim, are weakly sourced, so this course doesn't set a number of touches. The right number is the number the person welcomes."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Keep your promises', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["If you said \"I'll send that Thursday,\" send it Thursday, since reliability is part of trust. If you can't, say so before the deadline."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'The contact rules, in plain terms', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Several laws govern how we may contact people, and the table below gives the plain version of what the sources say."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Email: The CAN-SPAM Act covers commercial email, including email to businesses. Requirements include accurate sender information, non-deceptive subject lines, a clear statement that it is an ad, a valid postal address, and a clear way to opt out. Opt-outs must be honored within 10 business days. Source status: FTC compliance guide (last updated July 2025).","Phone calls: The FTC's 2024 amendment to the Telemarketing Sales Rule extended its ban on false or misleading statements to calls to businesses, effective May 16, 2024. The rule text reviewed shows the proposal did not extend other provisions, such as Do Not Call Registry rules, to business calls. Source status: Federal Register summary; counsel should confirm the final scope.","Texts: Federal law (the TCPA) restricts marketing texts and autodialed or prerecorded calls to cell phones without the proper consent. In 2025, a court struck down the FCC's stricter \"one-to-one\" consent rule, and the FCC restored the earlier standard, which requires written consent with clear disclosures. Source status: Law-firm articles; counsel should confirm."]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Several rules of thumb are safe in any channel.","Never contact someone who asked you to stop, and record the request.","Do not text a customer for marketing unless the company's written policy says how consent is obtained and recorded.","Be truthful in every message. False or misleading statements are against the rules in any channel, including to businesses.","Use only company-approved email tools that include the required opt-out and address.","Remember that one person's yes is not a blanket yes: permission to email about a topic is not permission to text."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'How much is too much', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["A calm guide for this course is to match their pace: if they reply quickly, you can too. If there's no reply, a couple of useful, spaced-out messages are reasonable, and then you ask once whether they would like you to stop. Never send repeated messages that read as pressure, and stop at \"no.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A short fictional exchange', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Jordan (email, three days after a demo): \"Hi Lena, you asked how the front desk would handle walk-ins. Here's a two-minute walkthrough. If this isn't the right time, tell me and I'll stop. Otherwise I'll check back Thursday as we discussed.\""]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The message answers a question, gives a clear next step, and offers an easy way out."]}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-l81-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"A prospect hasn't replied to two useful messages. What is the reasonable next step?","explanation":"A couple of spaced-out, useful messages are reasonable, but repeated messages read as pressure, and asking once keeps the choice with the person.","points":1,"position":1,"options":[{"id":"a","label":"Send daily reminders until they respond"},{"id":"b","label":"Switch to texting, since it is harder to ignore"},{"id":"c","label":"Ask once whether they'd like you to stop, and respect the answer"},{"id":"d","label":"Tell them the offer ends soon"}],"correct_option_id":"c"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Follow-up is useful when it helps the person move forward, which is why every message should give them something, keep your promises, follow the contact rules, and stop when asked."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"Before you send a follow-up, ask what it gives the person, and if the answer is nothing, don't send it."}$j$::jsonb);

  -- Lesson 8.2 -- Records and Habits
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Records and Habits', '', 2, 5, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Why keep notes', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can keep short, accurate, non-sensitive notes, and build daily habits that make follow-up reliable."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["You can't remember every conversation, and the customer expects you to. Notes let you pick up where you left off, keep promises, and pass the customer smoothly to a colleague."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What to record', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Keep the notes short and factual."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Who and when: \"Marco, plumbing business; call on [date].\"","What they care about: \"Wants fewer missed calls; two techs.\"","What you promised: \"Send setup overview by Thursday.\"","The next step and date: \"Follow-up call Friday at 10.\"","Contact permissions: \"Email OK. Asked not to be texted.\"","Objections and what helped: \"Worried about staff adoption; demo helped.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'What not to record', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Resona keeps customer information in the company database, non-sensitive only, and purges it after 365 days of no subscription. The rules that follow from that are firm.","Do not record anything sensitive, such as financial account details, health information, personal opinions about the person, or anything you would not be comfortable showing the customer.","Do not keep personal copies in your own phone or notebook beyond what the company allows.","Stick to what you need, and if you're unsure, ask your leader.","A good test is to write notes as if the customer might read them."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Daily habits', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Small habits do more than big efforts. Start the day with a short plan of who to contact and what to prepare, and log notes right after each conversation, while you remember. Set your next step and date before you move on, check your promises list at the end of the day, and review once a week what worked, what didn't, and what to change."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Handing off well', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["If a customer moves to another person at Resona, for support, setup, or another rep, brief that person so the customer doesn't have to repeat everything. Share what you promised and what matters to them."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l82-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"Which note belongs in a customer record?","explanation":"Notes stay short, factual, and non-sensitive, written as though the customer might read them.","points":1,"position":1,"options":[{"id":"a","label":"The next follow-up date and what you promised to send"},{"id":"b","label":"The health concerns the customer mentioned in passing"},{"id":"c","label":"Your personal opinion of the customer's character"},{"id":"d","label":"Financial account details the customer shared"}],"correct_option_id":"a"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Short, accurate, non-sensitive notes make follow-up reliable and fair, because they let anyone at Resona pick up the conversation without asking the customer to repeat it."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"End every conversation by writing the next step and its date."}$j$::jsonb);

  -- Lesson 8.3 -- Referrals and Reputation
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Referrals and Reputation', '', 3, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Reputation is earned', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can earn referrals honestly, handle reviews and testimonials correctly, and protect Resona's reputation."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["Customers who are treated well talk about it, and customers who are treated badly talk about it more. The best referral program is doing what you said, clearly and kindly."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Asking for a referral', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The open textbook (Selling for Success, NSCC) treats the sale as part of an ongoing relationship, and referrals come from that relationship. A good time to ask is after the customer has experienced value and not right after the yes."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["\"I'm glad it's working well. If you know another owner who might find this useful, I'd be glad to help them too. No pressure at all.\""]}$j$::jsonb),
    (v_p, 'rich_text', 3, $j${"body":["Wait until they're happy, make it easy to say no, and accept the answer. Thank them whether or not they refer anyone."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Rewards and incentives', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Do not invent referral rewards. If the company has an approved referral program, follow its written terms exactly, and otherwise do not promise rewards, discounts, or gifts for referrals, because pricing and promotions are fixed.","The FTC's rules on endorsements and consumer reviews matter here. According to a law-firm summary (BCLP, September 2024), a reward cannot depend on the reviewer giving a positive review or a particular view, directly or by implication. Incentivized reviews aren't banned, but a \"material connection\" such as a payment, free product, or prize must be clearly disclosed where people wouldn't expect it.","These practical rules apply in this company.","Never offer anything in exchange for a good review. You may ask for honest feedback.","Never write or edit a review or testimonial for a customer, or post one under another name.","Use a customer's name, quote, or business only with their permission, and only through the approved process.","Follow the written reviews policy once the company has one, which is a carried-over open item."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'When someone is not happy', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Unhappy customers are information, so respond quickly, honestly, and kindly. Do not argue, delete, or hide complaints, and pass problems to the right team. A complaint handled well often turns into loyalty.","If a customer posts a public complaint, do not reply on your own. Tell your leader, because the company decides how to respond."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recommending others', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["If a customer isn't a good fit, say so. Do not recommend a specific competitor or company unless Resona has approved referrals for that case. You can say, \"I don't think we're the right fit, and I'd rather be honest than sell you something that doesn't help.\""]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Protecting the company''s name', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Everything you say can reflect on Resona. Be accurate about what you're authorized to say, and be the same person online and in person. Do not disparage competitors or anyone else, and if you make a mistake, own it, fix it, and tell your leader."]}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-l83-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer posts a public complaint about Resona. What do you do?","explanation":"The company decides how to respond to public complaints, and a complaint handled well can turn into loyalty.","points":1,"position":1,"options":[{"id":"a","label":"Reply publicly to correct the customer's account"},{"id":"b","label":"Ask the customer to delete the post"},{"id":"c","label":"Post a favorable review to balance it out"},{"id":"d","label":"Don't reply on your own; tell your leader so the company can decide how to respond"}],"correct_option_id":"d"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Referrals come from doing right by customers, which is why the ask should be easy to decline and why no one at Resona buys, writes, or hides opinions."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"When a customer is happy, thank them first, and ask for a referral only if the moment is right and it's easy to decline."}$j$::jsonb);

  -- Lesson 8.4 -- Resilience and Ethics
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Resilience and Ethics', '', 4, 6, false)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Setbacks are normal', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Objective","tone":"info","body":"By the end of this lesson you can handle setbacks without losing your standards, and apply a simple test when a situation feels unclear."}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["The open textbook says refusals are a normal part of selling, that success often takes several attempts, and that confidence and the right mental attitude help you keep going. It also advises recording what works and what doesn't. The textbook gives a statistic about how often prospects say no, but with no method or sample, so this course doesn't repeat it.","In plain terms, most conversations won't end in a yes, and that doesn't mean you did something wrong."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Resilience habits', 2) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Separate the no from yourself: \"That was a no to the offer, not to me.\"","Learn one thing: Write one line: what would I do differently?","Reset between contacts: Walk, breathe, or talk to a teammate.","Stay with your process: Plan, ask, listen, follow up.","Ask for help early: Tell your leader if you are discouraged."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["If a hard stretch lasts, talk to your leader. Needing support is normal and not a weakness."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Pressure to cut corners', 3) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Slumps create temptation: overstate a benefit, skip a disclosure, keep contacting someone who said stop. These shortcuts cost more than they gain, because they harm customers, harm Resona, and can create legal exposure. The standards from the first module do not relax when results do."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'A simple test', 4) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["When a situation feels unclear, ask four questions. First, is it true, meaning would I be comfortable if the customer knew everything I knew? Second, is it fair, meaning am I helping them decide or pushing them past a concern? Third, is it allowed, meaning do I have authority and a written policy for this? And fourth, would I be comfortable if my leader and the customer saw it?","If any answer is no or unsure, stop and ask."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Who to ask', 5) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["Bring unclear situations to your leader. Some must always be escalated: a request for special terms, refunds, or exceptions, and a legal question from a customer. So must a complaint or a threat of a complaint, a request to stop contact that you're unsure how to record, and a mistake you made or noticed.","Asking is part of the job."]}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Putting the course together', 6) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'rich_text', 1, $j${"body":["The course comes down to one habit per module."]}$j$::jsonb),
    (v_p, 'rich_text', 2, $j${"body":["1. What selling is: Help people decide, honestly.","2. Preparing: Know your product, your customer, your plan.","3. Opening and rapport: Be clear, warm, and respectful of their time.","4. Discovery: Ask and listen before you present.","5. Presenting value: Tie benefits to what they said, and prove it truthfully.","6. Objections: Treat concerns as questions; respect a no.","7. Closing: Agree on a next step; no surprises on terms.","8. Follow-up and conduct: Be useful, be reliable, and keep your standards."]}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-l84-retrieval","assessment_id":null,"question_type":"multiple_choice","prompt":"What do you do when a situation feels unclear?","explanation":"The four questions are a quick test for pressure to cut corners, and a no or an unsure on any of them is the signal to stop and ask.","points":1,"position":1,"options":[{"id":"a","label":"Choose the option most likely to close the sale"},{"id":"b","label":"Ask whether it is true, fair, and allowed, and stop and ask your leader if any answer is no or unsure"},{"id":"c","label":"Wait to see whether the customer objects"},{"id":"d","label":"Decide on your own, since you know the customer best"}],"correct_option_id":"b"}}$j$::jsonb);

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Recap', 7) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Takeaway","tone":"success","body":"Standards that hold when results are hard are what make a seller trustworthy, and the four-question test followed by a conversation with your leader is how you hold them."}$j$::jsonb),
    (v_p, 'callout', 2, $j${"title":"When you're working with a customer","tone":"info","body":"After a hard conversation, write one thing you learned and one thing you did well."}$j$::jsonb);

  -- MODULE 8 CHECK
  insert into public.lessons (module_id, title, description, position, estimated_minutes, is_check)
  values (v_m, 'Module 8 Check', '', 5, 10, true)
  returning id into v_l;

  insert into public.lesson_pages (lesson_id, title, position) values (v_l, 'Module 8 Check', 1) returning id into v_p;
  insert into public.content_blocks (lesson_page_id, block_type, position, content) values
    (v_p, 'callout', 1, $j${"title":"Module 8 Check","tone":"info","body":"Answer every question correctly to finish the course lessons."}$j$::jsonb),
    (v_p, 'activity', 2, $j${"gates_progress":true,"question":{"id":"se-m8-check-1","assessment_id":null,"question_type":"multiple_choice","prompt":"What makes a follow-up useful?","explanation":"Correct answer: It restates what they cared about, shares something helpful, or answers an open question","points":1,"position":1,"options":[{"id":"a","label":"It reminds the customer that you are still waiting"},{"id":"b","label":"It repeats the original pitch with more detail"},{"id":"c","label":"It restates what they cared about, shares something helpful, or answers an open question"},{"id":"d","label":"It sets a deadline for the customer to respond"}],"correct_option_id":"c"}}$j$::jsonb),
    (v_p, 'activity', 3, $j${"gates_progress":true,"question":{"id":"se-m8-check-2","assessment_id":null,"question_type":"multiple_choice","prompt":"Which statement about CAN-SPAM is correct according to the FTC's guide?","explanation":"Correct answer: It covers commercial email, including business-to-business email","points":1,"position":2,"options":[{"id":"a","label":"It covers commercial email, including business-to-business email"},{"id":"b","label":"It applies only to emails sent to consumers"},{"id":"c","label":"It only applies to emails sent in bulk"},{"id":"d","label":"It does not require an opt-out option"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 4, $j${"gates_progress":true,"question":{"id":"se-m8-check-3","assessment_id":null,"question_type":"multiple_choice","prompt":"A prospect writes, \"Please stop contacting me.\" What do you do?","explanation":"Correct answer: Stop contacting them and record the request so the team does not contact them","points":1,"position":3,"options":[{"id":"a","label":"Send one last reminder before closing the file"},{"id":"b","label":"Ask them to reconsider by phone"},{"id":"c","label":"Wait a month and try again"},{"id":"d","label":"Stop contacting them and record the request so the team does not contact them"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 5, $j${"gates_progress":true,"question":{"id":"se-m8-check-4","assessment_id":null,"question_type":"multiple_choice","prompt":"Which note should NOT go in the customer record?","explanation":"Correct answer: Sensitive details such as financial account information or health information","points":1,"position":4,"options":[{"id":"a","label":"A promise to send information on Thursday"},{"id":"b","label":"Sensitive details such as financial account information or health information"},{"id":"c","label":"The next follow-up date"},{"id":"d","label":"The customer's stated priority"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 6, $j${"gates_progress":true,"question":{"id":"se-m8-check-5","assessment_id":null,"question_type":"multiple_choice","prompt":"When is a good time to ask for a referral?","explanation":"Correct answer: After the customer has experienced value, in a way that is easy to decline","points":1,"position":5,"options":[{"id":"a","label":"Immediately after the customer says yes"},{"id":"b","label":"After the customer has experienced value, in a way that is easy to decline"},{"id":"c","label":"Only when you are behind on your goals"},{"id":"d","label":"Before the customer has started using the product"}],"correct_option_id":"b"}}$j$::jsonb),
    (v_p, 'activity', 7, $j${"gates_progress":true,"question":{"id":"se-m8-check-6","assessment_id":null,"question_type":"multiple_choice","prompt":"A customer says they would be happy to leave a review. What is the correct approach?","explanation":"Correct answer: Ask for their honest feedback and offer nothing that depends on its being positive","points":1,"position":6,"options":[{"id":"a","label":"Offer a discount if the review is positive"},{"id":"b","label":"Write the review for them to post"},{"id":"c","label":"Ask them to remove any negative points"},{"id":"d","label":"Ask for their honest feedback and offer nothing that depends on its being positive"}],"correct_option_id":"d"}}$j$::jsonb),
    (v_p, 'activity', 8, $j${"gates_progress":true,"question":{"id":"se-m8-check-7","assessment_id":null,"question_type":"multiple_choice","prompt":"A prospect is not a good fit for Resona, and there is no approved referral for that case. What do you do?","explanation":"Correct answer: Say honestly that we may not be the right fit, without recommending a specific company","points":1,"position":7,"options":[{"id":"a","label":"Say honestly that we may not be the right fit, without recommending a specific company"},{"id":"b","label":"Recommend a competitor by name"},{"id":"c","label":"Sign them up anyway, in case it works out"},{"id":"d","label":"Stop replying to their messages"}],"correct_option_id":"a"}}$j$::jsonb),
    (v_p, 'activity', 9, $j${"gates_progress":true,"question":{"id":"se-m8-check-8","assessment_id":null,"question_type":"multiple_choice","prompt":"You are in a slump and tempted to overstate a benefit. What should you do?","explanation":"Correct answer: Keep your standards, ask yourself the four questions, and talk to your leader if you are struggling","points":1,"position":8,"options":[{"id":"a","label":"Overstate it just this once to get back on track"},{"id":"b","label":"Stop all follow-up until the slump ends"},{"id":"c","label":"Keep your standards, ask yourself the four questions, and talk to your leader if you are struggling"},{"id":"d","label":"Blame the customer for the missed sale"}],"correct_option_id":"c"}}$j$::jsonb);

  ------------------------------------------------------------------
  -- Course-end cumulative review: exam (80% to pass) + quick_review that
  -- samples from the exam's pool (see 0013_study_center_schema.sql).
  ------------------------------------------------------------------
  insert into public.assessments (course_id, assessment_type, title, passing_score, question_count, status)
  values (v_course_id, 'exam', 'Sales Essentials Course-End Review', 80, 12, 'published')
  returning id into v_exam_id;

  insert into public.assessments (course_id, assessment_type, title, question_count, status)
  values (v_course_id, 'quick_review', 'Sales Essentials Quick Review', 7, 'published');

  insert into public.assessment_questions (assessment_id, question_type, prompt, explanation, points, position, data) values
    (v_exam_id, 'multiple_choice', 'What is the best description of selling in this course?', 'Correct answer: Helping people make a good decision, honestly', 1, 1, $j${"options":[{"id":"a","label":"Getting people to buy as fast as possible"},{"id":"b","label":"Winning the argument about why the product is better"},{"id":"c","label":"Helping people make a good decision, honestly"},{"id":"d","label":"Using urgency to close while interest is high"}],"correct_option_id":"c"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'Which is a pressure tactic this course asks you to avoid?', 'Correct answer: Inventing a deadline to rush a decision', 1, 2, $j${"options":[{"id":"a","label":"Inventing a deadline to rush a decision"},{"id":"b","label":"Asking a clear question"},{"id":"c","label":"Summarizing what the customer said"},{"id":"d","label":"Offering a published plan"}],"correct_option_id":"a"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'Pricing is set in advance as a subscription. A customer asks, "Can you do better on price?" What is the best response?', 'Correct answer: "The price is the same for everyone. What I can do is make sure the plan fits what you need."', 1, 3, $j${"options":[{"id":"a","label":"\"Let me see what I can do.\""},{"id":"b","label":"\"Sign today and I'll lower it.\""},{"id":"c","label":"\"I'll have my manager call with a better price.\""},{"id":"d","label":"\"The price is the same for everyone. What I can do is make sure the plan fits what you need.\""}],"correct_option_id":"d"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'What is the best use of the first minute of a conversation?', 'Correct answer: Say who you are, why you are reaching out, why them, and ask permission to continue', 1, 4, $j${"options":[{"id":"a","label":"Start the pitch while the person is paying attention"},{"id":"b","label":"Say who you are, why you are reaching out, why them, and ask permission to continue"},{"id":"c","label":"Mention the price so there are no surprises later"},{"id":"d","label":"Talk about yourself so they get to know you"}],"correct_option_id":"b"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'Which question is best for discovery?', 'Correct answer: "What is taking the most time in your week right now?"', 1, 5, $j${"options":[{"id":"a","label":"\"You need this, right?\""},{"id":"b","label":"\"What is taking the most time in your week right now?\""},{"id":"c","label":"\"Do you want to save money?\""},{"id":"d","label":"\"Can I sign you up today?\""}],"correct_option_id":"b"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'What does the "so what?" test do?', 'Correct answer: It turns a feature into a benefit that matters to the customer', 1, 6, $j${"options":[{"id":"a","label":"It challenges the customer's assumptions"},{"id":"b","label":"It ends a conversation that is going nowhere"},{"id":"c","label":"It checks how a competitor describes the same feature"},{"id":"d","label":"It turns a feature into a benefit that matters to the customer"}],"correct_option_id":"d"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'Which statement is a claim you should avoid unless approved and supported?', 'Correct answer: "This will double your revenue."', 1, 7, $j${"options":[{"id":"a","label":"\"This will double your revenue.\""},{"id":"b","label":"\"Here is what the plan includes.\""},{"id":"c","label":"\"I don't know. Let me find out.\""},{"id":"d","label":"\"Here is how setup works.\""}],"correct_option_id":"a"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'What is the best way to treat an objection?', 'Correct answer: As a question or concern: listen, acknowledge, explore, respond, and check', 1, 8, $j${"options":[{"id":"a","label":"As a personal attack"},{"id":"b","label":"As proof they will not buy"},{"id":"c","label":"As a question or concern: listen, acknowledge, explore, respond, and check"},{"id":"d","label":"As a negotiating trick"}],"correct_option_id":"c"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'What is an honest alternative-choice close?', 'Correct answer: A choice between real, published plans or real dates, where "no" remains an open answer', 1, 9, $j${"options":[{"id":"a","label":"A choice between \"yes\" and \"yes\""},{"id":"b","label":"A choice between several discounts"},{"id":"c","label":"A choice between real, published plans or real dates, where \"no\" remains an open answer"},{"id":"d","label":"A choice made for the customer"}],"correct_option_id":"c"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'Before a customer commits to a subscription, what should they be able to say back?', 'Correct answer: What they get, the price, when billing starts, how it renews, and how to cancel', 1, 10, $j${"options":[{"id":"a","label":"What they get, the price, when billing starts, how it renews, and how to cancel"},{"id":"b","label":"Only the price"},{"id":"c","label":"How long the conversation lasted"},{"id":"d","label":"Nothing, since the terms are in writing"}],"correct_option_id":"a"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'A customer asks a legal question about their cancellation rights, and you are not sure. What do you do?', 'Correct answer: Say you will get the exact terms and escalate to your leader', 1, 11, $j${"options":[{"id":"a","label":"Guess confidently, so the customer isn't left waiting"},{"id":"b","label":"Say \"don't worry about it\""},{"id":"c","label":"Avoid the topic until the customer drops it"},{"id":"d","label":"Say you will get the exact terms and escalate to your leader"}],"correct_option_id":"d"}$j$::jsonb),
    (v_exam_id, 'multiple_choice', 'After a hard day with several "no" answers, what is the best response?', 'Correct answer: Learn one thing, reset, keep your standards, and ask your leader for support if needed', 1, 12, $j${"options":[{"id":"a","label":"Cut corners tomorrow to catch up"},{"id":"b","label":"Learn one thing, reset, keep your standards, and ask your leader for support if needed"},{"id":"c","label":"Quit contacting customers for a while"},{"id":"d","label":"Blame the customers"}],"correct_option_id":"b"}$j$::jsonb);


  ------------------------------------------------------------------
  -- Glossary: scoped to this course via glossary_terms.course_id (0017).
  -- on conflict guards against a term another course already seeded --
  -- normalized_term is still globally unique.
  ------------------------------------------------------------------
  insert into public.glossary_terms (term, definition, category, course_id, status) values
  ('Selling', 'The work of helping a person decide whether a product or service solves a problem they have', 'Sales: Foundations', v_course_id, 'published'),
  ('Seller-first', 'A kind of conversation that starts with the product and the seller''s goals', 'Sales: Foundations', v_course_id, 'published'),
  ('Buyer-first', 'A kind of conversation that starts with the person''s situation and goal', 'Sales: Foundations', v_course_id, 'published'),
  ('Buyer''s journey', 'The set of stages a person moves through before and after a purchase', 'Sales: Foundations', v_course_id, 'published'),
  ('Awareness', 'The stage in which a person recognizes a problem or opportunity', 'Sales: Foundations', v_course_id, 'published'),
  ('Consideration', 'The stage in which a person compares kinds of solutions', 'Sales: Foundations', v_course_id, 'published'),
  ('Decision', 'The stage in which a person chooses a specific option', 'Sales: Foundations', v_course_id, 'published'),
  ('Trust Equation', 'A practitioner framework that expresses trust as credibility plus reliability plus intimacy, divided by self-orientation', 'Sales: Foundations', v_course_id, 'published'),
  ('Self-orientation', 'The degree to which a person focuses on their own interests instead of the customer''s', 'Sales: Foundations', v_course_id, 'published'),
  ('High-pressure tactic', 'A technique that rushes or pushes a person past their own judgment', 'Sales: Foundations', v_course_id, 'published'),
  ('Escalate', 'To bring a question or concern to the right person instead of guessing', 'Sales: Foundations', v_course_id, 'published'),
  ('Provable claim', 'A statement about a product or result that can be shown to be true', 'Sales: Foundations', v_course_id, 'published'),
  ('Claims inventory', 'A sorting of what you say about a product into provable, true-for-some, and not provable', 'Sales: Preparation', v_course_id, 'published'),
  ('Best-fit customer', 'A person whom the product helps well', 'Sales: Preparation', v_course_id, 'published'),
  ('Poor-fit customer', 'A person whom the product is unlikely to serve well', 'Sales: Preparation', v_course_id, 'published'),
  ('Time box', 'A fixed, short amount of time set aside for a task', 'Sales: Preparation', v_course_id, 'published'),
  ('Pre-call objective', 'A goal set before a conversation', 'Sales: Preparation', v_course_id, 'published'),
  ('SMART goal', 'A goal that is specific, measurable, actionable, realistic, and time-bound', 'Sales: Preparation', v_course_id, 'published'),
  ('Minimum / target / stretch goal', 'Three levels of what you want from a conversation', 'Sales: Preparation', v_course_id, 'published'),
  ('One-minute plan', 'A four-line note written before each conversation that covers who, goal, first question, and ask', 'Sales: Preparation', v_course_id, 'published'),
  ('Sales call reluctance', 'Emotional discomfort that interferes with reaching out to prospects', 'Sales: Preparation', v_course_id, 'published'),
  ('Qualify', 'To find out, politely, whether the product fits the person', 'Sales: Preparation', v_course_id, 'published'),
  ('Authority (limits of)', 'The range of what you are allowed to offer or promise on behalf of the company', 'Sales: Preparation', v_course_id, 'published'),
  ('Opening', 'The first moments of a conversation, when you say who you are and why you are there', 'Sales: Opening & Rapport', v_course_id, 'published'),
  ('Permission-based opening', 'An opening that asks whether the person has time to talk', 'Sales: Opening & Rapport', v_course_id, 'published'),
  ('Rapport', 'The comfortable sense that the other person is on your side', 'Sales: Opening & Rapport', v_course_id, 'published'),
  ('Active listening', 'A way of listening fully and showing you heard, by pausing, saying back, and following up', 'Sales: Opening & Rapport', v_course_id, 'published'),
  ('Mirroring', 'The matching of another person''s gestures or speech, whether naturally or on purpose', 'Sales: Opening & Rapport', v_course_id, 'published'),
  ('Check-in', 'A short question that asks how the person is doing with the conversation', 'Sales: Opening & Rapport', v_course_id, 'published'),
  ('Soft no', 'A polite, vague way of declining', 'Sales: Opening & Rapport', v_course_id, 'published'),
  ('Gatekeeper', 'A person who controls access to the decision-maker', 'Sales: Opening & Rapport', v_course_id, 'published'),
  ('Consent (for contact)', 'A person''s agreement to be contacted in a particular way', 'Sales: Opening & Rapport', v_course_id, 'published'),
  ('Opt-out', 'A person''s request to stop being contacted', 'Sales: Opening & Rapport', v_course_id, 'published'),
  ('Discovery', 'The part of a conversation in which you learn whether and how your product fits the person''s situation', 'Sales: Discovery', v_course_id, 'published'),
  ('Open question', 'A question that invites explanation', 'Sales: Discovery', v_course_id, 'published'),
  ('Closed question', 'A question with a short answer such as yes, no, or a number', 'Sales: Discovery', v_course_id, 'published'),
  ('Probing question', 'A follow-up that digs into something the person just said', 'Sales: Discovery', v_course_id, 'published'),
  ('SPIN', 'A question framework made up of Situation, Problem, Implication, and Need-payoff questions', 'Sales: Discovery', v_course_id, 'published'),
  ('Leading question', 'A question that suggests the answer you want', 'Sales: Discovery', v_course_id, 'published'),
  ('Loaded question', 'A question that assumes something not yet established', 'Sales: Discovery', v_course_id, 'published'),
  ('Paraphrasing', 'A listening skill that restates what you heard in your own words', 'Sales: Discovery', v_course_id, 'published'),
  ('Summarizing', 'A listening skill that pulls together the key points to check understanding', 'Sales: Discovery', v_course_id, 'published'),
  ('Reflecting', 'A listening skill that repeats the essence of what was said, including the feeling', 'Sales: Discovery', v_course_id, 'published'),
  ('Underlying need', 'The real concern beneath the first thing a person says', 'Sales: Discovery', v_course_id, 'published'),
  ('Fit check', 'A quick review of whether the product suits the person', 'Sales: Discovery', v_course_id, 'published'),
  ('Poor fit', 'A situation in which the product is unlikely to serve the person well', 'Sales: Discovery', v_course_id, 'published'),
  ('Feature', 'A description of what a product is or does', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Benefit', 'What a feature does for this particular customer', 'Sales: Presenting Value', v_course_id, 'published'),
  ('"So what?" test', 'A check that asks what a feature means for the customer, and drops it if you can''t say', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Proof', 'Real, relevant, specific, current, and checkable support for a claim', 'Sales: Presenting Value', v_course_id, 'published'),
  ('ROI', 'Return on investment, meaning what a customer gains compared with what they spend', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Objective claim', 'A statement of fact about a product or result that can be proved or disproved', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Reasonable basis', 'The support a business must have before making an objective claim', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Substantiation', 'The evidence that backs a claim', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Testimonial', 'A customer''s statement about their experience with a product', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Typical results', 'What most customers can generally expect', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Material connection', 'A relationship with a seller that could affect how people weigh a recommendation', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Disclosure', 'A clear statement of a connection or a limitation', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Demonstration', 'A showing of the product doing something in a customer''s situation', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Plain language', 'Clear, short, everyday words', 'Sales: Presenting Value', v_course_id, 'published'),
  ('Objection', 'A concern, question, or hesitation a person raises about buying', 'Sales: Objections', v_course_id, 'published'),
  ('Hidden objection', 'The real concern beneath what a person first says', 'Sales: Objections', v_course_id, 'published'),
  ('LAER', 'A training model made up of Listen, Acknowledge, Explore, and Respond', 'Sales: Objections', v_course_id, 'published'),
  ('Check (step)', 'The step of asking whether an answer addressed the concern', 'Sales: Objections', v_course_id, 'published'),
  ('Price objection', 'A concern about cost or value', 'Sales: Objections', v_course_id, 'published'),
  ('Money objection', 'A concern about affordability or timing', 'Sales: Objections', v_course_id, 'published'),
  ('Source objection', 'A concern about the company or the seller', 'Sales: Objections', v_course_id, 'published'),
  ('Stall', 'A delay such as "let me think about it," which may hide a worry or a no', 'Sales: Objections', v_course_id, 'published'),
  ('Opt-out / stop request', 'A person''s request not to be contacted', 'Sales: Objections', v_course_id, 'published'),
  ('Objection log', 'A short record of objections, what they turned out to be, and what helped', 'Sales: Objections', v_course_id, 'published'),
  ('Closing', 'The point at which you and the customer agree on the next step, which may be a sale', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Trial close', 'A question that asks for an opinion and not a decision, to see where the customer stands', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Buying signal', 'A sign that a customer may be ready to decide', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Direct ask', 'A plain request such as "Would you like to go ahead?"', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Alternative-choice close', 'A way of closing that offers two real options, both of which move forward', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Assumptive close', 'A way of closing that speaks as if the decision were made, to be used with caution', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Material terms', 'The important facts a customer needs to decide, such as price, renewal, and cancellation', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('ROSCA', 'A federal law about online sales with recurring charges that requires clear disclosure, consent, and simple cancellation', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Cooling-Off Rule', 'An FTC rule that gives buyers three business days to cancel some sales made away from the seller''s place of business', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Consumer goods or services', 'Items bought mainly for personal, family, or household use', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Cancellation process', 'The published steps a customer follows to end a subscription', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Confirmation', 'A written recap of what the customer chose and what happens next', 'Sales: Closing & Terms', v_course_id, 'published'),
  ('Follow-up', 'Contact after a conversation that helps the customer move forward', 'Sales: Follow-Up & Conduct', v_course_id, 'published'),
  ('CAN-SPAM Act', 'A federal law governing commercial email, including email to businesses', 'Sales: Follow-Up & Conduct', v_course_id, 'published'),
  ('Telemarketing Sales Rule (TSR)', 'An FTC rule on sales calls, whose ban on misleading statements has also covered calls to businesses since 2024', 'Sales: Follow-Up & Conduct', v_course_id, 'published'),
  ('TCPA', 'A federal law that restricts certain marketing calls and texts without proper consent', 'Sales: Follow-Up & Conduct', v_course_id, 'published'),
  ('Consent', 'A person''s clear, recorded permission to be contacted in a given way', 'Sales: Follow-Up & Conduct', v_course_id, 'published'),
  ('Referral', 'A customer''s introduction of someone else who may benefit', 'Sales: Follow-Up & Conduct', v_course_id, 'published'),
  ('Handoff', 'The passing of a customer to a colleague with the context they need', 'Sales: Follow-Up & Conduct', v_course_id, 'published'),
  ('Resilience', 'The ability to continue steadily after setbacks without lowering standards', 'Sales: Follow-Up & Conduct', v_course_id, 'published')
  on conflict (normalized_term) do nothing;
end $$;

commit;
