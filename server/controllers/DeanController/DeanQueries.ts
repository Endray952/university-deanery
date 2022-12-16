import { v4 as uuid } from 'uuid';

export const deanQueries = {
    getStudents: () => {
        return `SELECT * FROM student 
        CROSS JOIN get_last_student_stauts(student.id) AS last_student_stauts
        CROSS JOIN get_last_student_group(student.id) AS last_student_group
        JOIN "group"  
        ON "group".id = last_student_group.group_id
        JOIN direction 
        ON direction.id = "group".direction_id 
        JOIN institute 
        ON institute.id = direction.institute_id 
        ;`;
    },
};
