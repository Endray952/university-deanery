import { Container } from '@mui/material';
import React from 'react';
import { Navigate, useNavigate } from 'react-router-dom';

import EditableList from '../components/EditableList/EditableList';
import { studentsListConfig } from '../components/EditableList/ListConfig/StudentsListConfig';
import Sidebar from '../components/Slidebar/Slidebar';
import { getStudents } from '../http/deanAPI';
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
                    <div
                        onClick={async (e) => console.log(await getStudents())}
                    >
                        ToursPage
                    </div>
                    <EditableList config={studentsListConfig} />
                </Container>
            </div>
        </>
    );
};
