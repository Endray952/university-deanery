import {
    role,
    STUDENTS_EDIT_PATH,
    STUDENT_MARKS_PATH,
    STUDENT_SHEDULE_PATH,
    TEACHERS_EDIT_PATH,
} from './consts';

export const SidebarByRole = new Map()
    .set(role.ADMIN, [
        { to: STUDENTS_EDIT_PATH, text: 'Студенты' },
        { to: STUDENT_MARKS_PATH, text: 'Мои оценки' },
        { to: TEACHERS_EDIT_PATH, text: 'Учителя' },
        { to: STUDENT_SHEDULE_PATH, text: 'Мое расписание' },
    ])
    .set(role.STUDENT, [
        { to: STUDENT_SHEDULE_PATH, text: 'Мое расписание' },
        { to: STUDENT_MARKS_PATH, text: 'Мои оценки' },
    ])
    .set(role.DEAN, [
        { to: STUDENTS_EDIT_PATH, text: 'Студенты' },
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
