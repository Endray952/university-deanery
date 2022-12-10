import { ADMIN_PATH, LOGIN_PATH, REGISTRATION_PATH } from './utils/consts';

import { AuthPage } from './pages/AuthPage';
import { ToursPage } from './pages/ToursPage';

/**
 * Routes for authentication
 */
export const authRoutes = [
    {
        path: ADMIN_PATH,
        component: AuthPage,
    },

    {
        path: REGISTRATION_PATH,
        component: AuthPage,
    },
];

/**
 * Public routes to see main pages
 */
export const publicRoutes = [
    {
        path: LOGIN_PATH,
        component: AuthPage,
    },
];
