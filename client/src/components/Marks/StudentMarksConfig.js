import { getAllCurrentMarksByUserId } from '../../http/studentAPI';
import UserStore from '../../store/UserStore';
import ModalDisciplineMarks from './ModalDisciplineMarks';

const leftStringIncludesRight = (left, right) => {
    return String(left)
        .toLocaleLowerCase()
        .includes(String(right).toLocaleLowerCase());
};

export const studentMarksConfig = {
    asyncGetItems: () => getAllCurrentMarksByUserId(UserStore?.user?.id),
    editableListHead: ['Предмет', 'Оценки', 'Средний балл', 'Действие'],

    getListRow: (mark) => {
        return {
            heading: {
                mainText: `${mark.subject_name || 'неизвестно'}`,
            },
            tableItems: [mark.marks, (+mark.average_mark).toFixed(2)],
            actionName: 'Подробнее',
        };
    },
    searchConfig: {
        searchBy: (mark, searchInput) => {
            return leftStringIncludesRight(mark.subject_name, searchInput);
        },
        searchPlaceholder: 'Поиск',
    },
    modal: {
        modalName: 'Оценки по предмету',
        modalContent: (item, handleClose, update) => (
            <ModalDisciplineMarks marks={item} handleClose={handleClose} />
        ),
    },
    actionDropDown: {
        name: 'marks',
        enabled: false,
        visible: false,
        actions: [],
    },
};
