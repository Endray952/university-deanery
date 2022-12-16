import * as React from 'react';
import { Navigate, redirect } from 'react-router-dom';
import UserStore from '../store/UserStore';
import { LOGIN_PATH, STUDENT_PATH } from '../utils/consts';
import { observer } from 'mobx-react-lite';

const DefaultPage = observer(() => {
    console.log(JSON.stringify(UserStore.isAuth));
    if (!UserStore.isAuth) {
        return <Navigate to={LOGIN_PATH} replace />;
    } else {
        return <Navigate to={STUDENT_PATH} replace />;
    }
    //return <Navigate to={LOGIN_PATH} replace />;
});

export default DefaultPage;
