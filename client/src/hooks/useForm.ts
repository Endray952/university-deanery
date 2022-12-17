import { useState } from 'react';

const initialArray: string[] = [];

export const useForm = (formNames: string[]) => {
    const [values, setValues] = useState(initialArray);
    const form: any = {};

    formNames.forEach((e, i) => {
        form[e] = {
            value: values[i],
            set: (newValue: string) => {
                setValues([
                    ...values.slice(0, i),
                    newValue,
                    ...values.slice(i + 1),
                ]);
            },
        };
    });

    return form;
};
