-----------------------
-- INFT 1105 Week 13
-- Christopher Alexander
--------------------------

--Update procedure
GO
CREATE OR ALTER PROCEDURE spUpdatePlayer
	@playerID INT,
	@regNumber VARCHAR(15),
	@lastName VARCHAR(25),
	@firstName VARCHAR(25),
	@isActive BIT
	AS
BEGIN
	--DECLARE @ResponseMessage VARCHAR(255);
	BEGIN TRY
	UPDATE players
		SET regNumber = @regNumber,
			lastName = @lastName,
			firstName = @firstName,
			isActive = @isActive
	WHERE playerID = @playerID;

	IF @@ROWCOUNT > 0 
		--SET @ResponseMessage = 'Successfully updated Player';
		PRINT 'Successfully updated Player'
	ELSE
		--SET @ResponseMessage = 'No matching player found. No changes made.';
		PRINT 'No matching player found. No changes made.';
	END TRY
	BEGIN CATCH
		--SET @ResponseMessage = 'ERROR OCCURRED!!!!' + ERROR_MESSAGE() + ERROR_NUMBER();
		PRINT 'ERROR OCCURRED!!!!' + ERROR_MESSAGE() + ERROR_NUMBER();
	END CATCH
	--SELECT @ResponseMessage AS ResponseMessage;
END;
GO

SELECT * FROM players WHERE playerID = 1332;

EXEC spUpdatePlayer 1332, 8888, 'Alexandersdfgsdfhcxfgjcgjcjgdfgjcgjcghfj', 'Christopher', 1;

--LOOPING

--Declare a variable to hold the current number
DECLARE @Counter INT = 1;

--Start the loop
WHILE @Counter <=10
BEGIN
	--Print the current value of the counter
	PRINT @Counter;

	--Increment the counter
	SET @Counter = @Counter +1;
END