import { Modal } from '@mui/material';
import React, { useState } from 'react';

const ModalWindow = ({ isModalOpen, setModalOpen, modalConfig, modalItem }) => {
    const handleClose = () => setModalOpen(false);
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
                                {modalConfig.modalName}
                            </h3>
                        </div>

                        {/* <!-- Modal body --> */}

                        {modalConfig.modalContent(modalItem, handleClose)}
                    </form>
                </div>
            </div>
        </Modal>
    );
};

export default ModalWindow;
