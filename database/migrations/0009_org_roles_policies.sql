begin;

-- zone_manager takes over the capabilities previously granted to the
-- 'instructor' and 'reviewer' roles: cohort leadership (visibility into
-- assigned learners' progress/enrollments/risk flags) and lab submission
-- review. 'certified_agent' course-access bypass is dropped -- ordinary
-- course access remains governed by enrollment rows regardless of role.
create or replace function public.instructor_can_access_learner(target_learner_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select public.has_role('zone_manager') and exists (
    select 1
    from public.cohort_members instructor_membership
    join public.cohort_members learner_membership
      on learner_membership.cohort_id = instructor_membership.cohort_id
    where instructor_membership.user_id = auth.uid()
      and instructor_membership.member_type = 'instructor'
      and learner_membership.user_id = target_learner_id
      and learner_membership.member_type = 'trainee'
  );
$$;

create or replace function public.can_access_course(target_course_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select
    public.has_role('admin')
    or public.has_role('zone_manager')
    or exists (
      select 1 from public.enrollments
      where user_id = auth.uid()
        and course_id = target_course_id
        and status in ('assigned', 'in_progress', 'completed')
    );
$$;

drop policy if exists "Instructors read assigned cohort learners" on public.profiles;
create policy "Zone managers read assigned cohort learners"
  on public.profiles for select to authenticated
  using (public.instructor_can_access_learner(id));

drop policy if exists "Instructors read assigned learner enrollments" on public.enrollments;
create policy "Zone managers read assigned learner enrollments"
  on public.enrollments for select to authenticated
  using (public.instructor_can_access_learner(user_id));

drop policy if exists "Instructors read assigned learner risk flags" on public.risk_flags;
create policy "Zone managers read assigned learner risk flags"
  on public.risk_flags for select to authenticated
  using (public.instructor_can_access_learner(learner_id));

drop policy if exists "Instructors create assigned learner risk flags" on public.risk_flags;
create policy "Zone managers create assigned learner risk flags"
  on public.risk_flags for insert to authenticated
  with check (
    created_by = auth.uid()
    and public.instructor_can_access_learner(learner_id)
  );

drop policy if exists "Instructors update assigned learner risk flags" on public.risk_flags;
create policy "Zone managers update assigned learner risk flags"
  on public.risk_flags for update to authenticated
  using (public.instructor_can_access_learner(learner_id))
  with check (public.instructor_can_access_learner(learner_id));

drop policy if exists "Reviewers read assigned lab submissions" on public.lab_submissions;
create policy "Zone managers read assigned lab submissions"
  on public.lab_submissions for select to authenticated
  using (
    public.has_role('zone_manager')
    and evaluated_by = auth.uid()
  );

commit;
