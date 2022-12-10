import { v4 as uuid } from 'uuid';

export const userQueries = {
    isLoginExist: (login: string) => {
        return `SELECT EXISTS(
            SELECT * FROM "User"
            WHERE login = '${login}'
        );`;
    },
    postFeedback: (studentId: string, text: string) => {
        return `INSERT INTO "feedback"(id,student_id,feedback_text,date)
        VALUES('${uuid()}', '${studentId}', '${text}' , LOCALTIMESTAMP);`;
    },
};
