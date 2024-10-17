/* **********************************************************
-- Sample Database for educational purposes....
*/

/* -- Uncomment this the first time you run this script */
USE master;
DROP DATABASE IF EXISTS employeeSample;
CREATE DATABASE employeeSample;

ALTER DATABASE employeeSample
   COLLATE Latin1_General_CI_AS;
GO

--    This PART of script will drop all TABLES related to sample database
USE employeeSample;

PRINT '****** Droping existing tables if they exist ******';
DROP TABLE IF EXISTS jobHistory;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS countries;
GO

--      This PART of the script creates SIX tables and adds associated constraints
--      and indexes for the DEMO user.

-- ********************************************************************
-- Create the COUNTRIES table to hold country information for customers
-- and company locations. 

PRINT '******  Creating COUNTRIES table ....';
CREATE TABLE countries ( 
	countryID	CHAR(2) PRIMARY KEY,
	countryName VARCHAR(40), 
    regionID	INT 
    );
GO
ALTER TABLE countries
	ALTER COLUMN countryName VARCHAR(40) COLLATE Latin1_General_100_CS_AS;

-- ********************************************************************
-- Create the LOCATIONS table to hold address information for company departments.
-- DEPARTMENTS has a foreign key to this table.

PRINT '******  Creating LOCATIONS table ....';
CREATE TABLE locations (
	locationID		SMALLINT	IDENTITY(3300,100)	PRIMARY KEY,
    streetAddress	VARCHAR(40),
	postalCode		VARCHAR(12),
	city			VARCHAR(30) NOT NULL,
	stateProv		VARCHAR(25),
	countryID		CHAR(2),
	CONSTRAINT loc_country_fk FOREIGN KEY (countryID) REFERENCES countries(countryID),
	CONSTRAINT loc_locid_chk CHECK (locationID < 9901)
    );
GO
ALTER TABLE locations
	ALTER COLUMN city VARCHAR(30) COLLATE Latin1_General_100_CS_AS;
GO

-- ********************************************************************
-- Create the DEPARTMENTS table to hold company department information.
-- EMPLOYEES  has a foreign key to this table.

PRINT '******  Creating DEPARTMENTS table ....';
CREATE TABLE departments ( 
	departmentID    SMALLINT	IDENTITY(280,10) PRIMARY KEY,
	departmentName  VARCHAR(30) NOT NULL,
	managerID		INT,
    locationID      SMALLINT,
	CONSTRAINT dept_loc_fk FOREIGN KEY (locationID) REFERENCES locations(locationID),
	CONSTRAINT dept_deptid_chk CHECK (departmentID < 9991)
    ) ;
GO
ALTER TABLE departments
	ALTER COLUMN departmentName VARCHAR(30) COLLATE Latin1_General_100_CS_AS;
GO

-- ********************************************************************
-- Create the EMPLOYEES table to hold the employee personnel 
-- information for the company.
-- EMPLOYEES has a self referencing foreign key to this table.

PRINT '******  Creating EMPLOYEES table ....'
CREATE TABLE employees (
	employeeID			INT		IDENTITY(207,1)		PRIMARY KEY,
    firstName			VARCHAR(20),
    lastName			VARCHAR(25) NOT NULL,
	email				VARCHAR(25) NOT NULL,
	phoneNumber			VARCHAR(20),
    hireDate			DATE NOT NULL,
	jobTitle			VARCHAR(10) NOT NULL,
	salary				DECIMAL(8,2),
    commissionPercent	DECIMAL(2,2),
    managerID			INT,
    departmentID		SMALLINT,
    CONSTRAINT emp_salary_min CHECK (salary > 0),
    CONSTRAINT emp_email_uk UNIQUE (email),
	CONSTRAINT emp_dept_fk FOREIGN KEY (departmentID) REFERENCES departments(departmentID),
    CONSTRAINT emp_manager_fk FOREIGN KEY (managerID) REFERENCES employees(employeeID)
    );
GO
ALTER TABLE employees
	ALTER COLUMN firstName VARCHAR(20) COLLATE Latin1_General_100_CS_AS;
ALTER TABLE employees
	ALTER COLUMN lastName VARCHAR(25) COLLATE Latin1_General_100_CS_AS;
GO

-- This PART of script will populate script for the sample database
-- NOTES There is a circular foreign key reference between 
--EMPLOYEES and DEPARTMENTS. That's why we disable
--the FK constraints here

-- ***************************insert data into the COUNTRIES table

