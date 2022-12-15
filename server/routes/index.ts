import Router from 'express';
import { router as feedbackRouter } from './FeedbackRouter.js';
import { router as userRouter } from './UserRouter.js';

/**
 * Main router, that collects all routes.
 */
const router = Router();

router.use('/user', userRouter);
router.use('/feedback', feedbackRouter);
//router.use('/admin', feedbackRouter);

export { router };
