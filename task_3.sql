SELECT area_id,
       avg(
           CASE
             WHEN compensation_gross = true AND compensation_from NOTNULL
               THEN compensation_from * 0.87
             WHEN compensation_gross = false AND compensation_from NOTNULL
               THEN compensation_from
             ELSE 0
             END
         ) AS avg_comp_from,
       avg(
           CASE
             WHEN compensation_gross = true AND compensation_to NOTNULL
               THEN compensation_to * 0.87
             WHEN compensation_gross = false AND compensation_to NOTNULL
               THEN compensation_to
             ELSE 0
             END
         ) AS avg_comp_to,
       avg(
           CASE
             WHEN compensation_gross = true AND compensation_from NOTNULL AND compensation_to NOTNULL
               THEN (compensation_to * 0.87 + compensation_from * 0.87) / 2
             WHEN compensation_gross = false AND compensation_from NOTNULL AND compensation_to NOTNULL
               THEN (compensation_to + compensation_from) / 2
             ELSE 0
             END
         ) AS avg_comp_from_comp_to
FROM vacancy_body
GROUP BY area_id
ORDER BY area_id;
