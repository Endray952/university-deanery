import React, { useState } from 'react';
import { studentsListConfig } from './ListConfig/StudentsListConfig';
import { v4 as uuid } from 'uuid';

const EditableListHead = ({ editableListHead }) => {
    return (
        <tr>
            {editableListHead.map((heading) => {
                return (
                    <th key={uuid()} scope='col' className='py-3 px-6'>
                        {heading}
                    </th>
                );
            })}
        </tr>
    );
};

export default EditableListHead;
