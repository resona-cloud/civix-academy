begin;

-- Corrects Lessons 1.1, 1.4, and 2.1 (and Module 1 Check) in the already-live
-- Resona Foundations content, per the v2 handoff's re-audit against the live
-- resonabrands.com site. Content in 0011 was confirmed live in production
-- (courses=1, lessons=15, content_blocks=92, 4 existing users already
-- enrolled) -- these are UPDATEs against existing rows, not a fresh seed.
--
-- Rows are located by lesson/page title + block_type + position rather than
-- by content_blocks.id, since the actual live ids were never captured in any
-- migration file (avoids hardcoding generated ids in a data migration).

-- ------------------------------------------------------------------------
-- Lesson 1.1 "The Resona Story" -- 3-phase process rebuilt to the real
-- 4-phase process (Discovery -> Architecture -> Brand & Execution ->
-- Systemize), mission quote corrected.
-- ------------------------------------------------------------------------

update public.content_blocks cb
set content = jsonb_build_object('body', array[
  'As client needs evolved, providing clarity and insight wasn''t enough. Businesses needed help fixing what the insight uncovered. Resona evolved from an analytics firm into a strategic product studio -- one that gives founders the product identity and infrastructure to compete, grow, and scale with confidence.',
  'Every engagement now runs through the same four phases, no matter the client or the industry:',
  'Discovery -- reading the business''s actual reality, before proposing anything',
  'Architecture -- designing the system and decision framework the business will stand on',
  'Brand & Execution -- built in parallel, not sequentially, so the product and how it''s perceived are never out of sync',
  'Systemize -- installing the methodology and operating capacity so the system runs without Resona standing over it',
  'That''s the same discipline that produced Resona''s own flagship methodology, ARC (Adapt -> React -> Control) -- proof of the process on the company that built it, before it was offered to anyone else.'
])
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'The Resona Story' and p.title = 'The Evolution' and cb2.block_type = 'rich_text' and cb2.position = 1
);

update public.content_blocks cb
set content = jsonb_build_object(
  'alt', 'Discovery, then Architecture, then Brand and Execution, then Systemize',
  'src', 'data:image/svg+xml;base64,' || encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 140" font-family="sans-serif"><defs><marker id="a1" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="10" y="35" width="190" height="70" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="105" y="65" text-anchor="middle" font-size="15" font-weight="600" fill="#0c4a6e">Discovery</text><text x="105" y="85" text-anchor="middle" font-size="11" fill="#0c4a6e">Read the reality</text><line x1="200" y1="70" x2="235" y2="70" stroke="#334155" stroke-width="2" marker-end="url(#a1)"/><rect x="240" y="35" width="190" height="70" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="335" y="65" text-anchor="middle" font-size="15" font-weight="600" fill="#0c4a6e">Architecture</text><text x="335" y="85" text-anchor="middle" font-size="11" fill="#0c4a6e">Design the system</text><line x1="430" y1="70" x2="465" y2="70" stroke="#334155" stroke-width="2" marker-end="url(#a1)"/><rect x="470" y="35" width="190" height="70" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="565" y="65" text-anchor="middle" font-size="14" font-weight="600" fill="#0c4a6e">Brand &amp; Execution</text><text x="565" y="85" text-anchor="middle" font-size="11" fill="#0c4a6e">Built in parallel</text><line x1="660" y1="70" x2="695" y2="70" stroke="#334155" stroke-width="2" marker-end="url(#a1)"/><rect x="700" y="35" width="190" height="70" rx="10" fill="#e0f2fe" stroke="#0369a1"/><text x="795" y="65" text-anchor="middle" font-size="15" font-weight="600" fill="#0c4a6e">Systemize</text><text x="795" y="85" text-anchor="middle" font-size="10.5" fill="#0c4a6e">Install the capacity to run it</text></svg>$svg$, 'UTF8'), 'base64')
)
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'The Resona Story' and p.title = 'The Evolution' and cb2.block_type = 'image' and cb2.position = 2
);

