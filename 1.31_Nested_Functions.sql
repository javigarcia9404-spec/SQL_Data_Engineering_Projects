--array

select ['python','sql','r'];

with skills as (
        select 'python' as skill
        union all
        select 'sql' as skill
        union all
        select 'r' as skill
)

,skills_array as (
    select array_agg(skill order by skill) as skills
    from skills
)

select
 skills[1] as skill_1,
 skills[2] as skill_2,
 skills[3] as skill_3
from skills_array;

--struct

select{skill:'python',type:'programming'}as skill_struct;

with skill_struct as (
    select 
        struct_pack(
            skill:= 'python',
            type:= 'programming'
    ) as s
)

select
    s.skill,
    s.type
from skill_struct;




with skill_table as (
    select 'python' as skills, 'programming' as types
    union all
    select 'sql' as skills, 'query_language' as types
    union all
    select 'r' as skill, 'programming' as types
)

select 
    struct_pack(
        skill := skills, 
        type := types
    )
from skill_table;

---Array of Structs

select [ 
    {skill:'python',type:'programming'},
    {skill:'sql',type:'query_language'},
] as skills_array_of_structs;

with skill_table as (
    select 'python' as skills, 'programming' as types
    union all
    select 'sql' as skills, 'query_language' as types
    union all
    select 'r' as skill, 'programming' as types
)

,skills_array_of_structs as (
    select 
        array_agg(
            struct_pack(
                skill := skills, 
                type := types
            )
        ) as array_of_structs
from skill_table
        )
select 
    array_of_structs[1].skill,
    array_of_structs[2].type,
    array_of_structs[3]
from skills_array_of_structs;


---Map/Object/ Dictionary

select map(['python', 'sql', 'r'], ['programming', 'query_language', 'statistics']) as skills_map;

with skill_map as (
    select map {'skill':'python','type':'programming'} as skills
)
select
    skills['skill'] as skill,
    skills['type'] as type 
from skill_map;

with skill_map_2 as (
    select map(['python', 'sql', 'r'], ['programming', 'query_language', 'statistics']) as skills
)
select
    skills['python'] as skill_1,
    skills['sql'] as skill_2,
    skills['r'] as skill_3
from skill_map_2;


---JSON YOU ARE GOING LIKELY GOING TO RECEIVE DATA AND CLEAN UP

with raw_skills_json as (
    SELECT
        '{"skill":"python","type":"programming"}'::json as skill_json
)

Select
    struct_pack(
        skill := json_extract_path_text(skill_json, '$.skill'),
        type := json_extract_path_text(skill_json, '$.type')
    )
from raw_skills_json;


--Arrays - Final example
--Build a flat skill table for co-workers to access job titles salary info, and skills in one table

CREATE OR REPLACE TEMP TABLE jobs_skills_array as (
select
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    array_agg(sd.skills) as skills_array
from job_postings_fact as jpf
left join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
left join skills_dim as sd
    on sjd.skill_id = sd.skill_id
--where jpf.job_id = '1147264'
group by all);

select* 
from jobs_skills_array
limit 100;

with flat_skills as (
select 
    job_id,
    job_title_short,
    salary_year_avg,
    unnest(skills_array) as skill
from jobs_skills_array
)

select 
    skill,
    median(salary_year_avg) as median_Avg
from flat_skills
group by all
order by median_avg desc;


--Array of structs final example
--Build a flat skill & type table for co-workers to access job_titles, salary info, skills, and type on one table

CREATE OR REPLACE TEMP TABLE jobs_skills_array_struct as (
select
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    array_agg(
        struct_pack(
            skill_type:= sd.type,
            skill_name:= sd.skills
        )
    ) as skills_type
from job_postings_fact as jpf
left join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
left join skills_dim as sd
    on sjd.skill_id = sd.skill_id
--where jpf.job_id = '1147264'
group by all);


select
    *
from jobs_skills_array_struct
where job_id = '812089';

--From the perspective of a Data Analyst, analyze the median salary per type of skills

select
    job_id,
    job_title_short,
    salary_year_avg,
    unnest(skills_type).skill_type as skill_type,
    unnest(skills_type).skill_name as skill_name
from jobs_skills_array_struct
limit 100;

with flat_skills as (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        unnest(skills_type).skill_type as skill_type,
        unnest(skills_type).skill_name as skill_name
    from jobs_skills_array_struct
)
select
    skill_type,
    median(Salary_year_avg) as median_salary
from flat_skills
group by all;