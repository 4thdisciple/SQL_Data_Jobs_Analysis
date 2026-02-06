/*
Question: What are the top paying jobs for the HR data analyst role?
- Find the top paying jobs for the data analyst role, remotely;
- Focus only on jobs with specified salaries (no null);
Why? Highlight the top paying jobs opportunities for the data analyst role for employment opportunities. 
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short LIKE 'Data Analyst' AND 
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10



/* SAME - FOR "HR DATA Analyst"
SELECT
    job_title,
    salary_year_avg,
    job_location,
    company_dim.company_id AS company_name
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_postings_fact.job_title LIKE 'HR Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg is not null
ORDER BY
 salary_year_avg DESC
LIMIT 10
/*

