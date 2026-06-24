begin;

alter table public.certifications enable row level security;
alter table public.courses enable row level security;
alter table public.modules enable row level security;
alter table public.lessons enable row level security;
alter table public.lesson_pages enable row level security;
alter table public.content_blocks enable row level security;
alter table public.fieldbook_articles enable row level security;
alter table public.glossary_terms enable row level security;
alter table public.user_progress enable row level security;
alter table public.activity_attempts enable row level security;
alter table public.lab_scenarios enable row level security;
alter table public.lab_submissions enable row level security;
alter table public.certificates enable row level security;

create policy "Authenticated users can read published certifications"
  on public.certifications for select to authenticated
  using (status = 'published');

create policy "Authenticated users can read published courses"
  on public.courses for select to authenticated
  using (status = 'published');

create policy "Authenticated users can read published course modules"
  on public.modules for select to authenticated
  using (
    exists (
      select 1 from public.courses
      where courses.id = modules.course_id
        and courses.status = 'published'
    )
  );

create policy "Authenticated users can read published course lessons"
  on public.lessons for select to authenticated
  using (
    exists (
      select 1
      from public.modules
      join public.courses on courses.id = modules.course_id
      where modules.id = lessons.module_id
        and courses.status = 'published'
    )
  );

create policy "Authenticated users can read published lesson pages"
  on public.lesson_pages for select to authenticated
  using (
    exists (
      select 1
      from public.lessons
      join public.modules on modules.id = lessons.module_id
      join public.courses on courses.id = modules.course_id
      where lessons.id = lesson_pages.lesson_id
        and courses.status = 'published'
    )
  );

create policy "Authenticated users can read published fieldbook articles"
  on public.fieldbook_articles for select to authenticated
  using (status = 'published');

create policy "Authenticated users can read published glossary terms"
  on public.glossary_terms for select to authenticated
  using (status = 'published');

create policy "Authenticated users can read published content blocks"
  on public.content_blocks for select to authenticated
  using (
    exists (
      select 1
      from public.fieldbook_articles
      where fieldbook_articles.id = content_blocks.fieldbook_article_id
        and fieldbook_articles.status = 'published'
    )
    or exists (
      select 1
      from public.lesson_pages
      join public.lessons on lessons.id = lesson_pages.lesson_id
      join public.modules on modules.id = lessons.module_id
      join public.courses on courses.id = modules.course_id
      where lesson_pages.id = content_blocks.lesson_page_id
        and courses.status = 'published'
    )
  );

create policy "Authenticated users can read published lab scenarios"
  on public.lab_scenarios for select to authenticated
  using (status = 'published');

create policy "Users manage their own progress"
  on public.user_progress for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can read their own activity attempts"
  on public.activity_attempts for select to authenticated
  using (auth.uid() = user_id);

create policy "Users can create their own activity attempts"
  on public.activity_attempts for insert to authenticated
  with check (
    auth.uid() = user_id
    and score is null
    and max_score is null
    and status in ('started', 'submitted')
  );

create policy "Users can read their own lab submissions"
  on public.lab_submissions for select to authenticated
  using (auth.uid() = user_id);

create policy "Users can create their own lab submissions"
  on public.lab_submissions for insert to authenticated
  with check (
    auth.uid() = user_id
    and score is null
    and evaluator_feedback is null
    and evaluated_by is null
    and evaluated_at is null
    and status in ('draft', 'submitted')
  );

create policy "Users can read their own certificates"
  on public.certificates for select to authenticated
  using (auth.uid() = user_id);

-- Administrative authoring, evaluation, and certificate issuance policies are
-- intentionally deferred until trusted staff roles/claims are defined.

commit;
