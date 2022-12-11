import * as React from 'react';
import { Navigate, redirect } from 'react-router-dom';

const DefaultPage = () => {
    return <Navigate to='/login' replace />;
};

export default DefaultPage;
