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

export const getStudentByUserId = async (id: string): Promise<object> => {
    try {
        const { data } = await $authHost.get(`api/student/myself/${id}`);
        return data;
    } catch (e) {
        throw e;
    }
};

export const getGroupById = async (group_id?: string): Promise<object> => {
    const { data } = await $authHost.get(
        `api/student/groupShedule/${'b9b6eff7-872b-4175-bb53-1405a1f4a2e3'}`
    );
    // console.log(data);
    return data;
};
