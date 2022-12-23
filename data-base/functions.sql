/* 1) Get semestr by date*/
create or replace FUNCTION public.get_sem_by_date(date)
  RETURNS TABLE  (
  	"studying_year_id" UUID,
  	"year_number" varchar(9), 
  	"semestr_type" semestr_type, 
  	start_date date , 
  	end_date date
  	) 
 AS
$func$
SELECT
	studying_year.id,
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

DROP FUNCTION get_sem_by_date;

/* 2) Get last student status*/
create or replace FUNCTION public.get_last_student_status(UUID)
  RETURNS TABLE  (
  	"student_status" student_status_type,
	status_date timestamp
  	) 
 AS
$$
SELECT "student_status" student_status_type, status_date timestamp
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





/* 4) Get last student group id*/
create or replace FUNCTION public.get_last_student_group_id(UUID)
  RETURNS UUID 
 AS
$$
SELECT student_group.id
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
student_group.start_in_group_date = last_student_group.start_in_group_date;
$$ 
LANGUAGE SQL;

DROP FUNCTION get_last_student_group_id;


/* 5) Get semestr groups*/
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



/* 6) Create student*/
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
   
   INSERT INTO student_status  (id, student_id, student_status, status_date)
   VALUES (gen_random_uuid(), id, 'enrolled', CURRENT_TIMESTAMP);
  
   	RETURN id;
END
$$
LANGUAGE 'plpgsql';
 
 
 SELECT * FROM get_last_student_group ('f3ca4adc-03b6-409a-af3d-81e76572beca');

/* 7) expell student  на фронте надо проветить, есть ли у него последняя группа*/
CREATE OR REPLACE FUNCTION public.expell_student
(
	student_id UUID,
	OUT expelled_student_id UUID
) RETURNS UUID AS
$$
DECLARE
  last_student_group_id UUID;
BEGIN
	INSERT INTO student_status (id, student_id, student_status, status_date)
	VALUES (gen_random_uuid(), $1, 'expelled', CURRENT_TIMESTAMP );
	
	last_student_group_id = get_last_student_group_id($1);

	UPDATE student_group SET 
	end_in_group_date = CURRENT_DATE 
	WHERE student_group.student_id = $1 AND student_group.id = last_student_group_id
RETURNING student_group.student_id INTO "expelled_student_id";

END
$$
LANGUAGE 'plpgsql';


/* 8) enroll student  на фронте надо проветить, есть ли у него последняя группа*/
CREATE OR REPLACE FUNCTION public.enroll_student
(
	student_id UUID,
	group_id UUID,
	OUT enrolled_student_id UUID
) RETURNS UUID AS
$$
BEGIN
	INSERT INTO student_group (id, student_id, group_id, start_in_group_date, end_in_group_date)
   	VALUES (gen_random_uuid(), $1, $2, CURRENT_DATE, null);
   
   INSERT INTO student_status  (id, student_id, student_status, status_date)
   VALUES (gen_random_uuid(), $1, 'enrolled', CURRENT_TIMESTAMP)
   RETURNING student_status.student_id INTO "enrolled_student_id";
END
$$
LANGUAGE 'plpgsql';



/* 9) Get current student group*/
create or replace FUNCTION public.get_current_student_group(UUID)
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
		WHERE current_st_group.student_id  = student.id  AND student_group.end_in_group_date IS NULL
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


/* 10) Get current student group id*/
create or replace FUNCTION public.get_current_student_group_id(UUID)
 RETURNS UUID AS
$$
SELECT student_group.id
FROM (
	SELECT student.id AS student_id, student_group.group_id, MAX(student_group.start_in_group_date) AS start_in_group_date
	FROM student
	JOIN student_group 
	ON student.id = student_group.student_id  
	WHERE student_group.group_id  IN (
		SELECT current_st_group.group_id 
		FROM student_group AS current_st_group
		WHERE current_st_group.student_id  = student.id  AND student_group.end_in_group_date IS NULL
		ORDER BY current_st_group.start_in_group_date DESC 
		LIMIT 1
		) AND student.id = $1
	GROUP BY student.id, student_group.group_id
) AS "last_student_group"
JOIN student_group 
ON student_group.group_id  = last_student_group.group_id AND 
student_group.student_id = last_student_group.student_id AND 
student_group.start_in_group_date = last_student_group.start_in_group_date;
$$ 
LANGUAGE SQL;

