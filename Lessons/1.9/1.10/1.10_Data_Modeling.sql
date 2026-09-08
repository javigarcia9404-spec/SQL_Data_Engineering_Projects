select 
    job_id
    ,job_title_short
from 
    job_postings_fact
limit 10;

select *
from information_schema.TABLES
where table_catalog = 'data_jobs';

PRAGMA SHOW_TABLES;


DESCRIBE job_postings_fact;