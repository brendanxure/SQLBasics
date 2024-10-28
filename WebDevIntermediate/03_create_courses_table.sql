/*
Brendan Obilo
03_create_courses_table.sql
04 October 2024
INFT2100
*/

DROP TABLE IF EXISTS courses CASCADE;

CREATE TABLE courses(
    course_code CHAR(9) PRIMARY KEY,
    course_name VARCHAR(100),
    semester INT,
    course_description VARCHAR(255)
);

