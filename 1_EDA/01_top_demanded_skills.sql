/* What are the most in-demand skills for data*/


select 
    *
from job_postings_fact as jpf
inner join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
inner join skills_dim as sd
     on sjd.skill_id = sd.skill_id
    limit 10;