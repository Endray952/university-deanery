export const feedBackQueries = {
    getFeedbacks: () => {
        return `SELECT * FROM "feedback";`;
    },
    postFeedback: (studentId: string, text: string) => {
        return `INSERT INTO "feedback"(id,student_id,feedback_text,date)
        VALUES(gen_random_uuid(), '${studentId}', '${text}' , LOCALTIMESTAMP);`;
    },
    getFeedbacksById: (feedbackId) => {
        return `SELECT * FROM "feedback" 
        WHERE "feedback".id = '${feedbackId}';`;
    },
};
