import { Modal } from '@mui/material';
import React, { useEffect, useState } from 'react';
import { getStudents } from '../../http/deanAPI';
import Spinner from '../Spinner';
import ActionDropDown from './ActionDropDown';
import ModalWindow from './Modal/ModalWindow';
import SearchInput from './SearchInput';
import EditableListHead from './EditableListHead';
import { v4 as uuid } from 'uuid';
import EditableListItem from './EditableListItem';

const EditableList = () => {
    const [isModalOpen, setModalOpen] = useState(false);
    const [students, setStudents] = useState(null);
    const [loading, setLoading] = useState(true);
    useEffect(() => {
        getStudents()
            .then((data) => {
                setStudents(data);
            })
            .finally(() => setLoading(false));
        console.log(students);
    }, []);

    if (loading) {
        return <Spinner />;
    }

    if (!students) {
        console.log(students);
        return <div>Ошибка загрузики данных</div>;
    }
    return (
        <>
            <div className='overflow-x-auto relative shadow-md sm:rounded-lg'>
                <div className='flex justify-between items-center py-4 bg-white dark:bg-gray-800'>
                    <ActionDropDown />
                    <SearchInput />
                </div>
                <table className='w-full text-sm text-left text-gray-500 dark:text-gray-400'>
                    <thead className='text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400'>
                        <EditableListHead />
                    </thead>
                    <tbody>
                        {students.map((student) => {
                            return (
                                <EditableListItem
                                    id={uuid()}
                                    setModalOpen={setModalOpen}
                                    student={student}
                                />
                            );
                        })}
                    </tbody>
                </table>
            </div>
            <ModalWindow
                id={uuid()}
                isModalOpen={isModalOpen}
                setModalOpen={setModalOpen}
                modalName={'Редактировать студента'}
            />
        </>
    );
};

export default EditableList;
