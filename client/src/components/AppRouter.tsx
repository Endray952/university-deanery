import React from 'react';
import { Route, Routes, redirect } from 'react-router-dom';
import { LoginPage } from '../pages/LoginPage';
import DefaultPage from '../pages/DefaultPage';
import { ToursPage } from '../pages/ToursPage';
import { authRoutes, publicRoutes } from '../routes';
import UserStore from '../store/UserStore';
import { DEFAULT_PATH, LOGIN_PATH } from '../utils/consts';

/**
 * Component represents navigation between different routes
 * @component
 */
export const AppRouter = () => {
    return (
        <Routes>
            {UserStore.isAuth &&
                authRoutes.map((route) => {
                    return (
                        <Route
                            key={route.path}
                            path={route.path}
                            element={<route.component />}
                        />
                    );
                })}

            {publicRoutes.map((route) => {
                return (
                    <Route
                        key={route.path}
                        path={route.path}
                        element={<route.component />}
                    />
                );
            })}

            {/* <Route path={'*'} element={<DefaultPage />} /> */}
        </Routes>
    );
};
