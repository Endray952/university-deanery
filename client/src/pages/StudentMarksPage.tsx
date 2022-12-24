import { Container } from '@mui/material';
import React, { useEffect, useState } from 'react';
import { Navigate, useNavigate } from 'react-router-dom';
import EditableListPage from '../components/Marks/EditableListPage';
import { studentMarksConfig } from '../components/Marks/StudentMarksConfig';

import Sidebar from '../components/Slidebar/Sidebar';
import { getStudents } from '../http/deanAPI';
import {
    getAllCurrentMarksByStudentId,
    getAllCurrentMarksByUserId,
    getStudentByUserId,
} from '../http/studentAPI';
import UserStore from '../store/UserStore';
import { ROOT_PATH } from '../utils/consts';

const PageContainerStyle = {
    display: 'flex',
};

export const StudentMarksPage = () => {
    const [currentStudent, setCurrentStudent] = useState<any>(null);

    const getStudent = async () => {
        try {
            // console.log(UserStore?.user?.id);
            if (UserStore?.user?.id) {
                // console.log('inside');
                const student: any = await getStudentByUserId(
                    UserStore.user.id
                );
                // console.log(student);
                setCurrentStudent(student?.student_id);
            }
        } catch (e) {
            console.log(e);
        }
    };
    useEffect(() => {
        getStudent();
    }, []);

    const getMarks = async () => {
        console.log(currentStudent);
        //@ts-ignore
        console.log(
            currentStudent
                ? await getAllCurrentMarksByStudentId(currentStudent)
                : 'current student null'
        );
        console.log(await getAllCurrentMarksByUserId(UserStore?.user?.id));
    };

    if (!UserStore.isAuth) {
        return <Navigate to={ROOT_PATH} replace />;
    }
    return (
        <>
            <div style={PageContainerStyle}>
                <Sidebar />
                <Container maxWidth='xl' color='cyan'>
                    <EditableListPage config={studentMarksConfig} />
                    <div onClick={getMarks}></div>
                </Container>
            </div>
        </>
    );
};
