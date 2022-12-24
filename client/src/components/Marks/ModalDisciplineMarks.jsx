import EditableListPage from './EditableListPage';
import marksWithDatesConfig from './MarksWithDatesConfig';

const ModalDisciplineMarks = ({ marks, handleClose }) => {
    return (
        <>
            <EditableListPage config={marksWithDatesConfig} />

            {/* <!-- Modal footer --> */}
            <div
                className='flex items-center p-6 space-x-2 rounded-b border-t border-gray-200'
                style={{ justifyContent: 'space-between' }}
            ></div>
        </>
    );
};

export default ModalDisciplineMarks;
