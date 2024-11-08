-- Name: Muath Alzghool
-- Student Number: 12345678
-- Course: INFT2100
-- section: 11
-- Drop table movies
DROP TABLE movies;
--create the movies table

CREATE TABLE movies(
    movie_num INTEGER PRIMARY KEY,
    title VARCHAR(35) NOT NULL,
    year INTEGER 
);
-- insert records in miovies

INSERT INTO movies 
	VALUES(1,'Tomorrow Never Dies',1997);
INSERT INTO movies (movie_num, title)
	VALUES(2,'Goldfinger');

INSERT INTO movies(movie_num, title, year) VALUES(
	16,
	'License To Kill',
	1989);

INSERT INTO movies(movie_num, title, year) VALUES(
	19,
	'The World Is Not Enough',
	1999);
INSERT INTO movies(movie_num, title, year) VALUES(
	20,
	'Die Another Day',
	2003);

--Delete recorde
DELETE FROM movies
	WHERE movie_num = 2;

SELECT * FROM movies;