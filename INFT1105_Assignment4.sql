-- **************************
-- INFT1105 - Assignment 4
-- revised Winter 2024

-- Student Name: Brendan Obilo
-- Student ID: 100952871
-- Date: 10/04/2024
-- **************************

/*
Please complete the following question in the spaces provided.  Your professor will run your entire script at once while testing/marking it.  Make sure your code is executable and that all comments aree commented appropriately.
*/

USE employeeSample;
GO
-----------------------------------------------------------------
-- Question 1
-- Using sub-queries, display the full name of the lowest paid employee(s).  Use only Salary!

SELECT 
	CONCAT(firstName, ' ', lastName) AS fullName
FROM employees
WHERE salary IN (SELECT MIN(salary) FROM employees)
ORDER BY firstName, lastName;


-----------------------------------------------------------------
-- Question 2
-- Display the city that the lowest salary employee(s) are located in.

-- hint 1: you can use both JOINs and sub-queries or just sub-queries
-- hint 2: make sure Kimberely Grant is considered!

SELECT l.city
FROM employees e
LEFT OUTER JOIN departments d ON e.departmentID = d.departmentID
LEFT OUTER JOIN locations l ON d.locationID = l.locationID
WHERE salary IN (SELECT MIN(salary) FROM employees)


-----------------------------------------------------------------
-- Question 3
-- Display the last name of the lowest paid employee(s) in each department
-- hint: you can use both JOINs and sub-queries or just sub-queries
SELECT lastName, departmentID
FROM employees e1
WHERE salary IN (SELECT MIN(salary) FROM employees e2 WHERE e1.departmentID = e2.departmentID
GROUP BY departmentID)
ORDER BY departmentID;


-----------------------------------------------------------------
-- Question 4
-- Display last name and salary for all employees who earn less than the 
-- lowest salary in ANY department.  
-- Sort the output by top salaries first and then by last name.
-- DO NOT use JOIN
-- hint: there is an ANY() function that is similar to IN()

SELECT lastName, salary
FROM employees
WHERE salary < ANY (SELECT MIN(salary) FROM employees
GROUP BY departmentID)
ORDER BY salary DESC, lastName;	

-- -------------------------------------
-- Question 5
-- The HR department needs a list of Department IDs for departments that do not 
-- contain the job ID of ST_CLERK.  Use a set operator to create this report.
-- DO NOT use JOIN

SELECT departmentID FROM departments
EXCEPT
SELECT departmentID FROM employees
WHERE jobTitle = 'ST_CLERK'
ORDER BY departmentID;

-- -------------------------------------
-- Question 5
-- Repeat Question 5, but also show the department name. Sort the output by department name. 
-- DO NOT use JOINs
-- Hint: a sub-query will work nicely...

SELECT departmentID, departmentName FROM departments
EXCEPT
SELECT departmentID, (SELECT departmentName FROM departments WHERE departments.departmentID = employees.departmentID) AS departmentName FROM employees
WHERE jobTitle = 'ST_CLERK'
ORDER BY departmentName


-- -------------------------------------
-- Question 6
-- The Vice President needs a list of job titles in departments 10, 50, 20 in that order. 
-- (i.e. all title from 10 first, then titles from 50, then titles from 20)
-- job title and department ID are to be displayed.

SELECT jobTitle, departmentID
FROM(
SELECT DISTINCT jobTitle, departmentID, 1 AS deptOrder FROM employees
WHERE departmentID = 10
UNION 
SELECT DISTINCT jobTitle, departmentID, 2 AS deptOrder FROM employees
WHERE departmentID = 50
UNION
SELECT DISTINCT jobTitle, departmentID, 3 AS deptOrder FROM employees
WHERE departmentID = 20
) newtable
ORDER BY deptOrder;


-- -------------------------------------
-- Question 7
-- The Vice President needs a list of Employees in departments 10, 50, 20 in that order. 
-- (i.e. all employees from 10 first, then employees from 50, then employees from 20)
-- within each department, employees are to be further sorted by lastname and firstname.
-- display the employees first name, last name, job title, departmentid, and department name.

-- clarification - data is first sorted by the departmentID in the order given, 
-- and then by lastname, and then by firstname.


