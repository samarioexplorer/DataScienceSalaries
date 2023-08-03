# This dataset contains information about salaries for data science related jobs around the world.

# Visuals on the table
SELECT * 
FROM datasciencesalaries
LIMIT 10

# Droping off unnecessary column.
ALTER TABLE datasciencesalaries
DROP COLUMN MyUnknownColumn

# How many countries are in the dataset?
SELECT COUNT(distinct company_location) AS number_of_countries
FROM datasciencesalaries
-- 50 countries featured

# How many entries are there for non US countries and the US?
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
    COUNT(company_location) AS count_entries
FROM datasciencesalaries
GROUP BY location
-- US 355 entries vs nonUS 252 entries, I will analyze those two groups separately -- 

# What is the highest and lowest salary for US entries?
(SELECT salary_in_usd AS US_salary_range
FROM datasciencesalaries
WHERE company_location = 'US'
ORDER BY salary_in_usd DESC
LIMIT 1)
UNION
(SELECT salary_in_usd AS US_salary_range
FROM datasciencesalaries
WHERE company_location = 'US'
ORDER BY salary_in_usd ASC
LIMIT 1)

# What is the hihest and lowest salary for nonUS entries?
(SELECT salary_in_usd AS nonUS_salary_range
FROM datasciencesalaries
WHERE NOT company_location = 'US'
ORDER BY salary_in_usd DESC
LIMIT 1)
UNION (
SELECT salary_in_usd AS nonUS_salary_range
FROM datasciencesalaries
WHERE NOT company_location = 'US'
ORDER BY salary_in_usd
LIMIT 1)
-- Issue: Some entries in both groups were probably added as a monthly salary (the lowest is 2859USD) instead of yearly salary --

# What is the average salary for US and nonUS countries?
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
    ROUND(AVG(salary_in_usd)) AS avg_salary
FROM datasciencesalaries
GROUP BY location
ORDER BY avg_salary DESC
-- Would be better to find median based on a different amount of entries for each group. --
-- US 144055, nonUS 67560 --

# What is the salary median for the US?
-- Getting a median number. Get the middle row number (177), in separate query sort results for US countries by salary and find what amount is on place 177 --
SELECT FLOOR(COUNT(company_location)/2) AS middle_row_number
FROM datasciencesalaries
WHERE company_location = 'US'

SELECT salary_in_usd AS median_number
FROM datasciencesalaries
WHERE company_location = 'US'
ORDER BY salary_in_usd
LIMIT 177,1
	
-- Second option to find a median. Set index for each row for the entries for US countries ordered by salary 
-- Find the value in the middle or two values if the number of rows is even and calculate average,
-- Return the average as a median value 135000 USD 

SET @rowindex := -1;
SELECT 
   ROUND(AVG(s.salary),0) AS median_US
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           datasciencesalaries.salary_in_usd AS salary
    FROM datasciencesalaries
	WHERE company_location = 'US' -- change to: WHERE NOT company_location = 'US' for nonUS countries --
    ORDER BY datasciencesalaries.salary_in_usd) AS s
WHERE
s.rowindex IN (FLOOR(@rowindex / 2) , CEIL(@rowindex / 2))
-- Return the average as a median value 135000 USD 
-- Median for nonUS countries is 62689 USD

# What is the average salary for entries by experience level?
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
    ROUND(avg(salary_in_usd), 0) AS average_salary,
	experience_level
FROM datasciencesalaries
GROUP BY location, experience_level
ORDER BY location, average_salary DESC
-- Average salary is increasing with experience level.-- 

# What is the average salary for each year?
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
	work_year, 
	ROUND(avg(salary_in_usd),0)
FROM datasciencesalaries
GROUP BY location, work_year
ORDER BY location DESC, work_year
-- There is a big step (over 10kUSD) in average salary in 2022 for nonUS countries. The US has comparable average salary throughout all years. --

