import { getSubjectMarksInfo } from '../../http/studentAPI';

const leftStringIncludesRight = (left, right) => {
    return String(left)
        .toLocaleLowerCase()
        .includes(String(right).toLocaleLowerCase());
};

const dateConvertOptions = {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
};

const dateToNormalDateString = (dateStr) => {
    const date = new Date(dateStr);
    return date.toLocaleDateString('ru', dateConvertOptions);
};

export const marksWithDatesConfig = {
    asyncGetItems: () => getSubjectMarksInfo(),
    editableListHead: ['Оценка', 'Дата', 'Учитель'],

    getListRow: (mark) => {
        return {
            heading: {
                mainText: `${mark.mark_value || 'неизвестно'}`,
                secondaryText: '',
            },
            tableItems: [
                dateToNormalDateString(mark.start_date),
                `${mark.name} ${mark.surname}`,
            ],
        };
    },
    searchConfig: {
        searchBy: (mark, searchInput) => {
            return (
                leftStringIncludesRight(mark.mark, searchInput) ||
                leftStringIncludesRight(mark.name, searchInput) ||
                leftStringIncludesRight(mark.surname, searchInput)
            );
        },
        searchPlaceholder: 'Поиск',
    },
    sort: (a, b) =>
        new Date(a.start_date).getTime() - new Date(b.start_date).getTime(),
    actionDropDown: {
        name: 'marksWithDates',
        enabled: false,
        visible: false,
        actions: [],
    },
};

export default marksWithDatesConfig;
