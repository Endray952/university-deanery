/*
 * 1) Оценки студента по определенному предмету в семестре
 * Подзапрос + INNER JOIN + WHERE
 */
SELECT student_mark.mark_value AS "mark", to_char(lesson.start_date, 'dd.mm.yyyy') AS "lesson_date", subject."name" AS "subject_name"
FROM (
    SELECT mark.id, mark.lesson_id, mark.mark_value
    FROM mark
    JOIN student
    ON mark.student_id = student.id AND student."name" ='Angel'AND student.surname = 'Claudia'
    JOIN student_group 
    ON student_group.student_id = student.id
    JOIN "group" 
    ON "group".id = student_group.group_id 
    WHERE "group".semestr_number = 1
) AS student_mark
JOIN lesson
ON lesson.id = student_mark.lesson_id
JOIN teacher_subject 
ON lesson.teacher_subject_id  = teacher_subject.id
JOIN subject 
ON teacher_subject.subject_id = subject.id
WHERE subject."name" = 'Математический анализ';


/*
 * 2)Вывести расписание группы на неделю
 * Concat, BETWEEN, ORDER BY
 */
SELECT subject."name" AS "subject", 
concat( teacher."name", ' ', teacher."surname") AS "teacher",
to_char(lesson.start_date, 'Day') AS "day", 
concat( to_char(lesson.start_date, 'HH:MI'),'-',to_char(lesson.end_date, 'HH:MI')) AS "time",
classroom."name" AS "classroom"
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
WHERE "group".code_number = '00002' AND (lesson.start_date BETWEEN '2022-09-05' AND '2022-09-11')
ORDER BY lesson.start_date;


/*
 * 3)Вывести группы определенного нарпавления и семестра, в которых сейчас меньше 25 человек (5 семестр)
 * GROUP BY, HAVING, COUNT
 */
SELECT "group".code_number , COUNT(*) AS "students_number", 25 - COUNT(*) AS "free places"
FROM "group"
JOIN studying_plan 
ON "group".studying_plan_id = studying_plan.id
JOIN direction 
ON direction.id = studying_plan.direction_id  
JOIN (SELECT student.id , student_group.group_id
		FROM student
		JOIN student_group
		ON student.id = student_group.student_id
		JOIN student_status
		ON student.id = student_status.student_id
		WHERE student_group.end_in_group_date IS NULL) AS "studying_students"
ON "group".id = studying_students.group_id
JOIN studying_year  
ON studying_year.id = studying_plan.start_year 
CROSS JOIN get_sem_by_date(CURRENT_DATE)  AS current_semestr
WHERE 
(date_part('year', current_semestr.start_date) - date_part('year', studying_year.start_date) = 1/2 ) AND 
"group".semestr_number = 1 AND 
direction."name" = 'Прикладная математика и ифнорматика'
GROUP BY "group".code_number 
HAVING COUNT(*) < 25
ORDER BY COUNT(*);

/*
 * function to get studying year from studying_year table by date
 */