# How many senior and executive positions are in the dataset for each year?
SELECT 
	experience_level, 
	COUNT(experience_level) AS entries_experience_level, 
	work_year
FROM datasciencesalaries
WHERE experience_level IN ('SE', 'EX') AND company_location = 'US' -- change to: WHERE NOT company_location = 'US' for nonUS countries --
GROUP BY work_year, experience_level
-- There is a huge jump in amount of Senior level entries for 2022 in the US (174 to 36 from pervious year) but for nonUS countries stays similar. --

# What is the difference in entries amount for each year?
SELECT t.work_year,
	SUM(t.entries_exp_level) AS total_entries
FROM (SELECT work_year, COUNT(experience_level) AS entries_exp_level
		FROM datasciencesalaries
		WHERE company_location = 'US' -- change WHERE NOT company_location = 'US' for nonUS countries --
        GROUP BY work_year) AS t
GROUP BY work_year
-- There are 226 entries for US in 2022 compare to 99 entries for 2021 and 30 entries in 2000. --
-- There are 92 entries for nonUS in 2022 compare to 118 for 2021 and 42 in 2000. --

# How many remote/hybrid/office positions are in each group?
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
    COUNT(IF(remote_ratio = 100, 1, NULL)) remote,
	COUNT(IF(remote_ratio = 50, 0, NULL)) hybrid, 
    COUNT(IF(remote_ratio = 0, 0, NULL)) office
FROM datasciencesalaries
GROUP BY location
ORDER BY remote DESC
-- US has 266 remote position 20 hybrid and 69 in office --
-- non US countries have 115 fully 79 hybrid and 58 in office --
-- Results are clearly in favoure of remote positions --

# What group has the highest percentage of remote positions?
(
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US_companies"
	END AS location,
    ROUND(COUNT(IF(remote_ratio = 100, 1, NULL))/COUNT(remote_ratio) * 100, 0) AS remote_percentage,
    ROUND(COUNT(IF(remote_ratio = 50, 1, NULL))/COUNT(remote_ratio) * 100, 0) AS hybrid_percentage, 
    ROUND(COUNT(IF(remote_ratio = 0, 1, NULL))/COUNT(remote_ratio) * 100, 0) AS in_office_percentage,
    COUNT(remote_ratio) AS total_entries
FROM datasciencesalaries
WHERE company_location = 'US'
GROUP BY location
ORDER BY total_entries DESC
)
UNION
(
SELECT 
	CASE
		WHEN company_location != 'US' THEN "nonUS_companies"
	END AS location,
    ROUND(COUNT(IF(remote_ratio = 100, 1, NULL))/COUNT(remote_ratio) * 100, 0) AS remote_percentage,
    ROUND(COUNT(IF(remote_ratio = 50, 1, NULL))/COUNT(remote_ratio) * 100, 0) AS hybrid_percentage, 
    ROUND(COUNT(IF(remote_ratio = 0, 1, NULL))/COUNT(remote_ratio) * 100, 0) AS in_office_percentage,
    COUNT(remote_ratio) AS total_entries
FROM datasciencesalaries
WHERE NOT company_location = 'US'
GROUP BY location
ORDER BY total_entries DESC
)
-- US 75:6:19 remote, hybrid, in office
-- nonUS 46:31:23 remote, hybrid, in office

# Does remote option affect the salary?
(SELECT 
    CASE
		WHEN remote_ratio = '100' THEN "US_remote"
        WHEN remote_ratio = '50' THEN "US_hybrid"
        WHEN remote_ratio = '0' THEN "US_office"
        ELSE "null"
	END AS remote_ratio,
	ROUND(AVG(salary_in_USD), 0) AS average_salary
FROM datasciencesalaries
WHERE company_location = 'US'
GROUP BY remote_ratio
ORDER BY average_salary)
UNION
(SELECT 
    CASE
		WHEN remote_ratio = '100' THEN "nonUS_remote"
        WHEN remote_ratio = '50' THEN "nonUS_hybrid"
        WHEN remote_ratio = '0' THEN "nonUS_office"
        ELSE "null"
	END AS remote_ratio,
	ROUND(AVG(salary_in_USD), 0) AS average_salary
FROM datasciencesalaries
WHERE NOT company_location = 'US'
GROUP BY remote_ratio
ORDER BY average_salary)
-- in US remote 146k, partly 131k, non 138k
-- nonUS remote 66k, partly 68k, non69k
-- for nonUS countries salary is comparable, for US countries remote positions are getting slightly higher salary

