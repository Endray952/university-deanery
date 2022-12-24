import React, { useEffect, useState, useRef } from "react";
import ActionDropDown from "./ActionDropDown";
import ModalWindow from "./Modal/ModalWindow";
import SearchInput from "./SearchInput";
import EditableListHead from "./EditableListHead";
import EditableListItem from "./EditableListItem";
import { LoaderComponent } from "react-fullscreen-loader";
import Pagination from "@mui/material/Pagination";

export const EditableListContext = React.createContext();

const pageRatio = 5;

const EditableListPage = ({ config, shouldUpdate }) => {
    const [isModalOpen, setModalOpen] = useState(false);
    const [isLoading, setIsLoading] = useState(true);
    const [listItems, setListItems] = useState(null);
    const [searchInput, setSearchInput] = useState("");
    const [modalItem, setModalItem] = useState(null);
    const [currentPage, setCurrentPage] = useState(1);

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
            <div className="overflow-x-auto relative shadow-md sm:rounded-lg">
                <div className="flex justify-between items-center py-4 bg-white">
                    <ActionDropDown config={config.actionDropDown} />
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
                            color="primary"
                        />
                    )}
                    <SearchInput
                        searchConfig={config.searchConfig}
                        searchInput={searchInput}
                        setSearchInput={setSearchInput}
                    />
                </div>
                <table className="w-full text-sm text-left text-gray-500">
                    <thead className="text-xs text-gray-700 uppercase bg-gray-50">
                        <EditableListHead
                            editableListHead={config.editableListHead}
                        />
                    </thead>
                    <tbody>
                        {(config.sort !== undefined ? listItems.sort(config.sort) : listItems)
                            .filter((item) =>
                                config.searchConfig.searchBy(item, searchInput)
                            )
                            .map((item, index) => (
                                <EditableListItem
                                    key={index}
                                    setModalOpen={setModalOpen}
                                    setModalItem={() => setModalItem(item)}
                                    listRow={config.getListRow(item)}
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
                    update={updateComponent}
                />
            )}
        </EditableListContext.Provider>
    );
};

export default EditableListPage;
