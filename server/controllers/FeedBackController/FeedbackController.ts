import { pool } from '../../db.js';
import { ApiError } from '../../error/ApiError.js';
import { feedBackQueries } from './FeedBackQueries.js';

class FeedbackController {
    async getFeedbackById(req, res, next) {
        try {
            const { id: feedbackId } = req.params;
            console.log(feedbackId);
            const feedbacks = await pool.query(
                feedBackQueries.getFeedbacksById(feedbackId)
            );
            res.json(feedbacks.rows);
        } catch (e) {
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async getFeedbacks(req, res) {
        const feedbacks = await pool.query(feedBackQueries.getFeedbacks());
        res.json(feedbacks.rows);
    }

    async postFeedback(req, res, next) {
        try {
            const { text } = req.body;
            const postRes = await pool.query(
                feedBackQueries.postFeedback(
                    '852ebb18-667d-485b-8544-2e3faa405819',
                    text
                )
            );
            console.log(postRes.rows);
            res.json(postRes.rows);
        } catch (e) {
            next(ApiError.badRequest(`${e.message}`));
        }
    }

    async updateFeedback(req, res) {}

    async deleteFeedback(req, res) {}
}
export default new FeedbackController();
