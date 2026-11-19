-- 0019_foundations_copy_style_pass.sql
-- Tone and copy pass on the live Resona Foundations course, following the CIVIX Academy
-- Course Writing Style Guide. Text-only: block, question, option and term ids, page order,
-- gating and correct answers are unchanged, except that the correct option is moved to a
-- different letter on lesson questions no learner has answered yet and on the cumulative
-- review (which has no attempts), because 36 of 38 lesson answers were option B.
-- Content is located by position or question id, not by uuid, so it also applies to a fresh seed.

create or replace function pg_temp.fb_block(p_m int, p_l int, p_p int, p_b int, p_type text, p_val jsonb)
returns void language plpgsql as $f$
declare n int;
begin
  update public.content_blocks cb set content = jsonb_set(cb.content, '{body}', p_val), updated_at = now()
  from public.lesson_pages lp, public.lessons l, public.modules m, public.courses c
  where cb.lesson_page_id = lp.id and lp.lesson_id = l.id and l.module_id = m.id and m.course_id = c.id
    and c.slug = 'resona-foundations' and m.position = p_m and l.position = p_l and lp.position = p_p
    and cb.position = p_b and cb.block_type::text = p_type;
  get diagnostics n = row_count;
  if n <> 1 then raise exception 'fb_block %.%.%.% (%) matched % rows', p_m, p_l, p_p, p_b, p_type, n; end if;
end $f$;

create or replace function pg_temp.fb_q(p_qid text, p_path text[], p_val jsonb)
returns void language plpgsql as $f$
declare n int;
begin
  update public.content_blocks cb set content = jsonb_set(cb.content, p_path, p_val), updated_at = now()
  from public.lesson_pages lp, public.lessons l, public.modules m, public.courses c
  where cb.lesson_page_id = lp.id and lp.lesson_id = l.id and l.module_id = m.id and m.course_id = c.id
    and c.slug = 'resona-foundations' and cb.block_type::text = 'activity' and cb.content->'question'->>'id' = p_qid;
  get diagnostics n = row_count;
  if n <> 1 then raise exception 'fb_q % matched % rows', p_qid, n; end if;
end $f$;

create or replace function pg_temp.fb_label(p_qid text, p_opt text, p_label text)
returns void language plpgsql as $f$
declare cur jsonb; idx int;
begin
  select cb.content into cur from public.content_blocks cb
  join public.lesson_pages lp on lp.id = cb.lesson_page_id join public.lessons l on l.id = lp.lesson_id
  join public.modules m on m.id = l.module_id join public.courses c on c.id = m.course_id
  where c.slug = 'resona-foundations' and cb.block_type::text = 'activity' and cb.content->'question'->>'id' = p_qid;
  select (ord - 1)::int into idx from jsonb_array_elements(cur->'question'->'options') with ordinality t(o, ord) where o->>'id' = p_opt;
  if idx is null then raise exception 'fb_label % % not found', p_qid, p_opt; end if;
  perform pg_temp.fb_q(p_qid, array['question','options', idx::text, 'label'], to_jsonb(p_label));
end $f$;

-- Moves the correct answer to p_target by swapping labels between two option ids.
-- Skipped when any learner has already answered the block.
create or replace function pg_temp.fb_place(p_qid text, p_target text)
returns void language plpgsql as $f$
declare cur jsonb; blk uuid; cid text; lc text; lt text; ic int; it int;
begin
  select cb.id, cb.content into blk, cur from public.content_blocks cb
  join public.lesson_pages lp on lp.id = cb.lesson_page_id join public.lessons l on l.id = lp.lesson_id
  join public.modules m on m.id = l.module_id join public.courses c on c.id = m.course_id
  where c.slug = 'resona-foundations' and cb.block_type::text = 'activity' and cb.content->'question'->>'id' = p_qid;
  if exists (select 1 from public.activity_attempts a where a.content_block_id = blk) then return; end if;
  cid := cur->'question'->>'correct_option_id';
  if cid = p_target then return; end if;
  select o->>'label', (ord-1)::int into lc, ic from jsonb_array_elements(cur->'question'->'options') with ordinality t(o, ord) where o->>'id' = cid;
  select o->>'label', (ord-1)::int into lt, it from jsonb_array_elements(cur->'question'->'options') with ordinality t(o, ord) where o->>'id' = p_target;
  if lc is null or lt is null then raise exception 'fb_place % cannot swap % and %', p_qid, cid, p_target; end if;
  perform pg_temp.fb_q(p_qid, array['question','options', ic::text, 'label'], to_jsonb(lt));
  perform pg_temp.fb_q(p_qid, array['question','options', it::text, 'label'], to_jsonb(lc));
  perform pg_temp.fb_q(p_qid, array['question','correct_option_id'], to_jsonb(p_target));
end $f$;

