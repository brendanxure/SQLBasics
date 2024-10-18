-- *******************************
-- INFT1105-02 Intro to Databases
-- My practice
-- March 2024
-- Brendan Xure
-- *******************************

--Display the second highest salary of employee

SELECT
Max(salary) AS maxSalary
FROM employees
WHERE salary NOT IN (
SELECT MAX(salary)
FROM employees
)

--look this up
SELECT * 
FROM employees e
INNER JOIN (SELECT departmentID, min(Salary) AS minSalary
FROM employees
GROUP BY departmentID) depSalary ON e.departmentID = depSalary.departmentID
WHERE depSalary.minSalary = e.salary

SELECT * 
FROM employees e
WHERE salary IN (SELECT min(Salary) AS minSalary
FROM employees WHERE e.departmentID = employees.departmentID GROUP BY departmentID
)


--Display the highest salary of employee in eqch department
SELECT
MAX(salary) AS maxSalary,
employees.departmentID,
(SELECT departmentName FROM departments WHERE departments.departmentID = employees.departmentID) AS departmentName
FROM employees
JOIN departments d ON employees.departmentID = d.departmentID
GROUP BY employees.departmentID

--OR

SELECT
MAX(salary) AS maxSalary,
d.departmentName
FROM employees
JOIN departments d ON employees.departmentID = d.departmentID
GROUP BY d.departmentName

-- Display alternate records
SELECT * 
FROM (
	SELECT row_number() OVER(ORDER BY employeeID) AS num,firstName, lastName
FROM employees
) t
WHERE t.num % 2 != 0

-- Display duplicate records
SELECT COUNT(employeeId) AS employee, salary
FROM employees
GROUP BY salary
HAVING COUNT(employeeId) > 1

--OR

SELECT COUNT(*) AS employee, salary
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1

--Display employee where name doesnt have letter m
SELECT
firstName + ' ' + lastName AS fullname
FROM employees
WHERE UPPER(firstName + ' ' + lastName) NOT LIKE '%M%' 


--Display nth row 
SELECT * 
FROM (
	SELECT
	firstname,
	row_number() OVER(ORDER BY employeeID) AS rowNumber
FROM employees
) t
WHERE rowNumber = 4

--Dsplay the 17th highest ranking salary employee
SELECT *
FROM employees
WHERE salary = (
SELECT salary 
FROM (
SELECT *
FROM (SELECT COUNT(salary) AS numberOfSalary, salary, row_number() OVER(ORDER BY salary ASC) AS rankOfsalary
FROM employees
GROUP BY salary
) t
WHERE rankOfsalary = 17
) tenthSalary
)

---Employee whose salary is more than the average salary of all employee 
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) AS averageSalary
FROM employees)

--Departments that dont have employee


SELECT departmentID, departmentName
FROM departments
EXCEPT
SELECT departmentID, (SELECT departmentName FROM departments WHERE departments.departmentID = employees.departmentID) AS departmentName
FROM employees

--OR
SELECT DISTINCT departmentID FROM employees

SELECT departmentID FROM departments

SELECT departmentID, departmentName FROM departments
WHERE departmentID NOT IN (SELECT DISTINCT departmentID FROM employees WHERE departmentID IS NOT NULL)

--OR

SELECT
 d.departmentID,
 departmentName
FROM employees e
RIGHT OUTER JOIN departments d ON e.departmentID = d.departmentID
WHERE e.departmentID is null

--OR
SELECT departmentID, departmentName
FROM departments d
WHERE departmentID NOT IN (SELECT departmentID FROM employees e WHERE d.departmentID = e.departmentID)

--Find the employee in each department who earns more than average in that department
SELECT
departmentID, salary
FROM employees
WHERE departmentID IS NOT NULL

SELECT departmentID, AVG(salary) AS averageSalary
FROM employees
WHERE departmentID IS NOT NULL
GROUP BY departmentID

SELECT employeeID, 
	   firstName, 
	   lastName, 
	   (SELECT departmentName FROM departments WHERE departments.departmentID = e.departmentID) AS departmentName,
	   salary,
	   averageDeptSalary.averageSalary
FROM employees e
INNER JOIN (SELECT departmentID, AVG(salary) AS averageSalary
FROM employees
WHERE departmentID IS NOT NULL
GROUP BY departmentID) AS averageDeptSalary ON e.departmentID = averageDeptSalary.departmentID
WHERE e.salary > averageDeptSalary.averageSalary AND e.departmentID = averageDeptSalary.departmentID

--OR
SELECT 
		employeeID, 
	   firstName, 
	   lastName, 
	   (SELECT departmentName FROM departments WHERE departments.departmentID = e1.departmentID) AS departmentName,
	   salary
FROM employees e1
WHERE salary >  (SELECT AVG(salary) AS averageSalary
FROM employees e2
WHERE e1.departmentID = e2.departmentID)

--Find Departments whose average salary is better than other departments
SELECT salary, departmentID
FROM employees

SELECT departmentID, 
	AVG(salary) AS averageSalary, 
	(SELECT departmentName FROM departments WHERE departments.departmentID = employees.departmentID) AS departmentName
FROM employees
WHERE departmentID IS NOT NULL
GROUP BY departmentID
HAVING AVG(salary) = (SELECT MAX(averageSalary) AS AverageSal
						FROM (SELECT departmentID, AVG(salary) AS averageSalary
						FROM employees
						WHERE departmentID IS NOT NULL
						GROUP BY departmentID) newtab)

--Find Departments whose average salary is better than other departments with the name of the employees in the departments
SELECT employeeID, firstName, lastName, departmentName, salary, d.averageSalary
FROM employees
INNER JOIN (SELECT departmentID, 
	AVG(salary) AS averageSalary, 
	(SELECT departmentName FROM departments WHERE departments.departmentID = employees.departmentID) AS departmentName
FROM employees
WHERE departmentID IS NOT NULL
GROUP BY departmentID
HAVING AVG(salary) = (SELECT MAX(averageSalary) AS AverageSal
						FROM (SELECT departmentID, AVG(salary) AS averageSalary
						FROM employees
						WHERE departmentID IS NOT NULL
						GROUP BY departmentID) newtab)) AS d ON employees.departmentID = d.departmentID


--Calculate sum of first 20 even numbers
GO
CREATE OR ALTER FUNCTION fncSumOfEvenNumber
		() RETURNS INT
AS
BEGIN
	DECLARE @output INT = 0
	DECLARE @currentNumber INT = 2
	DECLARE @lastNumber INT = 40

	WHILE @currentNumber <= @lastNumber
		BEGIN
			SET @output = @output + @currentNumber
			SET @currentNumber = @currentNumber + 2
		END
	RETURN @output
END
GO

SELECT dbo.fncSumOfEvenNumber() AS sumOfEvenNumbers


