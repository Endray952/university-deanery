import React from 'react';

const ModalInput = () => {
    return (
        <div className='col-span-6 sm:col-span-3'>
            <label
                htmlFor='first-name'
                className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
            >
                First Name
            </label>
            <input
                type='text'
                name='first-name'
                id='first-name'
                className='shadow-sm bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                placeholder='Bonnie'
                required
            />
        </div>
    );
};

export default ModalInput;
