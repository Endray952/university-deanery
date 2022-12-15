import {
    ADMIN_PATH,
    LOGIN_PATH,
    REGISTRATION_PATH,
    STUDENT_PATH,
} from './utils/consts';

import { LoginPage } from './pages/LoginPage';
import { ToursPage } from './pages/StudentPage';
import DefaultPage from './pages/DefaultPage';

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
        component: ToursPage,
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
        path: '/',
        component: DefaultPage,
    },
];
