{{ config(materialized='table') }}
SELECT *
FROM bigquery-public-data.stackoverflow.posts_questions
ORDER BY view_count DESC
LIMIT 1
