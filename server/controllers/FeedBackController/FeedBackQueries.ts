import { v4 as uuid } from 'uuid';

export const feedBackQueries = {
    getFeedbacks: () => {
        return `SELECT * FROM "feedback";`;
    },
    postFeedback: (studentId: string, text: string) => {
        return `INSERT INTO "feedback"(id,student_id,feedback_text,date)
        VALUES('${uuid()}', '${studentId}', '${text}' , LOCALTIMESTAMP);`;
    },
    getFeedbacksById: (feedbackId) => {
        return `SELECT * FROM "feedback" 
        WHERE "feedback".id = '${feedbackId}';`;
    },
};
