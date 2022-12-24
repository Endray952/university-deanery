import {
    ROOT_PATH,
    LOGIN_PATH,
    STUDENT_MARKS_PATH,
    STUDENTS_EDIT_PATH,
    TEACHERS_EDIT_PATH,
    STUDENT_SHEDULE_PATH,
} from './utils/consts';

import { LoginPage } from './pages/LoginPage';

import DefaultPage from './pages/DefaultPage';

import { EditStudentsPage } from './pages/EditStudentsPage';
import { EditTeachersPage } from './pages/EditTeachersPage';
import { StudentShedule } from './pages/StudentShedule';
import { StudentMarksPage } from './pages/StudentMarksPage';

/**
 * Routes for authentication
 */
export const adminRoutes = [
    // {
    //     path: ADMIN_PATH,
    //     component: LoginPage,
    // },

    {
        path: STUDENTS_EDIT_PATH,
        component: EditStudentsPage,
    },

    {
        path: STUDENT_MARKS_PATH,
        component: StudentMarksPage,
    },

    {
        path: TEACHERS_EDIT_PATH,
        component: EditTeachersPage,
    },

    {
        path: STUDENT_SHEDULE_PATH,
        component: StudentShedule,
    },
];

export const deanRoutes = [
    // {
    //     path: ADMIN_PATH,
    //     component: LoginPage,
    // },

    {
        path: STUDENTS_EDIT_PATH,
        component: EditStudentsPage,
    },
    {
        path: TEACHERS_EDIT_PATH,
        component: EditTeachersPage,
    },
    // {
    //     path: STUDENT_SHEDULE_PATH,
    //     component: StudentShedule,
    // },
    // {
    //     path: STUDENT_MARKS_PATH,
    //     component: StudentMarksPage,
    // },
];

export const studentRoutes = [
    // {
    //     path: ADMIN_PATH,
    //     component: LoginPage,
    // },

    {
        path: STUDENT_MARKS_PATH,
        component: StudentMarksPage,
    },
    {
        path: STUDENT_SHEDULE_PATH,
        component: StudentShedule,
    },
];

export const teacherRoutes = [
    // {
    //     path: ADMIN_PATH,
    //     component: LoginPage,
    // },

    {
        path: STUDENTS_EDIT_PATH,
        component: StudentMarksPage,
    },
];

export const rectorRoutes = [
    // {
    //     path: ADMIN_PATH,
    //     component: LoginPage,
    // },

    {
        path: STUDENTS_EDIT_PATH,
        component: StudentMarksPage,
    },
];

/**
 * Public routes to see main pages
 */
export const publicRoutes = [
    {
        path: LOGIN_PATH,
        component: LoginPage,
    },
    {
        path: ROOT_PATH,
        component: DefaultPage,
    },
];
