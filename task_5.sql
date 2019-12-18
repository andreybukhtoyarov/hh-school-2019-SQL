SELECT name FROM vacancy_body AS v_b
WHERE EXISTS(
  SELECT vacancy_id FROM response
  WHERE 5 > (SELECT count(vac.vacancy_id) AS count FROM vacancy AS vac
               JOIN response AS resp
                   ON vac.vacancy_id = resp.vacancy_id
                      AND (resp.response_time - vac.creation_time) <= interval '7 day 00:00:00'
                      AND v_b.vacancy_body_id = vac.vacancy_body_id
                                             GROUP BY vac.vacancy_id)
  )
OR NOT EXISTS(
  SELECT first.vacancy_id FROM response AS first
  JOIN vacancy AS vac ON vac.vacancy_body_id = v_b.vacancy_body_id
)
ORDER BY name;


