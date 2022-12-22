import { observer } from 'mobx-react-lite';
import React from 'react';
import UserStore from '../../store/UserStore';
import { adminSideBar } from '../../utils/constsJS';

import SlidebarItem from './SlidebarItem';

const Sidebar = observer(() => {
    return (
        <aside
            className='w-64 w3-sidebar w3-bar-block sticky h-screen'
            aria-label='Sidebar'
        >
            <div className='overflow-y-auto py-4 px-3 bg-gray-50 rounded dark:bg-gray-800 h-screen'>
                <ul className='space-y-2'>
                    {UserStore.user.role &&
                        adminSideBar
                            .get(UserStore.user.role)
                            .map((sidebarContent) => (
                                <SlidebarItem
                                    linkTo={sidebarContent.to}
                                    sidebarText={sidebarContent.text}
                                />
                            ))}
                </ul>
            </div>
        </aside>
    );
});

export default Sidebar;
