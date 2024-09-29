/*  Brendan Obilo
	100952871
	March 22nd, 2024
	INFT  1105 Assigment
*/

/*
1.	Create an SQL statement that adds yourself to the Players table.
Use your real first and last names, your real dob, and use your studentID as the regNumber.
Make yourself active and use a playerID of your own choice.
*/

INSERT INTO players (playerid, regnumber, lastname, firstname, isactive, dob)
	VALUES (71195, '100952871', 'Obilo', 'Brendan', 1, '1999-07-11');


/*
2. Create an SQL statement that change your professor’s (whom is a player in the database) 
dob to be May 16, 1992. ( I would love to be 20 years younger 😊 )
*/
UPDATE players
SET dob = CONVERT(DATE,'1992-05-16', 1)
WHERE playerid = 1332;

/*
3.	Create a statement that adds both yourself and your professor to the 
team called “Noobs” making yourself active and your professor not active.
Choose a jersey number for yourself and use number 16 for your prof.
*/
INSERT INTO rosters (playerid, teamid, Isactive, jerseynumber)
	VALUES (71195, 400, 1, 11),
			(1332, 400, 0, 16);

/*
4.	Create a query that outputs the team roster for all active teams in the league.
Include the player names, jersey number, and team name in each row,
making sure that players on the same team are together in the output,
further sorted by last name, then by first name.
*/

SELECT
	p.firstname + ' ' + p.lastname AS playerName,
	r.jerseynumber,
	teamname
FROM teams t
LEFT OUTER JOIN rosters r ON t.teamid = r.teamid
LEFT OUTER JOIN players p ON r.playerid = p.playerid
WHERE t.isactive = 1
ORDER BY teamname, p.lastname, p.firstname; 
/*
5.	Create a query that outputs the league schedule (game number, date, both team names, and location name)
for all future games, or games not yet played.  Sort the output in ascending chronological order. 
Use JOIN and not sub-queries.
*/
SELECT 
	Gamenum,
	gamedatetime,
	ht.teamname AS hometeam,
	vt.teamname AS visitteam,
	locationname
FROM games g
INNER JOIN teams ht ON g.hometeam = ht.teamid
INNER JOIN teams vt ON g.visitteam = vt.teamid
INNER JOIN locations l ON g.locationid = l.Locationid
WHERE gamedatetime > GETDATE() OR Isplayed = 0
ORDER BY gamedatetime;


/*
6.	Repeat Question 5, but use sub-queries to obtain the team names,
rather than JOINS.  You may still use JOINS for other output if required.  
Note: you should obtain the exact same output in Q5 and Q6
*/
SELECT 
	Gamenum,
	gamedatetime,
	(SELECT teamname FROM teams WHERE teamid = hometeam) AS homeTeam,
	(SELECT teamname FROM teams WHERE teamid = visitteam) AS visitTeam,
	locationname
FROM games g
INNER JOIN locations l ON g.locationid = l.Locationid
WHERE gamedatetime > GETDATE() OR Isplayed = 0
ORDER BY gamedatetime;

/*
7.	Take the statement from either Q5 or Q6 and store it in the database as a view,
called vwFutureGames.  Then create a query that uses the view to output the exact same results,
including sorting
*/
CREATE OR ALTER VIEW vwFutureGames AS (
SELECT 
	Gamenum,
	gamedatetime,
	ht.teamname AS hometeam,
	vt.teamname AS visitteam,
	locationname,
	Isplayed
FROM games g
	INNER JOIN teams ht ON g.hometeam = ht.teamid
	INNER JOIN teams vt ON g.visitteam = vt.teamid
	INNER JOIN locations l ON g.locationid = l.Locationid
WHERE gamedatetime > GETDATE() OR Isplayed = 0
);

SELECT 
	Gamenum,
	gamedatetime,
	hometeam,
	visitteam,
	locationname
FROM vwFutureGames 
ORDER BY gamedatetime

/*
8.	Create a query that outputs the locations id of the soccer fields (locations)
in the database that have never been assigned a game within the league.  
You may NOT use JOINS or Sub-Queries in the main statement, 
but you may use a sub-query to obtain the names afterwards.
*/
SELECT Locationid FROM locations
EXCEPT
SELECT DISTINCT(locationid) from games
ORDER BY Locationid

/*
9.	Repeat Question 8 using JOINS and NOT set operators.
*/

SELECT l.Locationid
FROM locations l
	LEFT OUTER JOIN games g ON l.Locationid = g.locationid
WHERE g.locationid = NULL
ORDER BY l.Locationid;


/*
10.	Create a query that outputs the number of games each team has played as the home team and 
how many games they have played as the away team as of today.  You may assume that the isPlayed field is up to date.  
A sample of the output might look like this:
TEAMID		TEAMNAME	HOMEGAMES	AWAYGAMES
1			kickers			5			6
2           wannabees       4           6

*/

SELECT 
	teamid AS TEAMID,
	teamname AS TEAMNAME,
	(SELECT COUNT(hometeam) FROM games WHERE Isplayed = 1 AND hometeam = teamid) AS HOMEGAMES,
	(SELECT COUNT(visitteam) FROM games WHERE Isplayed = 1 AND visitteam = teamid) AS AWAYGAMES
FROM teams
GROUP BY teamid, teamname
ORDER BY teamid, teamname;