create or replace function pg_temp.fb_exam_place(p_pos int, p_target text)
returns void language plpgsql as $f$
declare q record; cid text; lc text; lt text; opts jsonb;
begin
  select aq.id, aq.assessment_id, aq.data into q from public.assessment_questions aq join public.assessments a on a.id = aq.assessment_id
  join public.courses c on c.id = a.course_id where c.slug = 'resona-foundations' and a.assessment_type::text = 'exam' and aq.position = p_pos;
  if exists (select 1 from public.assessment_attempts x where x.assessment_id = q.assessment_id) then return; end if;
  cid := q.data->>'correct_option_id';
  if cid is null or cid = p_target then return; end if;
  select o->>'label' into lc from jsonb_array_elements(q.data->'options') o where o->>'id' = cid;
  select o->>'label' into lt from jsonb_array_elements(q.data->'options') o where o->>'id' = p_target;
  select jsonb_agg(case when o->>'id' = cid then jsonb_set(o,'{label}',to_jsonb(lt)) when o->>'id' = p_target then jsonb_set(o,'{label}',to_jsonb(lc)) else o end order by ord)
    into opts from jsonb_array_elements(q.data->'options') with ordinality t(o, ord);
  update public.assessment_questions set data = jsonb_set(jsonb_set(data,'{options}',opts),'{correct_option_id}',to_jsonb(p_target)), updated_at = now() where id = q.id;
end $f$;

create or replace function pg_temp.fb_exam_text(p_pos int, p_col text, p_val text)
returns void language plpgsql as $f$
declare n int;
begin
  execute format('update public.assessment_questions aq set %I = $1, updated_at = now() from public.assessments a, public.courses c where aq.assessment_id = a.id and a.course_id = c.id and c.slug = ''resona-foundations'' and a.assessment_type::text = ''exam'' and aq.position = $2', p_col) using p_val, p_pos;
  get diagnostics n = row_count;
  if n <> 1 then raise exception 'fb_exam_text % % matched % rows', p_pos, p_col, n; end if;
end $f$;