# What is the percentage of different experience positions working 100 remotely?
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
    ROUND(COUNT(IF(experience_level = 'EN', 1, NULL))/COUNT(experience_level) * 100, 0) AS entry_level,
    ROUND(COUNT(IF(experience_level = 'MI', 1, NULL))/COUNT(experience_level) * 100, 0) AS mid_level,
    ROUND(COUNT(IF(experience_level = 'SE', 1, NULL))/COUNT(experience_level) * 100, 0) AS senior_level,
    ROUND(COUNT(IF(experience_level = 'EX', 1, NULL))/COUNT(experience_level) * 100, 0) AS executive_level,
    COUNT(remote_ratio) AS total_entries
FROM datasciencesalaries
WHERE remote_ratio = '100'
GROUP BY location
ORDER BY total_entries DESC
-- US 9:22:63:6
-- nonUS 22:49:27:3

# What is the percentage among different experience level ?
(SELECT 
	CASE
		WHEN experience_level = 'EN' THEN "US_entry_level"
        WHEN experience_level = 'MI' THEN "US_mid_level"
        WHEN experience_level = 'SE' THEN "US_senior_level"
        WHEN experience_level = 'EX' THEN "US_executive_level"
        ELSE "null"
	END AS experience_level,
    ROUND(COUNT(IF(remote_ratio = '100', 1, NULL))/COUNT(experience_level) * 100, 0) AS remote,
    ROUND(COUNT(IF(remote_ratio = '50', 1, NULL))/COUNT(experience_level) * 100, 0) AS hybrid,
    ROUND(COUNT(IF(remote_ratio = '0', 1, NULL))/COUNT(experience_level) * 100, 0) AS office,
    COUNT(remote_ratio) AS total_entries
FROM datasciencesalaries
WHERE company_location = 'US'
GROUP BY experience_level
)
UNION
(SELECT 
	CASE
		WHEN experience_level = 'EN' THEN "nonUS_entry_level"
        WHEN experience_level = 'MI' THEN "nonUS_mid_level"
        WHEN experience_level = 'SE' THEN "nonUS_senior_level"
        WHEN experience_level = 'EX' THEN "nonUS_executive_level"
        ELSE "null"
	END AS experience_level,
    ROUND(COUNT(IF(remote_ratio = '100', 1, NULL))/COUNT(experience_level) * 100, 0) AS remote,
    ROUND(COUNT(IF(remote_ratio = '50', 1, NULL))/COUNT(experience_level) * 100, 0) AS hybrid,
    ROUND(COUNT(IF(remote_ratio = '0', 1, NULL))/COUNT(experience_level) * 100, 0) AS office,
    COUNT(remote_ratio) AS total_entries
FROM datasciencesalaries
WHERE NOT company_location = 'US'
GROUP BY experience_level
)
-- US 77:16:6 from 31 EN, 66:9:26 from 90 MI, 77:3:20 from 218 SE, 94:0:6 from 16 EX
-- nonUS 44:35:21 from 57 EN, 46:28:27 from 123 MI, 50:32:18 from 62 SE, 30:50:20 from 10 EX

# How many entries are there for different employment type and what is the average salary?
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
	ROUND(avg(salary_in_usd),0) AS average_salary, 
	COUNT(employment_type) AS total_employment_type,
	employment_type
