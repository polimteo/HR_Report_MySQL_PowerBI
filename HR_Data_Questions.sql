-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, count(*) AS total_employees
FROM hr
WHERE termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, count(*) AS total_employees
FROM hr
WHERE termdate = '0000-00-00'
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT 
	min(age) as youngest,
    max(age) as oldest
FROM hr
WHERE termdate = '0000-00-00';

-- group by age 
SELECT
	CASE
		WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
		WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    count(*) as total_employees
FROM hr
WHERE termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

-- group by age and gender
SELECT
	CASE
		WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
		WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
	END AS age_group, gender,
    count(*) as total_employees
FROM hr
WHERE termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;


-- 4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) as total_employees
FROM hr
WHERE termdate = '0000-00-00'
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, hire_date, termdate))) AS avg_length_employment
FROM hr
WHERE termdate <= curdate() AND termdate <> '0000-00-00' ;


-- 6. How does the gender distribution vary across departments?
SELECT department, gender, count(*) AS total_employees
FROM hr
WHERE termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, count(*) AS total_employees
FROM hr
WHERE termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?

SELECT 
	department,
    total_employees,
    total_terminated,
    ROUND((total_terminated/total_employees * 100), 2) AS turnover_rate
FROM (
		SELECT department, COUNT(*) AS total_employees,
        SUM(
			CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1
			ELSE 0
            END
            ) AS total_terminated
		FROM hr
        GROUP BY department
	) as subquery
ORDER BY turnover_rate DESC;


-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) AS total_employees
FROM hr
WHERE termdate = '0000-00-00'
GROUP BY location_state
ORDER BY total_employees DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT 
	year,
    total_hires,
    total_terminations,
    (total_hires - total_terminations) AS differences,
    ROUND((total_hires - total_terminations)/total_hires * 100, 2) AS differences_percent
FROM (
	SELECT YEAR(hire_date) AS year,
    COUNT(*) as total_hires,
    SUM(
		CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1
        ELSE 0
        END
    ) AS total_terminations
	FROM hr
    GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;
	

-- 11. What is the tenure distribution for each department?

SELECT department, ROUND(AVG(TIMESTAMPDIFF(YEAR, hire_date, termdate))) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate <> '0000-00-00'
GROUP BY department;