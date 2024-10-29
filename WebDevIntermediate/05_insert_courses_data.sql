/*
Brendan Obilo
05_insert_courses_data.sql
04 October 2024
INFT2100
*/

INSERT INTO courses (course_code, course_name, semester, course_description) 
VALUES

-- Semester 1 
('COMM 1100', 'Communication Foundations', 1, 'Focus on developing communication skills'),
('COMP 1116', 'Computer Systems - Hardware', 1, 'Introduction to computer hardware systems'),
('COSC 1100', 'Introduction to Programming', 1, 'Learn programming basics'),
('INFT 1104', 'Data Communications and Networking 1', 1, 'Introduction to networking principles'),
('INFT 1105', 'Introduction to Databases', 1, 'Learn database concepts and applications'),
('MATH 1114', 'Mathematics for IT', 1, 'Mathematics applicable to IT professionals'),

-- Semester 2
('COSC 1200', 'Object-Oriented Programming 1', 2, 'Introduction to object-oriented programming'),
('GNED 0002', 'General Education Elective', 2, 'Elective course for broader learning'),
('INFT 1206', 'Web Development - Fundamentals', 2, 'Introduction to web development'),
('INFT 1207', 'Software Testing and Automation', 2, 'Learn software testing practices'),
('MGMT 1223', 'Systems Development 1', 2, 'Introduction to systems development'),
('MGMT 1224', 'Business for IT Professionals', 2, 'Business principles for IT professionals'),

-- Semester 3

('COMM 2109', 'IT Career Essentials', 3, 'Learn essential skills for IT careers'),
('COSC 2100', 'Object-Oriented Programming 2', 3, 'Advanced object-oriented programming concepts'),
('GNED 0003', 'General Education Elective', 3, 'Elective course for broader learning'),
('INFT 2100', 'Web Development Intermediate', 3, 'Intermediate web development skills'),
('INFT 2101', 'Database Development 1', 3, 'Learn advanced database design'),
('MGMT 2107', 'Systems Development 2', 3, 'Advanced systems development concepts'),

-- Semester 4

('COSC 2200', 'Object-Oriented Programming 3', 4, 'Advanced topics in object-oriented programming'),
('GNED 0004', 'General Education Elective', 4, 'Elective course for broader learning'),
('INFT 2200', 'Mainframe Development 1', 4, 'Introduction to mainframe development'),
('INFT 2201', 'Web Development - Enterprise', 4, 'Enterprise-level web development skills'),
('INFT 2202', 'Web Development - Client Side Script', 4, 'Client-side scripting for web development'),
('INFT 2203', 'Cloud Technology Fundamentals', 4, 'Introduction to cloud technology concepts'),

-- Semester 5

('INFT 3100', 'Mainframe Development 2', 5, 'Advanced mainframe development'),
('INFT 3101', 'Mobile Development', 5, 'Introduction to mobile application development'),
('INFT 3102', 'Web Development - Frameworks', 5, 'Learn popular web development frameworks'),
('INFT 3103', 'Emerging Technologies', 5, 'Explore emerging technologies in IT'),
('INFT 3104', 'Cloud Technology for Developers', 5, 'Advanced cloud development techniques'),

-- Semester 6

('CPGA 3200', 'Capstone Project', 6, 'Complete a final project integrating learned skills'),
('CPGA 3201', 'Field Placement - CPA', 6, 'Real-world placement experience'),
('INFT 3200', 'Cloud Technology Operations', 6, 'Operations and management of cloud technology'),
('INFT 3201', 'Database Development 2', 6, 'Advanced database management concepts'),
('MGMT 3211', 'Cross-Functional Collaboration', 6, 'Collaboration across IT and business functions');
