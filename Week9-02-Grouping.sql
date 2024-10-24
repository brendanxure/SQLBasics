-- *******************************
-- INFT1105-02 Intro to Databases
-- Week 9 - The CUD of CRUD
-- March 2024
-- Christopher Alexander
-- *******************************


-- Other CRUD statements
-- INSERT, UPDATE, and DELETE

-- Inserting a new team
-- first off let us see what is in teams
SELECT * FROM teams;
-- not an autonumber
INSERT INTO teams (teamID, teamName, jerseyColour)
	VALUES (255, 'Hlibs team', 'Green');
-- shortcut version
INSERT INTO teams VALUES (100, 'Clintsteam', 1, 'Red');
-- insert multiple rows at a time
INSERT INTO teams VALUES 
	(101, 'team101', 1, 'Red'),
	(102, 'team102', 1, 'Blue'),
	(103, 'team103', 1, 'Purple');

-- let us add players to team 255
-- rosters table PK is an Autonumber field (identity)
INSERT INTO rosters (playerID, teamID, jerseynumber)
	VALUES (1310, 255, 1),
		(1314, 255, 2),
		(61820, 255, 10);
-- shortcut method with autonumber PK
INSERT INTO rosters VALUES (374022, 255, 1, 11); -- ignore identity field

SELECT *
FROM players
ORDER BY playerid DESC;

-- update data
UPDATE players 
SET firstname = 'Chris', lastname = 'Alexander'
WHERE playerID = 1332;

UPDATE teams SET teamname = 'BobsTeam', jerseycolour = 'Yellow'
WHERE teamID = 255;

SELECT * 
FROM teams
WHERE teamid = 255;

-- DELETE 
DELETE FROM teams;

DELETE FROM teams
WHERE teamID IN (100,101,102);

DELETE FROM teams
WHERE teamID = 103;

-- players on 255 moving to a new team
UPDATE rosters
SET teamID = 400
WHERE teamID = 255;

DELETE FROM teams
WHERE teamID = 255;

SELECT * FROM rosters WHERE teamID = 400;

DELETE FROM rosters
WHERE teamID = 400;

-- *******************************
-- INFT1105-02 Intro to Databases
-- Week 9 - Grouping and Aggregate Functions
-- March 2024
-- Christopher Alexander
-- *******************************

-- Starting with basic functions and calculated fields
-- Example:  Create a query that uses several different types of calculated fields
SELECT
	MONTH(dob) AS BirthMonth,   -- calc
	firstname + ' ' + lastname AS fullname,   -- calc
	firstname,   -- not calc
	getdate() + 1 AS SameTimeTommorow
FROM players;

-- How many players in the database??
SELECT * FROM players;

SELECT COUNT(playerid)  AS numPlayers 
FROM players;

-- There are 7 aggregate functions
-- COUNT
-- SUM
-- AVG
-- MAX
-- MIN
-- STDDEV
-- VARIANCE

-- How many players are on each team?
SELECT
	teamid,
	COUNT(playerID)
FROM rosters
GROUP BY teamid;
-- NOTE COUNT ignores null values...  
-- there is one team with no players which returns null
SELECT
	teamid,
	COUNT(ISNULL(playerID,0))
FROM rosters
GROUP BY teamid;

SELECT
	t.teamid,
	ISNULL(COUNT(playerID),0)
FROM rosters r RIGHT JOIN teams t ON r.teamid = t.teamid
GROUP BY t.teamid;

SELECT
	t.teamid,
	COUNT(ISNULL(playerID,0))
FROM rosters r RIGHT JOIN teams t ON r.teamid = t.teamid
GROUP BY t.teamid;

-- How many goals has each player scores, sort by most to least
SELECT 
	playerid,
	SUM(numGoals) AS totGoals
FROM goalscorers
GROUP BY playerID
ORDER BY totGoals DESC;
-- let us get the name
SELECT 
	p.playerid,
	firstname + ' ' + lastname AS fullname,
	SUM(numGoals) AS totGoals
FROM goalscorers gs JOIN players p ON gs.playerid = p.playerid
GROUP BY p.playerID, firstname, lastname
ORDER BY totGoals DESC;

-- Chris' Law
-- Any field this is included in the SELECT clause that is NOT part of an aggregate
-- function MUST be in the GROUP BY
SELECT 
	p.playerid,
	firstname + ' ' + lastname AS fullname,
	SUM(numGoals) AS totGoals
FROM goalscorers gs JOIN players p ON gs.playerid = p.playerid
GROUP BY p.playerID, firstname, lastname
ORDER BY totGoals DESC;

-- Output the goal scoring leaders FOR EACH team.
-- include the player and team names
SELECT 
	firstname,
	lastname,
	teamname,
	SUM(numGoals) AS totGoals
FROM goalscorers gs 
	JOIN players p ON gs.playerid = p.playerID
	JOIN teams t ON gs.teamid = t.teamid
GROUP BY p.playerid, t.teamid, firstname, lastname, teamname
ORDER BY teamname, totGoals DESC;

SELECT 
	firstname,
	lastname,
	teamname,
	SUM(numGoals) AS totGoals
FROM (players p
LEFT OUTER JOIN goalScorers gs ON p.playerid = gs.playerid)
JOIN teams t ON gs.teamid = t.teamid
GROUP BY p.playerid, t.teamid, firstname, lastname, teamname
ORDER BY teamname, totGoals DESC;

SELECT 
	playerid,
	SUM(numgoals) AS totGoals
FROM goalScorers
GROUP BY playerid

-- How many people were born each month of the year
SELECT 
	MONTH(dob) AS dobMonth,
	DATENAME(Month, dob) AS dobMonthName,
	COUNT(playerID) AS numPlayers
FROM players
GROUP BY MONTH(dob), DATENAME(Month, dob) 
ORDER BY dobMonth;

-- List how many people were born in each year, 
-- sorting the data from oldest person to yongest
SELECT
	YEAR(dob) AS yr,
    COUNT(playerid) AS numPlayers
FROM players
GROUP BY YEAR(dob)
ORDER BY yr;

-- coding ORDER
-- SELECT
-- FROM
-- WHERE
-- GROUP BY
-- HAVING
-- ORDER BY

-- ORDER OF EXECUTION
-- FROM
-- WHERE
-- GROUP BY
-- HAVING
-- SELECT
-- ORDER BY

-- -----------------------
-- HAVING
-- List how many people were born in each year, 
-- sorting the data from oldest person to yongest
-- Only include years 1970 to 2000

SELECT
	YEAR(dob) AS yr,
    COUNT(playerid) AS numPlayers
FROM players
WHERE YEAR(dob) BETWEEN 1970 AND 2000
GROUP BY YEAR(dob)
ORDER BY yr;

-- List how many people were born in each year, 
-- sorting the data from oldest person to yongest
-- Only include years 1970 to 2000
-- Also, only include years where 20 or more players were born
SELECT
	YEAR(dob) AS yr,
    COUNT(playerid) AS numPlayers
FROM players
WHERE YEAR(dob) BETWEEN 1970 AND 2000
GROUP BY YEAR(dob)
HAVING COUNT(playerid) >= 20 
ORDER BY yr;








