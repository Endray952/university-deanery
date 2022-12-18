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

    const [instituteData, setInstituteData] = useState();
    const [directionData, setDirectionData] = useState([]);
    const [semestrData, setSemestrData] = useState([]);
    const [groupData, setGroupData] = useState([]);

    useEffect(() => {
        setInstituteData(
            groups.map((group) => {
                return {
                    name: group.institute_name,
                    id: group.institute_id,
                };
            })
        );
    }, []);

    const handleInstituteSelect = (event, value) => {
        setInstitute(value.props.value);
    };

    useEffect(() => {
        if (institute) {
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
                        return direction.institute_id === institute;
                    })
            );
        }

        setDirection('');
        setSemestr('');
        setSemestrData([]);
        setSelectedGroupId('');
        setGroupData([]);
    }, [institute]);

    const handleDirectionSelect = (event, value) => {
        setDirection(value.props.value);
    };

    useEffect(() => {
        if (direction) {
            setSemestrData(
                groups
                    .map((group) => {
                        return {
                            name: group.semestr_number,
                            id: group.semestr_number,
                            direction_id: group.direction_id,
                        };
                    })
                    .filter((sem) => {
                        return sem.direction_id === direction;
                    })
            );
        }

        setSemestr('');
        setSelectedGroupId('');
        setGroupData([]);
    }, [direction, directionData]);

    const handleSemestSelect = (event, value) => {
        setSemestr(value.props.value);
    };

    useEffect(() => {
        if (direction) {
            setGroupData(
                groups
                    .map((group) => {
                        return {
                            name: group.code_number,
                            id: group.group_id,
                            direction_id: group.direction_id,
                            sem_number: group.semestr_number,
                        };
                    })
                    .filter((group) => {
                        return (
                            group.direction_id === direction &&
                            +group.sem_number === +semestr
                        );
                    })
            );
        }
    }, [semestr]);

    const handleGroupSelect = (event, value) => {
        setSelectedGroupId(value.props.value);
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
                        value={institute.value}
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
                        value={semestr}
                        // label={'keek'}
                        onChange={handleSemestSelect}
                    >
                        {getUniqueValues(semestrData).map((value) => {
                            return (
                                <MenuItem key={value.id} value={value.id}>
                                    {value.name}
                                </MenuItem>
                            );
                        })}
                    </Select>
                </FormControl>

                <FormControl required sx={{ m: 1, minWidth: 120, width: 280 }}>
                    <InputLabel id='demo-simple-select-required-label'>
                        {'Группа'}
                    </InputLabel>
                    <Select
                        labelId='demo-simple-select-required-label'
                        id='demo-simple-select-required'
                        value={selectedGroupId}
                        //label={`${label}*`}
                        onChange={handleGroupSelect}
                    >
                        {groupData.map((value) => {
                            return (
                                <MenuItem key={value.id} value={value.id}>
                                    {value.name}
                                </MenuItem>
                            );
                        })}
                    </Select>
                </FormControl>
            </div>
        </>
    );
}
