import React, { useContext, useState } from 'react';
import { updateStudent } from '../../../../../http/deanAPI';
import { EditableListContext } from '../../../EditableList';
import ModalInput from '../../ModalInput';
import ModalTransferStudent from './ModalTransferStudent';

const ModalEditStudent = ({ student, handleClose }) => {
    const [login, setLogin] = useState(student.login);
    const [name, setName] = useState(student.name);
    const [surname, setSurname] = useState(student.surname);
    const [email, setEmail] = useState(student.email);
    const [phone, setPhone] = useState(student.phone_number);
    const [passport, setPasport] = useState(student.passport);
    const { setListItems, setIsLoading, asyncGetItems } =
        useContext(EditableListContext);

    const [modalEditStudentOpen, setModalEditStudentOpen] = useState(false);

    const handleSave = async () => {
        const form = document.getElementById('dura');
        if (!form.checkValidity()) {
            const tmpSubmit = document.createElement('button');
            form.appendChild(tmpSubmit);
            tmpSubmit.click();
            form.removeChild(tmpSubmit);
        } else {
            handleClose();
            try {
                await updateStudent(
                    name,
                    surname,
                    email,
                    phone,
                    student.student_id
                );
            } catch (e) {
                console.log('update error');
            }

            setIsLoading(true);
            await asyncGetItems()
                .then((data) => {
                    setListItems(data);
                })
                .finally(() => setIsLoading(false));
        }
    };

    const handleTransferStudentClick = (e) => {
        e.preventDefault();
        setModalEditStudentOpen(true);
    };

    console.log(student);

    return (
        <>
            <div className='p-6 space-y-6'>
                <div className='grid grid-cols-6 gap-6'>
                    <ModalInput
                        inputName={'Логин'}
                        inputPlaceholder={'login'}
                        inputType={'text'}
                        isRequired={true}
                        inputValue={login}
                        onChangeSet={setLogin}
                        inputDisabled={true}
                    />
                    <ModalInput
                        inputName={'Имя'}
                        inputPlaceholder={'Иван'}
                        inputType={'text'}
                        isRequired={true}
                        inputValue={name}
                        onChangeSet={setName}
                    />
                    <ModalInput
                        inputName={'Фамилия'}
                        inputPlaceholder={'Иванов'}
                        inputType={'text'}
                        isRequired={true}
                        inputValue={surname}
                        onChangeSet={setSurname}
                    />
                    <ModalInput
                        inputName={'Email'}
                        inputPlaceholder={'example@dekanat.ru'}
                        inputType={'email'}
                        isRequired={true}
                        inputValue={email}
                        onChangeSet={setEmail}
                    />

                    <ModalInput
                        inputName={'Номер телефона'}
                        inputPlaceholder={'79991112233'}
                        inputType={'text'}
                        isRequired={true}
                        inputValue={phone}
                        onChangeSet={setPhone}
                    />
                    <ModalInput
                        inputName={'Паспорт'}
                        inputPlaceholder={'1111222222'}
                        inputType={'text'}
                        isRequired={true}
                        inputValue={passport}
                        onChangeSet={setPasport}
                    />
                </div>
            </div>

            {/* <!-- Modal footer --> */}
            <div
                className='flex items-center p-6 space-x-2 rounded-b border-t border-gray-200 dark:border-gray-600'
                style={{ justifyContent: 'space-between' }}
            >
                {/* <!-- Buttons from config --> */}

                <button
                    type='submit'
                    onClick={handleSave}
                    className='text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800'
                >
                    Сохранить
                </button>
                <button
                    onClick={handleTransferStudentClick}
                    className='text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800'
                >
                    Перевести студента
                </button>
            </div>
            <ModalTransferStudent
                isModalOpen={modalEditStudentOpen}
                modalName={'Перевод студента'}
                setModalOpen={setModalEditStudentOpen}
                student={student}
            />
        </>
    );
};

export default ModalEditStudent;
