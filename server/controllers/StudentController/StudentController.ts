import { pool } from '../../db.js';
import { ApiError } from '../../error/ApiError.js';
import { StudentQueries } from './StudentQueries.js';

class StudentController {
    // }

    async getStudentByUserId(req, res, next) {
        try {
            const { id } = req.params;
            const student = await pool.query(
                StudentQueries.getStudentByUserId(id)
            );
            res.json(student.rows[0]);
        } catch (e) {
            console.log('getStudentByUserId error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }
    async getGroupShedule(req, res, next) {
        try {
            const { group_id } = req.params;
            const shedule = await pool.query(
                StudentQueries.getGroupShedule(group_id)
            );
            res.json(shedule.rows);
        } catch (e) {
            console.log('get shedule error ');
            next(ApiError.badRequest(`${e.message}`));
        }
    }
    async getCurrentStudentMarks(req, res, next) {
        try {
            const { student_id } = req.params;
            const subjectsWithMarks = await pool.query(
                StudentQueries.getCurrentStudentMarks(student_id)
            );
            res.json(subjectsWithMarks.rows);
        } catch (e) {
            console.log('get student marks error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async getSubjectMarksInfo(req, res, next) {
        try {
            const { student_id, subject_id } = req.query;
            const subjectsWithMarks = await pool.query(
                StudentQueries.getSubjectMarksInfo(student_id, subject_id)
            );
            res.json(subjectsWithMarks.rows);
        } catch (e) {
            console.log('get student marks info error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async getStudentGroupByUserId(req, res, next) {
        try {
            const { user_id } = req.query;
            console.log(user_id);
            const subjectsWithMarks: any = await pool.query(
                StudentQueries.getStudentGroupByUserId(user_id)
            );
            res.json(subjectsWithMarks.rows[0]);
        } catch (e) {
            console.log('get student marks info error');
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async updateFeedback(req, res) {}

    async deleteFeedback(req, res) {}
}
export default new StudentController();
