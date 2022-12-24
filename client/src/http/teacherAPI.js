import { $authHost } from '.';
import UserStore from '../store/UserStore';

export const getMySheduleByUserId = async () => {
    try {
        console.log(UserStore.user.id);
        if (!UserStore?.user?.id) {
            console.log('getMySheduleByUserId error');
            return [];
        }
        const { data } = await $authHost.get(`api/teacher/myShedule/`, {
            params: {
                user_id: UserStore.user.id,
            },
        });

        return data;
    } catch (e) {
        console.log('getMySheduleByUserId error');
        return [];
    }
};

export const getTeacherIdByUserId = async () => {
    try {
        console.log(UserStore.user.id);
        if (!UserStore?.user?.id) {
            console.log('getTeacherIdByUserId error');
            return [];
        }
        const { data } = await $authHost.get(
            `api/teacher/getTeacherByUserId/`,
            {
                params: {
                    user_id: UserStore.user.id,
                },
            }
        );

        return data;
    } catch (e) {
        console.log('getTeacherIdByUserId error');
        return [];
    }
};

export const getLessonStudents = async (lesson_id) => {
    try {
        console.log(lesson_id);
        if (!lesson_id) {
            console.log('get lesson error');
            return [];
        }
        const { data } = await $authHost.get(`api/teacher/getLessonStudents/`, {
            params: {
                lesson_id: lesson_id,
            },
        });
        console.log(lesson_id);
        console.log(data);
        return data;
    } catch (e) {
        console.log('get lesson error');
        return [];
    }
};
