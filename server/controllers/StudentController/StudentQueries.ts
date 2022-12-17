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
        CROSS JOIN get_last_student_stauts(student.id) AS last_student_stauts
        CROSS JOIN get_last_student_group(student.id) AS last_student_group
        JOIN "group"  
        ON "group".id = last_student_group.group_id
        JOIN direction 
        ON direction.id = "group".direction_id 
        JOIN institute 
        ON institute.id = direction.institute_id 
        JOIN "system_user" 
        ON "system_user".person_id = student.id 
        WHERE student.id = '${userId}';`;
    },
};
