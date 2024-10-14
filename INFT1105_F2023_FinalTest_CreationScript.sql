-- **********************
-- Movies Sample Database
-- Winter 2024
-- Christopher Alexander
-- **********************
USE MASTER;
DROP DATABASE IF EXISTS test2_movies
GO
CREATE DATABASE test2_movies;
GO
USE test2_movies;

DROP TABLE IF EXISTS characters;
DROP TABLE IF EXISTS actors;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS ageratings;

CREATE TABLE ageRatings (
	ratingCode			CHAR(4) PRIMARY KEY,
	ratingName			VARCHAR(30) NOT NULL,
	ratingDescription	VARCHAR(200),
	isActive			BIT DEFAULT 1 NOT NULL);

INSERT INTO ageRatings VALUES ('PG', 'Parental Guidance', 'Some material may not be suitable for children. Parents urged to give "parental guidance". May contain some material parents might not like for their young children.', 1);
INSERT INTO ageRatings VALUES ('G', 'General Audiences', 'All ages admitted. Nothing that would offend parents for viewing by children.', 1);
INSERT INTO ageRatings VALUES ('PG13', 'Parents Strongly Cautioned', 'Some material may be inappropriate for children under 13. Parents are urged to be cautious. Some material may be inappropriate for pre-teenagers.', 1);
INSERT INTO ageRatings VALUES ('R', 'Restricted', 'Under 17 requires accompanying parent or adult guardian. Contains some adult material. Parents are urged to learn more about the film before taking their young children with them.', 1);
INSERT INTO ageRatings VALUES ('NC17', 'Adults Only', 'No one 17 and under admitted. Clearly adult. Children are not admitted.', 1);

GO

CREATE TABLE movies (
	movieID				INT PRIMARY KEY,
	movieName			VARCHAR(100) NOT NULL,
	lengthMinutes		SMALLINT,
	directorName		VARCHAR(100),
	productionCompany	VARCHAR(100) NOT NULL,
	genre				CHAR(2),
	ageRating			CHAR(4),
	CONSTRAINT movie_ratings_fk FOREIGN KEY (ageRating) REFERENCES ageratings(ratingCode)
);

-- Movie Data
INSERT INTO movies VALUES (1,'Top Gun Maverick', 130,'Joseph Kosinski', 'Paramount Pictures', 'AD', 'PG13');
INSERT INTO movies VALUES (2,'Avatar', 162,'James Cameron', '20th Century Fox', 'SF', 'PG');
INSERT INTO movies VALUES (3,'Oppenheimer', 181,'Christopher Nolan', 'Syncopy Inc.', 'BI', 'PG13');
INSERT INTO movies VALUES (4,'Finding Nemo', 100,'Andrew Stanton', 'Walt Disney Pictures', 'CD', 'G');

CREATE TABLE actors (
	actorID INT PRIMARY KEY,
	firstName VARCHAR(30) NOT NULL,
	lastName VARCHAR(30) NOT NULL,
	dob DATE,
	homeTown VARCHAR(100),
	gender CHAR(2)
);

INSERT INTO actors VALUES (101,'Tom','Cruise',null, '', 'M');
INSERT INTO actors VALUES (102,'Miles', 'Teller',null, '', 'M');
INSERT INTO actors VALUES (103,'Jennifer','Connelly',null, '', 'F');
INSERT INTO actors VALUES (104,'Val','Kilmer',null, '', 'M');
INSERT INTO actors VALUES (105,'Sam','Worthington',null, '', 'M');
INSERT INTO actors VALUES (106,'Zoe','Saldana',null, '', 'F');
INSERT INTO actors VALUES (107,'Stephen','Lang',null, '', 'M');
INSERT INTO actors VALUES (108,'Sigourney','Weaver',null, '', 'F');
INSERT INTO actors VALUES (109,'Cillian','Murphy',null, '', 'M');
INSERT INTO actors VALUES (110,'Emily','Blunt',null, '', 'F');
INSERT INTO actors VALUES (111,'Matt','Damon',null, '', 'M');
INSERT INTO actors VALUES (112,'Robert','Downey Jr.',null, '', 'M');
INSERT INTO actors VALUES (113,'Albert','Brooks',null, '', 'M');
INSERT INTO actors VALUES (114,'Ellen','DeGeneres',null, '', 'F');
INSERT INTO actors VALUES (115,'Alexander','Gould',null, '', 'M');
INSERT INTO actors VALUES (116,'Willem','DaFoe',null, '', 'M');

CREATE TABLE characters (
	movieID INT NOT NULL,
	actorID INT NOT NULL,
	characterName VARCHAR(75) NOT NULL,
	salary money,
	CONSTRAINT char_pk PRIMARY KEY (movieID, actorID, characterName)
);


INSERT INTO characters VALUES (1,101,'Maverick',0);
INSERT INTO characters VALUES (1,102,'Rooster',0);
INSERT INTO characters VALUES (1,103,'Penny',0);
INSERT INTO characters VALUES (1,104,'Iceman',0);
INSERT INTO characters VALUES (2,105,'Jake Sully',0);
INSERT INTO characters VALUES (2,106,'Neytiri',0);
INSERT INTO characters VALUES (2,107,'Miles Quaritch',0);
INSERT INTO characters VALUES (2,108,'Grace Augustine',0);
INSERT INTO characters VALUES (3,109,'Robert Oppenheimer',0);
INSERT INTO characters VALUES (3,110,'Katherine Oppenheimer',0);
INSERT INTO characters VALUES (3,111,'Leslie Groves',0);
INSERT INTO characters VALUES (3,112,'Lewiss Straud',0);
INSERT INTO characters VALUES (4,113,'Marlin',0);
INSERT INTO characters VALUES (4,114,'Dory',0);
INSERT INTO characters VALUES (4,115,'Nemo',0);
INSERT INTO characters VALUES (4,116,'Gill',0);