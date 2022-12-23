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
    private async createUser(
        login: string,
        hashedPassword: string,
        role: string,
        personId: string,
        next
    ) {
        try {
            console.log(login, hashedPassword, personId);
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
            console.log(login);
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
            const errorRes = { statusCode: '200', description: null };
            const candidateAprovement = await this.isUserLoginExists(
                next,
                login
            );
            if (candidateAprovement) {
                errorRes.statusCode = '404';
                errorRes.description =
                    'Пользователь с таким login уже существует';
                return res.json({ errorRes });
                // return next(
                //     ApiError.badRequest(
                //         'Пользователь с таким login уже существует'
                //     )
                // );
            }
            const studentId = (
                await pool.query(
                    deanQueries.createStudent(
                        name,
                        surname,
                        email,
                        phone_number,
                        passport,
                        birthday,
                        group_id
                    )
                )
            ).rows[0]['create_student'];
            const hashedPassword = await bcrypt.hash(String(password), 5);
            console.log(hashedPassword);
            console.log(studentId);
            this.createUser(
                login,
                hashedPassword,
                'student',
                String(studentId),
                next
            );
            console.log(login);
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
            const { name, surname, email, phone_number, student_id, passport } =
                req.body;
            //console.log(name, surname, email, phone_number, student_id);
            const students = await pool.query(
                deanQueries.updateStudent(
                    name,
                    surname,
                    email,
                    phone_number,
                    student_id,
                    passport
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
            //console.log(date);
            const groups = await pool.query(deanQueries.getGroups(date));

            res.json(groups.rows);
        } catch (e) {
            console.log('getGroups error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async expellStudent(req, res, next) {
        try {
            const { student_id } = req.body;
            console.log(student_id);
            const expelled_student_id = await pool.query(
                deanQueries.expellStudent(student_id)
            );

            res.json(expelled_student_id.rows);
        } catch (e) {
            console.log('expell error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async enrollStudent(req, res, next) {
        try {
            const { student_id, group_id } = req.body;
            console.log(student_id);
            const enrolled_student_id = await pool.query(
                deanQueries.enrollStudent(student_id, group_id)
            );

            res.json(enrolled_student_id.rows);
        } catch (e) {
            console.log('enroll error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async transferStudent(req, res, next) {
        try {
            const { student_id, group_id } = req.body;
            //console.log(student_id);
            const enrolled_student_id = await pool.query(
                deanQueries.transferStudent(student_id, group_id)
            );

            res.json(enrolled_student_id.rows);
        } catch (e) {
            console.log('transfer error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async getTeachers(req, res, next) {
        try {
            //const { student_id, group_id } = req.body;
            //console.log(student_id);
            const teachers = await pool.query(deanQueries.getTeachers());

            res.json(teachers.rows);
        } catch (e) {
            console.log('get teachers error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async getSubjects(req, res, next) {
        try {
            //const { student_id, group_id } = req.body;
            //console.log(student_id);
            const subjects = await pool.query(deanQueries.getSubjects());

            res.json(subjects.rows);
        } catch (e) {
            console.log('get subjects error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }
}
export default new DeanController();
