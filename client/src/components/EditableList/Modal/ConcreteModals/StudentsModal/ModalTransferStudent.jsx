import { Modal } from '@mui/material';
import React, { useEffect, useState } from 'react';
import GroupSelect from '../../ActionModals/ModalCreateStudent/GroupSelect';
import { v4 as uuid } from 'uuid';
import { getCurrentGroups } from '../../../../../http/deanAPI';
import Spinner from '../../../../Spinner';

const ModalTransferStudent = ({
    isModalOpen,
    setModalOpen,
    modalName,
    selectedGroupId,
    setSelectedGroupId,
}) => {
    const [groups, setGroups] = useState(null);
    //const [selectedGroupId, setSelectedGroupId] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [errorMsg, setErrorMsg] = useState(true);

    useEffect(() => {
        try {
            getCurrentGroups()
                .then((response) => {
                    setGroups(response);
                })
                .finally(() => setIsLoading(false));
        } catch (e) {
            console.log(e);
            setErrorMsg(e);
        }
    }, []);

    const handleClose = () => {
        setSelectedGroupId(null);
        setModalOpen(false);
    };

    const handleTransferStudent = () => {
        setModalOpen(false);
    };

    if (isLoading) {
        return (
            <>
                <p>{errorMsg}</p>
                <Spinner />
            </>
        );
    }

    return (
        <Modal
            open={isModalOpen}
            onClose={handleClose}
            aria-labelledby='modal-modal-title'
            aria-describedby='modal-modal-description'
        >
            <div
                id='editUserModal'
                tabIndex={-1}
                aria-hidden='true'
                className='flex overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center p-4 w-full md:inset-0 h-modal md:h-full'
            >
                <div className='relative w-full max-w-2xl h-full md:h-auto'>
                    {/* <!-- Modal content --> */}
                    <form
                        id='dura'
                        action='#'
                        className='relative bg-white rounded-lg shadow dark:bg-gray-700'
                    >
                        {/* <!-- Modal header --> */}
                        <div className='flex justify-between items-start p-4 rounded-t border-b dark:border-gray-600'>
                            <h3 className='text-xl font-semibold text-gray-900 dark:text-white'>
                                {modalName}
                            </h3>
                            {CloseButton(handleClose)}
                        </div>

                        {/* <!-- Modal body --> */}

                        {
                            <GroupSelect
                                groups={groups}
                                selectedGroupId={selectedGroupId}
                                setSelectedGroupId={setSelectedGroupId}
                            />
                        }
                        <div
                            className='flex items-center p-6 space-x-2 rounded-b border-t border-gray-200 dark:border-gray-600'
                            style={{ justifyContent: 'space-between' }}
                        >
                            <button
                                onClick={handleTransferStudent}
                                className=' text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800'
                            >
                                Добавить
                            </button>
                            <button
                                onClick={handleClose}
                                className=' text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800'
                            >
                                Отмена
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </Modal>
    );
};

export default ModalTransferStudent;

const CloseButton = (handleClose) => {
    return (
        <button
            type='button'
            className='text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center dark:hover:bg-gray-600 dark:hover:text-white'
            data-modal-toggle='editUserModal'
        >
            <svg
                className='w-5 h-5'
                fill='currentColor'
                viewBox='0 0 20 20'
                xmlns='http://www.w3.org/2000/svg'
                onClick={handleClose}
            >
                <path
                    fillRule='evenodd'
                    d='M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z'
                    clipRule='evenodd'
                ></path>
            </svg>
        </button>
    );
};
