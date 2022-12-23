/* 1) Get semestr by date*/
create or replace FUNCTION public.get_sem_by_date(date)
  RETURNS TABLE  (
  	"year_number" varchar(9), 
  	"semestr_type" semestr_type, 
  	start_date date , 
  	end_date date
  	) 
 AS
$func$
SELECT
	studying_year.year_number,
	studying_year.semestr_type,
	studying_year.start_date,
	studying_year.end_date
FROM
	studying_year
WHERE
	$1 BETWEEN studying_year.start_date AND studying_year.end_date
$func$ 
LANGUAGE SQL;

DROP FUNCTION get_student_last_stauts;



 2) Get last student status*/
create or replace FUNCTION public.get_last_student_stauts(UUID)
  RETURNS TABLE  (
  	"student_status" student_status_type,
	status_date date
  	) 
 AS
$$
SELECT "student_status" student_status_type, status_date date
FROM student 
JOIN student_status 
ON student.id = student_status.student_id 
WHERE student.id = $1 
ORDER BY status_date DESC
LIMIT 1
$$ 
LANGUAGE SQL;

/* 3) Get last student group*/
create or replace FUNCTION public.get_last_student_group(UUID)
  RETURNS TABLE  (
  	group_id UUID,
  	start_in_group_date date,
  	end_in_group_date date 
  	) 
 AS
$$
SELECT student_group.group_id, student_group.start_in_group_date, student_group.end_in_group_date
FROM (
	SELECT student.id AS student_id, student_group.group_id, MAX(student_group.start_in_group_date) AS start_in_group_date
	FROM student
	JOIN student_group 
	ON student.id = student_group.student_id  
	WHERE student_group.group_id  IN (
		SELECT current_st_group.group_id 
		FROM student_group AS current_st_group
		WHERE current_st_group.student_id  = student.id  
		ORDER BY current_st_group.start_in_group_date DESC 
		LIMIT 1
		) AND student.id = $1
	GROUP BY student.id, student_group.group_id
) AS "last_student_group"
JOIN student_group 
ON student_group.group_id  = last_student_group.group_id AND 
student_group.student_id = last_student_group.student_id AND 
student_group.start_in_group_date = last_student_group.start_in_group_date
$$ 
LANGUAGE SQL;



/* 4) Get semestr groups*/
create or replace FUNCTION public.get_semestr_groups(date)
  RETURNS TABLE  (
  	group_id UUID,
  	code_number varchar(5),
  	studying_plan_id UUID,
  	semestr_number int
  	) 
 AS
$$
SELECT "group".id AS group_id ,
"group".code_number ,
"group".studying_plan_id ,
"group".semestr_number 
FROM "group"
JOIN studying_plan 
ON studying_plan.id = "group".studying_plan_id 
CROSS JOIN get_sem_by_date($1) AS current_sem
JOIN studying_year 
ON studying_plan.start_year = studying_year.id
WHERE 
	(
		date_part('year', current_sem.start_date) - 
		date_part('year', studying_year.start_date) = 
		"group".semestr_number /2) 
	AND 
	(
		(studying_year.semestr_type='autumn' AND "group".semestr_number % 2 = 1) 
		OR 
		(studying_year.semestr_type='spring' AND "group".semestr_number % 2 = 0)
	);
$$ 
LANGUAGE SQL;



/* 5) Create student*/
CREATE OR REPLACE FUNCTION public.create_student
(
	"name" varchar(50), 
	surname varchar(50), 
	email varchar(100), 
	birthday date, 
	passport varchar(10), 
	phone_number varchar(20),
	group_id UUID
) RETURNS UUID AS
$$
DECLARE
  id UUID;
BEGIN
	id = gen_random_uuid();
    INSERT INTO student (id, "name", surname, email, birthday, passport, phone_number) 
    VALUES (id,$1,$2,$3,$4,$5,$6);
   
   	INSERT INTO student_group (id, student_id, group_id, start_in_group_date, end_in_group_date)
   	VALUES (gen_random_uuid(), id, $7, CURRENT_DATE, null);
   
--   INSERT INTO student_status  (id, student_id, student_status, status_date)
--   VALUES (gen_random_uuid(), id, 'enrolled', CURRENT_DATE);
  
   	RETURN id;
END
$$
  LANGUAGE 'plpgsql';

 
 
 
 CREATE TRIGGER public.update_student_status_after_change_group
AFTER INSERT ON student_group 
FOR EACH ROW
EXECUTE FUNCTION set_token_used();

CREATE OR REPLACE FUNCTION set_token_used() RETURNS TRIGGER
AS $$
BEGIN
UPDATE "registration_token"
SET "is_used" = TRUE
WHERE "token" = NEW."token";
RETURN NEW;
END;
$$
LANGUAGE PLPGSQL
 
 
 
 
 
 
 
 
 
 
 
 
 

