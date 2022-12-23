import { UserStore } from '../../../classes/UserStore';
import { getLessons } from '../../../http/studentAPI';
import { getGroupById } from '../../http/studentAPI';

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

    let hours = String(date.getHours());
    let minutes = String(date.getMinutes());

    if (hours.length === 1) {
        hours = '0' + hours;
    }

    if (minutes.length === 1) {
        minutes = '0' + minutes;
    }

    return hours + ':' + minutes;
};

export const StudentLessonsConfig = {
    asyncGetItems: getGroupById,
    editableListHead: ['Предмет', 'Учитель', 'Время', 'Кабинет'],

    getListRow: (lesson) => {
        return {
            heading: {
                mainText: `${lesson.subject || 'неизвестно'}`,
                secondaryText: '',
            },
            tableItems: [
                `${lesson.name} ${lesson.surname}`,
                dateToNormalDateString(lesson.start_date),
                lesson.classroom,
            ],
        };
    },
    getListRowDelimeterObj: (weekDay) => {
        return {
            id: '',
            disciplineName: weekDay,
            teacherName: '',
            teacherSurname: '',
            date: '',
            classroom: '',
        };
    },
    searchConfig: {
        searchBy: (course, searchInput) => {
            return (
                leftStringIncludesRight(course.name, searchInput) ||
                leftStringIncludesRight(course.teacheName, searchInput) ||
                leftStringIncludesRight(course.teacherSurname, searchInput)
            );
        },
        searchPlaceholder: 'Поиск урока',
    },
    sort: (a, b) => new Date(a.date).getTime() - new Date(b.date).getTime(),
    actionDropDown: {
        name: 'avCourses',
        enabled: false,
        visible: false,
        actions: [],
    },
};
