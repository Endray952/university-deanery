import { $authHost, $host } from '.';
import jwt_decode from 'jwt-decode';
import UserStore from '../store/UserStore';
import { userType } from '../utils/consts';

export const registration = async (login: string, password: string) => {
    const { data } = await $host.post('api/auth/registration', {
        login,
        password,
        role: 'admin',
    });
    return jwt_decode(data.token);
};

export const login = async (
    login: string,
    password: string
): Promise<userType | null> => {
    const { data } = await $host.post('api/user/login', {
        login,
        password,
    });
    localStorage.setItem('token', data.token);
    return jwt_decode(data.token);
};

export const check = async (): Promise<userType | null> => {
    const { data } = await $authHost.get('api/user/auth');
    localStorage.setItem('token', data.token);
    return jwt_decode(data.token);
};
