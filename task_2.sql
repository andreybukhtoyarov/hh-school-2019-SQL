INSERT INTO vacancy_body(
  company_name, name, text, area_id, address_id, work_experience,
  compensation_from, compensation_to, test_solution_required,
  work_schedule_type, employment_type, compensation_gross, driver_license_types
)
SELECT
  (SELECT ALL string_agg(
                  substr(
                      '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                      (random() * 77)::integer, 1
                    ),
                  '')
   FROM generate_series(1, 1 + ((random() * 100 + i % 10)::int % 10)::integer)) AS company_name,

  (SELECT ALL string_agg(
                  substr(
                      '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                      (random() * 77)::integer, 1
                    ),
                  '')
   FROM generate_series(1, 1 + ((random() * 200 + i % 10)::int % 10)::integer)) AS name,

  (SELECT ALL string_agg(
                  substr(
                      '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                      (random() * 77)::integer, 1
                    ),
                  '')
   FROM generate_series(1, 1 + (random() * 50 + i % 10)::integer % 10)) AS text,

  (random() * 1000)::int AS area_id,
  (random() * 50000)::int AS address_id,
  (random() * 500)::int AS work_experience,
  25000 + (random() * 1500)::int AS compensation_from,
  50000 + (random() * 150000)::int AS compensation_to,
  (random() > 0.5) AS test_solution_required,
  floor(random() * 4)::int AS work_schedule_type,
  floor(random() * 4)::int AS employment_type,
  (random() > 0.5) AS compensation_gross,
  (SELECT ARRAY[ string_agg(
      substr(
          'ABCD',
          ((random() * 3 + i % 2)::int)::integer, 1
        ),
      '')]
   FROM generate_series(1, 1) AS h(i))::varchar[] AS driver_license_types
FROM generate_series(1, 10000) AS g(i);

INSERT INTO vacancy (vacancy_body_id, creation_time, expire_time, employer_id, disabled, visible, area_id)
SELECT
  -- random in last 5 years
  (SELECT vacancy_body_id FROM vacancy_body WHERE vacancy_body_id = i) AS vacancy_body_id,
  now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS creation_time,
  now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS expire_time,
  (random() * 1000000)::int AS employer_id,
  (random() > 0.5) AS disabled,
  (random() > 0.5) AS visible,
  (random() * 1000)::int AS area_id
FROM generate_series(1, (SELECT count(vacancy_body_id) FROM vacancy_body)) AS g(i);

-- Delete invalid records
DELETE FROM vacancy WHERE expire_time <= creation_time;

INSERT INTO specialization (name, description)
SELECT
  (SELECT ALL string_agg(
                  substr(
                      '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                      (random() * 77)::integer, 1
                    ),
                  '')
   FROM generate_series(1, 1 + ((random() * 100 + i % 10)::int % 10)::integer)) AS company_name,
  (SELECT ALL string_agg(
                  substr(
                      '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                      (random() * 77)::integer, 1
                    ),
                  '')
   FROM generate_series(1, 1 + ((random() * 200 + i % 10)::int % 10)::integer)) AS company_name
FROM generate_series(1, 1000) AS g(i);

INSERT INTO vacancy_body_specialization (vacancy_body_id, specialization_id)
SELECT
  (SELECT vacancy_body_id FROM vacancy_body WHERE vacancy_body_id = i) AS vacancy_body_id,
  (SELECT ((random() * 700)::int  + i % 2 + 1)::integer)
FROM generate_series(1, (SELECT count(vacancy_body_id) FROM vacancy_body)) AS g(i);

INSERT INTO vacancy_body_specialization (vacancy_body_id, specialization_id)
SELECT
  (SELECT (
    (random() * ((SELECT count(vacancy_body_id) FROM vacancy_body) - (random() * 1000)::int  + i % 2 + 1)::integer
    )::int  + i % 2 + 1)::integer) AS vacancy_body_id,
  (SELECT ((random() * 700)::int  + i % 2 + 1)::integer)
