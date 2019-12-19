SELECT month_resume, month_vac
FROM
(SELECT date_part('month', creation_time) AS month_resume
   FROM resume WHERE active = true
   GROUP BY month_resume
   ORDER BY count(resume_id) DESC
   LIMIT 1
  ) AS res_count
JOIN
  (SELECT date_part('month', creation_time) AS month_vac
   FROM vacancy
   GROUP BY month_vac
   ORDER BY count(vacancy_id) DESC
   LIMIT 1
  ) AS vac_count
ON true;
