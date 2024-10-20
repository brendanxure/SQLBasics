/*    
INFT1105 - Week 5 - Lecture Demo
Clint MacDonald
Oct 5, 2023
Introduction to SQL
*/

-- SQL - Structured Query Language
-- Query - Question


-- 3 sub-categories of SQL
-- DML - Data Manipulation Language (working with data)(rows)
-- DDL - Data Definition Langauge (working with the design)(columns)
-- TCL - Transactional Control Language

-- DML - first couple of weeks

-- CRUD
-- C - Create (INSERT statement - adding new data)
-- R - Read   (SELECT statement - extracting information)
-- U - Update (UPDATE statement - editing existing data) 
-- D - Delete (DELETE statement - deleting existing data)

-- our first SQL statement
SELECT * 
FROM players;

-- syntax
/*
SELECT <comma separated field list>
FROM <data source (one or more tables)>
*/
-- '*' refers to ALL columns

-- what if we want to customize what column columns are shown
SELECT
	firstname,
	lastname,
	regnumber
FROM players;

-- column aliases
SELECT
	firstname AS fname,
	lastname AS "last name",   -- avoid if possible
	regnumber AS [reg number]  -- SQL Server only (avoid also)
FROM players;

-- table aliases
SELECT
	firstname,
	lastname,
	regnumber
FROM players p;

-- filtering (removing rows)
SELECT *
FROM players
WHERE firstname = 'Richard';

-- case sensitivity
SELECT *
FROM players
WHERE UPPER(firstname) = 'RICHARD';

-- what if we want Richard and David
SELECT *
FROM players
WHERE 
	UPPER(firstname) = 'RICHARD'
	OR LOWER(firstname) = 'david';

-- another example
SELECT *
FROM players
WHERE 
	UPPER(firstname) = 'RICHARD'
	OR LOWER(firstname) = 'david'
	AND regnumber > 41000;
	-- careful this does not work as expected

-- ORDER OF PRECEDENCE
     -- extension of ORDER of OPERATIONS
-- BEDMAS 
-- AND
-- OR
SELECT *
FROM players
WHERE 
	(UPPER(firstname) = 'RICHARD'
	OR LOWER(firstname) = 'david')
	AND regnumber > 41000;

-- Sorting
SELECT * 
FROM players
ORDER BY UPPER(firstname);

-- sort by multiple columns
SELECT * 
FROM players
ORDER BY 
	UPPER(lastname),
	UPPER(firstname);

-- summarize the syntax
/*
SELECT <comma separated field list>
FROM <data source, one or more tables>
WHERE <boolean filter criteria, with AND or OR>
ORDER BY <comma separated field list>
*/


-- calculated fields
-- remember that calculations does not necessarily mean numbers

-- math

SELECT	
	gamenum,
	homescore,
	homescore + 2 AS newHomeScore
FROM games
WHERE isPlayed = 1
ORDER BY gamenum;

-- or
SELECT	
	gamenum,
	homescore,
	visitscore,
	homescore - visitscore AS goalDiff
FROM games
WHERE isPlayed = 1
ORDER BY gamenum;

-- or
SELECT
	"firstname",
	lastname,
	firstname + ' ' + lastname AS fullName
FROM players
ORDER BY lastname;

-- note:
-- single quotes are for string literals
-- double quotes are for object names or assignments
-- in SQL Server only, [] can be interchanged with double quotes

-- the above statement can also be written using a function
SELECT
	firstname,
	lastname,
	CONCAT(firstname, ' ', lastname) AS fullName
FROM players
ORDER BY lastname;

-- Wildcards
-- what if we only know part of a string?
-- List all players whose lastname starts with S
SELECT 
	firstname,
	lastname
FROM players
WHERE UPPER(lastname) LIKE 'S%'
ORDER BY lastname;

-- find all the polish people (assuming ends with ski)
SELECT 
	firstname,
	lastname
FROM players
WHERE UPPER(lastname) LIKE '%SKI'
ORDER BY lastname;

-- anywhere
SELECT 
	firstname,
	lastname
FROM players
WHERE UPPER(lastname) LIKE '%DON%'
ORDER BY lastname;






SELECT 
	teamName,
	hometeam,
	visitteam
FROM teams t
	JOIN games gh ON t.teamid = gh.hometeam OR t.teamid = gh.visitteam
WHERE gamedatetime = '2024-03-05'