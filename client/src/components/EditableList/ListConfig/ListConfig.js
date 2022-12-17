import { getStudents } from '../../../http/deanAPI';

const getStudentStatus = (student) => {
    let status = '';
    switch (student.student_status) {
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

export const studentsListConfig = {
    asyncGetItems: getStudents,
    editableListHead: [
        'Имя',
        'Почта',
        'Статус',
        'Группа',
        'Курс',
        'Направление',
        'Институт',
        'Действие',
    ],
    editableListItems: {
        heading: (item) => {
            return `
            ${item.name || 'неизвестно'} 
            ${item.surname || 'неизвестно'}
            `;
        },
        tableItems: (item) => {
            return [
                item.email,
                item.student_status,
                item.code_number,
                item.semestr_number,
                item.institute_name,
            ];
        },
    },
};
