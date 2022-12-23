import * as React from 'react';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormHelperText from '@mui/material/FormHelperText';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import { IconButton } from '@mui/material';
import DeleteIcon from '@mui/icons-material/Delete';

export default function DropDownSubject({
    subjects,
    selectedSubjectsIds,
    setSelectedSubjectsIds,
}) {
    const [selectedValue, setSelectedValue] = React.useState();
    const [possibleSubjects, setPossibleSubjects] = React.useState([]);
    const handleSubjectSelect = (event, value) => {
        setSelectedValue(value.props.value);
        setSelectedSubjectsIds([...selectedSubjectsIds, value.props.value]);
    };
    React.useEffect(() => {
        setPossibleSubjects(
            subjects.filter(
                (subject) => !selectedSubjectsIds.includes(subject.id)
            )
        );
    }, [selectedSubjectsIds]);

    if (subjects?.length === 0) {
        return <p>Ошибка</p>;
    }
    return (
        <div style={{ display: 'flex' }}>
            {/* <button>keke</button> */}
            <FormControl required sx={{ m: 1, minWidth: 120, width: 280 }}>
                <InputLabel id='demo-simple-select-required-label'>
                    {'Предмет'}
                </InputLabel>
                <Select
                    labelId='demo-simple-select-required-label'
                    id='demo-simple-select-required'
                    value={selectedValue || ''}
                    //label={`${label}*`}
                    onChange={handleSubjectSelect}
                >
                    {possibleSubjects?.map((value) => {
                        return (
                            <MenuItem value={value.id} key={value.id}>
                                {value.name}
                            </MenuItem>
                        );
                    })}
                </Select>
            </FormControl>
        </div>
    );
}
