import {
    role,
    STUDENTS_EDIT_PATH,
    STUDENT_MARKS_PATH,
    STUDENT_SHEDULE_PATH,
    TEACHERS_EDIT_PATH,
} from './consts';

export const adminSideBar = new Map().set(role.ADMIN, [
    { to: STUDENTS_EDIT_PATH, text: 'Студенты' },
    { to: STUDENT_MARKS_PATH, text: 'Мои оценки' },
    { to: TEACHERS_EDIT_PATH, text: 'Учителя' },
    { to: STUDENT_SHEDULE_PATH, text: 'Мое расписание' },
]);
//@ts-ignore
// export const role = {
//     ADMIN: 'admin',
//     STUDENT: 'student',
//     DEAN: 'dean',
//     TEACHER: 'teacher',
//     RECTOR: 'teacher',
// };
