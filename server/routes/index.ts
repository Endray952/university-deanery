import Router from 'express';
import { router as feedbackRouter } from './FeedbackRouter.js';
import { router as authRouter } from './AuthRouter.js';

/**
 * Main router, that collects all routes.
 */
const router = Router();

router.use('/user', authRouter);
router.use('/feedback', feedbackRouter);

export { router };
