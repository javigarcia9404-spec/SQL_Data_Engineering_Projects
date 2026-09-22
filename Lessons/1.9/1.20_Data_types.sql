select
    * 
from information_schema.columns
where table_name = 'job_postings_fact';


describe data_jobs.job_postings_fact;

describe
select 
    job_title_short,
    salary_year_avg
from job_postings_fact;

select cast(123 as varchar);

select 
    job_work_from_home:: INT,
    salary_year_avg:: decimal(10,2) as salary_year_avg
from job_postings_fact
where salary_year_avg is not null
limit 10;




--struct

select{skil:'python',type:'programming'}as skill_struct;