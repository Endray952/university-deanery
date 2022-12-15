import React from 'react';

export default function SidebarItem() {
    return (
        <li>
            <a
                href='#'
                className='flex bg-gray-100 items-center p-2 text-base font-normal text-gray-900 rounded-lg dark:text-white hover:bg-gray-200 dark:hover:bg-gray-700'
            >
                <span className='ml-3'>Расписание</span>
            </a>
        </li>
    );
}
