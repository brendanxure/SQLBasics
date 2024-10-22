-- --------------------
-- TOPIC 1 for the day
-- DDL
-- --------------------

-- first things we must understand there are 7 constraints
-- 1 - Primary Key
-- 2 - Foreign Key
-- 3 - Unique -A unique constraint ensures that all values in a column are different.
-- 4 - Required (NOT NULL) - The NOT NULL constraint enforces a column to not accept NULL values.
-- 5 - DEFAULT - A DEFAULT constraint provides a default value for a column when none is specified.
-- 6 - Range (CHECK) - A CHECK constraint allows specifying a range of values that are valid for a column.SEL
-- 7 - Index - is used to improve the performance of data retrieval operations. It creates a physical storage structure that allows for efficient access to data based on the indexed column(s).

-- ---------------------
-- CREATE TABLE
-- ---------------------
--

-- syntax
/*
CREATE TABLE <tablename> (
	field1   datatype1   constraints,
	field2   datatype2   constraints,
	field3   datatype3   constraints,
	....
	fieldn   datatypen   constraints,
	CONSTRAINT <constraintname> <constrainttype> <constraintdetails>,
	CONSTRAINT <constraintname> <constrainttype> <constraintdetails>
);
*/

DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
	genreCode	CHAR(2)			PRIMARY KEY,
	genreName	VARCHAR(25)		NOT NULL,
	isActive	BIT				NOT NULL DEFAULT 1
);

DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
	actorID		INT				PRIMARY KEY,
	firstName	VARCHAR(25)		NOT NULL,
	middleName	VARCHAR(25),
	lastName	VARCHAR(35)		NOT NULL,
	dob			DATE			CHECK(dob < getdate()),
	homeTown	VARCHAR(25)
);

DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
	movieID		INT				PRIMARY KEY,
	movieName	VARCHAR(255)	NOT NULL,
	duration	SMALLINT		DEFAULT 0 NOT NULL,
	genre		CHAR(2),
	director	VARCHAR(50),
	yrRelease	SMALLINT,
	CONSTRAINT movies_genres_fk FOREIGN KEY (genre) REFERENCES genres(genreCode)
);

DROP TABLE IF EXISTS characters;
CREATE TABLE characters (
	actorID			INT				NOT NULL,
	movieID			INT				NOT NULL,
	characterName	VARCHAR(100)	NOT NULL,
	salary			DECIMAL(11,2)	DEFAULT 0,
	CONSTRAINT	characters_pk	PRIMARY KEY (actorID, movieID),
	CONSTRAINT	actors_characters_fk	FOREIGN KEY (actorID) REFERENCES actors(actorID),
	CONSTRAINT	movies_characters_fk	FOREIGN KEY (movieID) REFERENCES movies(movieID)
);

ALTER TABLE characters
	ADD characterID	INT IDENTITY(1,1);

ALTER TABLE characters
	DROP CONSTRAINT characters_pk;

ALTER TABLE characters
	ADD CONSTRAINT characters_pk PRIMARY KEY (characterID);



-- --------------------
-- TOPIC 2 for the day
-- SET OPERATORS
-- --------------------

-- UNION - is used to combine the results of two or more SELECT statements. It eliminates duplicate rows from the result set and only returns distinct values.

-- UNION ALL - Similar to UNION, but it includes all duplicates. It combines the results of two or more SELECT statements without attempting to remove duplicate rows.

-- INTERSECT - returns the intersection of the result sets of two SELECT statements (i.e., only the rows that are available in both SELECT statement results).

-- EXCEPT - returns distinct rows from the first SELECT statement that are not found in the second SELECT statement's results.

-- List all games for team 222
SELECT * FROM games
WHERE hometeam = 222
UNION 
SELECT * FROM games
WHERE visitteam = 222;



SELECT * FROM
	(
	SELECT locationID FROM games
	WHERE hometeam = 222
	UNION
	SELECT locationID FROM games
	WHERE visitteam = 222 ) t
ORDER BY locationID;

-- List all the locations that have NOT been used in any game!

-- JOIN way
SELECT l.locationID
FROM locations l 
	LEFT JOIN games g ON g.locationid = l.locationid
WHERE g.locationID IS NULL;

-- SET OPERATOR
SELECT locationID FROM locations
EXCEPT
SELECT locationID FROM games;

