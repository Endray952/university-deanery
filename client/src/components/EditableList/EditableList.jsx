import { Modal } from '@mui/material';
import React, { useState } from 'react';
import ActionDropDown from './ActionDropDown';
import Category from './Category';
import EditableListItem from './EditableListItem';
import ModalStudent from './ModalStudent';
import SearchInput from './SearchInput';
import TableHead from './TableHead';

const EditableList = () => {
    const [isModalOpen, setModalOpen] = useState(false);
    const handleOpen = () => setModalOpen(true);
    const handleClose = () => setModalOpen(false);

    return (
        <>
            <div className='overflow-x-auto relative shadow-md sm:rounded-lg'>
                <div className='flex justify-between items-center py-4 bg-white dark:bg-gray-800'>
                    <ActionDropDown />
                    <SearchInput />
                </div>
                <table className='w-full text-sm text-left text-gray-500 dark:text-gray-400'>
                    <thead className='text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400'>
                        <TableHead />
                    </thead>
                    <tbody>
                        <EditableListItem setModalOpen={setModalOpen} />
                        <EditableListItem setModalOpen={setModalOpen} />
                        <EditableListItem setModalOpen={setModalOpen} />
                        <EditableListItem setModalOpen={setModalOpen} />
                        <EditableListItem setModalOpen={setModalOpen} />
                        <EditableListItem setModalOpen={setModalOpen} />
                    </tbody>
                </table>
            </div>
            <ModalStudent
                isModalOpen={isModalOpen}
                setModalOpen={setModalOpen}
            />
        </>
    );
};

export default EditableList;
