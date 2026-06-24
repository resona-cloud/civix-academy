begin;

create extension if not exists pgcrypto;

create type public.content_status as enum ('draft', 'published', 'archived');
create type public.content_block_type as enum (
  'rich_text', 'image', 'video', 'callout', 'download', 'activity'
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table public.certifications (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  description text not null default '',
  status public.content_status not null default 'draft',
  passing_score numeric(5,2) check (passing_score between 0 and 100),
  valid_for_months integer check (valid_for_months is null or valid_for_months > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.courses (
  id uuid primary key default gen_random_uuid(),
  certification_id uuid references public.certifications(id) on delete set null,
  slug text not null unique,
  title text not null,
  description text not null default '',
  status public.content_status not null default 'draft',
  position integer not null default 1 check (position > 0),
  estimated_minutes integer check (estimated_minutes is null or estimated_minutes > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.modules (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  title text not null,
  description text not null default '',
  position integer not null check (position > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (course_id, position)
);

create table public.lessons (
  id uuid primary key default gen_random_uuid(),
  module_id uuid not null references public.modules(id) on delete cascade,
  title text not null,
  description text not null default '',
  position integer not null check (position > 0),
  estimated_minutes integer check (estimated_minutes is null or estimated_minutes > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (module_id, position)
);

create table public.lesson_pages (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  title text not null,
  position integer not null check (position > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (lesson_id, position),
  unique (id, lesson_id)
);

create table public.fieldbook_articles (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  summary text not null default '',
  category text,
  tags text[] not null default '{}',
  status public.content_status not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.glossary_terms (
  id uuid primary key default gen_random_uuid(),
  term text not null,
  normalized_term text generated always as (lower(trim(term))) stored,
  definition text not null,
  source_url text,
  status public.content_status not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (normalized_term)
);

create table public.content_blocks (
  id uuid primary key default gen_random_uuid(),
  lesson_page_id uuid references public.lesson_pages(id) on delete cascade,
  fieldbook_article_id uuid references public.fieldbook_articles(id) on delete cascade,
  block_type public.content_block_type not null,
  position integer not null check (position > 0),
  content jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint content_blocks_one_parent check (
    num_nonnulls(lesson_page_id, fieldbook_article_id) = 1
  )
);

create unique index content_blocks_lesson_page_position_idx
  on public.content_blocks (lesson_page_id, position)
  where lesson_page_id is not null;
create unique index content_blocks_article_position_idx
  on public.content_blocks (fieldbook_article_id, position)
  where fieldbook_article_id is not null;
create index courses_certification_id_idx on public.courses (certification_id);
create index modules_course_id_idx on public.modules (course_id);
create index lessons_module_id_idx on public.lessons (module_id);
create index lesson_pages_lesson_id_idx on public.lesson_pages (lesson_id);
create index fieldbook_articles_tags_idx on public.fieldbook_articles using gin (tags);

create trigger certifications_set_updated_at before update on public.certifications
  for each row execute function public.set_updated_at();
create trigger courses_set_updated_at before update on public.courses
  for each row execute function public.set_updated_at();
create trigger modules_set_updated_at before update on public.modules
  for each row execute function public.set_updated_at();
create trigger lessons_set_updated_at before update on public.lessons
  for each row execute function public.set_updated_at();
create trigger lesson_pages_set_updated_at before update on public.lesson_pages
  for each row execute function public.set_updated_at();
create trigger fieldbook_articles_set_updated_at before update on public.fieldbook_articles
  for each row execute function public.set_updated_at();
create trigger glossary_terms_set_updated_at before update on public.glossary_terms
  for each row execute function public.set_updated_at();
create trigger content_blocks_set_updated_at before update on public.content_blocks
  for each row execute function public.set_updated_at();

commit;
