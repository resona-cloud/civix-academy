begin;

-- Real Resona org roles. 'admin' remains a separate permission tier (a user
-- can hold both, e.g. founder + admin) and 'trainee' remains the default
-- role a new signup receives. 'instructor', 'reviewer', and 'certified_agent'
-- are left in place as retired, unused labels rather than dropped outright --
-- Postgres enums cannot drop values, and no profile currently holds them.
alter type public.app_role add value 'zone_manager';
alter type public.app_role add value 'sales_rep';
alter type public.app_role add value 'sourcing_operator';
alter type public.app_role add value 'developer';
alter type public.app_role add value 'founder';

commit;
