-- Identify the top 10 highest-paying Data Analyst roles that are available remotely
-- Find out what skills is needed for these jobs
WITH top_10_data_analyst_jobs AS (
    SELECT
        job_id,
        job_title,
        company_dim.name AS company_name,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date
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
        top_10_data_analyst_jobs.job_id,
        top_10_data_analyst_jobs.job_title,
        salary_year_avg,
        job_skills.skill_id,
        job_skills.skill_name,
        job_skills.skill_type
FROM
    top_10_data_analyst_jobs
INNER JOIN (
    SELECT
        skills_job_dim.job_id AS job_id,
        skills_job_dim.skill_id AS skill_id,
        skills_dim.skills AS skill_name,
        skills_dim.type AS skill_type
    FROM
        skills_job_dim
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
) AS job_skills ON top_10_data_analyst_jobs.job_id = job_skills.job_id
;