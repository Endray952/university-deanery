import React, { useEffect, useState, useRef } from 'react';

import EditableListItemDelimeter from './EditableListItemDelimeter';
import ModalWindow from '../EditableList/Modal/ModalWindow';
import { addDaysToDate, DatePagination, toNormalDate } from './DatePagination';
import SearchInput from '../EditableList/SearchInput';
import EditableListHead from '../EditableList/EditableListHead';
import EditableListItem from '../EditableList/EditableListItem';
import Spinner from '../Spinner';

export const EditableListContext = React.createContext();

const pageRatio = 5;

let weekDay = 1;

const week = [
    'Воскресенье',
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
];

const EditableListDate = ({ config, shouldUpdate }) => {
    const [isModalOpen, setModalOpen] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const [listItems, setListItems] = useState(null);
    const [searchInput, setSearchInput] = useState('');
    const [modalItem, setModalItem] = useState(null);
    const [currentPage, setCurrentPage] = useState(
        new Date(
            new Date().setDate(new Date().getDate() - new Date().getDay() + 1)
        ).toDateString()
    );
    console.log(currentPage);
    console.log(new Date(currentPage));
    const [currentListItems, setCurrentListItems] = useState([]);
    const sortedListItems = useRef([]);

    const currentPageStartDate = useRef(new Date(currentPage));
    const currentPageEndDate = useRef(
        new Date(addDaysToDate(currentPageStartDate.current, 6))
    );

    useEffect(() => {
        setCurrentPage(currentPage);
    }, [listItems]);

    useEffect(() => {
        currentPageStartDate.current = new Date(currentPage);
        currentPageEndDate.current = new Date(
            addDaysToDate(currentPageStartDate.current, 6)
        );

        if (!listItems) {
            return;
        }

        const list = [];
        //console.log(currentPageEndDate, currentPageStartDate);
        // console.log(currentPage);
        sortedListItems.current = (
            config.sort !== undefined ? listItems.sort(config.sort) : listItems
        )
            .filter((item) => config.searchConfig.searchBy(item, searchInput))
            .filter((item) => {
                // console.log(
                //     new Date(item.date).getTime() <
                //         currentPageEndDate.current.getTime() &&
                //         new Date(item.date).getTime() >
                //             currentPageStartDate.current.getTime()
                // );
                return (
                    new Date(item.date).getTime() <
                        currentPageEndDate.current.getTime() &&
                    new Date(item.date).getTime() >
                        currentPageStartDate.current.getTime()
                );
            });

        for (const [index, item] of sortedListItems.current.entries()) {
            if (index === 0) {
                console.log(new Date(item.date));
                list.push(
                    config.getListRowDelimeterObj(
                        `${week[weekDay]} ${toNormalDate(new Date(item.date))}`
                    )
                );
            }

            if (new Date(item.date).getDay() !== weekDay && weekDay < 7) {
                weekDay++;
                list.push(
                    config.getListRowDelimeterObj(
                        `${week[weekDay]} ${toNormalDate(new Date(item.date))}`
                    )
                );
            }

            list.push(item);
        }
        console.log(sortedListItems);
        setCurrentListItems(list);

        weekDay = 1;
    }, [currentPage, listItems, searchInput]);

    const updateComponent = () => {
        setIsLoading(true);
        config
            .asyncGetItems()
            .then((response) => {
                setListItems(response);
            })
            .finally(() => {
                setIsLoading(false);
            });
    };

    useEffect(() => {
        setIsLoading(true);
        config
            .asyncGetItems()
            .then((response) => {
                setListItems(response);
            })
            .finally(() => {
                setIsLoading(false);
            });
    }, [shouldUpdate]);

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
    console.log('item', currentListItems);
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
                    {listItems.filter((item) =>
                        config.searchConfig.searchBy(item, searchInput)
                    ).length > pageRatio && (
                        <DatePagination
                            page={currentPage}
                            onChange={setCurrentPage}
                        />
                    )}
                    <SearchInput
                        searchConfig={config.searchConfig}
                        searchInput={searchInput}
                        setSearchInput={setSearchInput}
                    />
                </div>
                <table className='w-full text-sm text-left text-gray-500'>
                    <thead className='text-xs text-gray-700 uppercase bg-blue-200 '>
                        <EditableListHead
                            editableListHead={config.editableListHead}
                        />
                    </thead>
                    <tbody>
                        {currentListItems.map((item, index) => {
                            console.log('item', item);
                            if (week.includes(item.subject.split(' ')[0])) {
                                return (
                                    <EditableListItemDelimeter
                                        heading={item.subject + ''}
                                    />
                                );
                            }

                            return (
                                <EditableListItem
                                    key={index}
                                    setModalOpen={setModalOpen}
                                    setModalItem={() => setModalItem(item)}
                                    listRow={config.getListRow(item)}
                                />
                            );
                        })}
                    </tbody>
                </table>
            </div>
            {config.modal && (
                <ModalWindow
                    isModalOpen={isModalOpen}
                    setModalOpen={setModalOpen}
                    modalConfig={config.modal}
                    modalItem={modalItem}
                    update={updateComponent}
                />
            )}
        </EditableListContext.Provider>
    );
};

export default EditableListDate;