FROM generate_series(1, (SELECT count(vacancy_body_id) FROM vacancy_body)) AS g(i);

INSERT INTO resume_body(
  name, description, education, driver_license_types, birthday,
  area_id, compensation, experience
)
SELECT
  (SELECT ALL string_agg(
                  substr(
                      '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                      (random() * 77)::integer, 1
                    ),
                  '')
   FROM generate_series(1, 1 + ((random() * 200 + i % 10)::int % 10)::integer)) AS name,

  (SELECT ALL string_agg(
                  substr(
                      '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                      (random() * 77)::integer, 1
                    ),
                  '')
   FROM generate_series(1, 1 + ((random() * 200 + i % 10)::int % 10)::integer)) AS description,

  (SELECT ALL string_agg(
                  substr(
                      '      abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                      (random() * 77)::integer, 1
                    ),
                  '')
   FROM generate_series(1, 1 + ((random() * 200 + i % 10)::int % 10)::integer)) AS education,

  (SELECT ARRAY[ string_agg(
      substr(
          'ABCD',
          ((random() * 3 + i % 2)::int)::integer, 1
        ),
      '')]
   FROM generate_series(1, 1) AS h(i))::varchar[] AS driver_license_types,

  now()-(random() * 365 * 24 * 3600 * 20) * '1 second'::interval AS birthday,
  (random() * 1000)::int AS area_id,
  30000 + (random() * 80000)::bigint AS compensation,
  (random() * 5)::int AS experience
FROM generate_series(1, 100000) AS g(i);

INSERT INTO resume (
  resume_body_id, user_id, creation_time, active
)
SELECT
  (SELECT resume_body_id FROM resume_body WHERE resume_body_id = i) AS resume_body_id,
  (random() * 1000000)::int AS user_id,
  now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS creation_time,
  (random() > 0.5) AS active
FROM generate_series(1, 100000) AS g(i);

INSERT INTO resume_body_specialization (resume_body_id, specialization_id)
SELECT
  (SELECT resume_body_id FROM resume_body WHERE resume_body_id = i) AS resume_body_id,
  (SELECT ((random() * 700)::int  + i % 2 + 1)::integer)
FROM generate_series(1, (SELECT count(resume_body_id) FROM resume_body)) AS g(i);

INSERT INTO resume_body_specialization (resume_body_id, specialization_id)
SELECT
  (SELECT (
    (random() * ((SELECT count(resume_body_id) FROM resume_body) - (random() * 1000)::int  + i % 2 + 1)::integer
  )::int  + i % 2 + 1)::integer) AS resume_body_id,
  (SELECT ((random() * 700)::int  + i % 2 + 1)::integer)
FROM generate_series(1, (SELECT count(resume_body_id) FROM resume_body)) AS g(i);

INSERT INTO response (vacancy_id, resume_id, response_time)
SELECT vac_id, res_id, response_time
FROM
  (SELECT ROW_NUMBER() OVER () AS rn, (random() * 10000 + i % 2 + 1)::int AS vac_id FROM generate_series(1, 50000) AS g(i)) AS QV
    JOIN
  (SELECT ROW_NUMBER() OVER () AS rn, (random() * 90000 + i % 2 + 1)::int AS res_id FROM generate_series(1, 50000) AS g(i)) AS QR
  USING(rn)
    JOIN
  (SELECT ROW_NUMBER() OVER () AS rn, now()-(random() * 365 * 24 * 3600 * 5) * '1 second'::interval AS response_time
   FROM generate_series(1, 50000) AS g(i)) AS T
  USING(rn) WHERE vac_id IN (SELECT vacancy_id FROM vacancy) AND res_id IN (SELECT resume_id FROM resume);

-- Delete invalid records
DELETE FROM response AS resp WHERE
  response_time <= (SELECT creation_time FROM vacancy AS vac WHERE vac.vacancy_id = resp.vacancy_id)
  OR
  (SELECT active FROM resume WHERE resume_id = resp.resume_id) = false;
