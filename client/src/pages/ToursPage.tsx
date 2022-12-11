import { Container } from '@mui/material';
import React from 'react';
import { Navigate, useNavigate } from 'react-router-dom';
import UserStore from '../store/UserStore';
import { DEFAULT_PATH } from '../utils/consts';

export const ToursPage = () => {
    if (!UserStore.isAuth) {
        return <Navigate to={DEFAULT_PATH} replace />;
    }

    return (
        <>
            <Container maxWidth='xl' color='cyan'>
                <div>ToursPage</div>
            </Container>
        </>
    );
};
