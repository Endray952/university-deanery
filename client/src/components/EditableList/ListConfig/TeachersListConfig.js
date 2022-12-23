import { getTeachers } from '../../../http/deanAPI';
import StudentsActions from '../Actions/StudentsActions';
import ModalEditTeacher from '../Modal/ConcreteModals/TeachersModal/ModalEditTeacher';

const teacherSubjects = (teacher) => {
    let subjects = '';
    teacher.subjects.forEach((subject) => {
        subjects = `${subjects}, ${subject.subject_name}`;
    });
    return subjects.substring(1);
};

const teacherStatus = (teacher) => {
    return teacher.is_working ? 'Работает' : 'Не работает';
};

const leftStringIncludesRight = (left, right) => {
    return String(left)
        .toLocaleLowerCase()
        .includes(String(right).toLocaleLowerCase());
};

export const teachersListConfig = {
    asyncGetItems: getTeachers,
    editableListHead: [
        'Имя',
        'Номер телефона',
        'Статус',
        'Предметы',
        'Действие',
    ],

    getListRow: (teacher) => {
        return {
            heading: {
                mainText: `${teacher.name || 'неизвестно'} ${
                    teacher.surname || 'неизвестно'
                }`,
                secondaryText: teacher.email,
            },
            tableItems: [
                teacher.phone_number,
                teacherStatus(teacher),
                teacherSubjects(teacher),
            ],
            actionName: 'изменить',
        };
    },
    searchConfig: {
        searchBy: (teacher, searchInput) => {
            return (
                leftStringIncludesRight(teacher.name, searchInput) ||
                leftStringIncludesRight(teacher.surname, searchInput) ||
                leftStringIncludesRight(teacher.is_working, searchInput) ||
                leftStringIncludesRight(teacher.login, searchInput) ||
                leftStringIncludesRight(teacher.subject_name, searchInput) ||
                leftStringIncludesRight(teacher.email, searchInput) ||
                leftStringIncludesRight(teacher.phone_number, searchInput)
            );
        },
        searchPlaceholder: 'Поиск по учителям',
    },
    modal: {
        modalName: 'Редактировать учителя',
        modalContent: (item, handleClose) => (
            <ModalEditTeacher student={item} handleClose={handleClose} />
        ),
    },
    actionComponent: (item) => <StudentsActions students={item} />,
};
