-- ****************************
-- INFT1105 - Winter 2024 
-- Final Test - Version A
-- NAME: Brendan Obilo
-- Student: 100952871
-- April 15, 2024
-- ****************************

/* The test is based on the database design provided in the ERD! */

-- PART B - On the Computer
-- all questions worth 5 marks

-- Before starting Part B - run the attached creation script!

/* Question 4
Write the SELECT statement to output the longest movie (length in minutes) in the database.  Output all fields, but do not use *.
*/
USE test2_movies;
GO

SELECT movieID,
	   movieName,
	   lengthMinutes,
	   directorName,
	   productionCompany,
	   genre,
	   ageRating
FROM movies
WHERE lengthMinutes = (SELECT MAX(lengthMinutes) 
FROM movies)
ORDER BY movieID, movieName


/* Question 5
List all the movies found in the 'PG', 'PG13', and 'G' age ratings.  Show the movies sorted by showing all PG movies first, then G, then PG13.  Within each rating, further sort the data by movie name.
*/
SELECT movieID,
	   movieName,
	   lengthMinutes,
	   directorName,
	   productionCompany,
	   genre,
	   ageRating
FROM (
SELECT movieID,
	   movieName,
	   lengthMinutes,
	   directorName,
	   productionCompany,
	   genre,
	   ageRating,
	   1 AS ratingOrder
FROM movies
WHERE ageRating  = 'PG'
UNION
SELECT movieID,
	   movieName,
	   lengthMinutes,
	   directorName,
	   productionCompany,
	   genre,
	   ageRating,
	   2 AS ratingOrder
FROM movies
WHERE ageRating  = 'G'
UNION
SELECT movieID,
	   movieName,
	   lengthMinutes,
	   directorName,
	   productionCompany,
	   genre,
	   ageRating,
	   3 AS ratingOrder
FROM movies
WHERE ageRating  = 'PG13'
) newTable
ORDER BY ratingOrder, movieName

/* Question 6
Write a Stored Procedure called spInsertActor that accepts parameters for each field in the Actors table.  The procedure will insert the data provided and the output the ONE row of data just inserted.
*/

GO
CREATE OR ALTER PROCEDURE spInsertActor 
	@actorCode INT, @actorFirstName VARCHAR(30), @actorLastName VARCHAR(30), @dob DATE, @homeTown VARCHAR(100), @gender CHAR(2)
AS
BEGIN
	INSERT INTO actors(actorID, firstName, lastName, dob, homeTown, gender)
		VALUES (@actorCode, @actorFirstName, @actorLastName, @dob, @homeTown, @gender)
	IF @@ROWCOUNT > 0
		SELECT * FROM actors WHERE actorID = @actorCode
END
GO

DECLARE @actorCode INT = 217;
EXEC dbo.spInsertActor @actorCode, 'Brendan', 'Obilo', '1999-07-11', 'oshawa', 'MA';
GO

