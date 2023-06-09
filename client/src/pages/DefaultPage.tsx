import * as React from 'react';
import { Navigate, redirect } from 'react-router-dom';
import UserStore from '../store/UserStore';
import {
    LOGIN_PATH,
    role,
    STUDENTS_EDIT_PATH,
    STUDENT_SHEDULE_PATH,
    TEACHER_SHEDULE_PATH,
} from '../utils/consts';
import { observer } from 'mobx-react-lite';

const DefaultPage = observer(() => {
    console.log('kek', JSON.stringify(UserStore.user?.role), role.TEACHER);
    if (!UserStore.isAuth) {
        return <Navigate to={LOGIN_PATH} replace />;
    } else {
        switch (UserStore.user?.role) {
            case role.ADMIN:
                return <Navigate to={STUDENTS_EDIT_PATH} replace />;
                break;
            case role.RECTOR:
                return <Navigate to={STUDENTS_EDIT_PATH} replace />;
                break;
            case role.DEAN:
                return <Navigate to={STUDENTS_EDIT_PATH} replace />;
                break;
            case role.TEACHER:
                return <Navigate to={TEACHER_SHEDULE_PATH} replace />;
                break;
            case role.STUDENT:
                return <Navigate to={STUDENT_SHEDULE_PATH} replace />;
                break;
            default:
                return <Navigate to={LOGIN_PATH} replace />;
        }
    }
    //return <Navigate to={LOGIN_PATH} replace />;
});

export default DefaultPage;
