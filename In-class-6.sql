/*  Brendan Obilo
	100952871
	March 13th, 2024
	INFT  1105 In class Activity 6
*/

/*
1. Create a query which lists ALL locations and how many games are scheduled as each location
*/

SELECT
	locationname,
	COUNT(gameid) AS numberOfGames
FROM games g
RIGHT OUTER JOIN locations l ON g.locationid = l.Locationid
GROUP BY locationname
ORDER BY locationname, numberOfGames;



/*
2. How many games has each team played? Only include teams whom have played more than 5 games
*/
SELECT 
	teamname,
	COUNT(gameid) AS numbeerOfGame
FROM teams t
INNER JOIN games g ON t.teamid = g.hometeam OR t.teamid = g.visitteam
WHERE Isplayed = 1
GROUP BY teamname
HAVING COUNT(gameid) > 5
ORDER BY teamname;

--OR

SELECT COUNT(Gamenum) AS NumberOfGames, teamname 
FROM games
INNER JOIN teams ON teams.teamid = games.hometeam
WHERE Isplayed = 1
GROUP BY teamname

SELECT COUNT(Gamenum) AS NumberOfGames, teamname 
FROM games
INNER JOIN teams ON teams.teamid = games.visitteam
WHERE Isplayed = 1
GROUP BY teamname

SELECT * FROM games