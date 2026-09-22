--CREATE TEMP TABLE

CREATE OR REPLACE TEMP TABLE src_priority_jobs as (
    select 
    jpf.job_id,
    jpf.job_title_short,
    cd.name as company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    current_timestamp as updated_at
 from 
  data_jobs.main.job_postings_fact jpf
left join data_jobs.main.company_dim cd 
  on jpf.company_id = cd.company_id
inner join staging.priority_roles r 
  on jpf.job_title_short = r.role_name);

select * from src_priority_jobs;

--UPDATE STATEMENT

-- UPDATE main.priority_jobs_snapshot AS tgt
-- SET 
--     priority_lvl = src.priority_lvl,
--     updated_at = src.updated_at
-- from src_priority_jobs AS src
-- where tgt.job_id = src.job_id
-- and tgt.priority_lvl is distinct from src.priority_lvl;



-- --INSERT STATEMENT

-- INSERT INTO main.priority_jobs_snapshot (
--     job_id, 
--     job_title_short, 
--     company_name, 
--     job_posted_date, 
--     salary_year_avg, 
--     priority_lvl, 
--     updated_at

-- )
-- select
--     src.job_id,
--     src.job_title_short,
--     src.company_name,
--     src.job_posted_date,
--     src.salary_year_avg,
--     src.priority_lvl,
--     src.updated_at
-- from src_priority_jobs src 
-- where not exists (
--     select 1 
--     from main.priority_jobs_snapshot tgt
--     where tgt.job_id = src.job_id
-- );


-- --DELETE STATEMENT

-- DELETE FROM main.priority_jobs_snapshot AS tgt
-- where not exists (
--     select 1 
--     from src_priority_jobs src
--     where src.job_id = tgt.job_id
-- );



--MERGE
MERGE INTO main.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
on tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl is distinct from src.priority_lvl THEN 
    UPDATE SET 

        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at

WHEN NOT MATCHED THEN
    INSERT ( 
        job_id, 
        job_title_short, 
        company_name, 
        job_posted_date, 
        salary_year_avg, 
        priority_lvl, 
        updated_at
    )
VALUES (
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
    
--Final Check query
select 
    job_title_short,
    count(*) as job_count,
    min(priority_lvl) as priority_lvl,
    min(updated_at) as updated_at
from main.priority_jobs_snapshot
group by all
order by job_count desc;