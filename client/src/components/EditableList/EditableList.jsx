import React, { useEffect, useState } from 'react';
import Spinner from '../Spinner';
import ActionDropDown from './ActionDropDown';
import ModalWindow from './Modal/ModalWindow';
import SearchInput from './SearchInput';
import EditableListHead from './EditableListHead';
import { v4 as uuid } from 'uuid';
import EditableListItem from './EditableListItem';
import Pagination from '@mui/material/Pagination';

export const EditableListContext = React.createContext();

const pageRatio = 5;

const EditableList = ({ config }) => {
    const [isModalOpen, setModalOpen] = useState(false);
    const [listItems, setListItems] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [searchInput, setSearchInput] = useState('');
    const [modalItem, setModalItem] = useState(null);
    const [currentPage, setCurrentPage] = useState(1);

    useEffect(() => {
        config
            .asyncGetItems()
            .then((data) => {
                setListItems(data);
            })
            .finally(() => setIsLoading(false));
    }, []);

    if (isLoading) {
        return <Spinner />;
    }

    if (!listItems) {
        console.log(listItems);
        return <div>Ошибка загрузики данных</div>;
    }

    return (
        <EditableListContext.Provider
            value={{
                setListItems,
                setIsLoading,
                asyncGetItems: config.asyncGetItems.bind(config),
            }}
        >
            <div className='overflow-x-auto relative shadow-md sm:rounded-lg '>
                <div className='flex justify-between items-center py-4 bg-white dark:bg-gray-800'>
                    <ActionDropDown />
                    <Pagination
                        count={
                            +(
                                listItems.filter((item) =>
                                    config.searchConfig.searchBy(
                                        item,
                                        searchInput
                                    )
                                ).length / pageRatio
                            ).toFixed(0)
                        }
                        page={currentPage}
                        onChange={(e, val) => setCurrentPage(val)}
                        color='primary'
                    />

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
                        {listItems
                            .filter((item) =>
                                config.searchConfig.searchBy(item, searchInput)
                            )
                            .map((item) => {
                                return (
                                    <EditableListItem
                                        key={uuid()}
                                        setModalOpen={setModalOpen}
                                        setModalItem={() => setModalItem(item)}
                                        listRow={config.getListRow(item)}
                                    />
                                );
                            })
                            .slice(
                                (currentPage - 1) * pageRatio,
                                (currentPage - 1) * pageRatio + pageRatio
                            )}
                    </tbody>
                </table>
            </div>
            <ModalWindow
                key={uuid()}
                isModalOpen={isModalOpen}
                setModalOpen={setModalOpen}
                modalConfig={config.modal}
                modalItem={modalItem}
            />
        </EditableListContext.Provider>
    );
};

export default EditableList;
