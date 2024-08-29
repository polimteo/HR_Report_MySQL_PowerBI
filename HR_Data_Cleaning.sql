CREATE DATABASE projects;

USE projects;

SELECT * FROM hr;

-- rename ï»¿id column to emp_id
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr;

SELECT count(birthdate) FROM hr;
-- total count is 22214

SELECT birthdate FROM hr;

-- start data cleaning

-- change date format of birthdate column
UPDATE hr
SET birthdate = CASE 
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
	WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
	ELSE NULL
END;

-- change data type of birthdate column to date
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

-- change date format for hire_date column
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
	WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
	ELSE NULL
END;

-- change data type of birthdate column to date
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- remove timestamp in termdate column
UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate !='';

-- there are empty rows in termdate, remove strict mode to eliminate error when alter data type to date
SET SQL_MODE = ' ';

-- alter data type of termdate column to date
ALTER TABLE hr
MODIFY COLUMN termdate DATE;

select termdate from hr;

-- add new column age
ALTER TABLE hr
ADD COLUMN age INT;


-- modify the year after 2060
UPDATE hr
SET birthdate = date_sub(birthdate, INTERVAL 100 YEAR)
WHERE birthdate BETWEEN '2060-01-01' AND '2070-01-01';

-- update age column
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

