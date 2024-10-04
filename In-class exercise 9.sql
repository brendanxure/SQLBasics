-- --------------------------
-- INFT1105-02 - In-class 9
-- April 3, 2024
-- Brendan Obilo
-- --------------------------

/*Using Sportleague database! */
USE Sportleagues;
GO

--Q1) Create a function that receives an input parameter of a teamID. The function then returns
--the gameID of the next game to be played by that team.
GO
CREATE OR ALTER FUNCTION fncNextTeamGame
	( @teamID  INT )
	RETURNS INT
	AS
	BEGIN
		DECLARE @gameID INT
		SELECT @gameID = (SELECT TOP 1 gameid
						FROM games
						WHERE gamedatetime > GETDATE() AND (hometeam = @teamID OR visitteam = @teamID))
		RETURN @gameID
	END
GO

DECLARE @teamID INT = 222
SELECT dbo.fncNextTeamGame(@teamID) AS nextGame


--Q2) Using the above function, create an SQL SELECT statement that outputs the game details
-- Including gameNum, date, location name, and the name of both teams!
GO
DECLARE @teamID INT = 222
SELECT gameid,
		Gamenum,
	   gamedatetime, 
	   (SELECT locationname FROM locations l WHERE l.Locationid = g.locationid) AS locationName, 
	   (SELECT teamname FROM teams ht WHERE ht.teamid = g.hometeam) AS homeTeam, 
	   (SELECT teamname FROM teams vt WHERE vt.teamid = g.visitteam) AS visitteam
FROM games g
WHERE g.gameid = (SELECT dbo.fncNextTeamGame(@teamID) AS nextGame)
GO

--Q3) Create a Stored Procedure that receives a teamID, and outputs the team's next game's details as provided in the previous question.
-- You should use the function created above in the SP to determine the gameID.
GO
CREATE OR ALTER PROCEDURE spTeamNextGame 
	@teamID INT
AS
BEGIN
	SELECT gameid,
			Gamenum,
		   gamedatetime, 
		   (SELECT locationname FROM locations l WHERE l.Locationid = g.locationid) AS locationName, 
		   (SELECT teamname FROM teams ht WHERE ht.teamid = g.hometeam) AS homeTeam, 
		   (SELECT teamname FROM teams vt WHERE vt.teamid = g.visitteam) AS visitteam
	FROM games g
	WHERE g.gameid = (SELECT dbo.fncNextTeamGame(@teamID) AS nextGame)
END
GO

DECLARE @teamID INT = 222
EXEC dbo.spTeamNextGame @teamID;
GO