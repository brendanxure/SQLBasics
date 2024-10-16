/*
INFT1105 - Winter 2024 - In-Class 8
Grouping, Joins, and SubQueries
Brendan Obilo
100952871
March. 2024
-------------------------------

Answer the following 2 questions during class and submit to DC Connect.  These are both tricky questions and you will need to collaborate with your classmates to get this done and truly understand it.  You may be asked to verbally explain your answer to demonstrate your knowledge of the topic beyond just having your friend show you how to do it or using generative AI.
*/

USE employeeSample; -- use the sample database from Assignments 2

/* 
Using GROUPing and JOIN
1) For each employee, how many people work directly under them?  Note: The managerID field, employees table, 
is a FK to the employeeID field in the employees table.
*/
SELECT
	e.firstName,
	e.lastName,
	e.employeeID,
	COUNT(m.employeeID) AS NoOfPeople
FROM employees e
LEFT OUTER JOIN employees m ON e.employeeID = m.managerID
GROUP BY e.employeeID, e.firstName, e.lastName

--OR
SELECT managerID, COUNT(managerID) As NumberOfWorker
FROM employees
GROUP BY managerID

SELECT CONCAT(firstName, ' ', lastName) AS fullName, employeeID, ISNULL(employeeManagers.NumberOfWorker, 0) AS NumberOfWorker
FROM employees
LEFT OUTER JOIN (
SELECT managerID, COUNT(managerID) As NumberOfWorker
FROM employees
GROUP BY managerID
) AS employeeManagers ON employees.employeeID = employeeManagers.managerID



/*
USING both GROUPing and Sub-Queries
2) Using Sub-Queries, Display the full name, Department Name, and salary for the lowest paid (by salary only) employee in each department.  Note: Double check your output as it might not be as you expect!
*/


SELECT 
	CONCAT(firstName, ' ', lastName) AS fullname,
	salary,
	d.departmentName
FROM employees e
INNER JOIN departments d ON e.departmentID = d.departmentID
WHERE e.salary IN (
	SELECT 
		MIN(salary) AS minSalary
	FROM employees e1
	WHERE e1.departmentID = d.departmentID
	GROUP BY e1.departmentID
)

--OR

SELECT CONCAT(firstName, ' ', lastName) AS fullname,
	e.salary,
	(SELECT departmentName FROM departments WHERE departments.departmentID = e.departmentID) AS departmentName
FROM employees e
INNER JOIN (SELECT departmentID, min(Salary) AS minSalary
FROM employees
GROUP BY departmentID) depSalary ON e.departmentID = depSalary.departmentID
WHERE depSalary.minSalary = e.salary

--OR
SELECT CONCAT(firstName, ' ', lastName) AS fullname,
	e.salary,
	(SELECT departmentName FROM departments WHERE departments.departmentID = e.departmentID) AS departmentName
FROM employees e
INNER JOIN (SELECT departmentID, min(Salary) AS minSalary
FROM employees
GROUP BY departmentID) depSalary ON e.departmentID = depSalary.departmentID AND depSalary.minSalary = e.salary

