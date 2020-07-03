-- CHALLENGE
--total current employees of the firm

SELECT COUNT (e.emp_no)
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (ti.to_date='9999-01-01'); 

-- create a database of people born between 1952 and 1955

SELECT e.emp_no,
e.first_name,
e.last_name,
ti.title,
ti.from_date,
ti.to_date,
s.salary
INTO retiring_title
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (ti.to_date='9999-01-01'); 

SELECT *
FROM retiring_title;

-- amount of people 72,458
SELECT COUNT(first_name)
FROM retiring_title

-- get rid only most recent title per employee. dupe employees with older titles. this is redundant now
SELECT emp_no,
	first_name,
	last_name,
	title,
	from_date,
	to_date,
	salary
INTO final_retiring_employees
FROM
	(SELECT rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title,
	rt.from_date,
  	rt.to_date,
	rt.salary, ROW_NUMBER() OVER
 (PARTITION BY (rt.emp_no)
  ORDER BY rt.to_date DESC) rn
  FROM retiring_title as rt
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT *
FROM final_retiring_employees;

-- 72,458 count after dupe names were removed
SELECT COUNT(first_name)
FROM final_retiring_employees;

--titles of employees retiring
SELECT rft.title, COUNT(*) AS count
INTO retiring_title_count
FROM final_retiring_employees as rft
GROUP BY rft.title;

-- Number of [titles] retiring
SELECT COUNT(DISTINCT rft.title)
into num_recent_titles_retiring
FROM final_retiring_employees as rft;

-- mentorship eligibility using the to_date filter as well
SELECT e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
ti.title,
ti.from_date,
ti.to_date
INTO mentorship
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
AND (ti.to_date='9999-01-01');

--1,549 people total eligble 

SELECT COUNT(first_name)
FROM mentorship
--titles of employees for mentorship

SELECT m.title, COUNT(*) AS count
FROM mentorship as m
GROUP BY m.title

