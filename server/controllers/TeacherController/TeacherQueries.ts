import { v4 as uuid } from 'uuid';
import { pool } from '../../db.js';

export const TeacherQueries = {
    getTeacherIdByUserId: (user_id) => {
        return `SELECT teacher.id as teacher_id, 
        teacher."name", 
        teacher.surname, 
        teacher.is_working, 
        teacher.email, 
        teacher.birthday
        FROM teacher 
    JOIN "system_user" 
    ON "system_user".person_id = teacher.id
    WHERE "system_user".id = '${user_id}'`;
    },

    getMySheduleByUserId: async (user_id) => {
        const id: any = await pool.query(
            TeacherQueries.getTeacherIdByUserId(user_id)
        );
        console.log('rows', id.rows[0]);
        // console.log(
        //     await pool.query(TeacherQueries.getTeacherIdByUserId(user_id))
        // );

        console.log('id', id.rows[0].teacher_id);
        return `SELECT 
        teacher.id as teacher_id,
        teacher."name", 
        teacher.surname, 
        teacher.is_working, 
        teacher.email, 
        teacher.birthday,
        teacher.phone_number,
        lesson.id as lesson_id,
        lesson.classroom_id ,
        lesson.duration ,
        lesson.start_date as date ,
        subject.id as subject_id,
        subject."name" as subject,
        lesson.lesson_type,
        classroom.name as "classroom"
        FROM teacher 
      JOIN lesson 
      ON lesson.teacher_id = teacher.id 
      JOIN subject
      ON subject.id = lesson.subject_id
      
      LEFT JOIN classroom 
      ON classroom.id = lesson.classroom_id 
      WHERE teacher.id = '${id.rows[0].teacher_id}' AND 
      EXISTS (SELECT * FROM get_sem_by_date(CURRENT_DATE) AS "current_sem"
          WHERE lesson.start_date BETWEEN "current_sem".start_date AND "current_sem".end_date
            )
      ;
      `;
    },

    getLessonStudents: async (lesson_id) => {
        return `SELECT 
        student."name" AS student_name,
        student."surname" AS student_surname,
        "group"."id" AS group_id,
        lesson.id AS lesson_id,
        "group".code_number,
        attendance.is_attendant,
        STRING_AGG(CAST(mark.mark_value AS varchar(1)), ', ') as "mark_value"
        FROM lesson 
        JOIN group_lesson
        ON group_lesson.lesson_id = lesson.id
        JOIN "group"
        ON "group".id = group_lesson.group_id 
        JOIN student_group
        ON student_group.group_id = group_lesson.group_id 
        LEFT JOIN mark 
        ON mark.lesson_id = lesson.id 
        JOIN student
        ON student_group.student_id = student.id
        LEFT JOIN attendance
        ON attendance.lesson_id = lesson.id 
        WHERE lesson.id = '${lesson_id}' 
        AND EXISTS(
                    SELECT * FROM student 
                    CROSS JOIN get_last_student_group_id(student.id) AS "last_student_group_id"
                    WHERE "last_student_group_id" = student_group.id
                    
            )
        GROUP BY student."name", student."surname", "group"."id", lesson.id, "group".code_number, attendance.is_attendant;
      `;
    },
};
