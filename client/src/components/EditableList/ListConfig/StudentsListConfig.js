import { getStudents } from '../../../http/deanAPI';

const getStudentStatus = (student_status) => {
    let status = '';
    switch (student_status) {
        case 'enrolled':
            status = 'учится';
            break;
        case 'expelled':
            status = 'отчислен';
            break;
        case 'academic_leave':
            status = 'академический отпуск';
            break;
        case 'graduated':
            status = 'окончил обучение';
            break;
        default:
            status = 'неизвестно';
    }
    return status;
};

const leftStringIncludesRight = (left, right) => {
    return String(left)
        .toLocaleLowerCase()
        .includes(String(right).toLocaleLowerCase());
};

export const studentsListConfig = {
    asyncGetItems: getStudents,
    editableListHead: [
        'Имя',
        'номер телефона',
        'Статус',
        'Группа',
        'Семестр',
        'Направление',
        'Институт',
        'Действие',
    ],

    getListRow: (item) => {
        return {
            heading: {
                mainText: `${item.name || 'неизвестно'} ${
                    item.surname || 'неизвестно'
                }`,
                secondaryText: item.email,
            },
            tableItems: [
                item.phone_number,
                getStudentStatus(item.student_status),
                item.group_code,
                item.semestr_number,
                item.direction_name,
                item.institute_name,
            ],
            actionName: 'изменить',
        };
    },
    searchConfig: {
        searchBy: (item, searchInput) => {
            return (
                leftStringIncludesRight(item.name, searchInput) ||
                leftStringIncludesRight(item.surname, searchInput) ||
                leftStringIncludesRight(
                    getStudentStatus(item.student_status),
                    searchInput
                ) ||
                leftStringIncludesRight(item.group_code, searchInput) ||
                leftStringIncludesRight(item.semestr_number, searchInput) ||
                leftStringIncludesRight(item.direction_name, searchInput) ||
                leftStringIncludesRight(item.institute_name, searchInput) ||
                leftStringIncludesRight(item.email, searchInput)
            );
        },
        searchPlaceholder: 'Поиск студента',
    },
    modal: {
        modalName: 'Редактировать студента',
        inputs: [
            {
                inputName: 'Имя',
                inputPlaceholder: 'Иван',
                inputType: 'text',
                isRequired: true,
            },
            {
                inputName: 'Фамилия',
                inputPlaceholder: 'Иванов',
                inputType: 'text',
                isRequired: true,
            },
            {
                inputName: 'Email',
                inputPlaceholder: 'example@dekanat.ru',
                inputType: 'email',
                isRequired: true,
            },
            {
                inputName: 'Номер телефона',
                inputPlaceholder: '+79991112233',
                inputType: 'number',
                isRequired: true,
            },
            {
                inputName: 'Номер телефона',
                inputPlaceholder: '+79991112233',
                inputType: 'number',
                isRequired: true,
            },
        ],
        buttons: [
            <button
                type='submit'
                className='text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800'
            >
                Сохранить
            </button>,
        ],
    },
};
