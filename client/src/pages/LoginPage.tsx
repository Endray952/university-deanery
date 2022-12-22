import React, { useEffect, useState } from 'react';

import { observer } from 'mobx-react-lite';
import { login } from '../http/userAPI';
import UserStore from '../store/UserStore';
import { Navigate, useNavigate } from 'react-router-dom';
import { ROOT_PATH, STUDENTS_EDIT_PATH } from '../utils/consts';

export const LoginPage = observer(() => {
    // const { user } = useContext(Context);
    // const location = useLocation();
    // const history = useHistory();
    // const UserStore.isAuth = location.pathname === LOGIN_ROUTE;
    const navigate = useNavigate();
    const [loginInput, setLogin] = useState('');
    const [password, setPassword] = useState('');
    const [errorText, setErrorText] = useState('');

    const click = async () => {
        try {
            const data = await login(loginInput, password);
            UserStore.setUser(data);
            UserStore.setIsAuth(true);
            // console.log(JSON.stringify(UserStore.user), JSON.stringify(data));
            navigate(ROOT_PATH);
        } catch (e: any) {
            //alert(e.response.data.message);
            setErrorText(e.response.data.message);
        }
    };

    useEffect(() => {
        if (UserStore.isAuth) {
            UserStore.setIsAuth(false);
            UserStore.setUser(null);
            localStorage.removeItem('token');
        }
    }, []);

    return (
        <>
            <section className='bg-gray-50 dark:bg-gray-900'>
                <div className='flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0'>
                    <p className='flex items-center mb-6 text-2xl font-semibold text-gray-900 dark:text-white'>
                        Войдите, чтобы продолжить
                    </p>
                    <div className='w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700'>
                        <div className='p-6 space-y-4 md:space-y-6 sm:p-8'>
                            <div className='space-y-4 md:space-y-6'>
                                <div>
                                    <label
                                        htmlFor='email'
                                        className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
                                    >
                                        Ваш логин
                                    </label>
                                    <input
                                        name='login'
                                        id='login'
                                        className='bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                                        placeholder='login'
                                        value={loginInput}
                                        onChange={(e: any) =>
                                            setLogin(e.target.value)
                                        }
                                    />
                                </div>
                                <div>
                                    <label
                                        htmlFor='password'
                                        className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
                                    >
                                        Пароль
                                    </label>
                                    <input
                                        type='password'
                                        name='password'
                                        id='password'
                                        placeholder='••••••••'
                                        value={password}
                                        onChange={(e: any) =>
                                            setPassword(e.target.value)
                                        }
                                        className='bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                                    />
                                </div>

                                <button
                                    onClick={click}
                                    className='w-full text-black border-gray-300 border-2  bg-gray-100 hover:bg-green-600 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-xl text-sm px-5 py-2.5 text-center'
                                >
                                    Войти
                                </button>
                            </div>
                            {errorText}
                        </div>
                    </div>
                </div>
            </section>
        </>
    );
});
