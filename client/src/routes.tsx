import {
    ADMIN_PATH,
    ROOT_PATH,
    LOGIN_PATH,
    REGISTRATION_PATH,
    STUDENT_PATH,
} from './utils/consts';

import { LoginPage } from './pages/LoginPage';

import DefaultPage from './pages/DefaultPage';
import { StudentPage } from './pages/StudentPage';

/**
 * Routes for authentication
 */
export const authRoutes = [
    {
        path: ADMIN_PATH,
        component: LoginPage,
    },

    {
        path: REGISTRATION_PATH,
        component: LoginPage,
    },

    {
        path: STUDENT_PATH,
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
