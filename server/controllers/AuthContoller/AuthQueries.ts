import { v4 as uuid } from 'uuid';

export const authQueries = {
    isLoginExist: (login: string) => {
        return `SELECT EXISTS(
            SELECT * FROM "system_user"
            WHERE "system_user"."login" = '${login}'
        );`;
    },
    createUser: (
        login: string,
        hashedPassword: string,
        role: string,
        personId: string
    ) => {
        return `INSERT INTO "system_user" 
        ("id", "login", "hashed_password", "role", "personId")
        VALUES ('${uuid()}', '${login}', '${hashedPassword}', '${role}', '${personId}');
        ;`;
    },
    getUser: (login: string) => {
        return `
            SELECT * FROM "system_user"
            WHERE "system_user"."login" = '${login}'
        ;`;
    },
};
