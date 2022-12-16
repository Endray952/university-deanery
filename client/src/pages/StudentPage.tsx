import { Container } from '@mui/material';
import React from 'react';
import { Navigate, useNavigate } from 'react-router-dom';

import EditableList from '../components/EditableList/EditableList';
import Sidebar from '../components/Slidebar/Slidebar';
import UserStore from '../store/UserStore';
import { ROOT_PATH } from '../utils/consts';

const PageContainerStyle = {
    display: 'flex',
};

export const StudentPage = () => {
    if (!UserStore.isAuth) {
        return <Navigate to={ROOT_PATH} replace />;
    }

    return (
        <>
            <div style={PageContainerStyle}>
                <Sidebar />
                <Container maxWidth='xl' color='cyan'>
                    <div>ToursPage</div>
                    <EditableList />
                </Container>
            </div>
        </>
    );
};
