import { getGroupSheduleById } from '../../http/studentAPI';

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

const getLessonType = {
    credit: 'зачет',
    practice: 'практика',
    exam: 'экзамен',
    lecture: 'лекция',
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
    asyncGetItems: getGroupSheduleById,
    editableListHead: ['Предмет', 'Преподаватель', 'Время', 'Аудитория'],

    getListRow: (lesson) => {
        //console.log('getListRow', lesson);
        return {
            heading: {
                mainText: `${lesson.subject || 'неизвестно'}`,
                secondaryText: getLessonType[lesson.lesson_type],
            },
            tableItems: [
                `${lesson.name || 'незивестно'} ${lesson.surname || ''}`,
                dateToNormalDateString(lesson.date) +
                    `- ${new Date(
                        new Date(lesson.date).getTime() +
                            +lesson.duration.substring(0, 2) * 3600000 +
                            +lesson.duration.substring(3, 5) * 60000
                    ).getHours()}:${new Date(
                        new Date(lesson.date).getTime() +
                            +lesson.duration.substring(0, 2) * 3600000 +
                            +lesson.duration.substring(3, 5) * 60000
                    ).getMinutes()}`,
                lesson.classroom,
            ],
        };
    },
    getListRowDelimeterObj: (weekDay) => {
        return {
            lesson_id: '',
            subject: weekDay,
            name: '',
            surname: '',
            date: '',
            classroom: '',
        };
    },
    searchConfig: {
        searchBy: (course, searchInput) => {
            // console.log(course);
            return (
                leftStringIncludesRight(course.subject, searchInput) ||
                leftStringIncludesRight(course.name, searchInput) ||
                leftStringIncludesRight(course.surname, searchInput)
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
