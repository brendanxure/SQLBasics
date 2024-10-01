-- ******************************
-- INFT1105 Week 6 and 7 - Lecture Demo
-- Christopher Alexander
-- Feb 12 2024
-- Intro to SQL continued
-- ******************************

-- parameters

-- we did this before
SELECT 
	firstname,
	lastname
FROM players
WHERE UPPER(lastname) LIKE 'S%'
ORDER BY lastname;

-- simulate software be declaring a parameter
DECLARE @letter CHAR(1);
SET @letter = 'M';

SELECT 
	firstname,
	lastname
FROM players
WHERE UPPER(lastname) LIKE @letter + '%'
ORDER BY lastname;

-- some things to watch for
DECLARE @letter2 VARCHAR(10);
SET @letter2 = '     M      ';

SELECT 
	firstname,
	lastname
FROM players
WHERE UPPER(lastname) LIKE TRIM(@letter2) + '%'
-- note the parameter is NOT doing a TRIM automatically
ORDER BY lastname;

-- TRIM removes both leading and trailing spaces

-- wild card combinations
-- name to start with M but also contains a D 
SELECT 
	firstname,
	lastname
FROM players
WHERE UPPER(lastname) LIKE 'M%D%'
ORDER BY lastname;


SELECT 
	firstname,
	lastname
FROM players
WHERE UPPER(lastname) LIKE '%M%D%'
ORDER BY lastname;

-- ORDER OF EXECUTION

SELECT
	firstname + ' ' + lastname AS Fullname, -- note column alias
	firstname,
	lastname
FROM players p -- note: table alias
WHERE UPPER(p.lastname) LIKE 'M%'
ORDER BY p.lastname, p.firstname;
-- note this should work fine

-- but let us try using the column alias
SELECT
	firstname + ' ' + lastname AS Fullname, -- note column alias
	firstname,
	lastname
FROM players p -- note: table alias
WHERE UPPER(p.lastname) LIKE 'M%'
ORDER BY fullname; -- we can use column alias in ORDER BY

-- but
SELECT
	firstname + ' ' + lastname AS Fullname, -- note column alias
	firstname,
	lastname
FROM players p -- note: table alias
WHERE UPPER(fullname) LIKE 'M%'  -- this breaks it
ORDER BY fullname; -- we can use column alias in ORDER BY

-- because of ORDER OF EXECUTION
/*
1 - FROM (with JOINS)
2 - WHERE
3 - SELECT (runs as a loop)
4 - ORDER BY

-- so column aliases cannot be used in WHERE because they do not
-- exist until the SELECT clause is executed...

-- what if we need to use the calculated field in the WHERE?
*/
SELECT
	firstname + ' ' + lastname AS Fullname, -- note column alias
	firstname,
	lastname
FROM players p -- note: table alias
WHERE UPPER(firstname + ' ' + lastname) LIKE 'M%'  -- this breaks it
ORDER BY fullname;


-- DATES

-- the problem with dates is the HUMAN
SELECT * FROM players;

-- list all the people born on may 18, 1992
SELECT *
FROM players
WHERE dob = '08-10-78'; -- different date formats matter when hard coding

-- we must convert our input to date type manually
SELECT *
FROM players
WHERE dob = CONVERT(DATE,'08-10-78',1);

-- some date functions 
-- MONTH
-- DAY
-- YEAR
-- DATEDIFF
-- MINUTE
-- DATE
-- DATEVALUE

-- BETWEEN
-- -- list all games where the hometeam score between 3 and 5 goals
SELECT *
FROM games
WHERE homescore >= 3 AND homescore <= 5
ORDER BY gameNum;
-- another way is using BETWEEN AND
SELECT *
FROM games
WHERE homescore BETWEEN 3 AND 5
ORDER BY gameNum;


-- JOINS

-- INNER JOINS
-- let us list the name of the players and names of teams they play on
SELECT
	firstname,
	lastname,
	teamname
FROM 
	players p 
	INNER JOIN rosters r ON p.playerid = r.playerid
	INNER JOIN teams t ON r.teamid = t.teamid
ORDER BY
	teamname,
	firstname,
	lastname;

-- inner joins will include all records where matching records exist
-- in both tables

-- OUTER JOIN
-- left, right, and full OUT JOIN

-- same as above but show ALL players, even if they are NOT on a team...
SELECT
	firstname,
	lastname,
	teamname
FROM 
	players p 
	LEFT OUTER JOIN rosters r ON p.playerid = r.playerid
	LEFT OUTER JOIN teams t ON r.teamid = t.teamid
ORDER BY
	teamname,
	firstname,
	lastname;

-- LEFT OUTER JOIN is an INNER JOIN plus all records from the table on 
--                 the left of the JOIN statement regardless of matches

-- RIGHT OUTER JOIN is an INNER JOIN plus all records from the table on 
--                 the right of the JOIN statement regardless of matches

-- FULL OUTER JOIN is an INNER JOIN plus all records from both tables on 
--                 regardless of matches

-- example
-- show all teams even if they do not have any players
SELECT
	firstname,
	lastname,
	teamname
FROM 
	players p 
	INNER JOIN rosters r ON p.playerid = r.playerid
	RIGHT OUTER JOIN teams t ON r.teamid = t.teamid
ORDER BY
	teamname,
	firstname,
	lastname;


	SELECT * FROM teams;

SELECT 
	teamName,
	hometeam,
	visitteam
FROM teams t
	JOIN games gh ON t.teamid = gh.hometeam OR t.teamid = gh.visitteam
WHERE gamedatetime = '2024-03-05'


