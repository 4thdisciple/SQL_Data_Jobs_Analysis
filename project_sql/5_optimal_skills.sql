/*
Question: What are the top skills in demand and also with the highest salary for data analysts?
- Identify skills that are in-demand and also associated with big salaries;
- Focuss is on Remote Positions only with specified salaries / not null;
Why? target skills that offer job security and high financial gains.
*/



WITH skills_demand AS (
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_work_from_home = True AND
    salary_year_avg IS NOT NULL
GROUP BY 
    skills_dim.skill_id
), AVG_salary AS(
SELECT 
    skills_job_dim.skill_id,
    ROUND (AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.salary_year_avg is not null AND
    job_work_from_home = True
GROUP BY 
    skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN AVG_salary ON skills_demand.skill_id = AVG_salary.skill_id
WHERE
    demand_count > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 10



/*

Cloud + data stack dominates demand and pay: Skills like Snowflake, Azure, AWS, BigQuery, Hadoop sit at the sweet spot of high demand and strong salaries, showing the market’s continued push toward cloud-native data platforms and scalable analytics.

Specialized languages/tools command salary premiums: Go leads on average salary despite moderate demand, suggesting scarcity value, while Java remains solid but more commoditized—useful, but no longer top-tier for pay without specialization.

Collaboration & enterprise tools are quietly lucrative: Confluence, Jira, and SSIS don’t top demand charts, yet their salaries stay competitive, indicating that enterprise environments value workflow, integration, and data operations skills more than many candidates expect.



[
  {
    "skill_id": 8,
    "skills": "go",
    "demand_count": "27",
    "avg_salary": "115320"
  },
  {
    "skill_id": 234,
    "skills": "confluence",
    "demand_count": "11",
    "avg_salary": "114210"
  },
  {
    "skill_id": 97,
    "skills": "hadoop",
    "demand_count": "22",
    "avg_salary": "113193"
  },
  {
    "skill_id": 80,
    "skills": "snowflake",
    "demand_count": "37",
    "avg_salary": "112948"
  },
  {
    "skill_id": 74,
    "skills": "azure",
    "demand_count": "34",
    "avg_salary": "111225"
  },
  {
    "skill_id": 77,
    "skills": "bigquery",
    "demand_count": "13",
    "avg_salary": "109654"
  },
  {
    "skill_id": 76,
    "skills": "aws",
    "demand_count": "32",
    "avg_salary": "108317"
  },
  {
    "skill_id": 4,
    "skills": "java",
    "demand_count": "17",
    "avg_salary": "106906"
  },
  {
    "skill_id": 194,
    "skills": "ssis",
    "demand_count": "12",
    "avg_salary": "106683"
  },
  {
    "skill_id": 233,
    "skills": "jira",
    "demand_count": "20",
    "avg_salary": "104918"
  }
]