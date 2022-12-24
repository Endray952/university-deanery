import React, { useContext, useState } from 'react';
import {
    changeTeacherStatus,
    updateTeacher,
    updateTeacherSubjects,
} from '../../../../../http/deanAPI';

import { EditableListContext } from '../../../EditableList';
import ModalInput from '../../ModalInput';
import ModalEditTeacherSubjects from './ModalEditTeacherSubjects';

const ModalEditTeacher = ({ student: teacher, handleClose }) => {
    const [login, setLogin] = useState(teacher.login);
    const [name, setName] = useState(teacher.name);
    const [surname, setSurname] = useState(teacher.surname);
    const [email, setEmail] = useState(teacher.email);
    const [phone, setPhone] = useState(teacher.phone_number);
    const [passport, setPasport] = useState(teacher.passport);
    const { setListItems, setIsLoading, asyncGetItems } =
        useContext(EditableListContext);

    const [modalEditTeacherSubjectOpen, setmodalEditTeacherSubjectOpen] =
        useState(false);

    const [initialHeldSubjects, setInitialHeldSubjects] = useState(
        teacher.subjects.filter((v) => v.subject_id).map((v) => v.subject_id)
    );

    const [selectedSubjects, setSelectedSubjects] = useState(
        teacher.subjects.filter((v) => v.subject_id).map((v) => v.subject_id)
    );
    console.log(teacher);
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
                if (isSubjectsChanged()) {
                    await updateTeacherSubjects(
                        teacher.teacher_id,
                        selectedSubjects
                    );
                }
                await updateTeacher(
                    name,
                    surname,
                    email,
                    phone,
                    teacher.teacher_id,
                    passport
                );
            } catch (e) {
                console.log('update error');
            }

            //setIsLoading(true);
            await asyncGetItems()
                .then((data) => {
                    setListItems(data);
                })
                .finally(() => setIsLoading(false));
        }
    };

    const handleEditTeacherSubjects = (e) => {
        e.preventDefault();
        setmodalEditTeacherSubjectOpen(true);
    };

    const handleChangeStatus = async (e) => {
        e.preventDefault();
        try {
            await changeTeacherStatus(teacher.teacher_id, teacher.is_working);
            await asyncGetItems()
                .then((data) => {
                    setListItems(data);
                })
                .finally(() => setIsLoading(false));
            handleClose();
        } catch (e) {
            handleClose();
            console.log('dismiss teacher error');
        }
    };

    const isSubjectsChanged = () => {
        let hasChanged = false;
        if (selectedSubjects.length !== initialHeldSubjects.length) {
            return true;
        }
        initialHeldSubjects.every((subjectId) => {
            if (!selectedSubjects?.includes(subjectId)) {
                hasChanged = true;
                return false;
            }
            return true;
        });
        return hasChanged;
    };

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
                {isSubjectsChanged() && (
                    <p>{'Сохранится также информация о изменении предметов'}</p>
                )}
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
                    type='submit'
                    onClick={handleChangeStatus}
                    className='text-white bg-red-600 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-red-700 dark:focus:ring-red-800'
                >
                    {teacher.is_working ? 'уволить' : 'принять на работу'}
                </button>

                <button
                    onClick={handleEditTeacherSubjects}
                    className='text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800'
                >
                    {'Изменить предметы'}
                </button>
            </div>
            <ModalEditTeacherSubjects
                isModalOpen={modalEditTeacherSubjectOpen}
                modalName={'Поменять предметы, которые ведет преподаватель'}
                setModalOpen={setmodalEditTeacherSubjectOpen}
                selectedSubjects={selectedSubjects}
                setSelectedSubjects={setSelectedSubjects}
                initialHeldSubjects={initialHeldSubjects}
            />
        </>
    );
};

export default ModalEditTeacher;
