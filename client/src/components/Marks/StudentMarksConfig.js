import { UserStore } from "../../../../classes/UserStore";
import { getAllMarks } from "../../../../http/studentAPI";
import ModalDisciplineMarks from "../../Modal/ModalDisciplineMarks";

const leftStringIncludesRight = (left, right) => {
    return String(left)
        .toLocaleLowerCase()
        .includes(String(right).toLocaleLowerCase());
};

export const studentMarksConfig = {
    asyncGetItems: () => getAllMarks(UserStore.personId),
    editableListHead: [
        "Предмет",
        "Оценки",
        "Средний балл",
        "Учитель",
        "Действие",
    ],

    getListRow: (mark) => {
        return {
            heading: {
                mainText: `${mark.disciplineName || "неизвестно"}`,
                secondaryText: mark.disciplineId,
            },
            tableItems: [
                mark.marks,
                (+mark.averageMark).toFixed(2),
                `${mark.teacherName} ${mark.teacherSurname}`,
            ],
            actionName: "Подробнее",
        };
    },
    searchConfig: {
        searchBy: (mark, searchInput) => {
            return (
                leftStringIncludesRight(mark.disciplineName, searchInput) ||
                leftStringIncludesRight(mark.teacheName, searchInput) ||
                leftStringIncludesRight(mark.teacherSurname, searchInput)
            );
        },
        searchPlaceholder: "Поиск",
    },
    modal: {
        modalName: "Оценки по предмету",
        modalContent: (item, handleClose, update) => (
            <ModalDisciplineMarks marks={item} handleClose={handleClose}/>
        ),
    },
    actionDropDown: {
        name: "marks",
        enabled: false,
        visible: false,
        actions: [],
    }
};
