import { Container } from '@mui/material';
import React from 'react';
import { Navigate } from 'react-router-dom';

import Sidebar from '../components/Slidebar/Sidebar';
import EditableListDate from '../components/TeacherShedule/EditableListDate';
import { TeacherLessonConfig } from '../components/TeacherShedule/TeacherLessonConfig';
import { getMySheduleByUserId, getTeacherIdByUserId } from '../http/teacherAPI';
import UserStore from '../store/UserStore';
import { ROOT_PATH } from '../utils/consts';

const PageContainerStyle = {
    display: 'flex',
};

export const TeacherSchedulePage = () => {
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
                        <EditableListDate config={TeacherLessonConfig} />
                    }
                    <div
                        onClick={async () =>
                            console.log(await getMySheduleByUserId())
                        }
                    ></div>
                </Container>
            </div>
        </>
    );
};
