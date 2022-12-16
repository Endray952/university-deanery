import { Modal } from '@mui/material';
import React, { useState } from 'react';
import ActionDropDown from './ActionDropDown';
import Category from './Category';
import EditableListItem from './EditableListItem';
import SearchInput from './SearchInput';
import TableHead from './TableHead';

const EditableList = () => {
    const [open, setOpen] = useState(false);
    const handleOpen = () => setOpen(true);
    const handleClose = () => setOpen(false);

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
                        <EditableListItem setOpen={setOpen} />
                        <tr className='bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600'>
                            <td className='p-4 w-4'>
                                <div className='flex items-center'>
                                    <input
                                        id='checkbox-table-search-2'
                                        type='checkbox'
                                        className='w-4 h-4 text-blue-600 bg-gray-100 rounded border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600'
                                    />
                                    <label
                                        htmlFor='checkbox-table-search-2'
                                        className='sr-only'
                                    >
                                        checkbox
                                    </label>
                                </div>
                            </td>
                            <th
                                scope='row'
                                className='flex items-center py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white'
                            >
                                <img
                                    className='w-10 h-10 rounded-full'
                                    src='/docs/images/people/profile-picture-3.jpg'
                                    alt='Jese image'
                                />
                                <div className='pl-3'>
                                    <div className='text-base font-semibold'>
                                        Bonnie Green
                                    </div>
                                    <div className='font-normal text-gray-500'>
                                        bonnie@flowbite.com
                                    </div>
                                </div>
                            </th>
                            <td className='py-4 px-6'>Designer</td>
                            <td className='py-4 px-6'>
                                <div className='flex items-center'>
                                    <div className='h-2.5 w-2.5 rounded-full bg-green-400 mr-2'></div>{' '}
                                    Online
                                </div>
                            </td>
                            <td className='py-4 px-6'>
                                {/* <!-- Modal toggle --> */}
                                <a
                                    href='#'
                                    type='button'
                                    data-modal-toggle='editUserModal'
                                    className='font-medium text-blue-600 dark:text-blue-500 hover:underline'
                                >
                                    Edit user
                                </a>
                            </td>
                        </tr>
                        <tr className='bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600'>
                            <td className='p-4 w-4'>
                                <div className='flex items-center'>
                                    <input
                                        id='checkbox-table-search-2'
                                        type='checkbox'
                                        className='w-4 h-4 text-blue-600 bg-gray-100 rounded border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600'
                                    />
                                    <label
                                        htmlFor='checkbox-table-search-2'
                                        className='sr-only'
                                    >
                                        checkbox
                                    </label>
                                </div>
                            </td>
                            <th
                                scope='row'
                                className='flex items-center py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white'
                            >
                                <img
                                    className='w-10 h-10 rounded-full'
                                    src='/docs/images/people/profile-picture-2.jpg'
                                    alt='Jese image'
                                />
                                <div className='pl-3'>
                                    <div className='text-base font-semibold'>
                                        Jese Leos
                                    </div>
                                    <div className='font-normal text-gray-500'>
                                        jese@flowbite.com
                                    </div>
                                </div>
                            </th>
                            <td className='py-4 px-6'>Vue JS Developer</td>
                            <td className='py-4 px-6'>
                                <div className='flex items-center'>
                                    <div className='h-2.5 w-2.5 rounded-full bg-green-400 mr-2'></div>{' '}
                                    Online
                                </div>
                            </td>
                            <td className='py-4 px-6'>
                                {/* <!-- Modal toggle --> */}
                                <a
                                    href='#'
                                    type='button'
                                    data-modal-toggle='editUserModal'
                                    className='font-medium text-blue-600 dark:text-blue-500 hover:underline'
                                >
                                    Edit user
                                </a>
                            </td>
                        </tr>
                        <tr className='bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600'>
                            <td className='p-4 w-4'>
                                <div className='flex items-center'>
                                    <input
                                        id='checkbox-table-search-2'
                                        type='checkbox'
                                        className='w-4 h-4 text-blue-600 bg-gray-100 rounded border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600'
                                    />
                                    <label
                                        htmlFor='checkbox-table-search-2'
                                        className='sr-only'
                                    >
                                        checkbox
                                    </label>
                                </div>
                            </td>
                            <th
                                scope='row'
                                className='flex items-center py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white'
                            >
                                <img
                                    className='w-10 h-10 rounded-full'
                                    src='/docs/images/people/profile-picture-5.jpg'
                                    alt='Jese image'
                                />
                                <div className='pl-3'>
                                    <div className='text-base font-semibold'>
                                        Thomas Lean
                                    </div>
                                    <div className='font-normal text-gray-500'>
                                        thomes@flowbite.com
                                    </div>
                                </div>
                            </th>
                            <td className='py-4 px-6'>UI/UX Engineer</td>
                            <td className='py-4 px-6'>
                                <div className='flex items-center'>
                                    <div className='h-2.5 w-2.5 rounded-full bg-green-400 mr-2'></div>{' '}
                                    Online
                                </div>
                            </td>
                            <td className='py-4 px-6'>
                                <a
                                    href='#'
                                    type='button'
                                    data-modal-toggle='editUserModal'
                                    className='font-medium text-blue-600 dark:text-blue-500 hover:underline'
                                >
                                    Edit user
                                </a>
                            </td>
                        </tr>
                        <tr className='bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-600'>
                            <td className='p-4 w-4'>
                                <div className='flex items-center'>
                                    <input
                                        id='checkbox-table-search-3'
                                        type='checkbox'
                                        className='w-4 h-4 text-blue-600 bg-gray-100 rounded border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600'
                                    />
                                    <label
                                        htmlFor='checkbox-table-search-3'
                                        className='sr-only'
                                    >
                                        checkbox
                                    </label>
                                </div>
                            </td>
                            <th
                                scope='row'
                                className='flex items-center py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white'
                            >
                                <img
                                    className='w-10 h-10 rounded-full'
                                    src='/docs/images/people/profile-picture-4.jpg'
                                    alt='Jese image'
                                />
                                <div className='pl-3'>
                                    <div className='text-base font-semibold'>
                                        Leslie Livingston
                                    </div>
                                    <div className='font-normal text-gray-500'>
                                        leslie@flowbite.com
                                    </div>
                                </div>
                            </th>
                            <td className='py-4 px-6'>SEO Specialist</td>
                            <td className='py-4 px-6'>
                                <div className='flex items-center'>
                                    <div className='h-2.5 w-2.5 rounded-full bg-red-500 mr-2'></div>{' '}
                                    Offline
                                </div>
                            </td>
                            <td className='py-4 px-6'>
                                <a
                                    href='#'
                                    type='button'
                                    data-modal-toggle='editUserModal'
                                    className='font-medium text-blue-600 dark:text-blue-500 hover:underline'
                                >
                                    Edit user
                                </a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <Modal
                open={open}
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
                            action='#'
                            className='relative bg-white rounded-lg shadow dark:bg-gray-700'
                        >
                            {/* <!-- Modal header --> */}
                            <div className='flex justify-between items-start p-4 rounded-t border-b dark:border-gray-600'>
                                <h3 className='text-xl font-semibold text-gray-900 dark:text-white'>
                                    Edit user
                                </h3>
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
                                        onClick={(e) => handleClose()}
                                    >
                                        <path
                                            fillRule='evenodd'
                                            d='M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z'
                                            clipRule='evenodd'
                                        ></path>
                                    </svg>
                                </button>
                            </div>
                            {/* <!-- Modal body --> */}
                            <div className='p-6 space-y-6'>
                                <div className='grid grid-cols-6 gap-6'>
                                    <div className='col-span-6 sm:col-span-3'>
                                        <label
                                            htmlFor='first-name'
                                            className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
                                        >
                                            First Name
                                        </label>
                                        <input
                                            type='text'
                                            name='first-name'
                                            id='first-name'
                                            className='shadow-sm bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                                            placeholder='Bonnie'
                                            required
                                        />
                                    </div>
                                    <div className='col-span-6 sm:col-span-3'>
                                        <label
                                            htmlFor='last-name'
                                            className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
                                        >
                                            Last Name
                                        </label>
                                        <input
                                            type='text'
                                            name='last-name'
                                            id='last-name'
                                            className='shadow-sm bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                                            placeholder='Green'
                                            required
                                        />
                                    </div>
                                    <div className='col-span-6 sm:col-span-3'>
                                        <label
                                            htmlFor='email'
                                            className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
                                        >
                                            Email
                                        </label>
                                        <input
                                            type='email'
                                            name='email'
                                            id='email'
                                            className='shadow-sm bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                                            placeholder='example@company.com'
                                            required
                                        />
                                    </div>
                                    <div className='col-span-6 sm:col-span-3'>
                                        <label
                                            htmlFor='phone-number'
                                            className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
                                        >
                                            Phone Number
                                        </label>
                                        <input
                                            type='number'
                                            name='phone-number'
                                            id='phone-number'
                                            className='shadow-sm bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                                            placeholder='e.g. +(12)3456 789'
                                            required
                                        />
                                    </div>
                                    <div className='col-span-6 sm:col-span-3'>
                                        <label
                                            htmlFor='department'
                                            className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
                                        >
                                            Department
                                        </label>
                                        <input
                                            type='text'
                                            name='department'
                                            id='department'
                                            className='shadow-sm bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                                            placeholder='Development'
                                            required
                                        />
                                    </div>
                                    <div className='col-span-6 sm:col-span-3'>
                                        <label
                                            htmlFor='company'
                                            className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
                                        >
                                            Company
                                        </label>
                                        <input
                                            type='number'
                                            name='company'
                                            id='company'
                                            className='shadow-sm bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                                            placeholder='123456'
                                            required
                                        />
                                    </div>
                                    <div className='col-span-6 sm:col-span-3'>
                                        <label
                                            htmlFor='current-password'
                                            className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
                                        >
                                            Current Password
                                        </label>
                                        <input
                                            type='password'
                                            name='current-password'
                                            id='current-password'
                                            className='shadow-sm bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                                            placeholder='••••••••'
                                            required
                                        />
                                    </div>
                                    <div className='col-span-6 sm:col-span-3'>
                                        <label
                                            htmlFor='new-password'
                                            className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
                                        >
                                            New Password
                                        </label>
                                        <input
                                            type='password'
                                            name='new-password'
                                            id='new-password'
                                            className='shadow-sm bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                                            placeholder='••••••••'
                                            required
                                        />
                                    </div>
                                </div>
                            </div>
                            {/* <!-- Modal footer --> */}
                            <div className='flex items-center p-6 space-x-2 rounded-b border-t border-gray-200 dark:border-gray-600'>
                                <button
                                    type='submit'
                                    className='text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800'
                                >
                                    Save all
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </Modal>
        </>
    );
};

export default EditableList;
