import { pool } from '../../db.js';
import { ApiError } from '../../error/ApiError.js';
import { StudentQueries } from './StudentQueries.js';

class StudentController {
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

    async updateFeedback(req, res) {}

    async deleteFeedback(req, res) {}
}
export default new StudentController();
