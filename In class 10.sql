-- **************************
-- INFT1105- In class 10

-- Student Name: Brendan Obilo
-- Student ID: 100952871
-- Date: 10/04/2024
-- **************************
USE sportleagues
GO

--Q1
--Write a SELECT statement to find all players whose first name starts with an S and ends with an E
--Show the name of the team they play for, if they are on a team!
--Apply an appropriate sorting!
SELECT p.playerid, p.firstname, p.lastname, t.teamname
FROM players p
LEFT OUTER JOIN rosters r ON p.playerid = r.playerid
LEFT OUTER JOIN teams t ON r.teamid = t.teamid
WHERE UPPER(p.firstname) LIKE 'S%E'
ORDER BY p.playerid, p.firstname, p.lastname, teamname;

--Q2
--A player named Steve Munn has decided that he would like to use his
--original name of Stephen and wishes to change his name in the database!
--Write the SQL statement to make this change!
UPDATE players 
SET firstname = 'Stephen'
WHERE playerid = 1362;

--Q3
--Write the SQL statement to display the current league scoring leaders (first and last names)
--by adding up all the goals they have scored.
--Only show the first 20 records
--Only show records if the players have scored more than 2 goals
--sort the data from most goals to least
SELECT TOP 20 p.firstname, p.lastname, SUM(numgoals) AS numOfGoals
FROM goalScorers g
INNER JOIN players p ON g.playerid = p.playerid
GROUP BY g.playerid, p.firstname, p.lastname
HAVING SUM(numgoals) > 2
ORDER BY numOfGoals DESC;
