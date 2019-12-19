CREATE FUNCTION execute() RETURNS TRIGGER AS $res_body$
BEGIN
  IF (TG_OP = 'DELETE') THEN
    BEGIN
      UPDATE resume SET active = false WHERE old.resume_body_id = resume.resume_body_id;
      RETURN OLD;
    END;
  END IF;

  IF (TG_OP = 'UPDATE') THEN
    BEGIN
      $1 := nextval('resume_body_resume_body_id_seq');
      INSERT INTO resume_body (resume_body_id, name, description, education, driver_license_types, birthday,
                               area_id, compensation, experience)
      VALUES ($1,
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
              $1,
              (SELECT user_id FROM resume WHERE resume.resume_body_id = old.resume_body_id),
              (SELECT creation_time FROM resume WHERE resume.resume_body_id = old.resume_body_id),
              false
             );
      UPDATE resume SET creation_time = now()
      WHERE resume_id = (SELECT resume_id FROM resume WHERE resume.resume_body_id = old.resume_body_id)
        AND active = true;

      RETURN NEW;
    END;
  END IF;
END;

$res_body$ LANGUAGE plpgsql;

CREATE TRIGGER update_resume BEFORE UPDATE OR DELETE ON resume_body FOR EACH ROW
EXECUTE PROCEDURE execute();
