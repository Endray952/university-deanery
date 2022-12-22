import {
    role,
    STUDENTS_EDIT_PATH,
    STUDENT_MARKS_PATH,
    TEACHERS_EDIT_PATH,
} from './consts';

export const adminSideBar = new Map().set(role.ADMIN, [
    { to: STUDENTS_EDIT_PATH, text: 'Студенты' },
    { to: STUDENT_MARKS_PATH, text: 'Студент' },
    { to: TEACHERS_EDIT_PATH, text: 'Учителя' },
]);
//@ts-ignore
// export const role = {
//     ADMIN: 'admin',
//     STUDENT: 'student',
//     DEAN: 'dean',
//     TEACHER: 'teacher',
//     RECTOR: 'teacher',
// };
