import { Container } from '@mui/material';
import React from 'react';
import { Navigate } from 'react-router-dom';
import EditableListDate from '../components/EditableListDate/EditableListDate';
import { StudentLessonsConfig } from '../components/EditableListDate/StudentLessonsConfig';
import Sidebar from '../components/Slidebar/Sidebar';
import { getGroupSheduleById } from '../http/studentAPI';
import UserStore from '../store/UserStore';
import { ROOT_PATH } from '../utils/consts';

const PageContainerStyle = {
    display: 'flex',
};

export const StudentShedule = () => {
    if (!UserStore.isAuth) {
        return <Navigate to={ROOT_PATH} replace />;
    }

    return (
        <>
            <div style={PageContainerStyle}>
                <Sidebar />
                <Container maxWidth='xl' color='cyan'>
                    {
                        //@ts-ignore
                        <EditableListDate config={StudentLessonsConfig} />
                    }
                    <div onClick={() => getGroupSheduleById()}>getInfo</div>
                </Container>
            </div>
        </>
    );
};
