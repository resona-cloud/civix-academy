begin;

-- Seeds glossary_terms so the Study Center flashcard panel has real content.
-- glossary_terms has no course_id column (it's a single shared terminology
-- source of truth across Fieldbook and Study Center, by design -- see
-- 0013_study_center_schema.sql) so these terms are course-specific in
-- CONTENT only, drawn directly from what Resona Foundations teaches, not
-- structurally scoped to it. category groups them thematically for the
-- flashcard panel's client-side category filter.

insert into public.glossary_terms (term, definition, category, status) values
  ('Discovery', 'The first phase of Resona''s process: reading a business''s actual reality, before proposing anything.', 'Methodology', 'published'),
  ('Architecture', 'The second phase of Resona''s process: designing the system and decision framework a business will stand on.', 'Methodology', 'published'),
  ('Brand & Execution', 'The third phase of Resona''s process, built in parallel with Architecture -- not sequentially -- so the product and how it''s perceived are never out of sync.', 'Methodology', 'published'),
  ('Systemize', 'The fourth phase of Resona''s process: installing the methodology and operating capacity so the system runs without Resona standing over it.', 'Methodology', 'published'),
  ('Data-Driven Excellence', 'Building the system that turns a number into a decision -- not just gathering data. Strategy comes first; data confirms it''s right, it doesn''t replace having one.', 'Values', 'published'),
  ('Simplicity in Complexity', 'Taking complex operational systems and making them clear, actionable, and accessible to everyone they serve, not just the people who built them.', 'Values', 'published'),
  ('Client Success First', 'Measuring success by how well clients actually perform, not by how polished the deliverable looks or how sophisticated the system is.', 'Values', 'published'),
  ('Integrity and Transparency', 'Being honest, ethical, and transparent in everything Resona builds and every relationship it carries -- an operating rule, given what Resona has access to.', 'Values', 'published'),
  ('Innovation and Growth', 'Embracing change and looking for smarter, faster, more effective solutions, in how Resona operates as well as for clients -- refusing to let the system calcify.', 'Values', 'published'),
  ('Product Studio', 'Resona''s external identity: a company that builds its own products and applies that same expertise to build for others.', 'Company & Products', 'published'),
  ('Service Arm', 'The internal function behind the Product Studio identity, covering product architecture, management, and solutions.', 'Company & Products', 'published'),
  ('Resona Brands', 'The part of the company the service arm operates under, focused on developing brand products and the strategy around them.', 'Company & Products', 'published'),
  ('ARC', 'Resona''s flagship methodology (Adapt -> React -> Control), proven on Resona itself before being offered as one of Resona''s two products -- connecting businesses to their own visibility.', 'Company & Products', 'published'),
  ('Procurely', 'One of Resona''s two products: a rapid-win procurement solution.', 'Company & Products', 'published'),
  ('Ownership', 'At Resona, running with what''s yours and keeping it visible in Monday, rather than waiting to be told.', 'Culture', 'published'),
  ('Direct Communication', 'Resona''s communication style: clear and honest in content, casual in tone -- directness and casualness aren''t in conflict here.', 'Culture', 'published'),
  ('Product-Led Growth', 'Resona''s current growth plan: developing genuinely excellent products and letting their quality compound into company growth, rather than running a separate growth initiative.', 'Growth', 'published');

commit;