-- Lesson copy and callouts
select pg_temp.fb_block(1, 1, 1, 1, 'rich_text', $j$["Resona started in 2024 as an analytics firm that provided enterprise-level clarity to small businesses across the country. The need was easy to see: most small and mid-size businesses aren't short on data, but they are short on a system that turns that data into a decision.","The scale of the gap is large. There are more than 34 million small and mid-size businesses in the US, roughly 70% of them operate without an in-house data team, and $1.2 trillion is lost industry-wide every year to decisions made on incomplete, inaccurate, or disconnected data.","These businesses aren't ignoring their numbers. What they lack is the infrastructure that enterprise companies have had for decades, meaning the analysts, the tooling, and the operating discipline needed to turn raw numbers into a next move."]$j$::jsonb);
select pg_temp.fb_block(1, 1, 1, 2, 'callout', $j$"The problem isn't a shortage of data but a shortage of clarity, and clarity has to be built deliberately."$j$::jsonb);
select pg_temp.fb_block(1, 1, 2, 1, 'rich_text', $j$["As client needs evolved, providing clarity and insight wasn't enough, because businesses also needed help fixing what the insight uncovered. Resona grew from an analytics firm into a strategic product studio that gives founders the product identity and infrastructure to compete, grow, and scale with confidence.","Every engagement now runs through the same four phases, whatever the client or industry. Discovery reads the business's actual reality before anything is proposed, and Architecture designs the system and decision framework the business will stand on. Brand & Execution is built in parallel with that work, not after it, so the product and how it's perceived are never out of sync. Systemize then installs the methodology and operating capacity so the system runs without Resona standing over it.","The same discipline produced Resona's own flagship methodology, ARC (Adapt, React, Control), which proved the process on the company that built it before it was offered to anyone else."]$j$::jsonb);
select pg_temp.fb_block(1, 1, 3, 1, 'callout', $j$"Resona's work gives founders the product identity and infrastructure to compete, grow, and scale with confidence, and that is why it moved beyond providing insight alone."$j$::jsonb);
select pg_temp.fb_block(1, 2, 1, 1, 'rich_text', $j$["This value isn't about being a data company; it's about building the system that turns a number into a decision. Data on its own is just a fact, and it becomes valuable once it's connected to a decision inside the right operational context. A recommendation without that system underneath it is a guess with a citation.","The standard, then, is not whether the team looked at the numbers but whether it built the framework that makes the numbers mean something.","Strategy comes first, which means reading the operational reality honestly. Data then confirms that the strategy is right, but it doesn't replace having one."]$j$::jsonb);
select pg_temp.fb_block(1, 2, 1, 2, 'callout', $j$"A dashboard full of accurate numbers isn't Data-Driven Excellence, whereas a framework that tells a business owner what to do next, and why, is."$j$::jsonb);
select pg_temp.fb_block(1, 2, 2, 1, 'rich_text', $j$["Simplicity in Complexity is the habit of taking complex operational systems and making them clear, actionable, and accessible to everyone the system serves, and not only to the people who built it. A system that's technically sound but too complicated to act on isn't done yet, because the job is finished when the system is usable and not when it's merely correct. Correct but unusable counts as a failure and not as a partial success.","Together, these two values describe one posture from two angles: build the right system, then make sure a person, and not just a spreadsheet, can run it."]$j$::jsonb);
select pg_temp.fb_block(1, 2, 3, 1, 'callout', $j$"The goal has never been more data but a system that's good enough for data to become a decision, and simple enough for a person to act on."$j$::jsonb);
select pg_temp.fb_block(1, 3, 1, 1, 'rich_text', $j$["Resona measures its success by how well its clients perform, and not by how polished a deliverable looks or how sophisticated the system is under the hood. What counts is whether the client is better off, which is why a recommendation is judged by its outcome and not by its cleverness.","\"Technically delivered\" and \"actually successful\" aren't the same thing. An impressive system that doesn't move the client's real numbers hasn't succeeded."]$j$::jsonb);
select pg_temp.fb_block(1, 3, 1, 2, 'callout', $j$"A beautifully architected system that a client never fully adopts isn't a win, while a simple system that a client actually runs and grows with is."$j$::jsonb);
select pg_temp.fb_block(1, 3, 2, 1, 'rich_text', $j$["Integrity and Transparency means being honest, ethical, and transparent in everything Resona builds and in every relationship it carries. Given what Resona has access to, this is an operating rule and not just a principle.","In practice, it means full transparency about what's accessed, why, where it goes, and when it's removed. Resona gets explicit consent before any system or data source is touched, and every action leaves an audit trail. A client's data is theirs, so Resona processes it on their behalf, and it leaves with them at the end of an engagement.","Client Success First and Integrity and Transparency reinforce each other, because a client can only trust that Resona is working in their interest if the relationship is transparent enough to verify it."]$j$::jsonb);
select pg_temp.fb_block(1, 3, 3, 1, 'callout', $j$"Clients can trust an outcome when they can see and verify the process behind it, which is why transparency and client success reinforce each other."$j$::jsonb);
select pg_temp.fb_block(1, 4, 1, 1, 'rich_text', $j$["At Resona, we embrace change and look for smarter, faster, more effective solutions, both for clients and in how Resona itself operates.","This value exists because the gap described in Lesson 1.1 doesn't close by itself, and it doesn't stay closed once it has been closed. The methodology gets refined as more businesses run it, the tooling improves as real engagements show what works, and the standard for \"good enough\" keeps moving, on purpose. Innovation and Growth is what keeps Resona from becoming the next version of the enterprise tools it was built to replace."]$j$::jsonb);
select pg_temp.fb_block(1, 4, 1, 2, 'callout', $j$"Innovation and Growth isn't a matter of chasing new technology; it means refusing to let the system calcify."$j$::jsonb);
select pg_temp.fb_block(1, 4, 1, 3, 'callout', $j$"Roughly 95% of new products fail, not because the idea was wrong but because there was no architecture, brand, or strategy built around it to carry it to market. And of the startups that do gain traction, 74% of high-growth ones collapse from scaling before the systems underneath them were ready. A methodology that stops improving stops protecting against exactly this."$j$::jsonb);
select pg_temp.fb_block(1, 4, 1, 4, 'callout', $j$"A person with this value has the desire to create something new and genuinely impactful, backed by real action and not just ideas talked about. That combination is what Resona looks for and develops in its people."$j$::jsonb);
select pg_temp.fb_block(1, 4, 2, 1, 'rich_text', $j$["Resona's impact shows up in outcomes. Roughly 68% of businesses that implement a structured product strategy report measurable revenue improvement within the first year, and a structured operating cycle moves businesses from concept to shipped release roughly three times faster, with significantly higher confidence. Improvements built on a real Control layer stick, whereas without one, businesses tend to revert to old patterns within 90 days.","Resona doesn't stop at handing over a system. Every engagement installs the methodology, tooling, and operating capacity directly into the business, so the client keeps running and improving it after Resona steps back.","The pattern holds across industries: a consumer platform that needed architecture and brand before it could function, a medtech hardware company with a strong product and no system around it, and a twelve-year retail business with no infrastructure for the shift online. In each case the work followed the same phases: discovery, architecture, brand and execution, and systemize."]$j$::jsonb);
select pg_temp.fb_block(1, 4, 3, 1, 'callout', $j$"Resona's impact is measured in businesses that gained clarity and capability once reserved for companies with full analytics teams, delivered through a system that keeps improving instead of standing still."$j$::jsonb);
select pg_temp.fb_block(2, 1, 1, 1, 'rich_text', $j$["Resona operates with a small, founder-led core team. Structure is fluid, so roles and responsibilities shift as the company grows, and most people carry more than one function. There is no large formal hierarchy at this stage."]$j$::jsonb);
select pg_temp.fb_block(2, 1, 1, 2, 'callout', $j$"Fluid structure is still structure: decisions and ownership are clear even without a formal org chart."$j$::jsonb);
select pg_temp.fb_block(2, 1, 2, 1, 'rich_text', $j$["Resona operates as a Product Studio, which means it builds its own products and, through that same expertise, builds for others. ARC and Procurely are the clearest proof of that. Both are Resona's own products, built with the same four-phase methodology the studio applies to every engagement (Discovery, Architecture, Brand & Execution, and Systemize, covered in Module 1).","Resona builds the architecture and operating discipline, and ARC and Procurely are two expressions of that discipline, shipped as standalone products. Each product has its own team structure, which is covered in that product's own course."]$j$::jsonb);
select pg_temp.fb_block(2, 1, 3, 1, 'callout', $j$"Resona is a Product Studio, and ARC and Procurely are its own products, which serve as proof of the same discipline the studio applies to every engagement."$j$::jsonb);
select pg_temp.fb_block(2, 2, 1, 1, 'rich_text', $j$["Externally, Resona identifies as a Product Studio, and that's the name people will recognize. Internally, the function behind that identity is the service arm, which covers three things: product architecture, which designs the system before anything gets built; management, which runs the engagement and the build from start to finish; and solutions, which are the delivered result, installed so the business runs it independently.","Product Studio and service arm describe the same thing from two angles, since one is the name and the other is the function."]$j$::jsonb);
select pg_temp.fb_block(2, 2, 1, 2, 'callout', $j$"\"A Product Studio\" is what Resona is called, and \"service arm\" is what it does. Both terms are correct and they don't conflict, so use both."$j$::jsonb);
select pg_temp.fb_block(2, 2, 2, 1, 'rich_text', $j$["The service arm operates under Resona Brands, the part of the company focused on developing brand products and the strategy around them. Resona Brands is where product architecture and brand identity get built together and not handed off in sequence, which means a Resona-built product ships with both a working system and a coherent market position from day one. Future product lines run through the same service arm and the same Resona Brands discipline."]$j$::jsonb);
select pg_temp.fb_block(2, 2, 3, 1, 'callout', $j$"Resona's identity is a Product Studio, and the service arm, covering architecture, management, and solutions, is the function behind it, operating under Resona Brands."$j$::jsonb);
select pg_temp.fb_block(2, 3, 1, 1, 'rich_text', $j$["Resona's two products solve different problems for different markets. ARC connects businesses to their visibility, and Procurely is a rapid-win procurement solution. The markets and the products are very different, yet both are built through the same service arm and the same strategy-first discipline."]$j$::jsonb);
select pg_temp.fb_block(2, 3, 1, 2, 'callout', $j$"The builder and the architecture discipline are the same for both products, but the markets differ, so avoid assuming any feature overlap between ARC and Procurely."$j$::jsonb);
select pg_temp.fb_block(2, 3, 2, 1, 'rich_text', $j$["Both products share one underlying belief: businesses lose ground without the right system, and the right system has to be built deliberately. ARC applies that belief to operational visibility and decision-making, while Procurely applies it to winning government procurement opportunities faster.","Each product's own course covers its mechanics, features, and workflows, and this lesson only covers where each one sits among Resona's offerings."]$j$::jsonb);
select pg_temp.fb_block(2, 3, 3, 1, 'callout', $j$"ARC connects businesses to their visibility, and Procurely delivers rapid-win procurement solutions, with the same Resona discipline underneath both despite the different markets."$j$::jsonb);
select pg_temp.fb_block(3, 1, 1, 1, 'rich_text', $j$["Given Resona's fluid, founder-led structure, ownership isn't assigned by title but treated as the working assumption: if something is yours, you run with it. Owning something means seeing it through and not just starting it, and ownership is tracked and visible in Monday, where work lives, gets assigned, and moves forward.","Ownership does come with role responsibilities, but every contribution, in whatever form it takes, is vital to Resona's success."]$j$::jsonb);
select pg_temp.fb_block(3, 1, 1, 2, 'callout', $j$"Ownership at Resona is less about being told what to do and more about making sure that what you're doing is visible to everyone else."$j$::jsonb);
select pg_temp.fb_block(3, 1, 2, 1, 'callout', $j$"Ownership means running with what's yours and keeping it visible in Monday, so that you aren't waiting to be told and your work doesn't go quiet."$j$::jsonb);
select pg_temp.fb_block(3, 2, 1, 1, 'rich_text', $j$["Communication at Resona is direct, so feedback and disagreement are said plainly and not softened into vague suggestions. Directness doesn't mean formality, though. Slack is where this shows up most: it's a casual environment built for ideas and execution, and not for rigid back-and-forth approval chains.","Direct means clear and honest, not stiff or corporate, so you can disagree plainly with someone and still keep the conversation easy."]$j$::jsonb);
select pg_temp.fb_block(3, 2, 1, 2, 'callout', $j$"Directness is about clarity and not about tone, which is why being direct and being casual don't conflict at Resona; they coexist."$j$::jsonb);
select pg_temp.fb_block(3, 2, 2, 1, 'callout', $j$"Resona expects people to say what they think plainly while keeping the conversation easy, and the two don't pull against each other."$j$::jsonb);
select pg_temp.fb_block(4, 1, 1, 1, 'rich_text', $j$["Resona's growth plan doesn't hinge on chasing a fixed target. It's built around continuing to develop top-tier products and letting those products lead the company's growth over time.","The near-term focus is on Procurely and ARC becoming genuinely excellent, and not just shipped. As product quality compounds, growth follows from the products themselves and not from a separate growth initiative running alongside them. That is the same logic covered in Module 1, where strategy comes first, architecture second, and execution third, and growth is what happens when that sequence is done right, repeatedly."]$j$::jsonb);
select pg_temp.fb_block(4, 1, 1, 2, 'callout', $j$"Growth isn't a separate function bolted onto the products; at Resona, the products are the growth strategy."$j$::jsonb);
select pg_temp.fb_block(4, 1, 2, 1, 'callout', $j$"Resona's growth plan is product-led: it builds genuinely excellent products and lets that quality carry the company forward."$j$::jsonb);
select pg_temp.fb_block(4, 2, 1, 1, 'rich_text', $j$["Resona runs on two engines, the studio arm and the product line, and both are active, both matter, and both reinforce each other. The studio applies Resona's methodology directly to client engagements, while the products, ARC and Procurely, apply that same methodology at scale, built by Resona for Resona's own market.","Client work and product work aren't competing priorities. They're two expressions of the same discipline, running in parallel."]$j$::jsonb);
select pg_temp.fb_block(4, 2, 1, 2, 'callout', $j$"Resona isn't choosing between being a studio and being a product company; it's built to run both at the same time, permanently."$j$::jsonb);
select pg_temp.fb_block(4, 2, 2, 1, 'callout', $j$"Resona runs on two engines, the studio and the products, which are both active, both permanent, and both proof of the same discipline."$j$::jsonb);
select pg_temp.fb_block(4, 3, 1, 1, 'rich_text', $j$["Module 1 covered the problem: enterprise-grade clarity has been out of reach for most SMBs. This lesson covers what Resona is doing about that gap beyond its own paying clients. It creates educational resources that are available to everyone and aren't gated behind a client engagement, and it partners with non-profits to extend that access into the community directly.","These efforts aren't marketing gestures. They apply the same \"level the playing field\" mission from Module 1 to people and organizations who may never become paying clients at all."]$j$::jsonb);
select pg_temp.fb_block(4, 3, 1, 2, 'callout', $j$"The mission is bigger than serving the clients Resona already has: it's to close the gap, and that includes people outside Resona's client base entirely."$j$::jsonb);
select pg_temp.fb_block(4, 3, 2, 1, 'callout', $j$"Resona's impact isn't measured only in client outcomes; it also shows up in educational access and non-profit partnerships that extend the mission into the wider community."$j$::jsonb);