PRINT '******  Populating COUNTRIES table ....';
INSERT INTO countries VALUES 
	( 'IT', 'Italy', 1),
	( 'JP', 'Japan', 3),
	( 'US', 'United States of America', 2),
	( 'CA', 'Canada', 2),
	( 'CN', 'China', 3),
	( 'IN', 'India', 3),
	( 'AU', 'Australia', 3),
	( 'ZW', 'Zimbabwe', 4),
	( 'SG', 'Singapore', 3),
	( 'UK', 'United Kingdom', 1),
	( 'FR', 'France', 1),
	( 'DE', 'Germany', 1),
	( 'ZM', 'Zambia', 4 ),
	( 'EG', 'Egypt', 4),
	( 'BR', 'Brazil', 2),
	( 'CH', 'Switzerland', 1),
	( 'NL', 'Netherlands', 1),
	( 'MX', 'Mexico', 2),
	( 'KW', 'Kuwait', 4),
	( 'IL', 'Israel', 4),
	( 'DK', 'Denmark', 1),
	( 'NG', 'Nigeria', 4),
	( 'AR', 'Argentina', 2),
	( 'BE', 'Belgium', 1);
GO
-- ***************************insert data into the LOCATIONS table
PRINT '******  Populating LOCATIONS table ....';

SET IDENTITY_INSERT locations ON;
GO
INSERT INTO locations (locationID, streetAddress, postalCode, city, stateProv, countryID) VALUES 
	( 1000, '1297 Via Cola di Rie', '00989', 'Roma', NULL, 'IT'),
	( 1100, '93091 Calle della Testa', '10934', 'Venice', NULL, 'IT'),
	( 1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP'),
	( 1300, '9450 Kamiya-cho', '6823', 'Hiroshima', NULL, 'JP'),
	( 1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US'),
	( 1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US'),
	( 1600, '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US'),
	( 1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US'),
	( 1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA'),
	( 1900, '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA'),
	( 2000, '40-5-12 Laogianggen', '190518', 'Beijing', NULL, 'CN'),
	( 2100, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN'),
	( 2200, '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU'),
	( 2300, '198 Clementi North', '540198', 'Singapore', NULL, 'SG'),
	( 2400, '8204 Arthur St', NULL, 'London', NULL, 'UK'),
	( 2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK'),
	( 2600, '9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK'),
	( 2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE'),
	( 2800, 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR'),
	( 2900, '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH'),
	( 3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH'),
	( 3100, 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL'),
	( 3200, 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal,', 'MX');
GO
SET IDENTITY_INSERT locations OFF;
GO

-- ****************************insert data into the DEPARTMENTS table
PRINT '******  Populating DEPARTMENTS table ....';

-- disable integrity constraint to EMPLOYEES to load data
--ALTER TABLE departments 
--  DISABLE CONSTRAINT dept_mgr_fk;
SET IDENTITY_INSERT departments ON;
GO
INSERT INTO departments (departmentID, departmentName, managerID, locationID) VALUES 
( 10, 'Administration', 200, 1700),
( 20, 'Marketing', 201, 1800),
( 50, 'Shipping', 124, 1500),
( 60, 'IT', 103, 1400),
( 80, 'Sales', 149, 2500),
( 90, 'Executive', 100, 1700),
( 110, 'Accounting', 205, 1700),
( 190, 'Contracting', NULL, 1700);
GO
SET IDENTITY_INSERT departments OFF;
GO
-- ***************************insert data into the EMPLOYEES table

PRINT '******  Populating EMPLOYEES table ....';
SET IDENTITY_INSERT employees ON;
GO
INSERT INTO employees (employeeID, firstName, lastName, email, phoneNumber, hireDate, jobTitle, salary, commissionPercent, managerID, departmentID) VALUES 
( 100, 'Steven', 'King', 'SKING', '515.123.4567', CONVERT(DATETIME, '2009-06-17', 102), 'AD_PRES', 288000, NULL, NULL, 90),
( 101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', CONVERT(DATETIME, '2011-09-21', 102), 'AD_VP', 204000, NULL, 100, 90),
( 102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', CONVERT(DATETIME, '2015-01-13', 102), 'AD_VP', 204000, NULL, 100, 90),
( 103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', CONVERT(DATETIME, '2012-01-03', 102), 'IT_PROG', 108000, NULL, 102, 60),
( 104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', CONVERT(DATETIME, '2013-05-21', 102), 'IT_PROG', 72000, NULL, 103, 60),
( 107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', CONVERT(DATETIME, '2021-02-07', 102), 'IT_PROG', 50400, NULL, 103, 60),
( 124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', CONVERT(DATETIME, '2021-11-16', 102), 'ST_MAN', 69600, NULL, 100, 50),
( 141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', CONVERT(DATETIME, '2017-10-17', 102), 'ST_CLERK', 42000, NULL, 124, 50),
( 142, 'Curtis', 'davies', 'CDAVIES', '650.121.2994', CONVERT(DATETIME, '2019-01-29', 102), 'ST_CLERK', 37200, NULL, 124, 50),
( 143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', CONVERT(DATETIME, '2020-03-15', 102), 'ST_CLERK', 31200, NULL, 124, 50),
( 144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', CONVERT(DATETIME, '2020-07-09', 102), 'ST_CLERK', 30000, NULL, 124, 50),
( 149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.429018', CONVERT(DATETIME, '2022-01-29', 102), 'SA_MAN', 126000, .2, 100, 80),
( 174, 'Ellen', 'Abel', 'EABEL', '011.44.1644.429267', CONVERT(DATETIME, '2018-05-11', 102), 'SA_REP', 132000, .30, 149, 80),
( 176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.429265', CONVERT(DATETIME, '2020-03-24', 102), 'SA_REP', 130200, .20, 149, 80),
( 178, 'Kimberely', 'Grant', 'KGRANT', '011.44.1644.429263', CONVERT(DATETIME, '2021-05-24', 102), 'SA_REP', 84000, .15, 149, NULL),
( 200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', CONVERT(DATETIME, '2009-09-17', 102), 'AD_ASST', 52800, NULL, 101, 10),
( 201, 'Michael', 'hartstein', 'MHARTSTE', '515.123.5555', CONVERT(DATETIME, '2018-02-17', 102), 'MK_MAN', 156000, NULL, 100, 20),
( 202, 'pat', 'Fay', 'PFAY', '603.123.6666', CONVERT(DATETIME, '2019-08-17', 102), 'MK_REP', 72000, NULL, 201, 20),
( 205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', CONVERT(DATETIME, '2016-06-07', 102), 'AC_MGR', 144000, NULL, 101, 110),
( 206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', CONVERT(DATETIME, '2016-06-07', 102), 'AC_ACCOUNT', 99600, NULL, 205, 110);
GO
SET IDENTITY_INSERT employees OFF;
GO
-- enable integrity constraint to DEPARTMENTS
-- ALTER TABLE departments 
--   ENABLE CONSTRAINT dept_mgr_fk;


--  Creating table JOB_HISTORY and populating data
PRINT '******  Creating JOB_HISTORY table ....';
CREATE TABLE jobHistory (
	employeeID INT,
	startDate  DATE NOT NULL,
    endDate    DATE NOT NULL,
    jobID		VARCHAR(10) NOT NULL,
    departmentID SMALLINT, 
    CONSTRAINT jhistDate_interval CHECK (endDate > startDate),
	CONSTRAINT jhist_dept_fk FOREIGN KEY (departmentID) REFERENCES departments(departmentID),
	CONSTRAINT jhist_empID_stDate_pk UNIQUE (employeeID, startDate),
	CONSTRAINT jobHistory_pk PRIMARY KEY (employeeID, startDate)
    );
GO

PRINT '******  Populating JOB_HISTORY table ....';
INSERT INTO jobHistory VALUES 
	(102, CONVERT(DATETIME, '13-JAN-1993', 102), CONVERT(DATETIME, '2020-07-24', 102), 'IT_PROG', 60),
	(101, CONVERT(DATETIME, '21-SEP-1989', 102), CONVERT(DATETIME, '2015-10-27', 102), 'AC_ACCOUNT', 110),
	(101, CONVERT(DATETIME, '28-OCT-1993', 102), CONVERT(DATETIME, '2019-03-15', 102), 'AC_MGR', 110),
	(201, CONVERT(DATETIME, '17-FEB-1996', 102), CONVERT(DATETIME, '2021-12-19', 102), 'MK_REP', 20),
	(114, CONVERT(DATETIME, '24-MAR-1998', 102), CONVERT(DATETIME, '2021-12-31', 102), 'ST_CLERK', 50),
	(122, CONVERT(DATETIME, '01-JAN-1999', 102), CONVERT(DATETIME, '2021-12-31', 102), 'ST_CLERK', 50),
	(200, CONVERT(DATETIME, '17-SEP-1987', 102), CONVERT(DATETIME, '2015-06-17', 102), 'AD_ASST', 90),
	(176, CONVERT(DATETIME, '24-MAR-1998', 102), CONVERT(DATETIME, '2020-12-31', 102), 'SA_REP', 80),
	(176, CONVERT(DATETIME, '01-JAN-1999', 102), CONVERT(DATETIME, '2021-12-31', 102), 'SA_MAN', 80),
	(200, CONVERT(DATETIME, '01-JUL-1994', 102), CONVERT(DATETIME, '2020-12-31', 102), 'AC_ACCOUNT', 90);
GO
-- *********************************************

PRINT '****** COMPLETE ******';