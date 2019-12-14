
CREATE TABLE IF NOT EXISTS vacancy_body (
    vacancy_body_id serial PRIMARY KEY,
    company_name varchar(150) DEFAULT ''::varchar NOT NULL,
    name varchar(220) DEFAULT ''::varchar NOT NULL,
    text text,
    area_id integer,
    address_id integer,
    work_experience integer DEFAULT 0 NOT NULL,
    compensation_from bigint DEFAULT 0,
    compensation_to bigint DEFAULT 0,
    test_solution_required boolean DEFAULT false NOT NULL,
    work_schedule_type integer DEFAULT 0 NOT NULL,
    employment_type integer DEFAULT 0 NOT NULL,
    compensation_gross boolean,
    driver_license_types varchar(5)[],
    CONSTRAINT vacancy_body_work_employment_type_validate CHECK ((employment_type = ANY (ARRAY[0, 1, 2, 3, 4]))),
    CONSTRAINT vacancy_body_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY[0, 1, 2, 3, 4])))
);

CREATE TABLE IF NOT EXISTS vacancy (
    vacancy_id serial PRIMARY KEY,
    vacancy_body_id integer DEFAULT 0 NOT NULL,
    creation_time timestamp NOT NULL,
    expire_time timestamp NOT NULL,
    employer_id integer DEFAULT 0 NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    area_id integer,
    FOREIGN KEY(vacancy_body_id) REFERENCES vacancy_body(vacancy_body_id)
);

CREATE TABLE IF NOT EXISTS specializations (
  specialization_id serial PRIMARY KEY,
  name varchar(150) DEFAULT ''::varchar NOT NULL,
  description varchar(220) DEFAULT ''::varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS vacancy_body_specialization (
    vacancy_body_id integer DEFAULT 0 NOT NULL,
    specialization_id integer DEFAULT 0 NOT NULL,
    FOREIGN KEY(vacancy_body_id) REFERENCES vacancy_body(vacancy_body_id),
    FOREIGN KEY(specialization_id) REFERENCES specializations(specialization_id)
);

CREATE TABLE IF NOT EXISTS resume_body (
  resume_body_id serial PRIMARY KEY,
  name varchar(220) DEFAULT ''::varchar NOT NULL,
  description varchar(220) DEFAULT ''::varchar NOT NULL,
  education varchar(220) DEFAULT ''::varchar NOT NULL,
  driver_license_types varchar(5)[],
  birthday timestamp NOT NULL,
  area_id integer DEFAULT 0 NOT NULL,
  compensation bigint DEFAULT 0 NOT NULL,
  experience integer DEFAULT 0 NOT NULL
);

CREATE TABLE IF NOT EXISTS resume (
  resume_id serial PRIMARY KEY,
  resume_body_id integer DEFAULT 0 NOT NULL,
  user_id integer DEFAULT 0 NOT NULL,
  creation_time timestamp NOT NULL,
  active boolean DEFAULT true NOT NULL,
  FOREIGN KEY(resume_body_id) REFERENCES resume_body(resume_body_id)
);

CREATE TABLE IF NOT EXISTS resume_body_specialization (
  resume_body_id integer DEFAULT 0 NOT NULL,
  specialization_id integer DEFAULT 0 NOT NULL,
  FOREIGN KEY(resume_body_id) REFERENCES resume_body(resume_body_id),
  FOREIGN KEY(specialization_id) REFERENCES specializations(specialization_id)
);

CREATE TABLE IF NOT EXISTS response (
  vacancy_id integer DEFAULT 0 NOT NULL,
  resume_id integer DEFAULT 0 NOT NULL,
  response_time timestamp NOT NULL,
  FOREIGN KEY(vacancy_id) REFERENCES vacancy(vacancy_id),
  FOREIGN KEY(resume_id) REFERENCES resume(resume_id)
);
