import EditableList from '../EditableList/EditableList';
import { studentsOnLessonConfig } from './StudentsOnLessonConfig';

const ModalEditLessonTeacher = ({ lesson, handleClose }) => {
    console.log(lesson.lesson_id);
    return (
        <>
            {lesson?.lesson_id && (
                <EditableList
                    config={studentsOnLessonConfig(lesson.lesson_id)}
                />
            )}

            {/* <!-- Modal footer --> */}
            <div
                className='flex items-center p-6 space-x-2 rounded-b border-t border-gray-200'
                style={{ justifyContent: 'space-between' }}
            >
                {/* {JSON.stringify(lesson)} */}
            </div>
        </>
    );
};

export default ModalEditLessonTeacher;
