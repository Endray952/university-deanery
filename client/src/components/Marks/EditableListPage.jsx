import React, { useEffect, useState, useRef } from 'react';

import Pagination from '@mui/material/Pagination';
import SearchInput from '../EditableList/SearchInput';
import EditableListHead from '../EditableList/EditableListHead';
import EditableListItem from '../EditableList/EditableListItem';
import { Spinner } from 'react-bootstrap';
import ModalWindow from '../EditableList/Modal/ModalWindow';

export const EditableListContext = React.createContext();

const pageRatio = 5;

const EditableListPage = ({ config }) => {
    const [isModalOpen, setModalOpen] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const [listItems, setListItems] = useState(null);
    const [searchInput, setSearchInput] = useState('');
    const [modalItem, setModalItem] = useState(null);
    const [currentPage, setCurrentPage] = useState(1);

    useEffect(() => {
        config
            .asyncGetItems()
            .then((response) => {
                setListItems(response);
            })
            .finally(() => {
                setIsLoading(false);
            });
    }, []);

    if (isLoading) {
        return <Spinner />;
    }

    if (!listItems) {
        return <div>Ошибка загрузки данных</div>;
    }
    //log(listItems);
    return (
        <EditableListContext.Provider
            value={{
                setListItems,
                setIsLoading,
                asyncGetItems: config.asyncGetItems.bind(config),
            }}
        >
            <div className='overflow-x-auto relative shadow-md sm:rounded-lg'>
                <div className='flex justify-between items-center py-4 bg-white'>
                    {/* <ActionDropDown config={config.actionDropDown} /> */}
                    <div></div>
                    {listItems.filter((item) =>
                        config.searchConfig.searchBy(item, searchInput)
                    ).length > pageRatio && (
                        <Pagination
                            count={Math.ceil(
                                listItems.filter((item) =>
                                    config.searchConfig.searchBy(
                                        item,
                                        searchInput
                                    )
                                ).length / pageRatio
                            )}
                            page={currentPage}
                            onChange={(e, val) => setCurrentPage(val)}
                            color='primary'
                        />
                    )}
                    <SearchInput
                        searchConfig={config.searchConfig}
                        searchInput={searchInput}
                        setSearchInput={setSearchInput}
                    />
                </div>
                <table className='w-full text-sm text-left text-gray-500'>
                    <thead className='text-xs text-gray-700 uppercase bg-gray-50'>
                        <EditableListHead
                            editableListHead={config.editableListHead}
                        />
                    </thead>
                    <tbody>
                        {(config.sort !== undefined
                            ? listItems.sort(config.sort)
                            : listItems
                        )
                            .filter((item) =>
                                config.searchConfig.searchBy(item, searchInput)
                            )
                            .map((item, index) => (
                                <EditableListItem
                                    key={index}
                                    setModalOpen={setModalOpen}
                                    setModalItem={() => setModalItem(item)}
                                    listRow={config.getListRow(item)}
                                    item={item}
                                />
                            ))
                            .slice(
                                (currentPage - 1) * pageRatio,
                                (currentPage - 1) * pageRatio + pageRatio
                            )}
                    </tbody>
                </table>
            </div>
            {config.modal && (
                <ModalWindow
                    isModalOpen={isModalOpen}
                    setModalOpen={setModalOpen}
                    modalConfig={config.modal}
                    modalItem={modalItem}
                />
            )}
        </EditableListContext.Provider>
    );
};

export default EditableListPage;
