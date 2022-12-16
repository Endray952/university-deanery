import React from 'react';
import { Route, Routes, redirect } from 'react-router-dom';
import DefaultPage from '../pages/DefaultPage';
import { authRoutes, publicRoutes } from '../routes';
import UserStore from '../store/UserStore';
import { observer } from 'mobx-react-lite';
/**
 * Component represents navigation between different routes
 * @component
 */
export const AppRouter = observer(() => {
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

            {!UserStore.isAuth &&
                publicRoutes.map((route) => {
                    return (
                        <Route
                            key={route.path}
                            path={route.path}
                            element={<route.component />}
                        />
                    );
                })}

            <Route path={'*'} element={<DefaultPage />} />
        </Routes>
    );
});