'be875cb5-bacc-460d-8cfb-2823515398ae'

SELECT * FROM get_current_student_group_id('be875cb5-bacc-460d-8cfb-2823515398ae')

/* 11) transfer student  на фронте надо проветить, есть ли у него последняя группа*/
CREATE OR REPLACE FUNCTION public.transfer_student
(
	student_id UUID,
	group_id UUID,
	OUT enrolled_student_id UUID
) RETURNS UUID AS
$$
BEGIN
	UPDATE student_group  SET 
	end_in_group_date = current_date
	WHERE student_group.id = get_current_student_group_id($1);
	
	INSERT INTO student_group (id, student_id, group_id, start_in_group_date, end_in_group_date)
   	VALUES (gen_random_uuid(), $1, $2, CURRENT_DATE, null)
   	RETURNING $1 INTO "enrolled_student_id";
END
$$
LANGUAGE 'plpgsql';




/*
 * 12)Вывести расписание группы на неделю
 * Concat, BETWEEN, ORDER BY
 */
SELECT subject."name" AS "subject", 
 teacher."name",
 teacher."surname",
to_char(lesson.start_date, 'Day') AS "day", 
classroom."name" AS "classroom",
lesson.start_date,
lesson.duration ,
lesson."lesson_type",
"group"."id" AS group_id,
lesson.id AS lesson_id,
group_lesson.id AS group_lesson_id,
teacher.id AS teacher_id
FROM lesson  
JOIN teacher_subject  
ON lesson.teacher_subject_id = teacher_subject.id 
JOIN teacher 
ON teacher.id = teacher_subject.teacher_id 
JOIN subject 
ON subject.id = teacher_subject.subject_id 
JOIN group_lesson 
ON group_lesson.lesson_id = lesson.id 
JOIN "group" 
ON "group".id = group_lesson.group_id 
JOIN classroom 
ON lesson.classroom_id = classroom.id
WHERE "group".id = 'b9b6eff7-872b-4175-bb53-1405a1f4a2e3'
ORDER BY lesson.start_date;



INSERT INTO teacher(id,"name",surname,email,birthday,passport, phone_number, is_working)
VALUES (gen_random_uuid(), ) RETURNING id




DELETE FROM teacher_subject 
WHERE teacher_id = '07ad411d-3a11-4496-a119-6a11ebf6bc47';























INSERT INTO teacher_subject (teacher_id, subject_id)
VALUES('050101af-f537-4f6e-a702-b0e65a832e02', 'ce19da85-a5e8-4186-823b-38462ad5036c'), ('050101af-f537-4f6e-a702-b0e65a832e02', 'fa34ffa0-393f-4bdd-ad46-be27d57948e6')
ON CONFLICT DO  NOTHING;





SELECT * FROM subject ;



SELECT * FROM teacher 
JOIN teacher_subject 
ON teacher_subject.teacher_id =teacher.id 
JOIN subject
ON subject.id = teacher_subject.subject_id
ORDER BY teacher.id;
 
 
 SELECT teacher.id AS "teacher_id",
        teacher."name" AS "teacher_name", 
        teacher."surname" AS "teacher_surname", 
        teacher.email,
        teacher.birthday,
        teacher.passport,
        teacher.is_working,
        teacher_subject.subject_id,
        subject."name" AS "subject_name",
        "system_user".id AS user_login,
        "system_user"."role",
        "system_user"."login"
        FROM teacher 
        JOIN teacher_subject 
        ON teacher_subject.teacher_id =teacher.id 
        JOIN subject
        ON subject.id = teacher_subject.subject_id
       LEFT JOIN "system_user" 
       ON "system_user".person_id = teacher.id
        ;
 
 
 
 

 
 CREATE TRIGGER public.update_student_status_after_change_group
AFTER UPDATE ON classrom  
FOR EACH ROW
EXECUTE FUNCTION public.set_lesson_();

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











