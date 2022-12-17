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

export const getStudents = async (): Promise<object> => {
    const { data } = await $authHost.get('api/dean/students');
    //console.log(data);
    //localStorage.setItem('token', data.token);
    //UserStore.setIsAuth(true);
    //console.log(jwt_decode(data.token));
    return data;
};

export const updateStudent = async (
    name: any,
    surname: any,
    email: any,
    phone_number: any,
    student_id: any
): Promise<object> => {
    console.log(name, surname, email, phone_number, student_id);
    const { data } = await $authHost.post('api/dean/updateStudent', {
        name,
        surname,
        email,
        phone_number,
        student_id,
    });
    //console.log(data);
    //localStorage.setItem('token', data.token);
    //UserStore.setIsAuth(true);
    //console.log(jwt_decode(data.token));
    return data;
};
