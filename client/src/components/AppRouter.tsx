import React from 'react';
import { Route, Routes, redirect } from 'react-router-dom';
import DefaultPage from '../pages/DefaultPage';
import {
    adminRoutes,
    deanRoutes,
    publicRoutes,
    rectorRoutes,
    studentRoutes,
    teacherRoutes,
} from '../routes';
import UserStore from '../store/UserStore';
import { observer } from 'mobx-react-lite';

import { role } from '../utils/consts';
/**
 * Component represents navigation between different routes
 * @component
 */

export const AppRouter = observer(() => {
    return (
        <Routes>
            {UserStore.isAuth &&
                UserStore.user?.role === role.ADMIN &&
                adminRoutes.map((route) => {
                    return (
                        <Route
                            key={route.path}
                            path={route.path}
                            element={<route.component />}
                        />
                    );
                })}

            {UserStore.isAuth &&
                UserStore.user?.role === role.STUDENT &&
                studentRoutes.map((route) => {
                    return (
                        <Route
                            key={route.path}
                            path={route.path}
                            element={<route.component />}
                        />
                    );
                })}

            {UserStore.isAuth &&
                UserStore.user?.role === role.TEACHER &&
                teacherRoutes.map((route) => {
                    return (
                        <Route
                            key={route.path}
                            path={route.path}
                            element={<route.component />}
                        />
                    );
                })}

            {UserStore.isAuth &&
                UserStore.user?.role === role.DEAN &&
                deanRoutes.map((route) => {
                    return (
                        <Route
                            key={route.path}
                            path={route.path}
                            element={<route.component />}
                        />
                    );
                })}

            {UserStore.isAuth &&
                UserStore.user?.role === role.RECTOR &&
                rectorRoutes.map((route) => {
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
            {/* {!UserStore.isAuth &&
                publicRoutes.map((route) => {
                    return (
                        <Route
                            key={route.path}
                            path={route.path}
                            element={<route.component />}
                        />
                    );
                })} */}

            <Route path={'*'} element={<DefaultPage />} />
        </Routes>
    );
});
