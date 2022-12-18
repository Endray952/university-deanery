import { pool } from '../../db.js';
import { ApiError } from '../../error/ApiError.js';
import { authQueries } from '../AuthContoller/AuthQueries.js';
import { deanQueries } from './DeanQueries.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

const generateJwt = (id: string, login: string, role: string) => {
    return jwt.sign({ id, login, role }, process.env.SECRET_KEY, {
        expiresIn: '24h',
    });
};
class DeanController {
    // async getFeedbackById(req, res, next) {
    //     try {
    //         const { id: feedbackId } = req.params;
    //         console.log(feedbackId);
    //         const feedbacks = await pool.query(
    //             feedBackQueries.getFeedbacksById(feedbackId)
    //         );
    //         res.json(feedbacks.rows);
    //     } catch (e) {
    //         next(ApiError.badRequest(`${e.message}`));
    //     }
    // }

    async createStudent(req, res, next) {
        try {
            const {
                login,
                password,
                name,
                surname,
                email,
                phone_number,
                passport,
                birthday,
                group_id,
            } = req.body;
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
            const studentId = await pool.query(
                deanQueries.createStudent(
                    name,
                    surname,
                    email,
                    phone_number,
                    passport,
                    birthday,
                    group_id
                )
            );
            //res.json(studentId.rows);

            const hashedPassword = await bcrypt.hash(password, 5);

            this.createUser(
                login,
                hashedPassword,
                'student',
                String(studentId),
                next
            );
            const token = generateJwt(String(studentId), login, 'student');
            return res.json({ token });
        } catch (e) {
            console.log('getStudents error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async getStudents(req, res, next) {
        try {
            const students = await pool.query(deanQueries.getStudents());
            res.json(students.rows);
        } catch (e) {
            console.log('getStudents error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async updateStudent(req, res, next) {
        try {
            const { name, surname, email, phone_number, student_id } = req.body;
            //console.log(name, surname, email, phone_number, student_id);
            const students = await pool.query(
                deanQueries.updateStudent(
                    name,
                    surname,
                    email,
                    phone_number,
                    student_id
                )
            );
            res.json(students.rows);
        } catch (e) {
            console.log('getStudents error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async getGroups(req, res, next) {
        try {
            const { date } = req.params;
            console.log(date);
            const groups = await pool.query(deanQueries.getGroups(date));

            res.json(groups.rows);
        } catch (e) {
            console.log('getGroups error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }
    // async postFeedback(req, res, next) {
    //     try {
    //         const { text } = req.body;
    //         const postRes = await pool.query(
    //             feedBackQueries.postFeedback(
    //                 '852ebb18-667d-485b-8544-2e3faa405819',
    //                 text
    //             )
    //         );
    //         console.log(postRes.rows);
    //         res.json(postRes.rows);
    //     } catch (e) {
    //         next(ApiError.badRequest(`${e.message}`));
    //     }
    // }

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
}
export default new DeanController();
