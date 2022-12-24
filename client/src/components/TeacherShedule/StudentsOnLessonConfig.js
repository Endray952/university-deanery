import { getLessonStudents } from '../../http/teacherAPI';

const leftStringIncludesRight = (left, right) => {
    return String(left)
        .toLocaleLowerCase()
        .includes(String(right).toLocaleLowerCase());
};

export const studentsOnLessonConfig = (lesson_id) => {
    return {
        asyncGetItems: () => getLessonStudents(lesson_id),
        editableListHead: ['Имя', 'оценка за урок', 'присутствие', 'Действие'],

        getListRow: (lesson) => {
            console.log(lesson);
            return {
                heading: {
                    mainText: `${lesson.student_name || 'неизвестно'} ${
                        lesson.student_surname || 'неизвестно'
                    }`,
                    secondaryText: lesson.code_number,
                },
                tableItems: [
                    lesson.mark_value || 'нет',
                    lesson.is_attendant || 'не проставлено',
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
                    leftStringIncludesRight(
                        teacher.subject_name,
                        searchInput
                    ) ||
                    leftStringIncludesRight(teacher.email, searchInput) ||
                    leftStringIncludesRight(teacher.phone_number, searchInput)
                );
            },
            searchPlaceholder: 'Поиск по учителям',
        },
        // modal: {
        //     modalName: 'Редактировать учителя',
        //     modalContent: (item, handleClose) => (
        //         <ModalEditTeacher student={item} handleClose={handleClose} />
        //     ),
        // },
        // actionComponent: (item) =>  <TeachersActions students={item} />,
        modal: null,
        actionComponent: () => null,
    };
};
