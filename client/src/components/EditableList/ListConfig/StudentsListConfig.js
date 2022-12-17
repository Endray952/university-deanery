import { getStudents } from '../../../http/deanAPI';
import ModalStudents from '../Modal/ModalStudents';

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

    getListRow: (student) => {
        return {
            heading: {
                mainText: `${student.name || 'неизвестно'} ${
                    student.surname || 'неизвестно'
                }`,
                secondaryText: student.email,
            },
            tableItems: [
                student.phone_number,
                getStudentStatus(student.student_status),
                student.student_status === 'enrolled'
                    ? student.group_code
                    : '-',
                student.student_status === 'enrolled'
                    ? student.semestr_number
                    : '-',
                student.student_status === 'enrolled'
                    ? student.direction_name
                    : '-',
                student.student_status === 'enrolled'
                    ? student.institute_name
                    : '-',
            ],
            actionName: 'изменить',
        };
    },
    searchConfig: {
        searchBy: (student, searchInput) => {
            return (
                leftStringIncludesRight(student.name, searchInput) ||
                leftStringIncludesRight(student.surname, searchInput) ||
                leftStringIncludesRight(
                    getStudentStatus(student.student_status),
                    searchInput
                ) ||
                leftStringIncludesRight(student.group_code, searchInput) ||
                leftStringIncludesRight(student.semestr_number, searchInput) ||
                leftStringIncludesRight(student.direction_name, searchInput) ||
                leftStringIncludesRight(student.institute_name, searchInput) ||
                leftStringIncludesRight(student.email, searchInput) ||
                leftStringIncludesRight(student.phone_number, searchInput)
            );
        },
        searchPlaceholder: 'Поиск студента',
    },
    modal: {
        modalName: 'Редактировать студента',
        modalContent: (item, handleClose) => (
            <ModalStudents student={item} handleClose={handleClose} />
        ),
    },
};

//Save на всякий случай
// inputs: (student) => {
//     console.log(student);
//     return [
//         {
//             inputName: 'Имя',
//             inputPlaceholder: 'Иван',
//             inputType: 'text',
//             isRequired: true,
//             value: student?.name,
//         },
//         {
//             inputName: 'Фамилия',
//             inputPlaceholder: 'Иванов',
//             inputType: 'text',
//             isRequired: true,
//             value: student?.surname,
//         },
//         {
//             inputName: 'Email',
//             inputPlaceholder: 'example@dekanat.ru',
//             inputType: 'email',
//             isRequired: true,
//             value: student?.email,
//         },
//         {
//             inputName: 'Номер телефона',
//             inputPlaceholder: '+79991112233',
//             inputType: 'text',
//             isRequired: true,
//             value: student?.phone_number,
//         },
//     ];
// },

// inputs: (student) => {
//     console.log(student);
//     return {
//         name: {
//             inputName: 'Имя',
//             inputPlaceholder: 'Иван',
//             inputType: 'text',
//             isRequired: true,
//             value: student?.name,
//         },
//         surname: {
//             inputName: 'Фамилия',
//             inputPlaceholder: 'Иванов',
//             inputType: 'text',
//             isRequired: true,
//             value: student?.surname,
//         },
//         email: {
//             inputName: 'Email',
//             inputPlaceholder: 'example@dekanat.ru',
//             inputType: 'email',
//             isRequired: true,
//             value: student?.email,
//         },
//         telephone_number: {
//             inputName: 'Номер телефона',
//             inputPlaceholder: '+79991112233',
//             inputType: 'text',
//             isRequired: true,
//             value: student?.phone_number,
//         },
//     };
// },

// buttons: [
//     <button
//         type='submit'
//         className='text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800'
//     >
//         Сохранить
//     </button>,
// ],
