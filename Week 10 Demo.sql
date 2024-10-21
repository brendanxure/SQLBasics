-- -----------------------------
-- INFT1105 - Week 10
-- March 18, 2024
-- Christopher Alexander
-- Sub-Queries 
-- -----------------------------

-- There are 3 types of SELECT statement results
-- They are:
-- 1) TABULAR - Consists of rows and columns, much like a spreadsheet or the original table from which the data is queried.
-- 2) LIST - typically refers to querying for a single column from a set of records
-- 3) SCALAR - is a single value. This kind of result is obtained when you query for a specific value or when using aggregate functions without a GROUP BY clause.

SELECT gameid, gamenum
FROM games
WHERE gameid > 10;
-- table

SELECT gamenum
FROM games
WHERE gamedatetime = '2024-04-05';
-- list

SELECT playerID
FROM players
WHERE UPPER(firstname) = 'CHRISTOPHER';
-- list

SELECT firstname
FROM players
WHERE playerid = 1332;
-- scalar

SELECT COUNT(gameID)
FROM games
WHERE gamedatetime > getdate();
-- scalar


-- example
-- who scored the most goals in a single game thus far 
SELECT MAX(numGoals)
FROM goalscorers;

SELECT playerID
FROM goalscorers
WHERE numGoals = 5;

SELECT firstname, lastname
FROM players
WHERE playerid IN (2025114, 2190470);

-- by using sub-queries in the WHERE clause....
SELECT playerID
FROM goalscorers
WHERE numGoals = (
	SELECT MAX(numGoals)
	FROM goalscorers
	);

-- ... more sub-queries
SELECT firstname, lastname
FROM players
WHERE playerid IN (
	SELECT playerID
	FROM goalscorers
	WHERE numGoals = (
		SELECT MAX(numGoals)
		FROM goalscorers
	)
);

-- Another Example
-- output the schedule including both team names and the location name
-- JOIN way
SELECT
	h.teamname AS HomeTeam,
	v.teamname AS VisitTeam,
	gamenum,
	gamedatetime,
	locationname
FROM games g 
	JOIN teams h ON h.teamid = g.hometeam
	JOIN teams v ON v.teamid = g.visitteam
	JOIN locations l ON g.locationid = l.locationid
ORDER BY gamedatetime;
-- Sub-Query way - using sub-queries in the SELECT Clause
SELECT
	(SELECT teamname FROM teams WHERE teamID = hometeam) AS HomeTeam,
	(SELECT teamname FROM teams WHERE teamID = visitteam) AS VisitTeam,
	gamenum,
	gamedatetime,
	(SELECT locationname FROM locations WHERE locationID = games.locationid) AS locationname
FROM games
ORDER BY gamedatetime;

-- Output only the games in the future
SELECT
	h.teamname AS HomeTeam,
	v.teamname AS VisitTeam,
	gamenum,
	gamedatetime,
	locationname
FROM games g 
	JOIN teams h ON h.teamid = g.hometeam
	JOIN teams v ON v.teamid = g.visitteam
	JOIN locations l ON g.locationid = l.locationid
WHERE gamedatetime > getdate()
ORDER BY gamedatetime;

SELECT
	h.teamname AS HomeTeam,
	v.teamname AS VisitTeam,
	gamenum,
	gamedatetime,
	locationname
FROM games g 
	JOIN teams h ON h.teamid = g.hometeam
	JOIN teams v ON v.teamid = g.visitteam
	JOIN locations l ON g.locationid = l.locationid
WHERE gamedatetime BETWEEN getdate() AND getdate() + 7
ORDER BY gamedatetime;

-- this is very repetitive
SELECT * 
FROM (
	SELECT
		h.teamname AS HomeTeam,
		v.teamname AS VisitTeam,
		gamenum,
		gamedatetime,
		locationname
	FROM games g 
		JOIN teams h ON h.teamid = g.hometeam
		JOIN teams v ON v.teamid = g.visitteam
		JOIN locations l ON g.locationid = l.locationid
	) AS t
WHERE gamedatetime > getdate()
ORDER BY t.gamedatetime;

-- --------------------
-- VIEWS
-- --------------------
CREATE OR ALTER VIEW vwSchedule AS (
SELECT
		h.teamname AS HomeTeam,
		v.teamname AS VisitTeam,
		gamenum,
		gamedatetime,
		locationname
	FROM games g 
		JOIN teams h ON h.teamid = g.hometeam
		JOIN teams v ON v.teamid = g.visitteam
		JOIN locations l ON g.locationid = l.locationid)
;

SELECT * FROM vwSchedule
WHERE gamedatetime > getdate()
ORDER BY gamedatetime;

SELECT * FROM vwSchedule
WHERE gamedatetime BETWEEN getdate() AND getdate() + 7
ORDER BY gamedatetime;

-----------------------------------------------READ------------------------------------------
SELECT 
	ht.teamname AS TEAMNAME,
	COUNT(hometeam) AS HOMEGAMES
FROM games g
	INNER JOIN teams ht ON g.hometeam = ht.teamid
WHERE Isplayed = 1
GROUP BY ht.teamname

SELECT 
	vt.teamname AS TEAMNAME,
	COUNT(visitteam) AS AWAYGAMES
FROM games g
	RIGHT OUTER JOIN teams vt ON g.visitteam = vt.teamid
WHERE Isplayed = 1
GROUP BY vt.teamname

SELECT 
	t.teamid AS TEAMID,
	t.teamname AS TEAMNAME,
	COALESCE(h.HOMEGAMES, 0) AS HOMEGAMES,
    COALESCE(a.AWAYGAMES, 0) AS AWAYGAMES
FROM teams t
	LEFT OUTER JOIN (
	SELECT 
		ht.teamid AS TEAMID,
		COUNT(hometeam) AS HOMEGAMES
	FROM games g
		INNER JOIN teams ht ON g.hometeam = ht.teamid
	WHERE Isplayed = 1
	GROUP BY ht.teamid) h ON t.teamid = h.TEAMID
	LEFT OUTER JOIN (
	SELECT 
		vt.teamid AS TEAMID,
		COUNT(visitteam) AS AWAYGAMES
	FROM games g
		INNER JOIN teams vt ON g.visitteam = vt.teamid
	WHERE Isplayed = 1
	GROUP BY vt.teamid) a ON t.teamid = a.TEAMID