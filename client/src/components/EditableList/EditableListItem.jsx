import React from 'react';

const EditableListItem = ({ setModalOpen, student }) => {
    let status = '';
    switch (student.student_status) {
        case 'enrolled':
            status = 'учится';
            break;
        case 'expelled':
            status = 'отчислен';
            break;
        case 'academic_leave':
            status = 'академический отпуск';
            break;
        case 'graduated':
            status = 'окончил обучение';
            break;
        default:
            status = 'неизвестно';
    }

    return (
        <tr className='bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600'>
            <th
                scope='row'
                className='flex items-center py-4 px-6 text-gray-900 whitespace-nowrap dark:text-white'
            >
                <div className='pl-3'>
                    <div className='text-base font-semibold'>{`${
                        student.name || 'неизвестно'
                    } ${student.surname || 'неизвестно'}`}</div>
                    <div className='font-normal text-gray-500'>
                        {`${student.email || 'неизвестно'}`}
                    </div>
                </div>
            </th>
            <td className='py-4 px-6'>{status}</td>
            <td className='py-4 px-6'>
                {`${student.code_number || 'неизвестно'}`}{' '}
            </td>
            <td className='py-4 px-6'>
                {`${student.semestr_number || 'неизвестно'}`}{' '}
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
                    Изменить
                </button>
            </td>
        </tr>
    );
};

export default EditableListItem;
