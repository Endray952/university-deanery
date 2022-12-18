import {
    ADMIN_PATH,
    ROOT_PATH,
    LOGIN_PATH,
    REGISTRATION_PATH,
    STUDENT_PATH,
    SUTDENTS_EDIT_PATH,
} from './utils/consts';

import { LoginPage } from './pages/LoginPage';

import DefaultPage from './pages/DefaultPage';
import { StudentPage } from './pages/StudentPage';

/**
 * Routes for authentication
 */
export const adminRoutes = [
    {
        path: ADMIN_PATH,
        component: LoginPage,
    },

    {
        path: REGISTRATION_PATH,
        component: LoginPage,
    },

    {
        path: SUTDENTS_EDIT_PATH,
        component: StudentPage,
    },
];

export const deanRoutes = [
    {
        path: ADMIN_PATH,
        component: LoginPage,
    },

    {
        path: REGISTRATION_PATH,
        component: LoginPage,
    },

    {
        path: SUTDENTS_EDIT_PATH,
        component: StudentPage,
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
        path: SUTDENTS_EDIT_PATH,
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
        path: SUTDENTS_EDIT_PATH,
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
        path: SUTDENTS_EDIT_PATH,
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
