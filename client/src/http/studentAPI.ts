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
        //console.log('data', data);
        return data;
    } catch (e) {
        throw e;
    }
};

export const getGroupSheduleById = async (
    group_id?: string
): Promise<object> => {
    const { data } = await $authHost.get(
        `api/student/groupShedule/${'b9b6eff7-872b-4175-bb53-1405a1f4a2e3'}`
    );
    //console.log(data);
    return data;
};

export const getAllCurrentMarksByStudentId = async (
    student_id: any
): Promise<object> => {
    const { data } = await $authHost.get(
        `api/student/getCurrentStudentMarks/${student_id}`
    );
    //console.log(data);
    return data;
};

export const getAllCurrentMarksByUserId = async (
    user_id: any
): Promise<object> => {
    const student = await getStudentByUserId(user_id);
    //@ts-ignore
    const marks = await getAllCurrentMarksByStudentId(student.student_id);
    return marks;
};

export const getSubjectMarksInfo = async (
    user_id: any,
    subject_id: any
): Promise<object> => {
    const student: any = await getStudentByUserId(user_id);
    //console.log(student);
    if (!student) {
        return [];
    }
    const { data } = await $authHost.get(`api/student/getSubjectMarksInfo`, {
        params: {
            student_id: student.student_id,
            subject_id,
        },
    });
    // console.log(data);
    return data;
};

export const getGroupByUserId = async (): Promise<object> => {
    try {
        console.log(UserStore?.user?.id);
        const { group_id }: any = (
            await $authHost.get(`api/student/getStudentGroupByUserId`, {
                params: {
                    user_id: UserStore?.user?.id,
                },
            })
        ).data;
        const { data } = await $authHost.get(
            `api/student/groupShedule/${group_id}`
        );

        console.log(group_id);
        return data;
    } catch (e) {
        console.log(e);
        return getGroupSheduleById();
    }
};
