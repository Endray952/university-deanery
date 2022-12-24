import React, { useState, useEffect } from 'react';
import {
    Navigate,
    NavLink,
    redirect,
    unstable_HistoryRouter,
    useNavigate,
} from 'react-router-dom';
import UserStore from '../store/UserStore';
import { ROOT_PATH, LOGIN_PATH, role } from '../utils/consts';
import { observer } from 'mobx-react-lite';
import { getStudentByUserId } from '../http/studentAPI';
import Spinner from './Spinner';

const navlinkStyle = `
    text-xl font-bold
    block py-2 pl-3 pr-4 
    text-gray-400
    hover:bg-gray-100
    md:hover:bg-transparent
    md:hover:text-[#fff] 
    border-b-1 border-[#ecd02d] 
    md:hover:border-b-2 border-[#ecd02d] 
    md:p-0 dark:
    md:dark:hover:text-white dark:hover:bg-gray-700 
    dark:hover:text-white md:dark:hover:bg-transparent
`;

const signUpStyle = `
    text-xl block ml-[50px]
    text-cyan-50
    md:hover:text-[#000] 
    border-2 border-cyan-50
    md:hover:bg-cyan-50
    md:p-[5px]
`;

export const NavBar = observer(() => {
    const navigate = useNavigate();
    const [currentUser, setCurrentUser] = useState<any>(null);
    const [loading, setLoading] = useState(true);
    useEffect(() => {
        try {
            if (UserStore.user) {
                // getStudentByUserId(UserStore.user?.id)
                //console.log(UserStore.user)
                // getStudentByUserId(UserStore.user.id)
                //     .then((data) => {
                //         setCurrentUser(data);
                //         console.log(data);
                //     })
                //     .finally(() => setLoading(false));
                getProfileByUser(setCurrentUser);
                setLoading(false);
            }
        } catch (e) {
            console.log(e);
        }

        //console.log(JSON.stringify(UserStore.user));
    }, []);
    console.log(JSON.stringify(UserStore.user));
    if (!UserStore.isAuth) {
        return null;
    }

    const logOut = () => {
        UserStore.setIsAuth(false);
        UserStore.setUser(null);
        localStorage.removeItem('token');
        navigate(ROOT_PATH);
    };

    return (
        <nav className='bg-[#30A245] px-2 sm:px-4 py-2.5 rounded text-cyan-50'>
            <div className='container flex flex-wrap items-center justify-between m-auto'>
                <NavLink to='/' className='flex items-center'>
                    <span className='self-center text-[30px] font-semibold whitespace-nowrap dark:text-white'>
                        Деканат
                    </span>
                </NavLink>

                <div
                    className='hidden w-full md:block md:w-auto'
                    id='navbar-default'
                >
                    <ul className='flex flex-row p-4 mt-4 border items-center  md:flex-row md:space-x-8 md:mt-0 md:text-sm md:font-medium md:border-0'>
                        {/* <li>
                            <NavLink
                                to='/tours'
                                className={navlinkStyle}
                                aria-current='page'
                            >
                                Hot destinations
                            </NavLink>
                        </li>
                        <li>
                            <NavLink to='/aboutpage' className={navlinkStyle}>
                                About
                            </NavLink>
                        </li> */}
                        <li>
                            <div
                                style={{
                                    display: 'flex',
                                    flexDirection: 'column',
                                }}
                            >
                                <p>
                                    {loading
                                        ? 'Загрузка...'
                                        : `${currentUser?.name || ''} ${
                                              currentUser?.surname || ''
                                          }`}
                                </p>
                                <p>
                                    {currentUser?.group
                                        ? `Группа ${currentUser?.group}`
                                        : ''}
                                </p>
                            </div>
                        </li>

                        <li>
                            <button onClick={logOut} className={signUpStyle}>
                                Выйти
                            </button>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    );
});

const getProfileByUser = async (setCurrentUser: any) => {
    if (!UserStore.user) {
        return 'неизвестно';
    }
    try {
        switch (UserStore.user.role) {
            case role.ADMIN:
                setCurrentUser({ name: 'админ' });
                break;
            case role.STUDENT:
                const student: any = await getStudentByUserId(
                    UserStore.user.id
                );
                console.log(student);
                setCurrentUser({
                    name: `${student.name} ${student.surname}`,
                    group: student.group_code,
                });
                break;
            default:
                setCurrentUser({ name: 'Не опредлено' });
        }
    } catch (e) {
        console.log(e);
    }
};
