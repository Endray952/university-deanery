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
