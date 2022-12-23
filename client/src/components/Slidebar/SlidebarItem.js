import { observer } from 'mobx-react-lite';
import React from 'react';
import { NavLink } from 'react-router-dom';
import { LOGIN_PATH } from '../../utils/consts';

export const SidebarItem = observer(({ linkTo, sidebarText }) => {
    const currentPath = String(window.location.pathname);
    return (
        <li>
            <NavLink
                to={linkTo}
                className={
                    currentPath === linkTo
                        ? 'flex bg-blue-200 items-center p-2 text-base font-normal text-gray-900 rounded-lg dark:text-white hover:bg-blue-300 dark:hover:bg-gray-700'
                        : 'flex bg-gray-100 items-center p-2 text-base font-normal text-gray-900 rounded-lg dark:text-white hover:bg-gray-200 dark:hover:bg-gray-700'
                }
            >
                <span>{sidebarText}</span>
            </NavLink>
        </li>
    );
});
export default SidebarItem;
