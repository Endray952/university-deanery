import { v4 as uuid } from 'uuid';

export const deanQueries = {
    getStudents: () => {
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
        direction."name" AS direction_name,
        "system_user"."role"  AS "role",
        "system_user"."login"
        FROM student 
        CROSS JOIN get_last_student_stauts(student.id) AS last_student_stauts
        CROSS JOIN get_last_student_group(student.id) AS last_student_group
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
    updateStudent: (name, surname, email, phone_number, student_id) => {
        return `UPDATE student SET
        "name" = '${name}',
        "surname" = '${surname}',
        "email" = '${email}',
        phone_number = '${phone_number}'
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
};
