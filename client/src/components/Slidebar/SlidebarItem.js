import React from 'react';
import { NavLink } from 'react-router-dom';
import { LOGIN_PATH } from '../../utils/consts';

export default function SidebarItem() {
    return (
        <li>
            <NavLink
                to={LOGIN_PATH}
                className='flex bg-gray-100 items-center p-2 text-base font-normal text-gray-900 rounded-lg dark:text-white hover:bg-gray-200 dark:hover:bg-gray-700'
            >
                <span>Добавить студента</span>
            </NavLink>
        </li>
    );
}