-- Activity explanations
select pg_temp.fb_q('l11-p2-retrieval', array['question','explanation'], $j$"The four phases run in this order: Discovery, Architecture, Brand & Execution, then Systemize."$j$::jsonb);
select pg_temp.fb_q('l11-p3-mastery-1', array['question','explanation'], $j$"Resona began as an analytics firm that provided enterprise-level clarity to small businesses."$j$::jsonb);
select pg_temp.fb_q('l11-p3-mastery-2', array['question','explanation'], $j$"Insight alone wasn't enough, because clients also needed help carrying out the solutions the insight pointed to."$j$::jsonb);
select pg_temp.fb_q('l12-p2-retrieval', array['question','explanation'], $j$"Data-Driven Excellence is about building the system that turns data into a decision, which is more than gathering numbers."$j$::jsonb);
select pg_temp.fb_q('l12-p3-mastery-1', array['question','explanation'], $j$"Due diligence comes first, because the data and context behind a decision have to be gathered before the decision is made."$j$::jsonb);
select pg_temp.fb_q('l12-p3-mastery-2', array['question','explanation'], $j$"Higher-stakes decisions carry more downside if the data and context turn out to be wrong, so the diligence has to match the stakes."$j$::jsonb);
select pg_temp.fb_q('l13-p2-retrieval', array['question','explanation'], $j$"Client Success First measures whether the client's real outcomes improved, and not how polished or advanced the work looks."$j$::jsonb);
select pg_temp.fb_q('l13-p3-mastery-1', array['question','explanation'], $j$"A transparent relationship requires presenting honest findings, even when the client hoped for a different answer."$j$::jsonb);
select pg_temp.fb_q('l13-p3-mastery-2', array['question','explanation'], $j$"The audit trail keeps the relationship transparent and verifiable for the client."$j$::jsonb);
select pg_temp.fb_q('l14-p2-retrieval', array['question','explanation'], $j$"A system that worked a year ago isn't automatically the best system today, so the methodology keeps being refined."$j$::jsonb);
select pg_temp.fb_q('l14-p3-mastery-1', array['question','explanation'], $j$"Most new products fail because no architecture, brand, or strategy was built around them to carry them to market, and not because the idea was wrong."$j$::jsonb);
select pg_temp.fb_q('l14-p3-mastery-2', array['question','explanation'], $j$"Without a real Control layer, improvements tend to revert to old patterns within about 90 days."$j$::jsonb);
select pg_temp.fb_q('m1-check-1', array['question','explanation'], $j$"The phases run in this order: Discovery, Architecture, Brand & Execution, then Systemize."$j$::jsonb);
select pg_temp.fb_q('m1-check-2', array['question','explanation'], $j$"Presenting honest findings applies both Client Success First and Integrity and Transparency."$j$::jsonb);
select pg_temp.fb_q('l21-p2-retrieval', array['question','explanation'], $j$"In practice it means Resona builds its own products and applies the same expertise to build for others."$j$::jsonb);
select pg_temp.fb_q('l21-p3-mastery-1', array['question','explanation'], $j$"Resona is a Product Studio that builds its own products and builds for others."$j$::jsonb);
select pg_temp.fb_q('l21-p3-mastery-2', array['question','explanation'], $j$"A product's team structure is covered in that product's own course, and not in this one."$j$::jsonb);
select pg_temp.fb_q('l22-p2-retrieval', array['question','explanation'], $j$"Product Studio is the external name and service arm is the internal working term for the same function."$j$::jsonb);
select pg_temp.fb_q('l22-p3-mastery-1', array['question','explanation'], $j$"The service arm covers product architecture, management, and solutions."$j$::jsonb);
select pg_temp.fb_q('l22-p3-mastery-2', array['question','explanation'], $j$"The service arm operates under Resona Brands."$j$::jsonb);
select pg_temp.fb_q('l23-p2-retrieval', array['question','explanation'], $j$"The two products serve different markets and are very different, but they're built on the same discipline."$j$::jsonb);
select pg_temp.fb_q('l23-p3-mastery-1', array['question','explanation'], $j$"At a high level, ARC connects businesses to their visibility."$j$::jsonb);
select pg_temp.fb_q('l23-p3-mastery-2', array['question','explanation'], $j$"At a high level, Procurely delivers a rapid-win procurement solution."$j$::jsonb);
select pg_temp.fb_q('m2-check-1', array['question','explanation'], $j$"Resona itself focuses on the service arm, meaning solution architecture, separate from the two products."$j$::jsonb);
select pg_temp.fb_q('m2-check-2', array['question','explanation'], $j$"Resona is a Product Studio that builds its own products and builds for others."$j$::jsonb);
select pg_temp.fb_q('l31-p1-retrieval', array['question','explanation'], $j$"Ownership stays visible through Monday, where work is tracked and assigned."$j$::jsonb);
select pg_temp.fb_q('l31-p2-mastery', array['question','explanation'], $j$"Monday is where ownership of work is tracked at Resona."$j$::jsonb);
select pg_temp.fb_q('l32-p1-retrieval', array['question','explanation'], $j$"Resona's style is direct in content and semi-casual in tone."$j$::jsonb);
select pg_temp.fb_q('l32-p2-mastery', array['question','explanation'], $j$"The expected response is to say it directly, without making it feel formal."$j$::jsonb);
select pg_temp.fb_q('m3-check-1', array['question','explanation'], $j$"Ownership of work is tracked in Monday."$j$::jsonb);
select pg_temp.fb_q('m3-check-2', array['question','explanation'], $j$"Slack provides a casual environment focused on ideas and execution, and not on rigid bureaucracy."$j$::jsonb);
select pg_temp.fb_q('l41-p1-retrieval', array['question','explanation'], $j$"Growth is driven primarily by continuing to develop top-tier products and letting them lead."$j$::jsonb);
select pg_temp.fb_q('l41-p2-mastery', array['question','explanation'], $j$"The products are the growth strategy, because their quality compounds into growth."$j$::jsonb);
select pg_temp.fb_q('l42-p1-retrieval', array['question','explanation'], $j$"The studio arm and the product line are two engines running in parallel, both applying the same methodology."$j$::jsonb);
select pg_temp.fb_q('l42-p2-mastery', array['question','explanation'], $j$"The studio arm continues running alongside the products indefinitely."$j$::jsonb);
select pg_temp.fb_q('l43-p1-retrieval', array['question','explanation'], $j$"Resona extends its mission through educational resources available to all and through partnerships with non-profits."$j$::jsonb);
select pg_temp.fb_q('l43-p2-mastery-1', array['question','explanation'], $j$"Resona creates educational resources and partners with non-profits."$j$::jsonb);
select pg_temp.fb_q('l43-p2-mastery-2', array['question','explanation'], $j$"The community work extends the same \"close the SMB access gap\" mission from Module 1 to people who aren't clients."$j$::jsonb);

