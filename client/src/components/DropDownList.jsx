import * as React from 'react';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormHelperText from '@mui/material/FormHelperText';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';

export default function DropDownList({ values, data, setData, label }) {
    const handleChange = (event) => {
        setData(event.target.value);
    };
    if (values?.lemgth === 0) {
        return <p>Ошибка</p>;
    }
    return (
        <div className='col-span-6 sm:col-span-3'>
            <FormControl required sx={{ m: 1, minWidth: 120, width: 280 }}>
                <InputLabel id='demo-simple-select-required-label'>
                    {label}
                </InputLabel>
                <Select
                    labelId='demo-simple-select-required-label'
                    id='demo-simple-select-required'
                    // value={data}
                    label={`${label}*`}
                    onChange={handleChange}
                >
                    {/* <MenuItem value=''>
                        <em>None</em>
                    </MenuItem>
                    <MenuItem value={10}>Ten</MenuItem>
                    <MenuItem value={20}>Twenty</MenuItem>
                    <MenuItem value={30}>Thirty</MenuItem> */}
                    {values.map((value) => {
                        return (
                            <MenuItem value={value.id}>{value.name}</MenuItem>
                        );
                    })}
                </Select>
            </FormControl>
        </div>
    );
}
