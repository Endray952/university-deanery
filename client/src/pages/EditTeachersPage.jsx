import React from 'react';
import { Container } from '@mui/material';
import { Navigate } from 'react-router-dom';
import EditableList from '../components/EditableList/EditableList';
import Sidebar from '../components/Slidebar/Sidebar';
import { getStudents } from '../http/deanAPI';
import UserStore from '../store/UserStore';
import { ROOT_PATH } from '../utils/consts';
import { studentsListConfig } from '../components/EditableList/ListConfig/StudentsListConfig';

const PageContainerStyle = {
    display: 'flex',
};

export const EditTeachersPage = () => {
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
                        getInfo
                    </div>

                    {
                        //@ts-ignore
                        <EditableList config={studentsListConfig} />
                    }
                </Container>
            </div>
        </>
    );
};
