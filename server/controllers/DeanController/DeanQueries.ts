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
        direction."name" AS direction_name
        FROM student 
        CROSS JOIN get_last_student_stauts(student.id) AS last_student_stauts
        CROSS JOIN get_last_student_group(student.id) AS last_student_group
        JOIN "group"  
        ON "group".id = last_student_group.group_id
        JOIN direction 
        ON direction.id = "group".direction_id 
        JOIN institute 
        ON institute.id = direction.institute_id 
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
    // addStudent: (name, surname, email, phone_number, student_id) => {

    // }
};
