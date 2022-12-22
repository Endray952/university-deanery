import { observer } from 'mobx-react-lite';
import React from 'react';
import { NavLink } from 'react-router-dom';
import { LOGIN_PATH } from '../../utils/consts';

export const SidebarItem = observer(({ linkTo, sidebarText }) => {
    return (
        <li>
            <NavLink
                to={linkTo}
                className='flex bg-gray-100 items-center p-2 text-base font-normal text-gray-900 rounded-lg dark:text-white hover:bg-gray-200 dark:hover:bg-gray-700'
            >
                <span>{sidebarText}</span>
            </NavLink>
        </li>
    );
});
export default SidebarItem;
