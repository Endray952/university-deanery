import { v4 as uuid } from 'uuid';

export const StudentQueries = {
    getStudentByUserId: (userId) => {
        return `SELECT student."name", 
        student."surname", 
        code_number AS group_code, 
        direction."direction_type", 
        email, 
        last_student_group.end_in_group_date,
        last_student_group.start_in_group_date,
        institute."name" AS institute_name,
        passport,
        phone_number,
        semestr_number,
        status_date,
        student_status,
        student.id AS student_id,
        last_student_group.group_id,
        institute_id,
        "system_user".login,
        "system_user"."role",
        "system_user"."hashed_password"
          FROM student 
        CROSS JOIN get_last_student_status(student.id) AS last_student_stauts
        CROSS JOIN get_last_student_group(student.id) AS last_student_group
        JOIN "group"  
        ON "group".id = last_student_group.group_id
        JOIN studying_plan 
        ON studying_plan.id = "group".studying_plan_id 
        JOIN direction 
        ON direction.id = studying_plan.direction_id 
        JOIN institute 
        ON institute.id = direction.institute_id 
        JOIN "system_user" 
        ON "system_user".person_id = student.id 
        WHERE "system_user".id = '${userId}';`;
    },
    getGroupShedule: (group_id) => {
        return `SELECT subject."name" AS "subject", 
      teacher."name",
      teacher."surname",
     classroom."name" AS "classroom",
     lesson.start_date AS date,
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
     WHERE "group".id = '${group_id}';`;
    },
};
