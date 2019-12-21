WITH res_id_res_spec_arr AS (
       SELECT resume_id AS res_id, array_agg(rbs.specialization_id) AS res_spec_arr FROM resume
       JOIN resume_body_specialization AS rbs ON resume.active = true AND resume.resume_body_id = rbs.resume_body_id
  GROUP BY res_id
     ), plus_vac_id AS (
  SELECT res_id, res_spec_arr, resp.vacancy_id AS vac_id FROM res_id_res_spec_arr
       JOIN response AS resp ON res_id_res_spec_arr.res_id = resp.resume_id
), plus_vac_body_id AS (
  SELECT res_id, res_spec_arr, vac_id, vac.vacancy_body_id AS vac_body_id FROM plus_vac_id
  JOIN vacancy AS vac ON vac_id = vac.vacancy_id
     GROUP BY res_id, res_spec_arr, vac_id, vac_body_id
), count_vac_body_spec AS (
  SELECT res_id, res_spec_arr, count(vac_body_spec.specialization_id) AS count, vac_body_spec.specialization_id AS spec FROM plus_vac_body_id
  JOIN vacancy_body_specialization AS vac_body_spec ON vac_body_spec.vacancy_body_id = vac_body_id
   GROUP BY res_id, res_spec_arr, spec
), max_count AS (
  SELECT res_id, res_spec_arr, max(count) AS max FROM count_vac_body_spec
  GROUP BY res_id, res_spec_arr
)
SELECT DISTINCT ON (max_count.res_id) max_count.res_id, max_count.res_spec_arr, count_vac_body_spec.spec FROM max_count
JOIN count_vac_body_spec ON max_count.res_id = count_vac_body_spec.res_id AND max = count_vac_body_spec.count
GROUP BY max_count.res_id, max_count.res_spec_arr, count_vac_body_spec.spec ORDER BY res_id;
