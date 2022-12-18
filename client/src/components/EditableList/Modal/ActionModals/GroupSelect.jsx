import React, { useEffect, useState } from 'react';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormHelperText from '@mui/material/FormHelperText';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';

export default function GroupSelect({
    groups,
    selectedGroupId,
    setSelectedGroupId,
}) {
    const [institute, setInstitute] = useState('');
    const [direction, setDirection] = useState('');
    const [semestr, setSemestr] = useState('');
    const [group, setsetGroupPhone] = useState('');

    const [instituteData, setInstituteData] = useState();
    const [directionData, setDirectionData] = useState([]);
    const [semestrData, setSemestrData] = useState([]);
    const [groupData, setsetGroupPhoneData] = useState([]);

    useEffect(() => {
        setInstituteData(
            groups.map((group) => {
                return {
                    name: group.institute_name,
                    id: group.institute_id,
                };
            })
        );
        // console.log(group);
        // console.log([
        //     ...new Map(
        //         instituteData?.map((item) => [item['id'], item])
        //     ).values(),
        // ]);
    }, []);

    const handleChange = (event) => {
        setSelectedGroupId(event.target.value);
    };

    const handleInstituteSelect = (event, value) => {
        //console.log('value', value, '\nevent', event,);
        setInstitute(event.target.value);
        // console.log(JSON.stringify(event.target.value));
        // console.log(JSON.stringify(institute));

        // console.log(JSON.stringify(directionData));
    };

    useEffect(() => {
        if (institute.id) {
            setDirectionData(
                groups
                    .map((group) => {
                        return {
                            name: group.direction_name,
                            id: group.direction_id,
                            institute_id: group.institute_id,
                        };
                    })
                    .filter((direction) => {
                        console.log(direction.institute_id, institute.id);
                        return direction.institute_id === institute.id;
                    })
            );
        }
        console.log(getUniqueValues(directionData));
    }, [institute.id]);

    const handleDirectionSelect = (event) => {
        // setDirection(event.target.value);
        // console.log(JSON.stringify(institute));
        // setDirectionData(
        //     groups.map((group) => {
        //         return {
        //             name: group.direction_name,
        //             id: group.direction_id,
        //         };
        //     })
        // );
    };

    const getUniqueValues = (array) => {
        return [...new Map(array?.map((item) => [item['id'], item])).values()];
    };

    if (groups?.length === 0) {
        return <p>Ошибка</p>;
    }
    return (
        <>
            <div className='col-span-6 sm:col-span-3'>
                <FormControl required sx={{ m: 1, minWidth: 120, width: 280 }}>
                    <InputLabel id='demo-simple-select-required-label'>
                        {'Институт'}
                    </InputLabel>
                    <Select
                        labelId='demo-simple-select-required-label'
                        id='demo-simple-select-required'
                        value={institute}
                        //label={`${label}*`}
                        onChange={handleInstituteSelect}
                    >
                        {getUniqueValues(instituteData)?.map((value) => {
                            return (
                                <MenuItem value={value.id} key={value.id}>
                                    {value.name}
                                </MenuItem>
                            );
                        })}
                    </Select>
                </FormControl>

                <FormControl required sx={{ m: 1, minWidth: 120, width: 280 }}>
                    <InputLabel id='demo-simple-select-required-label'>
                        {'Направление'}
                    </InputLabel>
                    <Select
                        labelId='demo-simple-select-required-label'
                        id='demo-simple-select-required'
                        value={direction}
                        //label={`${label}*`}
                        onChange={handleDirectionSelect}
                    >
                        {getUniqueValues(directionData).map((value) => {
                            return (
                                <MenuItem key={value.id} value={value.id}>
                                    {value.name}
                                </MenuItem>
                            );
                        })}
                    </Select>
                </FormControl>
            </div>
            <div className='col-span-6 sm:col-span-3'>
                <FormControl required sx={{ m: 1, minWidth: 120, width: 280 }}>
                    <InputLabel id='demo-simple-select-required-label'>
                        {'Семестр'}
                    </InputLabel>
                    <Select
                        labelId='demo-simple-select-required-label'
                        id='demo-simple-select-required'
                        value={''}
                        // label={'keek'}
                        onChange={handleChange}
                    >
                        {/* {values.map((value) => {
                        return (
                            <MenuItem value={value.id}>{value.name}</MenuItem>
                        );
                    })} */}
                    </Select>
                </FormControl>

                <FormControl required sx={{ m: 1, minWidth: 120, width: 280 }}>
                    <InputLabel id='demo-simple-select-required-label'>
                        {'Группа'}
                    </InputLabel>
                    <Select
                        labelId='demo-simple-select-required-label'
                        id='demo-simple-select-required'
                        value={''}
                        //label={`${label}*`}
                        onChange={handleChange}
                    >
                        {/* {values.map((value) => {
                        return (
                            <MenuItem value={value.id}>{value.name}</MenuItem>
                        );
                    })} */}
                    </Select>
                </FormControl>
            </div>
        </>
    );
}