update public.content_blocks cb
set content = jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
  'id', 'l11-p2-retrieval', 'assessment_id', null, 'question_type', 'multiple_choice',
  'prompt', 'Put Resona''s current four-phase process in the correct order.',
  'explanation', 'Discovery, then Architecture, then Brand & Execution, then Systemize.',
  'points', 1, 'position', 1,
  'options', jsonb_build_array(
    jsonb_build_object('id', 'a', 'label', 'Architecture -> Discovery -> Systemize -> Brand & Execution'),
    jsonb_build_object('id', 'b', 'label', 'Discovery -> Architecture -> Brand & Execution -> Systemize'),
    jsonb_build_object('id', 'c', 'label', 'Brand & Execution -> Discovery -> Architecture -> Systemize'),
    jsonb_build_object('id', 'd', 'label', 'Discovery -> Brand & Execution -> Architecture -> Systemize')
  ),
  'correct_option_id', 'b'
))
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'The Resona Story' and p.title = 'The Evolution' and cb2.block_type = 'activity' and cb2.position = 3
);

update public.content_blocks cb
set content = jsonb_build_object('title', 'Takeaway', 'tone', 'success', 'body', 'Resona gives founders the product identity and infrastructure to compete, grow, and scale with confidence.')
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'The Resona Story' and p.title = 'Recap' and cb2.block_type = 'callout' and cb2.position = 1
);

-- ------------------------------------------------------------------------
-- Lesson 1.4 "Where We're Headed" -- new failure-rate stats callout, "3x
-- decisions" corrected to "3x time to market", mastery Q1 replaced.
-- ------------------------------------------------------------------------

update public.content_blocks cb
set content = jsonb_build_object('body', array[
  'At Resona, we embrace change and look for smarter, faster, more effective solutions -- not just for clients, but in how Resona operates.',
  'This value exists because the gap covered in Lesson 1.1 doesn''t close by itself, and it doesn''t stay closed once it''s closed:',
  'The methodology gets refined as more businesses run it',
  'The tooling improves as real engagements surface what works',
  'The standard for "good enough" keeps moving, on purpose',
  'Innovation and Growth is what keeps Resona from becoming the next version of the enterprise tools it was built to replace.'
])
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'Where We''re Headed' and p.title = 'Innovation and Growth' and cb2.block_type = 'rich_text' and cb2.position = 1
);

-- Move the existing "What this looks like in a person" callout out of slot 3
-- before inserting the new stats callout there, so the new insert lands as
-- the second callout on the page (matching the v2 handoff's placement).
update public.content_blocks cb
set position = 4
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'Where We''re Headed' and p.title = 'Innovation and Growth' and cb2.block_type = 'callout' and cb2.position = 3
);

insert into public.content_blocks (lesson_page_id, block_type, position, content)
select p.id, 'callout', 3, jsonb_build_object(
  'title', 'Why the system has to keep improving', 'tone', 'info',
  'body', 'Roughly 95% of new products fail -- not because the idea was wrong, but because there was no architecture, brand, or strategy built around it to carry it to market. And of the startups that do gain traction, 74% of high-growth ones collapse from scaling before the systems underneath them were ready. A methodology that stops improving stops protecting against exactly this.'
)
from public.lesson_pages p
join public.lessons l on l.id = p.lesson_id
where l.title = 'Where We''re Headed' and p.title = 'Innovation and Growth';

