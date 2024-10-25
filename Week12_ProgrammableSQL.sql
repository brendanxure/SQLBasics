-- --------------------------
-- INFT1105-02 - Week 12
-- April 1, 2024
-- Christopher Alexander
-- Intro to Programmable SQL
-- --------------------------

USE Sportleagues;
GO

DECLARE @return_value int;
DECLARE @myName VARCHAR(25) = 'Robert';

SELECT * FROM players
WHERE firstname = @myName;

-- Functions
GO
CREATE OR ALTER FUNCTION fncReturnhigherNumber
	( @num1 INT, @num2 INT )
	RETURNS INT
	AS
	BEGIN
		
		RETURN 
			CASE 
				WHEN @num1 > @num2
					THEN @num1
				ELSE
					@num2
			END;
	END;
GO

SELECT dbo.fncReturnhigherNumber(10,20) AS higherNumber;

-- function to return the winning team

GO
CREATE OR ALTER FUNCTION fncDetermineWinningTeam(@gameID INT) RETURNS INT
AS
BEGIN
	DECLARE @hteamID INT, @vteamID INT, @homescore INT, @visitscore INT
	DECLARE @isPlayed BIT;
	DECLARE @retVal INT = 0;

	SELECT @isPlayed = ( SELECT isPlayed FROM games WHERE gameid = @gameid);
	SELECT @hteamID = ( SELECT hometeam FROM games WHERE gameid = @gameID);
	SELECT @vteamID = ( SELECT visitteam FROM games WHERE gameid = @gameID);
	SELECT @homescore = ( SELECT homescore FROM games WHERE gameid = @gameID);
	SELECT @visitscore = ( SELECT visitscore FROM games WHERE gameid = @gameID);

	RETURN
		CASE
			WHEN @isPlayed = 0 THEN
				-1
			WHEN @homescore > @visitscore THEN 
				@hteamID
			WHEN @homescore < @visitscore THEN 
				@vteamID
			ELSE
				0
		END;
END;


-- Stored Procedures
GO
CREATE PROCEDURE spShowTeamRoster 
	@teamID INT
AS
BEGIN
	SELECT firstname, lastname, jerseynumber
	FROM players p JOIN rosters r ON p.playerid = r.playerid
	WHERE r.teamid = @teamID;
END
GO

DECLARE @localTeamID INT = 222;
EXEC dbo.spShowTeamRoster @localTeamID;
GO


-- update procedure
GO
CREATE OR ALTER PROCEDURE spUpdatePlayer
	@playerID INT,
	@regNumber VARCHAR(15),
	@lastname VARCHAR(25),
	@firstname VARCHAR(25),
	@isActive BIT
	AS
BEGIN
	UPDATE players
		SET regNumber = @regNumber,
			lastname = @lastname,
			firstname = @firstname,
			isActive = @isActive
	WHERE playerID = @playerID;
END;
GO

SELECT * FROM players WHERE playerid = 1332;

EXEC spUpdatePlayer 1332, 71782, 'Alexander', 'Christopher', 1;