CREATE OR REPLACE
FUNCTION public.get_sem_by_date(date)
  RETURNS TABLE (
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

/*
 * 4)Вывести учителей и оснонвые предметы, по которым у них есть занятия в этом семестре
 * LEFT JOIN, CROSS JOIN
 */
SELECT DISTINCT concat( teacher."name", ' ', teacher."surname") AS "teacher", held_subjects."name" 
FROM teacher
LEFT JOIN ( 
	SELECT * from
	teacher_subject 
	CROSS JOIN get_sem_by_date(CURRENT_DATE)  AS current_semestr
	JOIN subject 
	ON subject.id = teacher_subject.subject_id 
	LEFT JOIN lesson 
	ON lesson.teacher_subject_id = teacher_subject.id AND
	lesson.start_date BETWEEN current_semestr.start_date AND current_semestr.end_date 
	) 
	AS held_subjects
ON teacher.id = held_subjects.teacher_id 
ORDER BY concat( teacher."name", ' ', teacher."surname");



/*
 * 5)Вывести студентов, которые не оставляли отзыв
 * EXCEPT
 */
SELECT concat(student."name", ' ', student .surname ) AS "student name", student.email, student.phone_number 
FROM student
EXCEPT
SELECT concat(student."name", ' ', student .surname ) AS "student name", student.email, student.phone_number 
FROM student
JOIN feedback 
ON feedback.student_id = student.id;


/*
 * 6)Вывести основные и дополнительные предметы, которые ведет учитель в этом семестре
 * UNION, DISTINCT
 */
SELECT * FROM
(
	SELECT DISTINCT subject."name" AS "subject name", 'main' AS "subject_type"
	FROM lesson 
	CROSS JOIN get_sem_by_date(CURRENT_DATE)  AS current_semestr
	JOIN teacher_subject 
	ON lesson.teacher_subject_id = teacher_subject.id 
	JOIN subject 
	ON teacher_subject.subject_id = subject.id 
	JOIN teacher  
	ON teacher_subject.teacher_id = teacher.id 
	WHERE (lesson.start_date BETWEEN current_semestr.start_date AND current_semestr.end_date) AND 
	teacher.id = '14df7baa-95f4-4607-9112-890c1c2cd1f1'
	UNION 
	SELECT DISTINCT subject."name", 'extra' AS "subject_type"
	FROM extra_classes 
	CROSS JOIN get_sem_by_date(CURRENT_DATE)  AS current_semestr
	JOIN subject 
	ON subject.id = extra_classes.subject_id 
	JOIN teacher 
	ON teacher.id = extra_classes.teacher_id  
	WHERE (extra_classes.start_date BETWEEN current_semestr.start_date AND current_semestr.end_date) AND 
	teacher.id = '14df7baa-95f4-4607-9112-890c1c2cd1f1'
) AS subjects
ORDER BY subjects.subject_type DESC;





/*
 * Список предметов на изучение в текущем семестре для студента
 * Сложные условия с датами
 */
SELECT subject."name", subject_plan.lectures_number , subject_plan.practices_number , subject_plan.assesment_type 
FROM student_group 
JOIN student 
ON student.id = student_group.student_id AND student.id = '024a6e9d-37c3-4751-b899-7b576784cae7'
JOIN "group" 
ON "group".id = student_group.group_id 
JOIN studying_plan 
ON studying_plan.id = "group".studying_plan_id 
JOIN studying_year 
ON studying_year.id = studying_plan.start_year 
JOIN semestr_plan  
ON semestr_plan.studying_plan_id  = studying_plan.id AND "group".semestr_number = semestr_plan.semestr 
JOIN subject_plan 
ON subject_plan.semestr_plan_id  = semestr_plan.id
JOIN subject 
ON subject_plan.subject_id  = subject.id
CROSS JOIN get_sem_by_date(CURRENT_DATE) AS current_semestr 
WHERE student_group.end_in_group_date IS NULL AND 
date_part('year', current_semestr.start_date) - date_part('year', studying_year.start_date) = "group".semestr_number /2;



--subject."name", subject_plan.lectures_number , subject_plan.practices_number , subject_plan.assesment_type, "group".code_Number
/*
 * Список предметов на изучение в определенном семестре для студента
 * Сложные условия с датами
 */
SELECT  subject."name", subject_plan.lectures_number , subject_plan.practices_number , subject_plan.assesment_type, "group".code_Number
FROM student_group 
JOIN student 
ON student.id = student_group.student_id AND student.id = 'd217a5a8-cf2d-4682-8697-e9226367371c'
JOIN "group" 
ON "group".id = student_group.group_id 
JOIN studying_plan 
ON studying_plan.id = "group".studying_plan_id 
JOIN studying_year 
ON studying_year.id = studying_plan.start_year 
JOIN semestr_plan  
ON semestr_plan.studying_plan_id  = studying_plan.id AND "group".semestr_number = semestr_plan.semestr 
JOIN subject_plan 
ON subject_plan.semestr_plan_id  = semestr_plan.id
JOIN subject 
ON subject_plan.subject_id  = subject.id
CROSS JOIN (
	SELECT * FROM studying_year 
	WHERE studying_year.year_number='2022/2023' AND 
	studying_year.semestr_type='autumn'
) AS concrete_studying_year
WHERE date_part('year', concrete_studying_year.start_date) - date_part('year', studying_year.start_date) = "group".semestr_number /2 AND (
(studying_year.semestr_type='autumn' AND "group".semestr_number % 2 = 1) OR (studying_year.semestr_type='spring' AND "group".semestr_number % 2 = 0))
;


/*
 * 7)Список предметов на изучение в определенном семестре для студента
 * Сложные условия с датами, WITH, LIMIT
 */
WITH concrete_group (group_id) 
AS (
	SELECT "group".id 
	FROM student_group 
	JOIN "group" 
	ON "group".id = student_group.group_id 
	JOIN student 
	ON student.id = student_group.student_id AND student.id = 'd217a5a8-cf2d-4682-8697-e9226367371c'
	JOIN studying_plan 
	ON studying_plan.id = "group".studying_plan_id 
	JOIN studying_year 
	ON studying_year.id = studying_plan.start_year 
	CROSS JOIN (
		SELECT * FROM studying_year 
		WHERE studying_year.year_number='2022/2023' AND 
		studying_year.semestr_type='autumn'
	) AS concrete_studying_year
	WHERE date_part('year', concrete_studying_year.start_date) - date_part('year', studying_year.start_date) = "group".semestr_number /2 AND (
	(studying_year.semestr_type='autumn' AND "group".semestr_number % 2 = 1) OR (studying_year.semestr_type='spring' AND "group".semestr_number % 2 = 0))
	GROUP BY "group".id , student_group.start_in_group_date
	ORDER BY student_group.start_in_group_date  DESC 
	LIMIT 1
)
SELECT DISTINCT subject."name", subject_plan.lectures_number , subject_plan.practices_number , subject_plan.assesment_type, "group".code_Number
FROM student_group 
JOIN student 
ON student.id = student_group.student_id AND student.id = 'd217a5a8-cf2d-4682-8697-e9226367371c'
JOIN "group" 
ON "group".id = student_group.group_id 
JOIN studying_plan 
ON studying_plan.id = "group".studying_plan_id 
JOIN studying_year 
ON studying_year.id = studying_plan.start_year 
JOIN semestr_plan  
ON semestr_plan.studying_plan_id  = studying_plan.id AND "group".semestr_number = semestr_plan.semestr 
JOIN subject_plan 
ON subject_plan.semestr_plan_id  = semestr_plan.id
JOIN subject 
ON subject_plan.subject_id  = subject.id
CROSS JOIN concrete_group
WHERE "group".id = concrete_group.group_id
;


/*
 * Вывести группы по годам обучения конкретного студента
 */
SELECT studying_year.year_number, "group".code_number, "group".semestr_number, direction."name", institute."name" 
FROM student_group 
JOIN student 
ON student.id = student_group.student_id AND student.id = 'd217a5a8-cf2d-4682-8697-e9226367371c'
JOIN "group" 
ON "group".id = student_group.group_id 
JOIN studying_plan 
ON studying_plan.id = "group".studying_plan_id 
JOIN studying_year 
ON studying_year.id = studying_plan.start_year 
JOIN direction 
ON direction.id = "group".direction_id 
JOIN institute
ON institute.id = direction.institute_id 
;


/*
 * 8)Вывести все предметы и оценки по ним в определенном семестре конкретного ученика
 * STRING_AGG, AVG
 */
WITH concrete_group (group_id) 
AS (
	SELECT "group".id 
	FROM student_group 
	JOIN "group" 
	ON "group".id = student_group.group_id 
	JOIN student 
	ON student.id = student_group.student_id AND student.id = 'd217a5a8-cf2d-4682-8697-e9226367371c'
	JOIN studying_plan 
	ON studying_plan.id = "group".studying_plan_id 
	JOIN studying_year 
	ON studying_year.id = studying_plan.start_year 
	CROSS JOIN (
		SELECT * FROM studying_year 
		WHERE studying_year.year_number='2022/2023' AND 
		studying_year.semestr_type='autumn'
	) AS concrete_studying_year
	WHERE date_part('year', concrete_studying_year.start_date) - date_part('year', studying_year.start_date) = "group".semestr_number /2 AND (
	(studying_year.semestr_type='autumn' AND "group".semestr_number % 2 = 1) OR (studying_year.semestr_type='spring' AND "group".semestr_number % 2 = 0))
	GROUP BY "group".id , student_group.start_in_group_date
	ORDER BY student_group.start_in_group_date  DESC 
	LIMIT 1
)
SELECT  subject."name" , STRING_AGG(mark.mark_value::varchar, ',') AS "marks", AVG(mark.mark_value) AS "average mark"
FROM student_group 
JOIN student 
ON student.id = student_group.student_id AND student.id = 'd217a5a8-cf2d-4682-8697-e9226367371c'
JOIN "group" 
ON "group".id = student_group.group_id 
JOIN studying_plan 
ON studying_plan.id = "group".studying_plan_id 
JOIN studying_year 
ON studying_year.id = studying_plan.start_year 
JOIN semestr_plan  
ON semestr_plan.studying_plan_id  = studying_plan.id AND "group".semestr_number = semestr_plan.semestr 
JOIN subject_plan 
ON subject_plan.semestr_plan_id  = semestr_plan.id
JOIN subject 
ON subject_plan.subject_id  = subject.id
CROSS JOIN concrete_group
JOIN group_lesson 
ON "group".id = group_lesson.group_id 
JOIN lesson  
ON lesson.id = group_lesson.lesson_id  AND 
lesson."lesson_type" NOT IN ('exam', 'credit' )
LEFT JOIN mark 
ON mark.lesson_id = lesson.id AND mark.student_id  = student.id
WHERE "group".id = concrete_group.group_id
GROUP BY subject.id, lesson."lesson_type" 
;



/*
 * 9) Вывести список предметов, которые есть в учебных планах, но нет учиетлей такой специальности
 * 
 */
SELECT subject."name"  FROM subject_plan
JOIN subject 
ON subject.id = subject_plan.subject_id 
WHERE NOT EXISTS
(
	SELECT * FROM teacher_subject 
	JOIN (
		SELECT teacher.id FROM teacher 
		WHERE EXISTS (
		SELECT * FROM teacher_status 
		WHERE teacher_status.teacher_id = teacher.id AND teacher_status.status_end_date IS NULL
	)) AS working_teacher
	ON teacher_subject.teacher_id = working_teacher.id
	JOIN subject
	ON subject.id = teacher_subject.subject_id 
	WHERE subject.id = subject_plan.subject_id
)
;


























WITH concrete_group (group_id) 
AS (
	SELECT "group".id 
	FROM student_group 
	JOIN "group" 
	ON "group".id = student_group.group_id 
	JOIN student 
	ON student.id = student_group.student_id AND student.id = 'f3ca4adc-03b6-409a-af3d-81e76572beca'
	JOIN studying_plan 
	ON studying_plan.id = "group".studying_plan_id 
	JOIN studying_year 
	ON studying_year.id = studying_plan.start_year 
	CROSS JOIN (
		SELECT * FROM studying_year 
		WHERE studying_year.year_number='2022/2023' AND 
		studying_year.semestr_type='autumn'
	) AS concrete_studying_year
	WHERE date_part('year', concrete_studying_year.start_date) - date_part('year', studying_year.start_date) = "group".semestr_number /2 AND (
	(studying_year.semestr_type='autumn' AND "group".semestr_number % 2 = 1) OR (studying_year.semestr_type='spring' AND "group".semestr_number % 2 = 0))
	GROUP BY "group".id , student_group.start_in_group_date
	ORDER BY student_group.start_in_group_date  DESC 
	LIMIT 1
)
SELECT subject."name", mark.mark_value, lesson."lesson_type"
FROM student_group 
JOIN student 
ON student.id = student_group.student_id AND student.id = 'f3ca4adc-03b6-409a-af3d-81e76572beca'
JOIN "group" 
ON "group".id = student_group.group_id 
JOIN studying_plan 
ON studying_plan.id = "group".studying_plan_id 
JOIN studying_year 
ON studying_year.id = studying_plan.start_year 
JOIN semestr_plan  
ON semestr_plan.studying_plan_id  = studying_plan.id AND "group".semestr_number = semestr_plan.semestr 
JOIN subject_plan 
ON subject_plan.semestr_plan_id  = semestr_plan.id
JOIN subject 
ON subject_plan.subject_id  = subject.id
CROSS JOIN concrete_group
JOIN group_lesson 
ON "group".id = group_lesson.group_id 
JOIN lesson  
ON lesson.id = group_lesson.lesson_id  AND 
lesson."lesson_type"  IN ('exam', 'credit' )
LEFT JOIN mark 
ON mark.lesson_id = lesson.id AND 
mark.student_id  = student.id
WHERE "group".id = concrete_group.group_id AND (mark.mark_value IS NULL OR mark.mark_value < 5)
GROUP BY lesson.id, subject."name", mark.mark_value 
;


/*
 * 9) Вывести отличников за определенный семестр(учебный год + осенний/весенний семестр) 
 * WITH, IN
 */
WITH exam (lesson_id, start_date , "lesson_type", subject_id) AS (
	SELECT  lesson.id, lesson.start_date , lesson."lesson_type" , subject.id
	FROM lesson
	JOIN teacher_subject 
	ON lesson.teacher_subject_id = teacher_subject.id 
	JOIN subject 
	ON teacher_subject.subject_id  = subject.id 
	CROSS JOIN get_sem_by_date(start_date::date) AS lesson_semestr 
	WHERE
	lesson_semestr.year_number = '2022/2023' AND 
	lesson_semestr.semestr_type = 'autumn' AND
	lesson."lesson_type" IN ('exam', 'credit' )
)
SELECT student."name", mark.mark_value, subject."name" 
FROM exam 
JOIN mark
ON mark.lesson_id = exam.lesson_id
JOIN student AS "all_students"
ON mark.student_id  = student.id 
JOIN subject 
ON subject.id = exam.subject_id 
WHERE NOT EXIST (
	SELECT subject."name", mark.mark_value, lesson."lesson_type"
	FROM student_group , (
		SELECT "group".id 
		FROM student_group 
		JOIN "group" 
		ON "group".id = student_group.group_id 
		JOIN student 
		ON student.id = student_group.student_id AND student.id = all_students.id
		JOIN studying_plan 
		ON studying_plan.id = "group".studying_plan_id 
		JOIN studying_year 
		ON studying_year.id = studying_plan.start_year 
		CROSS JOIN (
			SELECT * FROM studying_year 
			WHERE studying_year.year_number='2022/2023' AND 
			studying_year.semestr_type='autumn'
		) AS concrete_studying_year
		WHERE date_part('year', concrete_studying_year.start_date) - date_part('year', studying_year.start_date) = "group".semestr_number /2 AND (
		(studying_year.semestr_type='autumn' AND "group".semestr_number % 2 = 1) OR (studying_year.semestr_type='spring' AND "group".semestr_number % 2 = 0))
		GROUP BY "group".id , student_group.start_in_group_date
		ORDER BY student_group.start_in_group_date  DESC 
		LIMIT 1) AS concrete_group
	JOIN student 
	ON student.id = student_group.student_id AND student.id = all_students.id
	JOIN "group" 
	ON "group".id = student_group.group_id 
	JOIN studying_plan 
	ON studying_plan.id = "group".studying_plan_id 
	JOIN studying_year 
	ON studying_year.id = studying_plan.start_year 
	JOIN semestr_plan  
	ON semestr_plan.studying_plan_id  = studying_plan.id AND "group".semestr_number = semestr_plan.semestr 
	JOIN subject_plan 
	ON subject_plan.semestr_plan_id  = semestr_plan.id
	JOIN subject 
	ON subject_plan.subject_id  = subject.id
	CROSS JOIN concrete_group
	JOIN group_lesson 
	ON "group".id = group_lesson.group_id 
	JOIN lesson  
	ON lesson.id = group_lesson.lesson_id  AND 
	lesson."lesson_type"  IN ('exam', 'credit' )
	LEFT JOIN mark 
	ON mark.lesson_id = lesson.id AND 
	mark.student_id  = student.id
	WHERE "group".id = concrete_group.group_id AND (mark.mark_value IS NULL OR mark.mark_value < 5)
	)
;














subject."name", STRING_AGG(mark.mark_value::varchar, ',') AS "marks", AVG(mark.mark_value) AS "average mark"

SELECT distinct student."name", student."surname", "group".code_number  FROM student 
JOIN student_group 
ON student_group.student_id = student.id 
JOIN "group" 
ON "group".id = student_group.group_id 
WHERE student.id = '024a6e9d-37c3-4751-b899-7b576784cae7';

SELECT * from student JOIN student_group ON student_id =student.id;


/*
 * Вывести отличников за определенный семестр(учебный год + осенний/весенний семестр) 
 * WITH, IN
 */
WITH exam (lesson_id, start_date , "lesson_type", subject_id) AS (
	SELECT  lesson.id, lesson.start_date , lesson."lesson_type" , subject.id
	FROM lesson
	JOIN teacher_subject 
	ON lesson.teacher_subject_id = teacher_subject.id 
	JOIN subject 
	ON teacher_subject.subject_id  = subject.id 
	CROSS JOIN get_sem_by_date(start_date::date) AS lesson_semestr 
	WHERE
	lesson_semestr.year_number = '2022/2023' AND 
	lesson_semestr.semestr_type = 'autumn' AND
	lesson."lesson_type" IN ('exam', 'credit' )
),
studying_plan_subjects (studying_plan_id, subject_id, semestr_plan_id, direction_id) AS (
	SELECT DISTINCT studying_plan.id, subject.id, semestr_plan.id,  studying_plan.direction_id
	FROM studying_plan 
	JOIN semestr_plan 
	ON semestr_plan.studying_plan_id = studying_plan.id
	JOIN subject_plan 
	ON subject_plan.semestr_plan_id = semestr_plan.id
	JOIN "group"  
	ON "group".studying_plan_id  = studying_plan.id 
	JOIN studying_year 
	ON studying_year.id = studying_plan.start_year 
	JOIN subject 
	ON subject.id = subject_plan.subject_id
	WHERE 
	date_part('year', studying_year.start_date) + 
	"group".semestr_number / 2 = '2022' 
)
SELECT  *
FROM exam 
JOIN mark
ON mark.lesson_id = exam.lesson_id
JOIN student
ON mark.student_id  = student.id
JOIN student_group 
ON student_group.student_id = student.id AND student_group.end_in_group_date IS NULL
JOIN "group"  
ON "group".id = student_group.group_id 
JOIN studying_plan_subjects
ON studying_plan_subjects.subject_id = exam.subject_id AND 
studying_plan_subjects.studying_plan_id = "group".studying_plan_id 
;

student."name", student."surname", mark.mark_value, exam.lesson_id , student.id, "group".id

student.id, 
student."name", 
student.surname , 
student.email , 
"group".code_number , 
"group".semestr_number ,
institute."name",
direction."name",
direction."direction_type"
SELECT * FROM institute ;


--Добавить даты сессии

SELECT
*
FROM student 
	CROSS JOIN (
	SELECT * FROM studying_year 
	WHERE studying_year.year_number='2022/2023' AND 
	studying_year.semestr_type='autumn'
) AS studying_year
JOIN student_group 
ON student_group.student_id = student_id and
student_group.start_in_group_date <=  studying_year.start_date  AND 
(student_group.end_in_group_date >=  studying_year.end_date OR student_group.end_in_group_date IS NULL)
JOIN "group"
ON "group".id = student_group.group_id  
JOIN studying_plan 
ON "group".studying_plan_id = studying_plan.id 
JOIN direction 
ON studying_plan.direction_id  = direction.id
JOIN institute 
ON direction.institute_id  = institute.id
WHERE NOT EXISTS (
WITH exam (lesson_id, start_date , "lesson_type", subject_id) AS (
	SELECT  lesson.id, lesson.start_date , lesson."lesson_type" , subject.id
	FROM lesson
	JOIN teacher_subject 
	ON lesson.teacher_subject_id = teacher_subject.id 
	JOIN subject 
	ON teacher_subject.subject_id  = subject.id 
	CROSS JOIN get_sem_by_date(start_date::date) AS lesson_semestr 
	WHERE
	lesson_semestr.year_number = '2022/2023' AND 
	lesson_semestr.semestr_type = 'autumn' AND
	lesson."lesson_type" IN ('exam', 'credit' ) AND 
	lesson.start_date BETWEEN lesson_semestr.start_date AND lesson_semestr.end_date
),
studying_plan_subjects (studying_plan_id, subject_id, semestr_plan_id, direction_id, group_id) AS (
	SELECT DISTINCT studying_plan.id, subject.id, semestr_plan.id,  studying_plan.direction_id, "group".id
	FROM studying_plan 
	JOIN semestr_plan 
	ON semestr_plan.studying_plan_id = studying_plan.id 
	JOIN subject_plan 
	ON subject_plan.semestr_plan_id = semestr_plan.id
	JOIN "group"  
	ON "group".studying_plan_id  = studying_plan.id 
	JOIN studying_year 
	ON studying_year.id = studying_plan.start_year 
	JOIN subject 
	ON subject.id = subject_plan.subject_id
	WHERE 
	date_part('year', studying_year.start_date) + 
	"group".semestr_number / 2 = '2022' AND 
	semestr_plan.semestr % 2 = 1 AND 
	semestr_plan.semestr = "group".semestr_number 
)
SELECT student.id 
FROM student 
JOIN student_group 
ON student_group.student_id = student.id
JOIN "group"  
ON "group".id = student_group.group_id 
JOIN studying_plan_subjects
ON studying_plan_subjects.group_id = "group".id
JOIN exam
ON studying_plan_subjects.subject_id = exam.subject_id 
LEFT JOIN mark 
ON student.id = mark.student_id AND mark.lesson_id  = exam.lesson_id
WHERE (mark.mark_value IS NULL ) AND student_group.student_id = student.id
GROUP BY student.id 
)
;

OR mark.mark_value IN (2,3,4)


SELECT
*
FROM student 
	CROSS JOIN (
	SELECT * FROM studying_year 
	WHERE studying_year.year_number='2022/2023' AND 
	studying_year.semestr_type='autumn'
) AS studying_year
JOIN student_group 
ON student_group.student_id = student_id and
student_group.start_in_group_date <=  studying_year.start_date  AND 
(student_group.end_in_group_date >=  studying_year.end_date OR student_group.end_in_group_date IS NULL)
JOIN "group"
ON "group".id = student_group.group_id  
JOIN studying_plan 
ON "group".studying_plan_id = studying_plan.id 
JOIN direction 
ON studying_plan.direction_id  = direction.id
JOIN institute 
ON direction.institute_id  = institute.id
WHERE NOT EXISTS (
WITH exam (lesson_id, start_date , "lesson_type", subject_id) AS (
	SELECT  lesson.id, lesson.start_date , lesson."lesson_type" , subject.id
	FROM lesson
	JOIN teacher_subject 
	ON lesson.teacher_subject_id = teacher_subject.id 
	JOIN subject 
	ON teacher_subject.subject_id  = subject.id 
	CROSS JOIN get_sem_by_date(start_date::date) AS lesson_semestr 
	WHERE
	lesson_semestr.year_number = '2022/2023' AND 
	lesson_semestr.semestr_type = 'autumn' AND
	lesson."lesson_type" IN ('exam', 'credit' ) AND 
	lesson.start_date BETWEEN lesson_semestr.start_date AND lesson_semestr.end_date
),
studying_plan_subjects (studying_plan_id, subject_id, semestr_plan_id, direction_id, group_id) AS (
	SELECT DISTINCT studying_plan.id, subject.id, semestr_plan.id,  studying_plan.direction_id, "group".id
	FROM studying_plan 
	JOIN semestr_plan 
	ON semestr_plan.studying_plan_id = studying_plan.id 
	JOIN subject_plan 
	ON subject_plan.semestr_plan_id = semestr_plan.id
	JOIN "group"  
	ON "group".studying_plan_id  = studying_plan.id 
	JOIN studying_year 
	ON studying_year.id = studying_plan.start_year 
	JOIN subject 
	ON subject.id = subject_plan.subject_id
	WHERE 
	date_part('year', studying_year.start_date) + 
	"group".semestr_number / 2 = '2022' AND 
	semestr_plan.semestr % 2 = 1 AND 
	semestr_plan.semestr = "group".semestr_number 
)
SELECT student.id 
FROM student_group  
JOIN "group"  
ON "group".id = student_group.group_id 
JOIN studying_plan_subjects
ON studying_plan_subjects.group_id = "group".id
JOIN exam
ON studying_plan_subjects.subject_id = exam.subject_id 
LEFT JOIN mark 
ON student.id = mark.student_id AND mark.lesson_id  = exam.lesson_id
WHERE (mark.mark_value IS NULL  ) AND student_group.student_id = student.id
GROUP BY student.id 
)
;
OR mark.mark_value IN (2,3,4)





INSERT INTO "feedback"(id,student_id,feedback_text,date)
 VALUES(gen_random_uuid (),'852ebb18-667d-485b-8544-2e3faa405819' , 'kekekekekekeeekkke' , LOCALTIMESTAMP);

SELECT * FROM student 
CROSS JOIN get_student_last_stauts(student.id)
JOIN ;

SELECT * FROM student 
JOIN student_status ON student.id = student_status.student_id
ORDER BY student.id;

SELECT * FROM get_student_last_stauts('de3887fb-5415-4862-be0e-4630f3374c04');




INSERT INTO feedback(id, student_id,feedback_text, "date")
VALUES ('ad5b6714-65c9-4847-ab1a-45a5eec6d6a8', '852ebb18-667d-485b-8544-2e3faa405819', 'Ya igrau v dotu 2', CURRENT_TIMESTAMP)
ON CONFLICT (id)
DO UPDATE SET feedback_text = 'Ya igrau v dotu 2',
"date" = CURRENT_TIMESTAMP;






WHERE teacher.id = '19c22133-2905-47af-99ee-859a1857a58c';

SELECT * FROM extra_classes; 


SELECT * FROM teacher ;

SELECT * FROM feedback 
JOIN student ON feedback.student_id  = student.id;

INSERT INTO teacher (id, "name", surname, email, birthday, passport, phone_number, academic_degree) 
VALUES(gen_random_uuid (), 'Dura', 'Polnaya', 'daun@chort.com', '1980-01-01','143244', '+23452435', 'professor');

SELECT date_part('year', now()); 

SELECT * FROM "group" JOIN direction ON direction.id = "group".direction_id ; 