/*  Brendan Obilo
	100952871
	March 7th, 2024
	INFT  1105 In class Activity 5
*/
USE sportleagues
GO

/* Question 1
Create a query that output the names of the divisions and the teams (team name) that are in those divisions.
*/

SELECT
	d.divname,
	t.teamname
FROM teams t
INNER JOIN teamsInDivs td ON t.teamid = td.teamid 
INNER JOIN divs d ON td.divid = d.divid
ORDER BY d.divname;

/* Question 2
Repeat Q1 but this time make sure that ALL divisions are shown, even if no teams are assigned to the division */
SELECT
	d.divname,
	t.teamname
FROM teams t
INNER JOIN teamsInDivs td ON t.teamid = td.teamid 
RIGHT OUTER JOIN divs d ON td.divid = d.divid
ORDER BY d.divname;



/* Question 3
Output all the games that are going to be played next month (December now,
but next month it will show January). Include the gameid, gamenum,
gamedate, both team names, and the name of the location where it will be
played. Sort the data by the game date. */ 
DECLARE @NextMonth DATE;
SET @NextMonth = DATEADD(MONTH, 1, GETDATE());

SELECT
	gameid,
	Gamenum,
	gamedatetime,
	t.teamname AS hometeam,
	ts.teamname AS visitteam,
	locationname
FROM games g
INNER JOIN teams t ON g.hometeam = t.teamid
INNER JOIN teams ts ON g.visitteam = ts.teamid
INNER JOIN locations l ON g.locationid = l.Locationid
WHERE gamedatetime BETWEEN DATEFROMPARTS(YEAR(GETDATE()), MONTH(@NextMonth), 1) AND EOMONTH(@NextMonth)
ORDER BY gamedatetime;
