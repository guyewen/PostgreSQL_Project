-- What are the most in-demand skills for data analysts?
WITH top_5_skills_for_data_analyst AS (
    SELECT
        skills_job_dim.skill_id AS skill_id,
        COUNT(skill_id) AS num_jobs
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE job_postings_fact.job_title_short = 'Data Analyst'
    GROUP BY skill_id
    ORDER BY num_jobs DESC
    LIMIT 5
)
SELECT
    top_5_skills_for_data_analyst.skill_id,
    num_jobs,
    skills,
    type
FROM top_5_skills_for_data_analyst
INNER JOIN skills_dim ON top_5_skills_for_data_analyst.skill_id = skills_dim.skill_id
ORDER BY num_jobs DESC
;