-- solution 1 using a fake column sorter
SELECT firstName, lastName, jobTitle, departmentID, departmentName
FROM (
SELECT firstName,
	   lastName, 
	   jobTitle, 
	   departmentID, 
	   (SELECT departmentName FROM departments d WHERE d.departmentID = employees.departmentID) AS departmentName,
	   1 AS deptOrder
FROM employees
WHERE departmentID = 10
UNION
SELECT firstName,
	   lastName, 
	   jobTitle, 
	   departmentID, 
	   (SELECT departmentName FROM departments d WHERE d.departmentID = employees.departmentID) AS departmentName,
	   2 AS deptOrder
FROM employees
WHERE departmentID = 50
UNION
SELECT firstName,
	   lastName, 
	   jobTitle, 
	   departmentID, 
	   (SELECT departmentName FROM departments d WHERE d.departmentID = employees.departmentID) AS departmentName,
	   3 AS deptOrder
FROM employees
WHERE departmentID = 20
) newTable
ORDER BY deptOrder, lastName, firstName


-- ----------------------------------------
-- Question 8
-- Write a non-saved procedure that declares an integer number and prints
-- "The number is even" is shown if a number is divisible by 2.
-- Otherwise, it prints "The number is odd".
BEGIN
DECLARE @integerNumber INT = 8
	IF @integerNumber % 2 = 0
	  PRINT 'The number is even'
    ELSE 
      PRINT 'The number is odd'
END;
GO


-- -------------------------------
-- Question 9
/*	Write a user-defined function, called fncCalcFactorial, that gets an 
	integer number n and calculates and returns its factorial.  

	Example:
	0! = 1
	2! = fact(2) = 2 * 1 = 2
	3! = fact(3) = 3 * 2 * 1 = 6
	. . .
	n! = fact(n) = n * (n-1) * (n-2) * . . . * 1

	Create a non-saved procedure that executes the above function and outputs the 
	result for 3 different input values.
*/
GO
CREATE OR ALTER FUNCTION fncCalcFactorial
		(@n INT) RETURNS INT
AS
BEGIN
	DECLARE @output INT = 1
		IF @n < 0
			RETURN NULL
		ELSE IF @n = 0 OR @n = 1
			RETURN @output
		ELSE
			WHILE @n > 1
				BEGIN
					SET @output = @output * @n
					SET @n = @n -1
				END;
			RETURN @output
END;
GO

SELECT dbo.fncCalcFactorial(0) AS factorial, dbo.fncCalcFactorial(2) AS factorial1, dbo.fncCalcFactorial(3) AS factorial2


-- ------------------------------------------
-- Question 10
/* 
Create a stored procedure, called spCountryInsertNew that receives the 
countryCode, countryName, and regionID 
for a new country to be added to the database!

The procedure executes the appropriate INSERT statement and uses the PRINT
statement to display if the insertion was successful or not.

Make sure you use a TRY CATCH to display an appropriate message if an error occurs!

Place a GO; statement in front of and after the CREATE statement such that it won't
give you the "only one command in a batch" error!
*/
GO
CREATE OR ALTER PROCEDURE spCountryInsertNew
		@countryCode CHAR(2),
		@countryName VARCHAR(40),
		@regionID INT
AS
BEGIN
	DECLARE @ResponseMessage VARCHAR(255)
	BEGIN TRY
	INSERT INTO countries(countryID, countryName, regionID)
		VALUES (@countryCode, @countryName, @regionID)
	IF @@ROWCOUNT > 0
		PRINT 'Country added Successfully';
	ELSE 
		PRINT 'Country was not added';
	END TRY
	BEGIN CATCH
		PRINT 'ERROR OCCURED!!!' + ERROR_MESSAGE() + ERROR_NUMBER();
	END CATCH
END;

GO

-- sample execution
GO
BEGIN
	EXEC spCountryInsertNew 'NE', 'Nigeria', 2;
	
END;
GO


-- --------------------------------------
-- Question 11
-- Create a stored procedure called spCountriesDelete that accepts a country code 
-- as a parameter and deletes that record.

-- Make sure you use a TRY CATCH to display an appropriate message if an error occurs!

GO
CREATE OR ALTER PROCEDURE spCountriesDelete
		@countryCode CHAR(2)
AS
BEGIN
	BEGIN TRY
	DELETE from countries
	WHERE countryID = @countryCode
	IF @@ROWCOUNT > 0
		PRINT 'Country Deleted Successfully'
	ELSE
		PRINT 'Country was not deleted'
	END TRY
	BEGIN CATCH
		PRINT 'ERROR OCCURED!!!' + ERROR_MESSAGE() + ERROR_NUMBER();
	END CATCH
END;

GO
-- sample execution
BEGIN
	EXEC spCountriesDelete 'AR';
	
END;
GO

