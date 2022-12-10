import { pool } from '../../db.js';
import { ApiError } from '../../error/ApiError.js';
import { userQueries } from './UserQueries.js';

class UserController {
    async isUserLoginExists(req, res, next) {
        try {
            const { login } = req.body;
            const userLoginExists = await pool.query(
                userQueries.isLoginExist(login)
            );
            return userLoginExists;
        } catch (e) {
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async addUser(req, res, next) {
        try {
            pool.query(
                `INSER INTO TABLE "User" 
                VALUES ($1, $2, $3, $4, $5)`
            );
        } catch (e) {
            next(ApiError.badRequest(e.message));
        }
    }
}

export default new UserController();
