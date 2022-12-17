import React, { useState } from 'react';
import { studentsListConfig } from './ListConfig/ListConfig';

const EditableListHead = () => {
    const [action, isAction] = useState(true);
    return (
        <tr>
            {/* <th scope='col' className='py-3 px-6'>
                Name
            </th>
            <th scope='col' className='py-3 px-6'>
                Position
            </th>
            <th scope='col' className='py-3 px-6'>
                Status
            </th>
            <th scope='col' className='py-3 px-6'>
                Action
            </th> */}
            {studentsListConfig.editableListHead.map((heading) => {
                return (
                    <th scope='col' className='py-3 px-6'>
                        {heading}
                    </th>
                );
            })}
        </tr>
    );
};

export default EditableListHead;
