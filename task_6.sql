SELECT res_id, array_agg(arr), spec FROM
  (SELECT res_id, arr, max(count), spec FROM
    (SELECT res_id, arr, count(v_b_s.specialization_id) AS count, v_b_s.specialization_id AS spec FROM
      (SELECT res_id, arr, vac_id, vac.vacancy_body_id AS v_b_id FROM
        (SELECT res_id, arr, resp.vacancy_id AS vac_id FROM
          (SELECT resume_id AS res_id, rbs.specialization_id AS arr FROM resume
              JOIN resume_body_specialization AS rbs ON resume.resume_body_id = rbs.resume_body_id
           GROUP BY resume_id, arr) AS first
            JOIN response AS resp ON first.res_id = resp.resume_id
         GROUP BY res_id, arr, vac_id) AS second
          JOIN vacancy AS vac ON vac_id = vac.vacancy_id
       GROUP BY res_id, arr, vac_id, v_b_id) AS third
        JOIN vacancy_body_specialization AS v_b_s ON v_b_s.vacancy_body_id = v_b_id
     GROUP BY res_id, arr, spec) AS fourth
   GROUP BY res_id, arr, spec) AS fifth
GROUP BY res_id, spec;
