import { pool } from '../../db.js';
import UserController from '../UserController/UserController.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { ApiError } from '../../error/ApiError.js';
import { authQueries } from './AuthQueries.js';

const generateJwt = (id: string, login: string, role: string) => {
    return jwt.sign({ id, login, role }, process.env.SECRET_KEY, {
        expiresIn: '24h',
    });
};

class AuthController {
    async hashPassword(password: string) {
        return await bcrypt.hash(password, 10);
    }

    async validatePassword(plainPassword: string, hashedPassword: string) {
        return await bcrypt.compare(plainPassword, hashedPassword);
    }

    async registration(req, res, next) {
        try {
            const { login, password, role, personId } = req.body;

            const candidateAprovement = await this.isUserLoginExists(
                next,
                login
            );
            if (candidateAprovement) {
                return next(
                    ApiError.badRequest(
                        'Пользователь с таким login уже существует'
                    )
                );
            }
            const hashedPassword = await bcrypt.hash(password, 5);

            this.createUser(login, hashedPassword, role, personId, next);
            const token = generateJwt(personId, login, role);
            return res.json({ token });
        } catch (e) {
            console.log('registration');
            next(ApiError.badRequest(`${e.message} + 'Registration failed'`));
        }
    }
    private async createUser(
        login: string,
        hashedPassword: string,
        role: string,
        personId: string,
        next
    ) {
        try {
            await pool.query(
                authQueries.createUser(login, hashedPassword, role, personId)
            );
        } catch (e) {
            console.log('createUser');
            //next(ApiError.badRequest(`Error creating user/ ${e.message}`));
            throw e;
        }
    }

    private async isUserLoginExists(next, login) {
        try {
            //console.log(login);
            const userLoginExists = await pool.query(
                authQueries.isLoginExist(login)
            );
            return userLoginExists.rows[0].exists;
        } catch (e) {
            console.log('isUserLoginExists');
            throw e;
            //next(ApiError.badRequest(`${e.message}`));
        }
    }

    private async getUser(login) {
        try {
            const user = await pool.query(authQueries.getUser(login));
            return user.rows[0];
        } catch (e) {
            console.log('isUserLoginExists');
            throw e;
            //next(ApiError.badRequest(`${e.message}`));
        }
    }

    async login(req, res, next) {
        const { login, password } = req.body;
        let user = await this.isUserLoginExists(next, login);
        if (!user) {
            return next(
                ApiError.badRequest('Пользователя с таким login не существует')
            );
        }
        user = await this.getUser(login);
        //console.log('login', user);
        const comparePassword = bcrypt.compareSync(
            password,
            user.hashed_password
        );
        if (!comparePassword) {
            return next(ApiError.internal('Указан неверный пароль'));
        }
        const token = generateJwt(user.id, user.login, user.role);
        return res.json({ token });
    }

    async check(req, res, next) {
        const token = generateJwt(req.user.id, req.user.login, req.user.role);
        return res.json({ token });
        // return res.json({ message: 'sosi' });
    }
}

export default new AuthController();
