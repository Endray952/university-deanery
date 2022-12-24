import { pool } from '../../db.js';
import { ApiError } from '../../error/ApiError.js';
import { TeacherQueries } from './TeacherQueries.js';

class TeacherController {
    // }

    async getTeacherByUserId(req, res, next) {
        try {
            const { user_id } = req.query;
            const student = await pool.query(
                TeacherQueries.getTeacherIdByUserId(user_id)
            );
            res.json(student.rows[0]);
        } catch (e) {
            console.log('getStudentByUserId error', e);
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async getMySheduleByUserId(req, res, next) {
        try {
            const { user_id } = req.query;
            console.log(user_id);
            const subjectsWithMarks: any = await pool.query(
                await TeacherQueries.getMySheduleByUserId(user_id)
            );
            res.json(subjectsWithMarks.rows);
        } catch (e) {
            console.log('get student marks info error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async getLessonStudents(req, res, next) {
        try {
            const { lesson_id } = req.query;
            console.log(lesson_id);
            const subjectsWithMarks: any = await pool.query(
                await TeacherQueries.getLessonStudents(lesson_id)
            );
            res.json(subjectsWithMarks.rows);
        } catch (e) {
            console.log('get student marks info error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }
}
export default new TeacherController();
