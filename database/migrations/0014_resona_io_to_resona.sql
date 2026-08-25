begin;

-- Drops "IO" from every "Resona IO" reference across the live Resona
-- Foundations course: the course description, Module 2's title, and six
-- content_blocks (one of which embeds the text inside an SVG data URI).
-- All rows were confirmed live before this migration -- these are UPDATEs
-- against existing rows, not a reseed. Located by content match / lesson
-- position rather than hardcoded content_blocks ids.

update public.courses
set description = replace(description, 'Resona IO', 'Resona')
where slug = 'resona-foundations';

update public.modules
set title = 'Resona'
where course_id = (select id from public.courses where slug = 'resona-foundations')
  and title = 'Resona IO';

-- Lesson "Company Structure" / page "Resona, ARC, and Procurely" / image:
-- both the alt text and the SVG's own <text> label say "Resona IO".
update public.content_blocks cb
set content = jsonb_set(
  jsonb_set(cb.content, '{alt}', to_jsonb('Resona as a Product Studio, branching into ARC and Procurely'::text)),
  '{src}',
  to_jsonb('data:image/svg+xml;base64,' || encode(convert_to($svg$<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 460 190" font-family="sans-serif"><defs><marker id="a5" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#334155"/></marker></defs><rect x="130" y="10" width="200" height="60" rx="10" fill="#eff6ff" stroke="#1d4ed8"/><text x="230" y="35" text-anchor="middle" font-size="14" font-weight="600" fill="#1e3a8a">Resona</text><text x="230" y="55" text-anchor="middle" font-size="11" fill="#1e3a8a">Product Studio</text><line x1="200" y1="70" x2="115" y2="115" stroke="#334155" stroke-width="2" marker-end="url(#a5)"/><line x1="260" y1="70" x2="345" y2="115" stroke="#334155" stroke-width="2" marker-end="url(#a5)"/><rect x="10" y="120" width="200" height="60" rx="10" fill="#eff6ff" stroke="#1d4ed8"/><text x="110" y="145" text-anchor="middle" font-size="14" font-weight="600" fill="#1e3a8a">ARC</text><text x="110" y="163" text-anchor="middle" font-size="11" fill="#1e3a8a">own team structure</text><rect x="250" y="120" width="200" height="60" rx="10" fill="#eff6ff" stroke="#1d4ed8"/><text x="350" y="145" text-anchor="middle" font-size="14" font-weight="600" fill="#1e3a8a">Procurely</text><text x="350" y="163" text-anchor="middle" font-size="11" fill="#1e3a8a">own team structure</text></svg>$svg$, 'UTF8'), 'base64'))
)
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'Company Structure' and p.title = 'Resona, ARC, and Procurely' and cb2.block_type = 'image' and cb2.position = 2
);

update public.content_blocks cb
set content = jsonb_set(cb.content, '{question,prompt}', to_jsonb('What does "Resona -- A Product Studio" mean in practice?'::text))
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'Company Structure' and p.title = 'Resona, ARC, and Procurely' and cb2.block_type = 'activity' and cb2.position = 3
);

update public.content_blocks cb
set content = jsonb_set(cb.content, '{body}', to_jsonb('Resona is a Product Studio. ARC and Procurely are its own products, and proof of the same discipline the studio applies to every engagement.'::text))
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'Company Structure' and p.title = 'Recap' and cb2.block_type = 'callout' and cb2.position = 1
);

update public.content_blocks cb
set content = jsonb_set(cb.content, '{body,0}', to_jsonb('Resona identifies as a Product Studio -- externally, this is the name people will recognize. Internally, the actual function behind that identity is the service arm, which covers three things:'::text))
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'The Service Arm' and p.title = 'What the Service Arm Covers' and cb2.block_type = 'rich_text' and cb2.position = 1
);

update public.content_blocks cb
set content = jsonb_set(cb.content, '{body}', to_jsonb('Resona -- Product Studio. The service arm -- architecture, management, and solutions -- is the function behind that identity, operating under Resona Brands.'::text))
where cb.id = (
  select cb2.id from public.content_blocks cb2
  join public.lesson_pages p on p.id = cb2.lesson_page_id
  join public.lessons l on l.id = p.lesson_id
  where l.title = 'The Service Arm' and p.title = 'Recap' and cb2.block_type = 'callout' and cb2.position = 1
);

commit;
