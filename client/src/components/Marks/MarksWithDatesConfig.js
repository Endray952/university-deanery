import { UserStore } from "../../../../classes/UserStore";
import { getAllMarks, getMarksWithDate } from "../../../../http/studentAPI";
import ModalDisciplineMarks from "../../Modal/ModalDisciplineMarks";

const leftStringIncludesRight = (left, right) => {
    return String(left)
        .toLocaleLowerCase()
        .includes(String(right).toLocaleLowerCase());
};

const dateConvertOptions = {
    year: "numeric",
    month: "long",
    day: "numeric",
};

const dateToNormalDateString = (dateStr) => {
    const date = new Date(dateStr);
    return (
        date.toLocaleDateString("ru", dateConvertOptions) +
        " " +
        date.getHours() +
        ":" +
        date.getMinutes() +
        "0"
    );
};

export const marksWithDatesConfig = {
    asyncGetItems: () => getMarksWithDate(),
    editableListHead: ["Оценка", "Дата", "Учитель"],

    getListRow: (mark) => {
        return {
            heading: {
                mainText: `${mark.mark || "неизвестно"}`,
                secondaryText: "",
            },
            tableItems: [
                dateToNormalDateString(mark.date),
                `${mark.teacherName} ${mark.teacherSurname}`,
            ],
        };
    },
    searchConfig: {
        searchBy: (mark, searchInput) => {
            return (
                leftStringIncludesRight(mark.mark, searchInput) ||
                leftStringIncludesRight(mark.teacheName, searchInput) ||
                leftStringIncludesRight(mark.teacherSurname, searchInput)
            );
        },
        searchPlaceholder: "Поиск",
    },
    sort: (a, b) => new Date(a.date).getTime() - new Date(b.date).getTime(),
    actionDropDown: {
        name: "marksWithDates",
        enabled: false,
        visible: false,
        actions: [],
    }
};

export default marksWithDatesConfig;
