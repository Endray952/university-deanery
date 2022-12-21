import React, { useContext, useEffect, useState } from 'react';
import { createStudent, getCurrentGroups } from '../../../../../http/deanAPI';
import BasicDatePicker from '../../../../DatePicker';
import Spinner from '../../../../Spinner';
import { EditableListContext } from '../../../EditableList';
import ModalInput from '../../ModalInput';
import GroupSelect from './GroupSelect';

const ModalAddStudentContent = ({ handleClose }) => {
    const [isLoading, setIsLoading] = useState(true);

    const [login, setLogin] = useState('');
    const [password, setPassword] = useState('');
    const [name, setName] = useState('');
    const [surname, setSurname] = useState('');
    const [email, setEmail] = useState('');
    const [phone, setPhone] = useState('');
    const [passport, setPasport] = useState('');
    const [birthday, setBirthday] = useState('');
    const {
        setListItems,
        setIsLoading: setListIsLoading,
        asyncGetItems,
    } = useContext(EditableListContext);
    const [groups, setGroups] = useState(null);
    const [selectedGroupId, setSelectedGroupId] = useState(null);
    const [errorText, setErrorText] = useState(null);

    useEffect(() => {
        getCurrentGroups()
            .then((response) => {
                setGroups(response);
            })
            .finally(() => setIsLoading(false));
    }, []);

    const handleSave = async () => {
        const form = document.getElementById('dura');
        if (!form.checkValidity() && errorText !== '') {
            console.log('in check validity');
            const tmpSubmit = document.createElement('button');
            form.appendChild(tmpSubmit);
            tmpSubmit.click();
            form.removeChild(tmpSubmit);
        } else {
            const response = await createStudent(
                login,
                password,
                name,
                surname,
                email,
                phone,
                passport,
                `${birthday.$y}-${birthday.$M + 1}-${birthday.$D}`,
                selectedGroupId
            );
            console.log(response);
            if (response?.hasOwnProperty('errorRes')) {
                console.log(response);
                setErrorText(response.errorRes.description);
                return;
            }
            setErrorText('');
            handleClose();
            setListIsLoading(true);
            await asyncGetItems()
                .then((data) => {
                    setListItems(data);
                })
                .finally(() => setListIsLoading(false));
        }
    };

    if (isLoading) {
        return <Spinner />;
    }

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
                    />
                    <ModalInput
                        inputName={'Пароль'}
                        inputPlaceholder={''}
                        inputType={'text'}
                        isRequired={true}
                        inputValue={password}
                        onChangeSet={setPassword}
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
                    <BasicDatePicker value={birthday} setValue={setBirthday} />
                    {/* <DropDownList
                        values={groups.map((group) => {
                            return {
                                name: group.code_number,
                                id: group.group_id,
                            };
                        })}
                        data={selectedGroupId}
                        setData={setSelectedGroupId}
                        label={'группа'}
                    /> */}
                    <GroupSelect
                        groups={groups}
                        selectedGroupId={selectedGroupId}
                        setSelectedGroupId={setSelectedGroupId}
                    />
                </div>
                <p> {errorText}</p>
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
                    Добавить
                </button>
            </div>
        </>
    );
};

export default ModalAddStudentContent;