FROM datasciencesalaries
GROUP BY location, employment_type
ORDER BY location, average_salary DESC
-- US highest salary for Contract 222k, highest amount of employment type FT 346, compare to 2,3,4 for the rest
-- non US highest salary for FT 69K, highest amount of employment type FT 242, compare to 8,1,1 for the rest

# What is the percentage of different employment type for each group US vs. nonUS?
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
	ROUND(COUNT(IF(employment_type = 'FT', 1, NULL))/COUNT(employment_type) * 100, 0) AS fulltime,
    ROUND(COUNT(IF(employment_type = 'PT', 1, NULL))/COUNT(employment_type) * 100, 0) AS parttime, 
    ROUND(COUNT(IF(employment_type = 'FL', 1, NULL))/COUNT(employment_type) * 100, 0) AS freelance,
    ROUND(COUNT(IF(employment_type = 'CT', 1, NULL))/COUNT(employment_type) * 100, 0) AS contract,
    COUNT(employment_type) AS total_entries
FROM datasciencesalaries
GROUP BY location
-- US 97:1:1:1, nonUS 96:3:0:0 Full time contract is the most common type of employment.

# How many different titles are there in the dataset and what data position is the most frequent
SELECT COUNT(distinct job_title) AS job_count
FROM datasciencesalaries

SELECT job_title,
	COUNT(job_title) AS count_jobs
FROM datasciencesalaries
GROUP BY job_title
ORDER BY count_jobs DESC
LIMIT 10`listings london`
-- There are 50 different job titles in the tab. Data scientist 143, Data engineer 132, data analyst 97 ML engineer 41 are the most common. --

# Does bigger companies allows remote positions more than small or medium companies? 
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
    company_size,
	ROUND(COUNT(IF(remote_ratio = '100', 1, NULL))/COUNT(remote_ratio) * 100, 0) AS remote_percentage,
	ROUND(COUNT(IF(remote_ratio = '50', 1, NULL))/COUNT(remote_ratio) * 100, 0) AS hybrid_percentage,
	ROUND(COUNT(IF(remote_ratio = '0', 1, NULL))/COUNT(remote_ratio) * 100, 0) AS office_percentage
FROM datasciencesalaries
GROUP BY location, company_size
-- for nonUS large companies are more likely to offer hybrid position, small and medium companies are more likely to offer fully remote position
-- for US companies are more likely to offer fully remote position

# Is the average salary higher for bigger companies? 
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
    ROUND(AVG(salary_in_usd),0) as average_salary,
	company_size
FROM datasciencesalaries
GROUP BY location, company_size
ORDER BY location, average_salary DESC
-- for both groups the bigger company the higher salary
-- non US 71k, 67k, 61k, US 160k, 141k, 104k

# How many data related positions are there by company size?
SELECT 
    company_size,
	COUNT(job_title) as total_positions
FROM datasciencesalaries
GROUP BY company_size
ORDER BY total_positions DESC
-- US M companies has the most positions 218, L 106, S31
-- nonUS M 108, L 92, S 52
-- The most data realted positions in this dataset is in medium-size companies for both groups. 

# Does large companies have more people working on senior and executive positions than small companies?
SELECT 
	CASE
		WHEN company_location = 'US' THEN "US"
        ELSE "nonUS"
	END AS location,
    company_size, 
	COUNT(IF(experience_level = 'SE' OR 'EX',1, NULL)) as SE_EX_positions
FROM datasciencesalaries
GROUP BY location, company_size
ORDER BY location, SE_EX_positions
-- US medium companies has the most SEEX level positions 162, L47, S9
-- nonUS L25, M24, S13 comparable

# How many people are in a different country than it is the company headquarters?
SELECT
	CASE 
		WHEN company_location = employee_residence THEN "same"
        ELSE "different"
	END AS matching_countries,
    ROUND(COUNT(company_location)/607* 100,1) AS number_of_positions -- 607 is the number of entries at the moment
FROM datasciencesalaries
GROUP BY matching_countries