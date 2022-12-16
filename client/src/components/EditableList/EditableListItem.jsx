import React from 'react';

const EditableListItem = ({ setModalOpen, student }) => {
    return (
        <tr className='bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600'>
            <th
                scope='row'
                className='flex items-center py-4 px-6 text-gray-900 whitespace-nowrap dark:text-white'
            >
                <div className='pl-3'>
                    <div className='text-base font-semibold'>Neil Sims</div>
                    <div className='font-normal text-gray-500'>
                        neil.sims@flowbite.com
                    </div>
                </div>
            </th>
            <td className='py-4 px-6'>React Developer</td>
            <td className='py-4 px-6'>
                <div className='flex items-center'>
                    <div className='h-2.5 w-2.5 rounded-full bg-green-400 mr-2'></div>{' '}
                    Online
                </div>
            </td>
            <td className='py-4 px-6'>
                {/* <!-- Modal toggle --> */}
                <button
                    onClick={(e) => {
                        setModalOpen(true);
                    }}
                    data-modal-toggle='editUserModal'
                    className='font-medium text-blue-600 dark:text-blue-500 hover:underline'
                >
                    Edit user
                </button>
            </td>
        </tr>
    );
};

export default EditableListItem;
