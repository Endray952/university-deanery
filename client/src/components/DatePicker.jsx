import * as React from 'react';

import TextField from '@mui/material/TextField';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import 'dayjs/locale/ru';

export default function BasicDatePicker({ value, setValue, placeholder }) {
    // console.log(
    //     'time',
    //     `${value.y}-${value.M + 1}-${value.D}`,
    //     JSON.stringify(value).slice(0, 11),
    //     value.year(),
    //     value.month(),
    //     value.day(),
    //     value.date()
    // );
    return (
        <div className='col-span-6 sm:col-span-3'>
            <label
                htmlFor='first-name'
                className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'
            ></label>
            Дата рождения*
            <LocalizationProvider
                dateAdapter={AdapterDayjs}
                adapterLocale={'ru'}
            >
                <DatePicker
                    label={placeholder}
                    value={value}
                    onChange={(newValue) => {
                        setValue(newValue);
                    }}
                    renderInput={(params) => <TextField {...params} required />}
                />
            </LocalizationProvider>
        </div>
    );
}
//`${inputName}${isRequired ? '*' : ''}`}
