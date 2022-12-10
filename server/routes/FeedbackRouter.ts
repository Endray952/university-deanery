import Router, { Request, Response } from 'express';
import FeedbackController from '../controllers/FeedBackController/FeedbackController.js';

const router = Router();

router.post('/', FeedbackController.postFeedback);
router.get('/', FeedbackController.getFeedbacks);

router.get('/:id', FeedbackController.getFeedbackById);
router.delete('/:id');
router.put('/:id');

export { router };
