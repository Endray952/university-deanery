import React from 'react';
import { v4 as uuid } from 'uuid';
import { getSubjectMarksInfo } from '../../http/studentAPI';
import UserStore from '../../store/UserStore';
import marksWithDatesConfig from '../Marks/MarksWithDatesConfig';

const EditableListItem = ({ setModalOpen, listRow, setModalItem, item }) => {
    const handleOpenModal = () => {
        setModalItem();

        marksWithDatesConfig.asyncGetItems = () =>
            getSubjectMarksInfo(UserStore.user.id, item.subject_id);

        console.log(item);
        setModalOpen(true);
    };

    return (
        <tr className='bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600'>
            {/* <!-- Modal header --> */}
            <th
                scope='row'
                className='flex items-center py-4 px-6 text-gray-900 whitespace-nowrap dark:text-white'
            >
                <div className='pl-3'>
                    <div className='text-base font-semibold'>
                        {listRow.heading.mainText}
                    </div>
                    {listRow.heading.secondaryText && (
                        <div className='font-normal text-gray-500'>
                            {listRow.heading.secondaryText}
                        </div>
                    )}
                </div>
            </th>

            {listRow.tableItems.map((item) => {
                return (
                    <td key={uuid()} className='py-4 px-6'>
                        {item || 'неизвестно'}
                    </td>
                );
            })}

            {listRow.actionName && (
                <td className='py-4 px-6'>
                    {/* <!-- Modal toggle --> */}
                    <button
                        onClick={handleOpenModal}
                        data-modal-toggle='editUserModal'
                        className='font-medium text-blue-600 dark:text-blue-500 hover:underline'
                    >
                        {listRow.actionName}
                    </button>
                </td>
            )}
        </tr>
    );
};

export default EditableListItem;
