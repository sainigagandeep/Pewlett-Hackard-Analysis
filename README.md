# Pewlett-Hackard-Analysis
# Pewlett-Hackard-Analysis

#### *Employee database analysis on retiring employees using SQL and pgAdmin*

## Overview
The goal of this project was to act as a Human Resources Analyst to determine who will be retiring in the next few years and how many positions (and titles) will Pewlett Hackard need to fill. By doing this I helped future-proof PH by generating a list of all employees eligible for the retirement package and a list of how many job titles are going to be open after that generation of employees retires. 

## Resources
- Orginal datasets:
  - departments.csv
  - dept_emp.csv
  - dept_manager.csv
  - employees.csv
  - salaries.csv
  - titles.csv

- Software:
  - SQL
  - PostgreSQL
  - pgAdmin


## Results
- After creating the unique_titles table by joining the employees and titles tables, filtering them by date of birth and date hired, removing duplicates, and ordering the data points by date hired there are **90,398 employees retiring** as per the above criterion. 

To download: [unique_titles.csv](https://github.com/nicoserrano/Pewlett-Hackard-Analysis/files/6736136/unique_titles.csv)


- Out of those employees leaving, there are 29,414 Senior Engineers, 28,254 Senior Staff, 14,222 Engineers, 12,243 Staff, 4,502 Technique Leaders, 1,761 Assistant Engineers, and 2 Managers. 

![retiring_titles_pic](https://user-images.githubusercontent.com/83378141/123863229-53d63100-d8f7-11eb-952e-6dcc7c9655e2.png)

To download: [retiring_titles.csv](https://github.com/nicoserrano/Pewlett-Hackard-Analysis/files/6736122/retiring_titles.csv)

- Created the mentorship_eligibility table by joining the employees, department employees, and titles tables. In this case, the criterion for the join was that the employees were born in 1965 and that they were currently working at PH, in order for them to apply to the retiring/mentorship package. There were 1,549 employees eligible 

To download: [mentorship_eligibility.csv](https://github.com/nicoserrano/Pewlett-Hackard-Analysis/files/6736217/mentorship_eligibility.csv)

- Out of those eligible employees, there are 402 Engineers, 392 Senior Staff, 332 Staff, 290 Senior Engineers, 77 Technique Leaders, and 56 Assistant Engineers. 

![title_mentorship_eligibility_pic](https://user-images.githubusercontent.com/83378141/123863289-651f3d80-d8f7-11eb-9245-56a49dd010c0.png)

To download: [title_mentorship_eligibility.csv](https://github.com/nicoserrano/Pewlett-Hackard-Analysis/files/6736245/title_mentorship_eligibility.csv)


## Summary
Ideally, as the silver tsunami approaches the idea would be to prepare and be on the look for 13,505 employees. This number represents the number of people that are currently working at the company, have been there since 1985 to 1988, and their birth date is between 1962 and 1965 to be eligible to leave work. The plan is to offer these people the mentorship program so that they can keep mentoring new employees. However, if they decide to go PH should be ready to hire that amount of people. 

```
SELECT DISTINCT ON (emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, t.title
INTO employees_leaving
FROM employees as e
JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01') AND (e.birth_date BETWEEN '1962-01-01' AND '1965-12-31')
	AND (de.from_date BETWEEN '1985-01-01' AND '1988-12-31')
ORDER BY e.emp_no
```

To download: [employees_leaving.csv](https://github.com/nicoserrano/Pewlett-Hackard-Analysis/files/6736392/employees_leaving.csv)

Now, to check if there are enough potential mentors in all of the departments, we recreated the employees_leaving table to add the department they belong to. 

```
SELECT DISTINCT ON (emp_no) e.emp_no, d.dept_name, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, t.title
INTO employees_leaving_by_dept
FROM employees as e
JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
JOIN titles as t
ON (e.emp_no = t.emp_no)
LEFT JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01') AND (e.birth_date BETWEEN '1962-01-01' AND '1965-12-31')
	AND (de.from_date BETWEEN '1985-01-01' AND '1988-12-31')
ORDER BY e.emp_no

```

To download: [employees_leaving_by_dept.csv](https://github.com/nicoserrano/Pewlett-Hackard-Analysis/files/6736464/employees_leaving_by_dept.csv)

Now, I grouped the leaving employees table by department to count how many of them were in each department:

```
SELECT COUNT(first_name) "Count", dept_name
FROM employees_leaving_by_dept
GROUP BY dept_name
ORDER BY "Count" desc;
```
![employees_leaving_by_dept_pic](https://user-images.githubusercontent.com/83378141/123868118-4328b980-d8fd-11eb-81eb-fe23e80cffc4.png)


In conclusion, it all depends on how many retiring employees are willing to stay and mentor others. Nevertheless, a good mentor to mentee ratio I would say is 1:3. That is one mentor for 3 new employees. Assuming each year there are more or less 13,000 employees retiring and 13,000 new employees entering, we would need 3,000-4,000 mentors distributed proportionally in all the departments.  We would need that in order for every department to stay put, at least 25% of the retirees accept the mentorship program because that would leave PH witha a 1:3 ratio. 

We can see that there is an explicit pattern in the results. There is one group consisting of the first three departments with more than 2000 employees leaving on each of them, and there is another group with the rest of the departments with around 700 to 800 employees leaving on each of them. In order for this to work, 25% of retiring employees should be able to stay mentoring (1:3 ratio) that would be somewhat like 188 mentors for each Marketing, Finance, HR, Research, Quality Mgtm, and Customer service and around 625 mentors for Development, Production, and Sales. 



