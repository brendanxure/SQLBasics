-- ***************************************
-- INFT1105 - Advanced Practice Questions
-- Christopher Alexander
-- Winter 2024
-- ***************************************

USE sportleagues
GO
/* Question 1
Create a SELECT statement to return the full names "lastname, firstname", the 
shirt number and team name for all players who are both active as players and 
active on their respective teams (rosters.isactive).
•	Include all teams: even if they have players registered or not. 
•	Sort the results by team name and then by last name. 
•	Use Joins, not sub-selects. */

SELECT CONCAT(lastname, ', ', firstname) AS fullName,
		jerseynumber,
		teamname
FROM players p
INNER JOIN rosters r ON p.playerid = r.playerid
RIGHT OUTER JOIN teams t ON r.teamid = t.teamid
WHERE p.isactive = 1 AND r.Isactive = 1
ORDER BY teamname, lastname

    
/* Question 2
 We want to start a new award for the league; player of the week.  
We need a query that returns the top goal scorers for the past 
14 days including: the first name, last name, and total goals scored 
per player in the time period.  
•	Only include those who have scored more than 1 goal.  
•	Sort the output from most goals to least goals scored.  
•	Note: You may not get any results for this query if you run it today! */
SELECT p.firstname, p.lastname, SUM(numgoals) AS totalGoals
FROM goalScorers gs
INNER JOIN players p ON p.playerid = gs.playerid
INNER JOIN games g ON  gs.gameid = g.gameid
WHERE g.gamedatetime BETWEEN getdate() -14 AND getdate()
GROUP BY gs.playerid, p.firstname, p.lastname
HAVING SUM(numgoals) > 1
ORDER BY totalGoals DESC;

/* Question 3
We are starting a monthly newsletter and want to include a small section 
detailing the upcoming games.  Produce a query that lists all games to be 
played "next month" (dynamic).  (i.e. right now it should show November’s games,
but in November it will show December…etc.)  
•	Include the game number, game date, and the short team names for both the 
    home team and the visitor team, as well as the name of the game location.  
•	Sort the schedule by date showing the first games first.  
Note/Hint: how will this work in December for January???? */
DECLARE @NextMonth DATE = DATEADD(MONTH, 1, GETDATE())
SELECT Gamenum, 
	   gamedatetime, 
	   (SELECT teamname FROM teams ht WHERE ht.teamid = games.hometeam) AS hometeam,
	   (SELECT teamname FROM teams vt WHERE vt.teamid = games.visitteam) AS visitteam,
	   (SELECT locationname FROM locations l WHERE l.Locationid = games.locationid) AS locationname
FROM games
WHERE gamedatetime BETWEEN DATEFROMPARTS(YEAR(GETDATE()), MONTH(@NextMonth), 1) AND EOMONTH(@NextMonth)
ORDER BY gamedatetime



/* Question 4
Create a query that shows the FUTURE games for any single team where the 
teamID is entered as a parameter by the user at the time the query is run.  
•	show the game number and game date for each game
•	format the date similar to "Feb 21, 2019"
•	sort the results by game date */
DECLARE @teamID INT = 222;
SELECT Gamenum, FORMAT(gamedatetime, 'MMMM dd, yyyy') AS gamedate
FROM games
WHERE (gamedatetime > GETDATE()) AND (hometeam = @teamID OR visitteam = @teamID)
ORDER BY gamedatetime

/* Question 5
Show a list of teams in each division in the database.  
•	include the division’s name and the team’s name,
•	sort the output by the division’s display order and then by team name,
•	only show divisions that are active and teams that are active,
•	include all active divisions, even if they contain no teams. */
SELECT d.displayOrder, divname, teamname
FROM teams t
RIGHT OUTER JOIN teamsInDivs td ON t.teamid = td.teamid
INNER JOIN divs d ON td.divid = d.divid
WHERE (d.isActive = 1 AND t.isactive = 1) OR d.isActive = 1
ORDER BY displayOrder, teamname;

    
/* Question 6
) List all the jersey numbers user in the league along with the total number of players who use that number:
•	order the results showing the most used number first,
•	only show results for those numbers used more than once */
SELECT jerseynumber, COUNT(DISTINCT playerid) AS NumberOfPlayers
FROM rosters
GROUP BY jerseynumber
HAVING COUNT(DISTINCT playerid) > 1
ORDER BY NumberOfPlayers DESC;

/* Question 7
Create a SELECT statement that returns all active players on the Aurora team 
(team 212) whose first name starts with "d".  Also provide their shirt number 
and their registration number.
•	include the firstname and lastname of the players returned in a single column.
•	active players means players whom are currently actively on the team roster */
SELECT CONCAT(firstname, ' ', lastname) AS fullName, jerseynumber, regnumber
FROM players p
INNER JOIN rosters r ON p.playerid = r.playerid
WHERE r.isactive = 1 AND r.teamid = 212 AND LOWER(firstname) LIKE 'd%' 
ORDER BY regnumber, fullName, jerseynumber;

/* Question 8
Create a list of locationIDs that have NOT been used for 
any games in the games table.
•	you may NOT use a JOIN
•	you may NOT use a sub-query
•	sort the output numerically. */
SELECT Locationid
FROM locations
EXCEPT
SELECT DISTINCT locationid
FROM games
ORDER BY Locationid;


/* Question 9
Provide the first and last names of all players who play for a team whose name, 
or part name, is entered by the user (i.e. a parameter) sorted by last name, 
then by first name.
•	you may NOT use JOINS
•	you do not need PSQL for this
•	the team name may be only partially entered (i.e. only part of the name 
- example:  "OCK" could be entered for "Rockies") */
DECLARE @userInput VARCHAR(10) = '  Ban';
SELECT *
FROM (SELECT 
	(SELECT firstname FROM players p WHERE p.playerid = r.playerid) AS firstname,
	(SELECT lastname FROM players p WHERE p.playerid = r.playerid) AS lastname,
	(SELECT teamname FROM teams t WHERE r.teamid = t.teamid) AS teamname
FROM rosters r) newtable
WHERE UPPER(teamname) LIKE + '%' + UPPER(TRIM(@userInput)) + '%'
ORDER BY lastname, firstname



/* Question 10
List all players on teams 212, 218, and 223. Show playerID, teamID and player 
first and last names.
•	Sort the output by showing players from team 218 first, then players 
    from 212, then players from 223.
•	Within each team list, sort the players by last name, then first name */

SELECT playerid, teamid, firstname, lastname
FROM (SELECT r.playerid, teamid, p.lastname, p.firstname, 1 AS teamOrder
FROM rosters r
INNER JOIN players p ON r.playerid = p.playerid
WHERE r.teamid = 218
UNION
SELECT r.playerid, teamid, p.lastname, p.firstname, 2 AS teamOrder
FROM rosters r
INNER JOIN players p ON r.playerid = p.playerid
WHERE r.teamid = 212
UNION
SELECT r.playerid, teamid, p.lastname, p.firstname, 3 AS teamOrder
FROM rosters r
INNER JOIN players p ON r.playerid = p.playerid
WHERE r.teamid = 223) AS newTable
ORDER BY teamOrder, lastname, firstname
