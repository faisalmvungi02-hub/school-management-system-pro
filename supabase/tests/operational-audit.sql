-- PLUS OS read-only operational verification queries
-- Run against a disposable/test project first where a test writes are involved.
-- This file contains SELECT-only diagnostics.

-- 1. Application tables and RLS coverage
select n.nspname as schema_name,
       count(*) as table_count,
       count(*) filter (where c.relrowsecurity) as rls_enabled,
       count(*) filter (where c.relforcerowsecurity) as force_rls_enabled
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname in ('public','private') and c.relkind = 'r'
group by n.nspname
order by n.nspname;

-- 2. Tables with the largest estimated live/dead tuple counts
select schemaname, relname, n_live_tup, n_dead_tup, seq_scan, idx_scan
from pg_stat_user_tables
where schemaname in ('public','private')
order by n_live_tup desc, n_dead_tup desc
limit 100;

-- 3. Partitioned application tables
select n.nspname as schema_name,
       c.relname as table_name,
       pg_get_partkeydef(c.oid) as partition_key
from pg_partitioned_table p
join pg_class c on c.oid = p.partrelid
join pg_namespace n on n.oid = c.relnamespace
where n.nspname in ('public','private')
order by 1,2;

-- 4. Installed operational extensions
select extname, extversion
from pg_extension
where extname in ('pg_stat_statements','pg_cron','pg_net','pgmq','pg_partman','pgcrypto','supabase_vault')
order by extname;

-- 5. Slowest statements by total execution time (requires pg_stat_statements)
select calls, round(total_exec_time::numeric,2) as total_ms,
       round(mean_exec_time::numeric,2) as mean_ms,
       rows, left(query,500) as query_sample
from pg_stat_statements
order by total_exec_time desc
limit 25;

-- 6. Scheduled jobs (requires pg_cron)
select jobid, schedule, command, active
from cron.job
order by jobid;

-- 7. Unique constraints protecting retry-sensitive data
select n.nspname as schema_name, c.relname as table_name,
       con.conname as constraint_name,
       pg_get_constraintdef(con.oid) as definition
from pg_constraint con
join pg_class c on c.oid = con.conrelid
join pg_namespace n on n.oid = c.relnamespace
where con.contype = 'u'
  and n.nspname in ('public','private')
order by 1,2,3;
