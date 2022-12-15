import { Container } from '@mui/material';
import React from 'react';
import { Navigate, useNavigate } from 'react-router-dom';
import Sidebar from '../components/Slidebar/Slidebar';
import UserStore from '../store/UserStore';
import { DEFAULT_PATH } from '../utils/consts';

const PageContainerStyle = {
    display: 'flex',
};

export const ToursPage = () => {
    if (!UserStore.isAuth) {
        return <Navigate to={DEFAULT_PATH} replace />;
    }

    return (
        <>
            <div style={PageContainerStyle}>
                <Sidebar />
                <Container maxWidth='xl' color='cyan'>
                    <div>ToursPage</div>
                </Container>
            </div>
        </>
    );
};
