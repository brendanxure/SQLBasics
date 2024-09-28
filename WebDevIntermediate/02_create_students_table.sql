/*
Brendan Obilo
02_create_students_table.sql
04 October 2024
INFT2100
*/

DROP TABLE IF EXISTS students CASCADE; 

CREATE TABLE students(
    student_id INT PRIMARY KEY,
    program_code CHAR(4),
    CONSTRAINT fk_students_users FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE
);

