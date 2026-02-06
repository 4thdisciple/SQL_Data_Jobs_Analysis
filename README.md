# Introduction

This project focuses on data analyst roles, examining top-paying positions, the most in-demand skills, and areas where high demand aligns with high salaries in data analytics.

SQL queries for this project can be found in the project_sql folder. -> [project_sql folder](/project_sql/)

# Background

This project was created to highlight top-paying and in-demand skills, making it easier for others to identify optimal job opportunities.

### The questions I aimed to answer using SQL were:

1. What are the highest-paying data analyst jobs?
2. What skills are required for these top-paying roles?
3. Which skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I used 

- **SQL**: The core of my analysis for querying data and generating insights.
- **PostgreSQL**: Used to manage and store the dataset.
- **Visual Studio Code**: Used to write and run SQL queries.
- **Git & GitHub**: Used for version control, collaboration, and project tracking.

# The analysis

Each query in this project focuses on a specific aspect of the data analyst job market, as detailed below:

### 1. Top paying data analyst jobs

I filtered job postings by average yearly salary and location, focusing only on remote roles. The query below shows the highest-paying data analyst opportunities.
```sql
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
```
Here is a breakdown of the top data analyst jobs:

- **Wide salary range**: The top 10 roles range from $184K to $650K in average yearly salary.
- **Multi-industry demand**: High-paying employers come from a variety of industries (e.g., SmartAsset, AT&T, Meta).
- **Job title variety**: Titles range from Data Analyst to Director of Analytics.

![top paying jobs](assets\top_paying_roles.png)


### 2. Skills for top paying jobs

To understand the skill sets behind top-paying roles, I joined job postings with skills data to reveal what employers prioritize in high-compensation positions.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        company_dim.name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
```

Here’s a breakdown of the most in-demand skills for the top 10 highest-paying data analyst roles:

- **SQL** leads with a count of 8.
- **Python** follows closely with a count of 7.
- **Tableau** is also highly sought after, with a count of 6.
Other skills such as R, Snowflake, Pandas, and Excel show varying levels of demand.

![skills top jobs](assets\q2_count_skills.png)

### 3. In demand skills for data analysts

This query identifies the skills most frequently requested in job postings, helping highlight areas of high demand.

```sql
SELECT 
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_work_from_home = True
GROUP BY 
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5
```

Here’s a breakdown of the most in-demand skills for data analysts in 2023:

- **SQL and Excel** remain fundamental, highlighting the importance of strong foundational skills in data processing and spreadsheet analysis.

- Programming and visualization tools such as **Python, Tableau, and Power BI** are essential, reflecting the growing importance of technical skills for data storytelling and decision support.

![skills in demand](assets\q3.png)


*** 4. Skills based on salary

This analysis of average salaries by skill revealed which skills are most highly compensated.

```sql
SELECT 
    skills_dim.skills,
    ROUND (AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.salary_year_avg is not null
    -- AND job_work_from_home = True - use this for Remote
GROUP BY 
    skills_dim.skills
ORDER BY
    avg_salary DESC
LIMIT 25
```

Top-Paying Skills for Data Analysts

- **Big Data & ML: PySpark, Couchbase, DataRobot, Jupyter, Pandas, and NumPy** are highly valued for data processing and predictive modeling.
- **Software & Deployment Tools: GitLab, Kubernetes, and Airflow** skills command a premium due to their role in automation and efficient data pipelines.
- **Cloud Computing: Tools like Elasticsearch, Databricks, and GCP** highlight the growing importance of cloud-based analytics for higher salaries.

![top paying skills](assets\q4.png)


*** 5. Optimal skills to learn

By combining insights from skill demand and salary data, this query identifies skills that are both highly sought after and well-compensated, providing a strategic guide for skill development.

```sql
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
```
![q5](assets\q5.png)

Most Optimal Skills for Data Analysts

 - **Python & R**: High demand (236 & 148) with average salaries around $101K, showing broad value and accessibility.
- **Cloud Platforms**: Snowflake, Azure, AWS, BigQuery—high demand and high pay highlight the importance of cloud skills.
 **BI & Visualization**: Tableau and Looker enable actionable insights, with salaries around $99K–$104K.
- **Databases**: Oracle, SQL Server, and NoSQL remain essential, with salaries near $98K–$105K.


# What I learned 

**Complex Query Crafting**: Mastered advanced SQL techniques, expertly joining tables and using WITH clauses for temporary table management like a pro.

**Data Aggregation**: Became proficient with GROUP BY and aggregate functions such as COUNT() and AVG(), turning them into powerful tools for summarizing data.

**Analytics**: Enhanced real-world problem-solving skills, translating business questions into actionable, insightful SQL queries.

# Conclusion
### Insights


1. Top-Paying Data Analyst Jobs: Remote data analyst roles offer a wide salary range, with the highest-paying positions reaching up to $650,000.

2. Skills for Top-Paying Jobs: High-paying roles consistently require advanced SQL proficiency, highlighting its importance for top earners.

3. Most In-Demand Skills: SQL is the most frequently requested skill in the data analyst job market, making it essential for job seekers.

4. Skills Linked to Higher Salaries: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, reflecting a premium on niche expertise.

5. Optimal Skills for Market Value: SQL stands out as both highly in-demand and well-compensated, making it one of the most strategic skills for data analysts to learn to maximize career opportunities and earning potential.


