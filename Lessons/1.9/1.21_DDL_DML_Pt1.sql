CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;

--DROP DATABASE jobs_mart;

SHOW DATABASES;

--DROP DATABASE IF EXISTS jobs_mart;

SELECT * 
FROM INFORMATION_SCHEMA.SCHEMATA;

CREATE SCHEMA IF NOT EXISTS jobs_mart.staging;

CREATE SCHEMA IF NOT EXISTS jobs_mart.main;

--DROP SCHEMA IF EXISTS jobs_mart.staging;

CREATE TABLE IF NOT EXISTS jobs_mart.staging.preferred_roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL,
);

select * 
from information_schema.tables
where table_name = 'jobs_mart';

select  *
from information_schema.tables
where table_catalog = 'jobs_mart';

select * from jobs_mart.staging.priority_roles;

describe jobs_mart.staging.priority_roles;

INSERT INTO jobs_mart.staging.preferred_roles (role_id, role_name)
VALUES 
        (1, 'Data Engineer'),
       (2, 'Senior Data Engineer'),
       (3, 'Data Analyst'),
       (4, 'Machine Learning Engineer'),
       (5, 'Business Intelligence Analyst');

INSERT INTO jobs_mart.staging.preferred_roles (role_id, role_name)
VALUES 
        (6, 'Software Engineer');


ALTER TABLE jobs_mart.staging.priority_roles
ADD COLUMN preferred_role BOOLEAN;

ALTER TABLE jobs_mart.staging.preferred_roles
DROP COLUMN preferred_role;

UPDATE jobs_mart.staging.priority_roles
SET preferred_role = TRUE
WHERE role_id = 1 or role_id = 2;

UPDATE jobs_mart.staging.priority_roles
SET preferred_role = FALSE
WHERE role_id = 3 or role_id = 4 or role_id = 5 or role_id = 6;

ALTER TABLE jobs_mart.staging.preferred_roles
RENAME TO priority_roles;

ALTER TABLE jobs_mart.staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

ALTER TABLE jobs_mart.staging.priority_roles
ALTER COLUMN priority_lvl TYPE INT;

UPDATE jobs_mart.staging.priority_roles
SET priority_lvl = 3
WHERE role_id IN (3, 4, 5, 6);

ALTER TABLE jobs_mart.staging.priority_roles
DROP COLUMN priority_lvl;