/*
INFT1105 - Introduction to Databases
Assignment 2
*/
USE employeeSample;
GO

/* Question 1
If the following SELECT statement does NOT execute successfully, why and how would you 
fix it (Answer in words in commented text) and then actually correct the statement (not commented)
*/
SELECT
	lastName AS "LName",
	jobTitle AS "Job Title",
	hireDate AS JobStart
FROM employees
ORDER BY JobTitle;

/* 
Answer -> 
SELECT
	lastName AS "LName",
	jobTitle AS "Job Title",
	hireDate AS "Job Start"
FROM employees
ORDER BY JobTitle;
*/

-- ********************************************************************************

/* Question 2
Display the employeeid, last name and salary of employees earning in the range of $96,000 to $132,000 inclusively.  
Sort the output by top salaries first and then by last name.
*/
SELECT
	employeeID,
	lastName,
	salary
FROM employees
WHERE salary BETWEEN 96000 AND 132000
ORDER BY salary DESC, lastName;
	

/* Question 3
Write the solution for question 2 again but change the salary from annual to a weekly salary.  Make the output formatted like currency.
(i.e. a $ is shown, commas separating every 3 digits, and exactly 2 decimal places.)
NOTE: There is NOT exactly 52 in a year, so dividing by 52 is not good enough.  It is okay to assume it is NOT a leap year.
*/
SELECT
	employeeID,
	lastName,
	FORMAT(salary * 7 / 365 , 'C', 'en-US') AS weekly_salary
FROM employees
WHERE salary BETWEEN 96000 AND 132000
ORDER BY salary DESC, lastName;

/* Question 4
Display the job titles and full names of employees whose first name contains an ‘e’ or ‘E’ anywhere. 
The output should look like: (BONUS MARK FOR NOT using the OR keyword in the solution but obtaining the same results)
*/
SELECT 
	jobTitle,
	firstName + ' ' + lastName AS fullName
FROM employees
WHERE UPPER(firstName) LIKE '%E%'
   
   

/* Question 5
After the code given:
Create a query to display the address of the various locations where 
offices are located.  Add a parameter to the query such that the user 
can enter all, or part of, the city name and all locations from the 
resultant cities will be shown. 
When you execute it, you must execute all three statements together!
*/
DECLARE @cityName VARCHAR(30);
SET @cityName = '';

SELECT *
FROM locations
WHERE LOWER(city) LIKE '%' + LOWER(@cityName) + '%'



/* Question 6
Write a query to display the today's date and tomorrow’s date in the following format:
September 15th of year 2019 the result will depend on the day when you RUN/EXECUTE this query.  
Label the column "Tomorrow".
*/
IF DAY(GETDATE()) = 1
SELECT 
	FORMAT(GETDATE(), 'MMMM dd"st of year" yyyy') AS "Today",
    FORMAT(DATEADD(day, 1, GETDATE()), 'MMMM dd"nd of year" yyyy') AS "Tomorrow";
ELSE IF DAY(GETDATE()) = 2
SELECT 
	FORMAT(GETDATE(), 'MMMM dd"nd of year" yyyy') AS "Today",
    FORMAT(DATEADD(day, 1, GETDATE()), 'MMMM dd"rd of year" yyyy') AS "Tomorrow";
ELSE IF DAY(GETDATE()) = 3
SELECT 
	FORMAT(GETDATE(), 'MMMM dd"rd of year" yyyy') AS "Today",
    FORMAT(DATEADD(day, 1, GETDATE()), 'MMMM dd"th of year" yyyy') AS "Tomorrow";
ELSE
SELECT 
	FORMAT(GETDATE(), 'MMMM dd"th of year" yyyy') AS "Today",
    FORMAT(DATEADD(day, 1, GETDATE()), 'MMMM dd"th of year" yyyy') AS "Tomorrow";

	

/*  Question 7
For each employee in departments 20, 50 and 60 display last name, 
first name, department name, salary, and salary increased by 4% and 
expressed as a whole number.  Label the increased salary column 
"NewSalary".  Also add a column that subtracts the old salary from the new
salary and displays the difference. Label the column "AnnualPayIncrease".
Sort the output first by department name, then by employee lastname.
*/
SELECT 
	e.lastName,
	e.firstName,
	d.departmentName,
	e.salary,
	ROUND(cast(salary * 1.04 AS float), 0) AS NewSalary,
	ROUND(cast(salary * 1.04 - salary AS float), 0) AS AnnualPayIncrease
FROM employees e
JOIN departments d ON e.departmentID = d.departmentID
WHERE e.departmentID IN (20, 50, 60)
ORDER BY d.departmentName, e.lastName;

    
	

/* Question 8
For each employee hired before 2014, display the employee’s last name, 
hire date and calculate the number of FULL years the employee has worked at the company.
Do not round the answer, as 11.99 is not 12 yet, it should be 11 full years.
    a.	Label the column Years worked. 
    b.	Order your results by the number of years employed.  
*/
      
-- okay'ish answer: but DATEDIFF rounds so might round up years.
SELECT
    lastName,
	hireDate,
	FLOOR(DATEDIFF(day, hireDate, GETDATE()) / 365.249) AS 'Years worked'
FROM employees
WHERE year(hireDate) < 2014
ORDER BY 'Years worked';

SELECT
	lastName,
	hireDate,
	DATEDIFF(YEAR, hireDate, GETDATE()) AS 'Years worked'
FROM employees
WHERE year(hireDate) < 2014
ORDER BY 'Years worked';

/* Question 9
Create a query that displays the city names, country codes and state 
province names, but only for those cities that starts with 'S' and has at 
least 8 characters in their name. If city does not have a province name 
assigned, then put 'Unknown Province'.  Be cautious of case sensitivity! 
*/
SELECT 
	city,
	countryID,
	COALESCE(stateProv, 'Unknown Province') AS stateProv
FROM locations
WHERE city LIKE 'S%' AND LEN(city) >= 8;
	
    
/* Question 10
Provide a list of ALL departments, what city they are located in, and the name
of the current manager, if there is one.  
*/
SELECT 
	d.departmentID,
	d.departmentName,
	l.city,
	e.firstName + ' ' + e.lastName AS 'Manager Name'
FROM departments d
JOIN locations l ON d.locationID = l.locationID
LEFT JOIN employees e ON d.managerID = e.employeeID


/* Question 11
Allow the user to enter the name of a country, or any part of the name, and 
then list all employees, with their job title, currently working in that country.  Use a parameter named @country
*/
DECLARE @country VARCHAR(40)
SET @country = ' can '

SELECT 
	e.employeeID,
	e.firstName + ' ' + e.lastName AS 'Full Name',
	e.jobTitle,
	c.countryName AS 'Country Name'
FROM employees e
JOIN departments d ON e.departmentID = d.departmentID
JOIN locations l ON d.locationID = l.locationID
RIGHT OUTER JOIN countries c ON l.countryID = c.countryID
WHERE LOWER(c.countryName) LIKE '%' + LOWER(TRIM(@country)) + '%';


	