update public.content_blocks cb
set content = jsonb_build_object('body', array[
  'Resona''s impact shows up in outcomes:',
  'Roughly 68% of businesses that implement a structured product strategy report measurable revenue improvement within the first year',
  'A structured operating cycle moves businesses from concept to shipped release roughly three times faster, with significantly higher confidence',
  'Improvements built on a real Control layer stick -- without one, businesses tend to revert to old patterns within 90 days',
  'Resona doesn''t stop at handing over a system. Every engagement installs the methodology, tooling, and operating capacity directly into the business -- so the client keeps running and improving it after Resona steps back.',
  'Same pattern, different industries: a consumer platform needing architecture and brand before it could function, a medtech hardware company with a strong product and no system around it, a twelve-year retail business with no infrastructure for the shift online. Discovery, architecture, brand and execution, systemize -- every time.'
])
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'Where We''re Headed' and p.title = 'How Resona Empowers Businesses' and cb2.block_type = 'rich_text' and cb2.position = 1
);

update public.content_blocks cb
set content = jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
  'id', 'l14-p3-mastery-1', 'assessment_id', null, 'question_type', 'multiple_choice',
  'prompt', 'According to Resona, why do most new products actually fail?',
  'explanation', 'There was no architecture, brand, or strategy built around it to carry it to market.',
  'points', 1, 'position', 1,
  'options', jsonb_build_array(
    jsonb_build_object('id', 'a', 'label', 'The underlying idea was wrong'),
    jsonb_build_object('id', 'b', 'label', 'There was no architecture, brand, or strategy built around it to carry it to market'),
    jsonb_build_object('id', 'c', 'label', 'The market wasn''t ready for the product'),
    jsonb_build_object('id', 'd', 'label', 'The founding team lacked technical skill')
  ),
  'correct_option_id', 'b'
))
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'Where We''re Headed' and p.title = 'Recap' and cb2.block_type = 'activity'
    and cb2.content -> 'question' ->> 'id' = 'l14-p3-mastery-1'
);

-- ------------------------------------------------------------------------
-- Lesson 2.1 "Company Structure" -- references the real 4-phase methodology
-- instead of the retired "strategy-first" shorthand.
-- ------------------------------------------------------------------------

update public.content_blocks cb
set content = jsonb_build_object('body', array[
  'Resona operates as a Product Studio -- it builds its own products and, through that same expertise, builds for others. ARC and Procurely are the clearest proof of that: both are Resona''s own products, built using the same four-phase methodology -- Discovery, Architecture, Brand & Execution, Systemize -- the studio applies to every engagement, covered in Module 1.',
  'Each product has its own team structure, covered in that product''s own course',
  'Resona builds the architecture and operating discipline; ARC and Procurely are two expressions of that discipline, shipped as standalone products'
])
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'Company Structure' and p.title = 'Resona, ARC, and Procurely' and cb2.block_type = 'rich_text' and cb2.position = 1
);

-- ------------------------------------------------------------------------
-- Module 1 Check -- Q1 updated from the retired 3-step shorthand to the real
-- 4-phase process, per user decision (2026-08-24), so the check stays
-- consistent with what Lesson 1.1 now teaches.
-- ------------------------------------------------------------------------

update public.content_blocks cb
set content = jsonb_build_object('gates_progress', true, 'question', jsonb_build_object(
  'id', 'm1-check-1', 'assessment_id', null, 'question_type', 'multiple_choice',
  'prompt', 'What are the four phases of Resona''s process, in order, when working with a client?',
  'explanation', 'Discovery, then Architecture, then Brand & Execution, then Systemize.',
  'points', 1, 'position', 1,
  'options', jsonb_build_array(
    jsonb_build_object('id', 'a', 'label', 'Discovery -> Architecture -> Brand & Execution -> Systemize'),
    jsonb_build_object('id', 'b', 'label', 'Architecture -> Discovery -> Systemize -> Brand & Execution'),
    jsonb_build_object('id', 'c', 'label', 'Systemize -> Discovery -> Architecture -> Brand & Execution'),
    jsonb_build_object('id', 'd', 'label', 'Discovery -> Brand & Execution -> Architecture -> Systemize')
  ),
  'correct_option_id', 'a'
))
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'Module 1 Check' and cb2.block_type = 'activity'
    and cb2.content -> 'question' ->> 'id' = 'm1-check-1'
);

commit;
