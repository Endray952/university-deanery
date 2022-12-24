//export const ADMIN_PATH = '/admin';
export const LOGIN_PATH = '/login';
export const STUDENT_MARKS_PATH = '/studentMarks';
export const STUDENT_SHEDULE_PATH = '/studentShedule';
//export const DEAN_PATH = '/dean';
export const ROOT_PATH = '/';
export const STUDENTS_EDIT_PATH = '/editStudents'; //edit
export const TEACHERS_EDIT_PATH = '/editTeachers'; //edit
export const TEACHER_SHEDULE_PATH = '/teacherShedule';
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
    RECTOR: 'rector',
};
