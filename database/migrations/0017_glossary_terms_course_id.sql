begin;

-- Scopes glossary_terms to a course. Flagged in 0016 as a known gap: until
-- now glossary_terms was a single shared pool, so a second course's terms
-- would have shown up in every learner's flashcard deck.
--
-- course_id is nullable on purpose: null means a shared term (the Fieldbook
-- glossary), which stays visible to everyone. A term with a course_id is only
-- readable by someone who can access that course (enrolled and, for every
-- course but Resona Foundations, Foundations complete). Admins and
-- zone_managers see everything through the existing admin policy and
-- can_access_course() bypass.
--
-- normalized_term stays globally unique -- two courses can't define the same
-- term yet. Loosening that to (course_id, normalized_term) is a separate
-- change if it's ever needed.

alter table public.glossary_terms
  add column course_id uuid references public.courses(id) on delete cascade;

create index glossary_terms_course_id_idx on public.glossary_terms (course_id);

-- Backfill the 17 Resona Foundations terms seeded by 0016, matched by their
-- categories so any other shared term is left null.
update public.glossary_terms
set course_id = (select id from public.courses where slug = 'resona-foundations')
where course_id is null
  and category in ('Methodology', 'Values', 'Company & Products', 'Culture', 'Growth');

drop policy "Authenticated users can read published glossary terms" on public.glossary_terms;

create policy "Authorized users read published glossary terms"
  on public.glossary_terms for select to authenticated
  using (
    status = 'published'
    and (course_id is null or public.can_access_course(course_id))
  );

commit;
