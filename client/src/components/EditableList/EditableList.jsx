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

const EditableList = ({ config }) => {
    const [isModalOpen, setModalOpen] = useState(false);
    const [listItems, setListItems] = useState(null);
    const [loading, setLoading] = useState(true);
    const [searchInput, setSearchInput] = useState('');
    const [modalItem, setModalItem] = useState(null);
    useEffect(() => {
        config
            .asyncGetItems()
            .then((data) => {
                setListItems(data);
            })
            .finally(() => setLoading(false));
    }, []);

    if (loading) {
        return <Spinner />;
    }
    console.log(modalItem, 'config: ', config.modal);
    if (!listItems) {
        console.log(listItems);
        return <div>Ошибка загрузики данных</div>;
    }

    return (
        <>
            <div className='overflow-x-auto relative shadow-md sm:rounded-lg '>
                <div className='flex justify-between items-center py-4 bg-white dark:bg-gray-800'>
                    <ActionDropDown />
                    <SearchInput
                        searchConfig={config.searchConfig}
                        searchInput={searchInput}
                        setSearchInput={setSearchInput}
                    />
                </div>
                <table className='w-full text-sm text-left text-gray-500 dark:text-gray-400'>
                    <thead className='text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400'>
                        <EditableListHead
                            editableListHead={config.editableListHead}
                        />
                    </thead>
                    <tbody>
                        {listItems.map((item) => {
                            if (
                                config.searchConfig.searchBy(item, searchInput)
                            ) {
                                return (
                                    <EditableListItem
                                        id={uuid()}
                                        setModalOpen={setModalOpen}
                                        setModalItem={() => setModalItem(item)}
                                        listRow={config.getListRow(item)}
                                    />
                                );
                            } else {
                                return null;
                            }
                        })}
                    </tbody>
                </table>
            </div>
            <ModalWindow
                id={uuid()}
                isModalOpen={isModalOpen}
                setModalOpen={setModalOpen}
                modalConfig={config.modal}
                modalItem={modalItem}
            />
        </>
    );
};

export default EditableList;
