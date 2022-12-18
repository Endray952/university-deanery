export const ADMIN_PATH = '/admin';
export const LOGIN_PATH = '/login';
export const REGISTRATION_PATH = '/registration';
export const STUDENT_PATH = '/student';
export const DEAN_PATH = '/dean';
export const ROOT_PATH = '/';
export const SUTDENTS_EDIT_PATH = '/student'; //edit

export interface userType {
    id: string;
    login: string;
    role: string;
    iat: any;
    exp: any;
}

export const role = {
    ADMIN: 'admin',
    STUDENT: 'student',
    DEAN: 'dean',
    TEACHER: 'teacher',
    RECTOR: 'teacher',
};
