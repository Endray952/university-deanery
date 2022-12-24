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
    lesson.start_date as date,
    lesson.duration ,
    lesson."lesson_type",
    "group"."id" AS group_id,
    lesson.id AS lesson_id,
    group_lesson.id AS group_lesson_id,
    teacher.id AS teacher_id
    FROM lesson  
    JOIN subject 
    ON subject.id = lesson.subject_id 
    JOIN group_lesson 
    ON group_lesson.lesson_id = lesson.id 
    JOIN "group" 
    ON "group".id = group_lesson.group_id 
    LEFT JOIN teacher  
    ON teacher.id = lesson.teacher_id 
    LEFT JOIN classroom 
    ON lesson.classroom_id = classroom.id
    WHERE "group".id = '${group_id}';`;
    },

    getCurrentStudentMarks: (student_id) => {
        return `select 
          --mark.mark_value ,
          subject."name" as subject_name,
          subject."id" as subject_id,
          AVG(mark.mark_value) as average_mark,
          STRING_AGG(mark.mark_value::varchar, ',') as marks
          --teacher."name" as teacher_name,
          --teacher.surname  as teacher_name,
          from lesson 
          left join mark 
          on mark.lesson_id = lesson.id and 
            mark.student_id = '${student_id}'  
          join teacher on
          teacher.id = lesson.teacher_id 
          join subject 
          on subject.id = lesson.subject_id 
          join group_lesson 
          on group_lesson.lesson_id = lesson.id 
          join student_group 
          on student_group.group_id = group_lesson.group_id 
          where student_group.id = get_current_student_group_id('${student_id}') and 
          student_group.student_id = '${student_id}' 
          group by subject."name", subject."id"    
;`;
    },
};
