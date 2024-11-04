/*
Brendan Obilo
09_crud_examples.sql
05 October 2024
INFT2100
*/

--INSERT Example for Users
INSERT INTO users(first_name, last_name, email, birth_date, password)
VALUES 
('Alice', 'Johnson', 'alice.johnson@example.com', '1995-03-12', crypt('alice_password', gen_salt('bf'))),
('Brian', 'Smith', 'brian.smith@example.com', '1993-07-22', crypt('brian_password', gen_salt('bf'))),
('Catherine', 'Lee', 'catherine.lee@example.com', '1998-11-30', crypt('catherine_password', gen_salt('bf')));

-- SELECT Example without a WHERE clause
SELECT * 
FROM users;

-- SELECT Examples with a WHERE clause
SELECT * 
FROM users
WHERE email = 'jack.anderson@example.com';

SELECT first_name, last_name, email
FROM users
WHERE user_id < 100900010;

-- SELECT Examples with a ORDER BY clause
SELECT first_name, last_name, user_id, created_at, last_access
FROM users
ORDER BY last_access DESC;

-- UPDATE Example with a WHERE clause
UPDATE users
SET last_access = '2024-10-05 15:52:20'
WHERE user_id = 100900003;

UPDATE users
SET first_name = 'Xure'
WHERE email = 'alice.smith@example.com';

--DELETE Example with a WHERE clause
DELETE FROM users
WHERE user_id = 100900002;

DELETE FROM users
WHERE first_name = 'Frank' AND last_name = 'Garcia';

--INSERT a new course into the courses table
INSERT INTO courses (course_code, course_name, semester, course_description) 
    VALUES ('XURE 1234', 'Introduction to Xure', 3, 'Tell you about xure');

--SELECT students with marks greater than 80.
SELECT *
FROM marks
WHERE final_mark > 80;


--UPDATE a course description for the new course based on its course_code
UPDATE courses
SET course_description = 'Discussion about Xure'
WHERE course_code = 'XURE 1234';

--DELETE a student based on the student_id.
DELETE FROM students
WHERE student_id = 100900004;

DELETE FROM users
WHERE user_id = 100900004;

