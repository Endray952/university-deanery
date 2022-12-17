import Router from 'express';
import { router as feedbackRouter } from './FeedbackRouter.js';
import { router as userRouter } from './UserRouter.js';
import { router as deanRouter } from './DeanRouter.js';
import { router as studentRouter } from './StudentRouter.js';
/**
 * Main router, that collects all routes.
 */
const router = Router();

router.use('/user', userRouter);
router.use('/feedback', feedbackRouter);
router.use('/dean', deanRouter);
router.use('/student', studentRouter);

export { router };
