begin;

alter table public.notes
  add column fieldbook_article_id uuid references public.fieldbook_articles(id) on delete cascade;

alter table public.notes
  add constraint notes_exactly_one_target check (
    num_nonnulls(subject_user_id, lesson_page_id, fieldbook_article_id) = 1
  );

create index notes_fieldbook_article_id_idx
  on public.notes (fieldbook_article_id)
  where fieldbook_article_id is not null;

alter table public.user_progress
  add column visited_page_ids uuid[] not null default '{}',
  add column completed_page_ids uuid[] not null default '{}';

commit;
