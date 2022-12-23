import { v4 as uuid } from 'uuid';
import { pool } from '../../db.js';

export const deanQueries = {
    // getStudents: () => {
    //     return `SELECT DISTINCT student."name",
    //     student."surname",
    //     code_number AS group_code,
    //     direction."direction_type",
    //     email,
    //     last_student_group.end_in_group_date,
    //     last_student_group.start_in_group_date,
    //     institute."name" AS institute_name,
    //     passport,
    //     phone_number,
    //     semestr_number,
    //     status_date,
    //     student_status,
    //     student.id AS student_id,
    //     last_student_group.group_id,
    //     institute_id,
    //     direction."name" AS direction_name,
    //     "system_user"."role"  AS "role",
    //     "system_user"."login"
    //     FROM student
    //     CROSS JOIN get_last_student_status(student.id) AS last_student_stauts
    //     CROSS JOIN get_last_student_group(student.id) AS last_student_group
    //     JOIN "group"
    //     ON "group".id = last_student_group.group_id
    //     JOIN studying_plan
    //     ON studying_plan.id = "group".studying_plan_id
    //     JOIN direction
    //     ON direction.id = studying_plan.direction_id
    //     JOIN institute
    //     ON institute.id = direction.institute_id
    //     LEFT JOIN "system_user"
    //     ON "system_user".person_id = student.id
    //     ORDER BY student."name", student."surname"
    //     ;`;
    // },
    getStudents: () => {
        return `SELECT DISTINCT student."name",
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
        direction."name" AS direction_name,
        "system_user"."role"  AS "role",
        "system_user"."login",
        current_student_group.group_id as "current_group_id"
        FROM student
        CROSS JOIN get_last_student_status(student.id) AS last_student_stauts
        CROSS JOIN get_last_student_group(student.id) AS last_student_group
        LEFT JOIN get_current_student_group(student.id) AS current_student_group ON 1=1
        JOIN "group"
        ON "group".id = last_student_group.group_id
        JOIN studying_plan
        ON studying_plan.id = "group".studying_plan_id
        JOIN direction
        ON direction.id = studying_plan.direction_id
        JOIN institute
        ON institute.id = direction.institute_id
        LEFT JOIN "system_user"
        ON "system_user".person_id = student.id
        ORDER BY student."name", student."surname"
        ;`;
    },

    updateStudent: (
        name,
        surname,
        email,
        phone_number,
        student_id,
        passport
    ) => {
        return `UPDATE student SET
        "name" = '${name}',
        "surname" = '${surname}',
        "email" = '${email}',
        phone_number = '${phone_number}',
        passport = '${passport}'
        WHERE student.id = '${student_id}';`;
    },
    createStudent: (
        name,
        surname,
        email,
        phone_number,
        passport,
        birthday,
        group_id
    ) => {
        return `SELECT * FROM create_student('${name}','${surname}', '${email}', '${birthday}', '${passport}', '${phone_number}', '${group_id}');`;
    },
    getGroups: (date: any) => {
        return `SELECT semestr_groups.group_id AS group_id ,
        semestr_groups.code_number ,
        semestr_groups.studying_plan_id ,
        semestr_groups.semestr_number ,
        direction_id,
        direction."name" AS direction_name,
        direction."direction_type",
        studying_plan.id AS studying_plan_id,
        institute.id AS institute_id,
        institute."name" AS institute_name
        FROM get_semestr_groups(${date}) AS semestr_groups
        JOIN studying_plan  
        ON studying_plan.id = semestr_groups.studying_plan_id
        JOIN direction  
        ON direction.id = studying_plan.direction_id 
        JOIN institute 
        ON institute.id = direction.institute_id 
        ;`;
    },

    expellStudent: (student_id: any) => {
        return `SELECT * FROM expell_student('${student_id}');`;
    },

    enrollStudent: (student_id: any, group_id: any) => {
        return `SELECT * FROM enroll_student('${student_id}', '${group_id}');`;
    },

    transferStudent: (student_id: any, group_id: any) => {
        return `SELECT * FROM transfer_student('${student_id}', '${group_id}');`;
    },

    getTeachers: () => {
        return ` SELECT teacher.id AS "teacher_id",
        teacher.phone_number,
        teacher."name" , 
        teacher."surname" , 
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
        LEFT JOIN teacher_subject 
        ON teacher_subject.teacher_id =teacher.id 
        LEFT JOIN subject
        ON subject.id = teacher_subject.subject_id
       LEFT JOIN "system_user" 
       ON "system_user".person_id = teacher.id
        ;`;
    },

    getSubjects: () => {
        return `SELECT * FROM subject;`;
    },

    updateTeacher: (
        name,
        surname,
        email,
        phone_number,
        teacher_id,
        passport
    ) => {
        return `UPDATE teacher SET
            "name" = '${name}',
            "surname" = '${surname}',
            "email" = '${email}',
            phone_number = '${phone_number}',
            passport = '${passport}'
            WHERE teacher.id = '${teacher_id}';`;
    },

    updateTeacherSubjects: (teacher_id, subject_ids) => {
        let values = '';
        subject_ids.forEach((subjectId) => {
            values += `('${teacher_id}', '${subjectId}'),`;
        });
        values = values.substring(0, values.length - 1);
        console.log(values);
        pool.query(
            `DELETE FROM teacher_subject 
        WHERE teacher_id = '${teacher_id}';`
        );
        return `INSERT INTO teacher_subject(teacher_id, subject_id)
        VALUES ${values};`;
    },

    updateTeacherChangeStatus: (teacher_id, is_working) => {
        return `UPDATE teacher SET
        is_working = ${Boolean(!is_working)}
        WHERE teacher.id = '${teacher_id}';`;
    },
};
