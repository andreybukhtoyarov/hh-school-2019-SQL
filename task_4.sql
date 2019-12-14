SELECT *
FROM
(SELECT date_trunc('month', creation_time) AS month_resume, count(resume_id) AS count
   FROM resume
   GROUP BY month_resume
   ORDER BY count DESC
   LIMIT 1
  ) AS res_count
JOIN
  (SELECT date_trunc('month', creation_time) AS month_vac, count(vacancy_id) AS count
   FROM vacancy
   GROUP BY month_vac
   ORDER BY count DESC
   LIMIT 1
  ) AS vac_count
ON true;
