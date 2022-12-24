import {
    role,
    STUDENTS_EDIT_PATH,
    STUDENT_MARKS_PATH,
    STUDENT_SHEDULE_PATH,
    TEACHERS_EDIT_PATH,
    TEACHER_SHEDULE_PATH,
    DEFAULT_PATH,
} from './consts';

export const SidebarByRole = new Map()
    .set(role.ADMIN, [
        { to: STUDENTS_EDIT_PATH, text: 'Студенты' },
        // { to: STUDENT_MARKS_PATH, text: 'Мои оценки' },
        { to: TEACHERS_EDIT_PATH, text: 'Учителя' },
        // { to: STUDENT_SHEDULE_PATH, text: 'Мое расписание' },
        { to: '/', text: 'Расписание' },
        { to: '/', text: 'Отзывы' },
    ])
    .set(role.STUDENT, [
        { to: STUDENT_SHEDULE_PATH, text: 'Мое расписание' },
        { to: STUDENT_MARKS_PATH, text: 'Мои оценки' },
    ])
    .set(role.DEAN, [
        { to: STUDENTS_EDIT_PATH, text: 'Студенты' },
        { to: TEACHERS_EDIT_PATH, text: 'Учителя' },
        { to: '/', text: 'Дополнительные занятия' },
        { to: '/', text: 'Отзывы' },
    ])
    .set(role.TEACHER, [
        { to: TEACHER_SHEDULE_PATH, text: 'Мое расписание' },
        { to: '/', text: 'Дополнительные занятия' },
    ]);

//@ts-ignore
// export const role = {
//     ADMIN: 'admin',
//     STUDENT: 'student',
//     DEAN: 'dean',
//     TEACHER: 'teacher',
//     RECTOR: 'teacher',
// };
