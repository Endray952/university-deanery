import React, { useEffect, useState, useRef } from 'react';
import ActionDropDown from './ActionDropDown';
import SearchInput from './SearchInput';
import EditableListHead from './EditableListHead';
import EditableListItem from './EditableListItem';
import { LoaderComponent } from 'react-fullscreen-loader';
import {
    DatePagination,
    addDaysToDate,
    toNormalDate,
} from '../DatePagination/DatePagination';
import EditableListItemDelimeter from './EditableListItemDelimeter';
import ModalWindow from '../EditableList/Modal/ModalWindow';

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
        ).toLocaleDateString()
    );

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

        sortedListItems.current = (
            config.sort !== undefined ? listItems.sort(config.sort) : listItems
        )
            .filter((item) => config.searchConfig.searchBy(item, searchInput))
            .filter(
                (item) =>
                    new Date(item.date).getTime() <
                        currentPageEndDate.current.getTime() &&
                    new Date(item.date).getTime() >
                        currentPageStartDate.current.getTime()
            );

        for (const [index, item] of sortedListItems.current.entries()) {
            if (index === 0) {
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

        setCurrentListItems(list);

        weekDay = 1;
    }, [currentPage, listItems]);

    const updateComponent = () => {
        setIsLoading(true);
        config
            .asyncGetItems()
            .then((response) => {
                setListItems(response.data.courses);
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
                setListItems(response.data.courses);
            })
            .finally(() => {
                setIsLoading(false);
            });
    }, [shouldUpdate]);

    useEffect(() => {
        config
            .asyncGetItems()
            .then((response) => {
                setListItems(response.data.courses);
            })
            .finally(() => {
                setIsLoading(false);
            });
    }, []);

    if (isLoading) {
        return <LoaderComponent />;
    }

    if (!listItems) {
        return <div>Ошибка загрузки данных</div>;
    }

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
                    <ActionDropDown config={config.actionDropDown} />
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
                    <thead className='text-xs text-gray-700 uppercase bg-gray-50'>
                        <EditableListHead
                            editableListHead={config.editableListHead}
                        />
                    </thead>
                    <tbody>
                        {currentListItems.map((item, index) => {
                            if (
                                week.includes(item.disciplineName.split(' ')[0])
                            ) {
                                return (
                                    <EditableListItemDelimeter
                                        heading={item.disciplineName + ''}
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
