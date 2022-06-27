-- CREATE RETIREMENT_INFO TABLE
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--then we exported it to inlcude it in the data folder

SELECT * FROM retirement_info

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--output gave 41,380



-- DROP TABLE retirement to recreate it including the EMP_NO to be able to join it
DROP TABLE retirement_info

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info




-- 1 JOINING DEPARTMENTS AND DEPT_MANAGER TABLES
SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no

-- 2 Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;


--USING ALIASES
--1 for departments and dept_manager
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--2 for retirement_info and dept_emp
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;


--CREATING THE NEW ACTUAL TABLE FOR RETIREMENT AND DEPT_EMP
--this table is going to help us see how many employees are going to retire and check
--if they stil work here
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
INTO current_emp --here is that we create it
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01'); --to include only the emp who are working to the present moment

SELECT * FROM current_emp


-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

--CREATING A NEW TABLE OF CURRENT_EMP_BY_DEPT to show the possible ppl that are retiring by dept (count)
-- Employee count by department number USING GROUP BY AND ORDER BY AND COUNT
SELECT COUNT(ce.emp_no), de.dept_no
INTO current_emp_by_dept --here we are creating a new table
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no

SELECT * FROM current_emp_by_dept


----- LIST 1 RETIRING EMP INFO WITH GENDER SALARY TO DATE (to check they are present emp)
--USING THIS CODE WE KNEW THAT salaries did not have the emp working up to present moment,
-- so we needed the dept_emp table as well that we knew from before it did have it
select * from salaries
ORDER BY to_date DESC;

--3-TABLE JOIN
--JOIN FOR RETIRING EMP (EMP_INFO) WITH THEIR SALARY FROM SALARIES TABLE AND TO_DATE FROM DEPT_EMP
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info

--

--  THIS TWO FOLLOWING TABLES ARE GIVING PROBLEMS
---- LIST 2: MANAGEMENT. Some of the emp retiring are from the mngt team and we want to know who
----TABELE 2 MANAGERS RETIRING
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

---- TABLE 3 DEPT RETIREES
-- current_emp  + dept added to it
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no);

--QUESTIONS TO ASK: 
-- what is going on with salaries
-- why are there only 5 active mngers for nine deptos
-- why are some employees appearing twice? 

--create tailored lists

--


--SKILL DRILL NEW TABLE
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info_sales
FROM current_emp as ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales')

SELECT * FROM dept_info_sales



--SKILL DRILL 2
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info_sales_devlp
FROM current_emp as ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name in ('Sales','Development')
ORDER BY d.dept_name DESC;

SELECT * FROM dept_info_sales_devlp