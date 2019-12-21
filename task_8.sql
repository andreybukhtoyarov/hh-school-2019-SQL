CREATE FUNCTION execute() RETURNS TRIGGER AS $res_body$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    BEGIN
      UPDATE resume SET active = false WHERE old.resume_body_id = resume.resume_body_id;
      RETURN OLD;
    END;
  END IF;

  IF (TG_OP = 'UPDATE') THEN
    DECLARE
      id bigint := nextval('resume_body_resume_body_id_seq');
    BEGIN
      INSERT INTO resume_body (resume_body_id, name, description, education, driver_license_types, birthday,
                               area_id, compensation, experience)
      VALUES (id,
              OLD.name,
              OLD.description,
              OLD.education,
              OLD.driver_license_types,
              OLD.birthday,
              OLD.area_id,
              OLD.compensation,
              OLD.experience);

      INSERT INTO resume (resume_id, resume_body_id, user_id, creation_time, active)
      VALUES ((SELECT resume_id FROM resume WHERE resume.resume_body_id = old.resume_body_id),
              id,
              (SELECT user_id FROM resume WHERE resume.resume_body_id = old.resume_body_id),
              now(),
              false
             );
      UPDATE resume SET last_change_time = now()
      WHERE resume_id = (SELECT resume_id FROM resume WHERE resume.resume_body_id = old.resume_body_id)
        AND active = true;

      RETURN NEW;
    END;
  END IF;
END;

$res_body$ LANGUAGE plpgsql;

CREATE TRIGGER update_resume BEFORE UPDATE OR DELETE ON resume_body FOR EACH ROW
EXECUTE PROCEDURE execute();

-- Обновляем имя резюме по заданному resume_id
UPDATE resume_body SET name = ('New Name 1' || quote_literal(random() * 10))
WHERE resume_body_id = (SELECT resume_body_id FROM resume WHERE resume.resume_id = 5 AND resume.active = true);

-- Выводим историю именений названий резюме по заданному resume_id
SELECT resume_id, last_change_time, new_title, old_title FROM
  (SELECT ROW_NUMBER() OVER (ORDER BY last_change_time DESC) AS rn,
          resume_id,
          last_change_time,
          res_body.name AS new_title
   FROM resume
          JOIN resume_body AS res_body ON resume.resume_id = 5 AND resume.resume_body_id = res_body.resume_body_id
   ORDER BY last_change_time DESC
  ) AS first
    LEFT OUTER JOIN
  (SELECT ROW_NUMBER() OVER (ORDER BY last_change_time DESC) AS rn,
          res_body.name AS old_title
   FROM resume_body AS res_body
          JOIN resume AS res ON
         resume_id = 5
       AND res.resume_body_id = res_body.resume_body_id
       AND res_body.resume_body_id <>
           (SELECT resume_body_id FROM resume
            WHERE resume.resume_id = 5 ORDER BY last_change_time DESC LIMIT 1
           ) ORDER BY last_change_time DESC
  ) AS second
  USING (rn);
