export const ADMIN_PATH = '/admin';
export const LOGIN_PATH = '/login';
export const REGISTRATION_PATH = '/registration';
export const STUDENT_PATH = '/student';
export const DEAN_PATH = '/dean';
export const ROOT_PATH = '/';

export interface userType {
    id: string;
    login: string;
    role: string;
    iat: any;
    exp: any;
}
