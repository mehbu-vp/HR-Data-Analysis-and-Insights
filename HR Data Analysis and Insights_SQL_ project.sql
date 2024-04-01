-- Project Title: HR Data Analysis and Insights

/*
Project Overview:
This project involves the analysis of a Human Resources (HR) dataset containing information about employees. 
The dataset is structured in a CSV format and includes various attributes such as employee names, cities, blood groups, 
genders, birth dates, salaries, departments, satisfaction levels, number of projects, average monthly hours, 
years spent in the company, work accidents, and promotions in the last 5 years.
*/
/*
Objective:
The primary objective of this project is to perform a comprehensive analysis of the HR dataset using SQL queries.
 The analysis aims to extract valuable insights that can be beneficial for HR professionals and management in making informed decisions regarding employee satisfaction,
 performance, departmental trends, and more.
*/
/*
Dataset Overview:
The dataset consists of 21 employee records, each containing information such as:

Employee Name: Name of the employee.
City: City where the employee is located.
Blood Group: Blood group of the employee.
Gender: Gender of the employee (M for Male, F for Female).
Birth Date: Date of birth of the employee.
Salary: Salary level of the employee (categorized as low, medium, or high).
Department: Department in which the employee works.
Satisfaction Level: Level of job satisfaction reported by the employee.
Number of Projects: The number of projects the employee is assigned to.
Average Monthly Hours: Average number of hours worked per month.
Time Spent in Company (years): Number of years the employee has been with the company.
Work Accident: Indicator of whether the employee has had a work accident (1 for yes, 0 for no).
Promotion in Last 5 Years: Indicator of whether the employee was promoted in the last 5 years (1 for yes, 0 for no).
*/


CREATE DATABASE hr_csv_project;
use hr_csv_project;
-- Import dataset
-- Eplore the data

-- find the number of observations in the table.
SELECT count(*)as num_observations from hr_csv;

-- find the count of employees by gender.
SELECT Gender ,count(*) as num_employees
FROM hr_csv
GROUP BY Gender;

--  find the count of male and female employees by department.
SELECT
    department,
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM hr_csv
GROUP BY department;

-- find the average satisfaction level by department.
SELECT Department,avg(Satisfaction_level)as avg_Satisfaction_level
from hr_csv
GROUP BY Department;

-- find the average number of projects by department.
SELECT Department,avg(Number_Project)as avg_num_project 
FROM hr_csv
GROUP BY Department;

--  find the most tenured employees in the company.
SELECT * FROM hr_csv
ORDER BY `Time_Spend_Company(years)` DESC
LIMIT 10;

-- find the count of employees who were promoted in the last five years by department and gender.
SELECT Department,Gender,
count(Promotion_Last_5Years)as num_promotedemp_last_5years
from hr_csv
GROUP BY Department,Gender;

-- find the count of employees by city.
SELECT City,count(*)as num_employees
FROM hr_csv
GROUP BY City;

-- Find customers whose 60th birthday is upcoming within the next 30 days.
SELECT * FROM hr_csv
WHERE date_add(Birth_Date,interval 60 year)
BETWEEN curdate() and date_add(curdate(),interval 30 day);


-- Find employees whose birthdays are tomorrow.
SELECT * FROM hr_csv
WHERE date_format(birth_date, '%m-%d')
 =date_format(date_add(curdate(),interval 1 day), '%m-%d');
 
-- Map Salary Categories to Numeric Values
SELECT
  `Employee Name`,
  Department,
  CASE
    WHEN salary = 'low' THEN 1
    WHEN salary = 'medium' THEN 2
    WHEN salary = 'high' THEN 3
    ELSE 0 -- Handle any other cases
  END AS salary_numeric
FROM hr_csv;

--  categorize salaries based on salary ranges.
SELECT
    `Employee Name`,
    Salary,
    Department,
    CASE
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 80000 THEN 'Medium'
        WHEN Salary > 80000 THEN 'High'
        ELSE 'Unknown'
    END AS Salary_Category
FROM
    hr_csv;

 --  find the percentage of employees with high salaries in the company.
WITH high_salary_count AS (
  SELECT COUNT(*) AS high_salary_count
  FROM hr_csv
  WHERE salary = 'high'
),
total_employee_count AS (
  SELECT COUNT(*) AS total_count
  FROM hr_csv
)

SELECT
  (high_salary_count.high_salary_count * 100.0 / total_employee_count.total_count) AS percentage_high_salary
FROM
  high_salary_count, total_employee_count;

SELECT
    (COUNT(CASE WHEN Salary > 100000 THEN 1 END) / COUNT(*)) * 100 
    AS Percentage_High_Salaries
FROM
    hr_csv;

--  find details of the nth largest salary in the company.
SELECT * 
FROM hr_csv
ORDER BY salary DESC
LIMIT 1 OFFSET 0;

-- Write a query to describe the salary percentile based on salary.
SELECT
`Employee Name`,
Salary,
NTILE(4) OVER (ORDER BY Salary) AS Quartile
FROM
hr_csv;

-- Retrieve employees in the Marketing department
SELECT * FROM hr_csv WHERE Department='marketing';

-- Retrieve employees with names starting with 'J'
SELECT * FROM hr_csv
WHERE `Employee Name` LIKE 'J%';

-- Retrieve employees  salaries is medium
SELECT * FROM hr_csv
WHERE Salary = 'medium';

/*
Conclusion:
Through this project, we aim to gain a deeper understanding of the HR dataset by leveraging SQL queries for analysis. 
The insights obtained will help HR professionals and management in optimizing employee satisfaction, improving performance, 
and making strategic decisions for the company's growth and success.
*/