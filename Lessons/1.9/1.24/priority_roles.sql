CREATE OR REPLACE TABLE staging.priority_roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL,
    priority_lvl INT
);

INSERT INTO staging.priority_roles (role_id, role_name, priority_lvl)
values 
(1,'Data Engineer', 2),
(2,'Senior Data Engineer', 2),
(3,'Software Engineer', 4);

select * from staging.priority_roles;