DROP FUNCTION public.create_student;

DELETE FROM student_status 
WHERE student_status.student_id = 'f467a39c-7f2e-418c-ab86-cebc5c335c0a';

WITH status_del AS (
	DELETE FROM student_group
	WHERE student_group.student_id = 'f467a39c-7f2e-418c-ab86-cebc5c335c0a'
	RETURNING student_group.student_id 
)
DELETE FROM student WHERE student.id IN (SELECT * FROM status_del);






SELECT * FROM create_person('Evgeny', 'Sudakov', 'Sudach@ebu.darkhole', '2003-02-28', '1490111222', '89812281488', 'da5f9b0e-c590-45a3-8ea1-e1d9c63e4895');

SELECT * FROM student 
JOIN student 


INSERT INTO "system_user" 
        ("id", "login", "hashed_password", "role", "person_id")
        VALUES (gen_random_uuid(), 'chel', '12454', 'student', '661908e7-b719-4129-8db8-fd760484fe87');




SELECT * FROM get_semestr_groups(CURRENT_DATE);

SELECT semestr_groups.group_id AS group_id ,
semestr_groups.code_number ,
semestr_groups.studying_plan_id ,
semestr_groups.semestr_number ,
direction_id,
direction."name" AS direction_name,
direction."direction_type",
studying_plan.id AS studying_plan_id,
institute.id AS institute_id,
institute."name" AS institute_name
FROM get_semestr_groups(CURRENT_DATE) AS semestr_groups
JOIN studying_plan  
ON studying_plan.id = semestr_groups.studying_plan_id
JOIN direction  
ON direction.id = studying_plan.direction_id 
JOIN institute 
ON institute.id = direction.institute_id 
;








SELECT *
FROM "group" 
JOIN studying_plan 
ON studying_plan.id = "group".studying_plan_id 
CROSS JOIN get_sem_by_date(CURRENT_DATE) AS current_sem
JOIN studying_year 
ON studying_plan.start_year = studying_year.id
WHERE 
	(
		date_part('year', current_sem.start_date) - 
		date_part('year', studying_year.start_date) = 
		"group".semestr_number /2) 
	AND 
	(
		(studying_year.semestr_type='autumn' AND "group".semestr_number % 2 = 1) 
		OR 
		(studying_year.semestr_type='spring' AND "group".semestr_number % 2 = 0)
	);



SELECT * FROM get_sem_by_date(CURRENT_DATE);


SELECT * FROM get_last_student_group('de3887fb-5415-4862-be0e-4630f3374c04');







997351a9-a9b1-434f-927d-e36f4e0b8ee1

INSERT INTO "studying_year" (id, year_number, semestr_type, start_date, end_date) 
VALUES (gen_random_uuid (), '2022/2023', 'autumn', '2022-09-01', '2023-01-25');

INSERT INTO "studying_year" (id, year_number, semestr_type, start_date, end_date, start_session_date, end_session_date) 
VALUES (gen_random_uuid (), '2021/2022', 'autumn', '2021-09-01', '2022-01-25', '2021-12-16','2022-01-25');

INSERT INTO "studying_year" (id, year_number, semestr_type, start_date, end_date, start_session_date, end_session_date) 
VALUES (gen_random_uuid (), '2021/2022', 'spring', '2022-01-26', '2022-08-31', '2022-06-01','2022-07-02');

INSERT INTO "studying_year" (id, year_number, semestr_type, start_date, end_date, start_session_date, end_session_date) 
VALUES (gen_random_uuid (), '2020/2021', 'autumn', '2020-09-01', '2021-01-25', '2020-12-16','2021-01-25');

INSERT INTO "studying_year" (id, year_number, semestr_type, start_date, end_date, start_session_date, end_session_date) 
VALUES (gen_random_uuid (), '2020/2021', 'spring', '2021-01-26', '2021-08-31','2021-06-01','2022-07-02');

INSERT INTO "group"  ("id",  semestr_number, code_number, studying_plan_id  ) 
VALUES(gen_random_uuid () ,  3, '00302', '0dbb7e3a-2a91-4c34-a9e0-41c1fcb00fc2');

INSERT INTO studying_plan  ("id", direction_id  , start_year  ) 
VALUES(gen_random_uuid ()  , '3c7e1c5e-397f-467e-b958-ebbb3a1b2c68', '68dd368f-09ce-4cd3-9632-fb5fe6de686e');




UPDATE student SET
"name" = 'Nikita',
"surname" = 'Dimitryuk',
"email" = 'Nikita.Dimitryuk@gmail.com',
phone_number = '89111488228'
WHERE student.id = '997351a9-a9b1-434f-927d-e36f4e0b8ee1';