-- Activity prompts and option labels
select pg_temp.fb_q('l12-p3-mastery-1', array['question','prompt'], $j$"Client scenario: an assisted living facility is expanding to a new state. Before making that call, what should happen first?"$j$::jsonb);
select pg_temp.fb_q('l13-p3-mastery-1', array['question','prompt'], $j$"Continuing the assisted living facility scenario, due diligence shows the client's originally preferred state isn't the strongest option. What's the right move?"$j$::jsonb);
select pg_temp.fb_q('l21-p2-retrieval', array['question','prompt'], $j$"What does \"Resona, a Product Studio\" mean in practice?"$j$::jsonb);
select pg_temp.fb_q('l23-p3-mastery-1', array['question','prompt'], $j$"What does ARC do, at a high level?"$j$::jsonb);
select pg_temp.fb_q('l23-p3-mastery-2', array['question','prompt'], $j$"What does Procurely do, at a high level?"$j$::jsonb);
select pg_temp.fb_label('l11-p3-mastery-2', 'b', $t$Insight alone wasn't enough, since clients also needed help executing solutions$t$);
select pg_temp.fb_label('l12-p3-mastery-1', 'a', $t$Move forward, since the client's confidence in the opportunity is enough$t$);
select pg_temp.fb_label('l12-p3-mastery-2', 'a', $t$It doesn't, because due diligence matters equally everywhere$t$);
select pg_temp.fb_label('l22-p2-retrieval', 'b', $t$The same function, with Product Studio as the external name and service arm as the internal working term$t$);
select pg_temp.fb_label('l31-p1-retrieval', 'c', $t$It isn't tracked, because everyone just knows$t$);
select pg_temp.fb_label('l41-p2-mastery', 'a', $t$They're unrelated, because growth comes from sales activity alone$t$);
select pg_temp.fb_label('l41-p2-mastery', 'b', $t$The products are the growth strategy, because their quality compounds into growth$t$);
select pg_temp.fb_label('l43-p1-retrieval', 'a', $t$It doesn't, because the mission only applies to clients$t$);
select pg_temp.fb_label('l43-p2-mastery-1', 'a', $t$Nothing, because impact is limited to paying clients$t$);

-- Correct-answer positions (unanswered lesson questions only)
select pg_temp.fb_place('l11-p2-retrieval', 'c');
select pg_temp.fb_place('l11-p3-mastery-1', 'a');
select pg_temp.fb_place('l11-p3-mastery-2', 'd');
select pg_temp.fb_place('l12-p2-retrieval', 'a');
select pg_temp.fb_place('l12-p3-mastery-1', 'c');
select pg_temp.fb_place('l12-p3-mastery-2', 'd');
select pg_temp.fb_place('l13-p2-retrieval', 'b');
select pg_temp.fb_place('l13-p3-mastery-1', 'a');
select pg_temp.fb_place('l13-p3-mastery-2', 'd');
select pg_temp.fb_place('l14-p2-retrieval', 'c');
select pg_temp.fb_place('l14-p3-mastery-1', 'b');
select pg_temp.fb_place('l14-p3-mastery-2', 'd');
select pg_temp.fb_place('m1-check-1', 'a');
select pg_temp.fb_place('m1-check-2', 'c');
select pg_temp.fb_place('l21-p2-retrieval', 'c');
select pg_temp.fb_place('l21-p3-mastery-1', 'a');
select pg_temp.fb_place('l21-p3-mastery-2', 'd');
select pg_temp.fb_place('l22-p2-retrieval', 'a');
select pg_temp.fb_place('l22-p3-mastery-1', 'c');
select pg_temp.fb_place('l22-p3-mastery-2', 'd');
select pg_temp.fb_place('l23-p2-retrieval', 'b');
select pg_temp.fb_place('l23-p3-mastery-1', 'a');
select pg_temp.fb_place('l23-p3-mastery-2', 'd');
select pg_temp.fb_place('m2-check-1', 'c');
select pg_temp.fb_place('m2-check-2', 'b');
select pg_temp.fb_place('l31-p1-retrieval', 'd');
select pg_temp.fb_place('l31-p2-mastery', 'a');
select pg_temp.fb_place('l32-p1-retrieval', 'c');
select pg_temp.fb_place('l32-p2-mastery', 'c');
select pg_temp.fb_place('m3-check-1', 'a');
select pg_temp.fb_place('m3-check-2', 'd');
select pg_temp.fb_place('l41-p1-retrieval', 'a');
select pg_temp.fb_place('l41-p2-mastery', 'c');
select pg_temp.fb_place('l42-p1-retrieval', 'd');
select pg_temp.fb_place('l42-p2-mastery', 'b');
select pg_temp.fb_place('l43-p1-retrieval', 'a');
select pg_temp.fb_place('l43-p2-mastery-1', 'd');
select pg_temp.fb_place('l43-p2-mastery-2', 'c');

-- Cumulative review
select pg_temp.fb_exam_text(1, 'explanation', $t$The four phases run in this order: Discovery, Architecture, Brand & Execution, then Systemize, as covered in Module 1.$t$);
select pg_temp.fb_exam_text(2, 'explanation', $t$False. Client Success First measures whether the client's real outcomes improved, and not how impressive the system looks.$t$);
select pg_temp.fb_exam_text(8, 'explanation', $t$Monday is where work is tracked and assigned.$t$);
select pg_temp.fb_exam_text(11, 'explanation', $t$False. The studio arm continues running alongside the products indefinitely, because both are permanent.$t$);
select pg_temp.fb_exam_text(6, 'prompt', $t$At a high level, what does ARC do?$t$);
select pg_temp.fb_exam_text(7, 'prompt', $t$At a high level, what does Procurely do?$t$);
-- exam 12 option a
update public.assessment_questions aq set data = jsonb_set(data, '{options}', (select jsonb_agg(case when x->>'id' = 'a' then jsonb_set(x,'{label}',to_jsonb($t$It doesn't, because the mission only applies to clients$t$::text)) else x end order by ord) from jsonb_array_elements(aq.data->'options') with ordinality t(x, ord))), updated_at = now() from public.assessments a, public.courses c where aq.assessment_id = a.id and a.course_id = c.id and c.slug = 'resona-foundations' and a.assessment_type::text = 'exam' and aq.position = 12;
select pg_temp.fb_exam_place(1, 'a');
select pg_temp.fb_exam_place(3, 'c');
select pg_temp.fb_exam_place(4, 'd');
select pg_temp.fb_exam_place(6, 'a');
select pg_temp.fb_exam_place(7, 'c');
select pg_temp.fb_exam_place(8, 'd');
select pg_temp.fb_exam_place(9, 'b');
select pg_temp.fb_exam_place(10, 'b');
select pg_temp.fb_exam_place(12, 'd');

-- Glossary definitions
update public.glossary_terms set definition = $t$A methodology (Adapt, React, Control) that Resona proved on itself before offering it as one of its two products, which connects businesses to their own visibility.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$ARC$t$;
update public.glossary_terms set definition = $t$A procurement solution that is one of Resona's two products and is built for rapid wins.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Procurely$t$;
update public.glossary_terms set definition = $t$A company that builds its own products and applies the same expertise to build for others, and Resona's external identity.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Product Studio$t$;
update public.glossary_terms set definition = $t$The part of the company that the service arm operates under, focused on developing brand products and the strategy around them.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Resona Brands$t$;
update public.glossary_terms set definition = $t$The internal function behind Resona's Product Studio identity, covering product architecture, management, and solutions.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Service Arm$t$;
update public.glossary_terms set definition = $t$A style of speaking that is clear and honest in content and casual in tone, so that being plain and being relaxed don't conflict.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Direct Communication$t$;
update public.glossary_terms set definition = $t$The habit of running with what's yours and keeping it visible in Monday, instead of waiting to be told.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Ownership$t$;
update public.glossary_terms set definition = $t$Resona's current growth plan, in which genuinely excellent products and the compounding of their quality drive company growth, with no separate growth initiative running alongside.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Product-Led Growth$t$;
update public.glossary_terms set definition = $t$The second phase of Resona's process, in which the system and decision framework a business will stand on are designed.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Architecture$t$;
update public.glossary_terms set definition = $t$The third phase of Resona's process, built in parallel with Architecture and not after it, so that the product and how it's perceived are never out of sync.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Brand & Execution$t$;
update public.glossary_terms set definition = $t$The first phase of Resona's process, in which a business's actual reality is read before anything is proposed.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Discovery$t$;
update public.glossary_terms set definition = $t$The fourth phase of Resona's process, in which the methodology and operating capacity are installed so the system runs without Resona standing over it.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Systemize$t$;
update public.glossary_terms set definition = $t$A value that measures success by how well clients actually perform and not by how polished the deliverable looks or how sophisticated the system is.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Client Success First$t$;
update public.glossary_terms set definition = $t$A value of building the system that turns a number into a decision and not just gathering data, with strategy coming first and data confirming that it's right.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Data-Driven Excellence$t$;
update public.glossary_terms set definition = $t$A value of embracing change and looking for smarter, faster, more effective solutions, in how Resona operates as well as for clients, while refusing to let the system calcify.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Innovation and Growth$t$;
update public.glossary_terms set definition = $t$A value of being honest, ethical, and transparent in everything Resona builds and every relationship it carries, treated as an operating rule given what Resona has access to.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Integrity and Transparency$t$;
update public.glossary_terms set definition = $t$A value of taking complex operational systems and making them clear, actionable, and accessible to everyone they serve, and not only to the people who built them.$t$, updated_at = now() where course_id = (select id from public.courses where slug = 'resona-foundations') and term = $t$Simplicity in Complexity$t$;
