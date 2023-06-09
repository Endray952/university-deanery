import React, { useState } from 'react';
import ModalAddStudent from '../Modal/ActionModals/ModalCreateStudent/ModalAddStudent';

const StudentsActions = ({ students }) => {
    const [isOpen, setOpen] = useState(true);
    const [isModalAddStudentOpen, setModalAddStudentOpen] = useState(false);

    return (
        <>
            <div style={{ marginLeft: '15px' }}>
                <button
                    id='dropdownActionButton'
                    data-dropdown-toggle='dropdownAction'
                    className='inline-flex items-center text-gray-500 bg-white border border-gray-300 focus:outline-none hover:bg-gray-100 focus:ring-4 focus:ring-gray-200 font-medium rounded-lg text-sm px-3 py-1.5 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:bg-gray-700 dark:hover:border-gray-600 dark:focus:ring-gray-700'
                    onClick={(e) => setOpen(!isOpen)}
                >
                    <span className='sr-only'>Action button</span>
                    Действия
                    <svg
                        className='ml-2 w-3 h-3'
                        aria-hidden='true'
                        fill='none'
                        stroke='currentColor'
                        viewBox='0 0 24 24'
                        xmlns='http://www.w3.org/2000/svg'
                    >
                        <path
                            strokeLinecap='round'
                            strokeLinejoin='round'
                            strokeWidth='2'
                            d='M19 9l-7 7-7-7'
                        ></path>
                    </svg>
                </button>
                {/* <!-- Dropdown menu --> */}
                <div
                    id='dropdownAction'
                    className=' z-10 w-44 bg-white rounded divide-y divide-gray-100 shadow dark:bg-gray-700 dark:divide-gray-600 absolute'
                    hidden={isOpen}
                >
                    <ul
                        className='py-1 text-sm text-gray-700 dark:text-gray-200'
                        aria-labelledby='dropdownActionButton'
                    >
                        <li>
                            <div
                                className='cursor-pointer block py-2 px-4 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white'
                                onClick={() => {
                                    setModalAddStudentOpen(true);
                                    setOpen(!isOpen);
                                }}
                            >
                                Добавить студента
                            </div>
                        </li>
                    </ul>
                    {/* <div className='py-1'>
                        <a
                            href='#'
                            className='block py-2 px-4 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white'
                        >
                            Delete User
                        </a>
                    </div> */}
                </div>
            </div>
            {/* <!-- AddStudentModal --> */}
            <ModalAddStudent
                isModalOpen={isModalAddStudentOpen}
                setModalOpen={setModalAddStudentOpen}
            />
        </>
    );
};

export default StudentsActions;
