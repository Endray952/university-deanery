import { $authHost, $host } from '.';
import jwt_decode from 'jwt-decode';
import UserStore from '../store/UserStore';

// export const registration = async (login: string, password: string) => {
//     const { data } = await $host.post('api/auth/registration', {
//         login,
//         password,
//         role: 'admin',
//     });
//     return jwt_decode(data.token);
// };

// export const login = async (
//     login: string,
//     password: string
// ): Promise<object> => {
//     const { data } = await $host.post('api/user/login', {
//         login,
//         password,
//     });
//     localStorage.setItem('token', data.token);
//     return jwt_decode(data.token);
// };
export const getCurrentGroups = async (): Promise<Array<any>> => {
    const { data } = await $authHost.get('api/dean/getGroups/CURRENT_DATE');
    //console.log(data);
    return data;
};

export const getGroupsByDate = async (date: any): Promise<object> => {
    const { data } = await $authHost.get("api/dean/getGroups/'date'");

    return data;
};

export const getStudents = async (): Promise<object> => {
    const { data } = await $authHost.get('api/dean/students');
    console.log(data);
    return data;
};

export const createStudent = async (
    login: any,
    password: any,
    name: any,
    surname: any,
    email: any,
    phone_number: any,
    passport: any,
    birthday: any,
    group_id: any
): Promise<object> => {
    console.log(name, surname, email, phone_number);
    const { data } = await $authHost.post('api/dean/createStudent', {
        login,
        password,
        name,
        surname,
        email,
        phone_number,
        passport,
        birthday,
        group_id,
    });

    return data;
};

export const updateStudent = async (
    name: any,
    surname: any,
    email: any,
    phone_number: any,
    student_id: any,
    passport: any
): Promise<object> => {
    console.log(name, surname, email, phone_number, student_id);
    const { data } = await $authHost.post('api/dean/updateStudent', {
        name,
        surname,
        email,
        phone_number,
        student_id,
        passport,
    });
    return data;
};

export const enrollStudent = async (
    group_id: any,
    student_id: any
): Promise<object> => {
    //console.log(name, surname, email, phone_number, student_id);
    const { data } = await $authHost.post('api/dean/enrollStudent', {
        group_id,
        student_id,
    });
    return data;
};

export const expellStudent = async (student_id: any): Promise<object> => {
    //console.log(name, surname, email, phone_number, student_id);
    const { data } = await $authHost.post('api/dean/expellStudent', {
        student_id,
    });
    return data;
};

export const transferStudent = async (
    group_id: any,
    student_id: any
): Promise<object> => {
    //console.log(name, surname, email, phone_number, student_id);
    const { data } = await $authHost.post('api/dean/transferStudent', {
        group_id,
        student_id,
    });
    return data;
};

export const getTeachers = async () => {
    const { data } = await $authHost.get('api/dean/teachers');
    //console.log(data);
    const mapData = new Map();
    const resData = [];

    data.forEach((teacher: any) => {
        if (mapData.has(teacher.teacher_id)) {
            const curItem = mapData.get(teacher.teacher_id);
            curItem.subjects.push({
                subject_id: teacher.subject_id,
                subject_name: teacher.subject_name,
            });
            mapData.set(teacher.teacher_id, curItem);
        } else {
            //const curItem = {id: teacher.id, subjects: [{subject_name: teacher.subject}]}
            const curItem = {
                ...teacher,
                subjects: [
                    {
                        subject_id: teacher.subject_id,
                        subject_name: teacher.subject_name,
                    },
                ],
            };
            mapData.set(teacher.teacher_id, curItem);
        }
    });
    //@ts-ignore
    for (let value of mapData.values()) {
        //console.log(value)
        resData.push(value);
    }
    //console.log(JSON.stringify(resData));
    //console.log(resData);
    return resData;
};

export const getSubjects = async (): Promise<object> => {
    try {
        const { data } = await $authHost.get('api/dean/getSubjects');
        return data;
    } catch (e) {
        console.log(e);
        return [];
    }
};

export const updateTeacher = async (
    name: any,
    surname: any,
    email: any,
    phone_number: any,
    teacher_id: any,
    passport: any
): Promise<object> => {
    console.log(name, surname, email, phone_number, teacher_id);
    const { data } = await $authHost.post('api/dean/updateTeacher', {
        name,
        surname,
        email,
        phone_number,
        teacher_id,
        passport,
    });
    return data;
};

export const updateTeacherSubjects = async (
    teacher_id: any,
    subject_ids: any
): Promise<object> => {
    try {
        const { data } = await $authHost.post(
            'api/dean/updateTeacherSubjects',
            {
                teacher_id,
                subject_ids,
            }
        );
        return data;
    } catch (e) {
        throw e;
    }
};

export const changeTeacherStatus = async (
    teacher_id: any,
    is_working: any
): Promise<object> => {
    const { data } = await $authHost.post(
        'api/dean/updateTeacherChangeStatus',
        {
            teacher_id,
            is_working,
        }
    );
    return data;
};

export const createTeacher = async (
    login: any,
    password: any,
    name: any,
    surname: any,
    email: any,
    phone_number: any,
    passport: any,
    birthday: any
): Promise<object> => {
    //console.log(name, surname, email, phone_number);
    const { data } = await $authHost.post('api/dean/createTeacher', {
        login,
        password,
        name,
        surname,
        email,
        phone_number,
        passport,
        birthday,
    });

    return data;
};
