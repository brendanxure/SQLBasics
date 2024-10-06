/*  Brendan Obilo
	100952871
	March 21st, 2024
	INFT  1105 In class Activity 7
*/

/* Q1
Write SQL DECLARE and SELECT statements that define an interger, accept a player ID, 
and then lists all the goals that player has scored, including the gameNum and date.
HINT: You only need goalscorers and games tables
*/
DECLARE @playerIdentity INT;
SET @playerIdentity = 2143578

SELECT 
	playerid,
	numgoals,
	Gamenum,
	gamedatetime
FROM goalScorers gs
INNER JOIN games g ON gs.gameid = g.gameid
WHERE playerid = @playerIdentity
ORDER BY gamedatetime;



/* Q2
Write a SELECT statement to show how many times each shirt number (jersery number)
has been assigned to a player.
-Note that if the same player where the same number on a 2 different teams, it should only count once!
*/
SELECT
	jerseynumber,
	COUNT(DISTINCT playerid) AS timesAssigned
FROM rosters
GROUP BY jerseynumber
ORDER BY jerseynumber;


/* Q3
Write the SQL statements to:
1) add your self as a player to the database with your reg number being studentID
2) add a team to the database called INFT1105
3) Add yourself to that team!
*/

INSERT into players (playerid, regnumber, lastname, firstname, isactive, dob)
	VALUES(71195, '100952871', 'Obilo', 'Brendan', 1, '1999-07-11')

INSERT into teams (teamid, teamname, isactive, jerseycolour)
	VALUES(420, 'INFT1105', 1, 'Grey')

INSERT into rosters (playerid, teamid, Isactive, jerseynumber)
	VALUES (71195, 420, 1, 11)