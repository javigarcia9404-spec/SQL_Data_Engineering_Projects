describe 
select 
    a.*,
    b.*
from data_jobs.job_postings_fact as a
left join data_jobs.company_dim b 
on a.company_id = b.company_id
limit 10;

describe data_jobs.main.job_postings_fact;
describe data_jobs.job_postings_fact;
show schemas;

SELECT *
    table_schema,
    table_name
FROM information_schema.tables
where table_schema IS NOT NULL
ORDER BY table_schema, table_name;

show databases;
show schemas;
show tables;

select *
from information_schema.schemata;

select * 
from information_schema.tables
where table_catalog = 'data_jobs';

select *
from information_schema.columns
where table_name = 'company_dim';