-- CHALLENGE
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

SELECT emp_no, first_name, last_name, title, from_date, to_date, salary
FROM retiring_title;

-- amount of people 133776
SELECT COUNT(first_name)
FROM retiring_title

-- get rid only most recent title per employee
SELECT emp_no,
	first_name,
	last_name,
	title,
	from_date,
	to_date,
	salary
INTO retiring_final_title
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

SELECT emp_no, first_name, last_name, title, from_date, to_date, salary
FROM retiring_final_title;

-- 90,398 after dupe names were removed
SELECT COUNT(first_name)
FROM retiring_final_title

-- mentorship eligibility this containes dupes again

SELECT e.emp_no,
e.first_name,
e.last_name,
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

--2,846 people total including dupes
SELECT COUNT(first_name)
FROM mentorship

-- added a filter that only includes the people still at the company. include a filter that requires to_date to be 9999-01-01. other way is much longer
SELECT e.emp_no,
e.first_name,
e.last_name,
ti.title,
ti.from_date,
ti.to_date
INTO mentorship_filtered
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (ti.to_date='9999-01-01'); 

SELECT emp_no, first_name, last_name, title, from_date, to_date
FROM mentorship_filtered;

-- filtered mentorship positions are 1,549
SELECT COUNT(first_name)
FROM mentorship_filtered

