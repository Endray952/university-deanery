import {
    ADMIN_PATH,
    ROOT_PATH,
    LOGIN_PATH,
    REGISTRATION_PATH,
    STUDENT_MARKS_PATH,
    STUDENTS_EDIT_PATH,
    TEACHERS_EDIT_PATH,
} from './utils/consts';

import { LoginPage } from './pages/LoginPage';

import DefaultPage from './pages/DefaultPage';
import { StudentPage } from './pages/StudentPage';
import { EditStudentsPage } from './pages/EditStudentsPage';
import { EditTeachersPage } from './pages/EditTeachersPage';

/**
 * Routes for authentication
 */
export const adminRoutes = [
    {
        path: ADMIN_PATH,
        component: LoginPage,
    },

    // {
    //     path: REGISTRATION_PATH,
    //     component: LoginPage,
    // },

    {
        path: STUDENTS_EDIT_PATH,
        component: EditStudentsPage,
    },

    {
        path: STUDENT_MARKS_PATH,
        component: StudentPage,
    },

    {
        path: TEACHERS_EDIT_PATH,
        component: EditTeachersPage,
    },
];

export const deanRoutes = [
    {
        path: ADMIN_PATH,
        component: LoginPage,
    },

    // {
    //     path: REGISTRATION_PATH,
    //     component: LoginPage,
    // },

    {
        path: STUDENTS_EDIT_PATH,
        component: StudentPage,
    },
    {
        path: TEACHERS_EDIT_PATH,
        component: EditTeachersPage,
    },
];

export const studentRoutes = [
    {
        path: ADMIN_PATH,
        component: LoginPage,
    },

    {
        path: REGISTRATION_PATH,
        component: LoginPage,
    },

    {
        path: STUDENTS_EDIT_PATH,
        component: StudentPage,
    },
];

export const teacherRoutes = [
    {
        path: ADMIN_PATH,
        component: LoginPage,
    },

    {
        path: REGISTRATION_PATH,
        component: LoginPage,
    },

    {
        path: STUDENTS_EDIT_PATH,
        component: StudentPage,
    },
];

export const rectorRoutes = [
    {
        path: ADMIN_PATH,
        component: LoginPage,
    },

    {
        path: REGISTRATION_PATH,
        component: LoginPage,
    },

    {
        path: STUDENTS_EDIT_PATH,
        component: StudentPage,
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
