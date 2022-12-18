import { pool } from '../../db.js';
import { ApiError } from '../../error/ApiError.js';
import { deanQueries } from './DeanQueries.js';

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

    async addStudent(req, res, next) {
        try {
            const { name, surname, email, phone_number, student_id } = req.body;
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

    async updateFeedback(req, res) {}

    async deleteFeedback(req, res) {}
}
export default new DeanController();
