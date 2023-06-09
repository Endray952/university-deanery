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
        ("id", "login", "hashed_password", "role", "person_id")
        VALUES (gen_random_uuid(), '${login}', '${hashedPassword}', '${role}', '${personId}')
        ;`;
    },
    getUser: (login: string) => {
        return `
            SELECT * FROM "system_user"
            WHERE "system_user"."login" = '${login}'
        ;`;
    },
};
