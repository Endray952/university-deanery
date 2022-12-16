import { v4 as uuid } from 'uuid';

export const deanQueries = {
    getStudents: () => {
        return `SELECT * FROM "student";`;
    },
};
