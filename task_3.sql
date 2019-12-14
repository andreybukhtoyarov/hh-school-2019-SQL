SELECT area_id,
       avg(
           CASE
             WHEN compensation_gross = true
               THEN compensation_from * 0.87
             ELSE compensation_from
             END
         ) AS c_from,
       avg(
           CASE
             WHEN compensation_gross = true
               THEN compensation_to * 0.87
             ELSE compensation_to
             END
         ) AS c_to,
       avg(
           CASE
             WHEN compensation_gross = true AND compensation_from > 0 AND compensation_to > 0
               THEN (compensation_to * 0.87 + compensation_from * 0.87) / 2
             WHEN compensation_from > 0 AND compensation_to > 0
               THEN (compensation_to + compensation_from) / 2
             ELSE 0
             END
         ) AS avg
FROM vacancy_body
GROUP BY area_id
ORDER BY area_id;
