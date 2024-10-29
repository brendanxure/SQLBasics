/*
Brendan Obilo
04_create_marks_table.sql
04 October 2024
INFT2100
*/
DROP TABLE IF EXISTS marks;

CREATE TABLE marks(
    student_id INT,
    course_code CHAR(9),
    final_mark INT CHECK (final_mark BETWEEN 0 AND 100),
    achieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_students_marks FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_courses_marks FOREIGN KEY (course_code) REFERENCES courses(course_code) ON DELETE CASCADE
)