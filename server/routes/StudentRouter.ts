import Router, { Request, Response } from 'express';
import DeanController from '../controllers/DeanController/DeanController.js';
import FeedbackController from '../controllers/FeedBackController/FeedbackController.js';
import StudentController from '../controllers/StudentController/StudentController.js';
import { checkRoleMiddleWare } from '../middleware/CheckRoleMiddleware.js';

const router = Router();

router.get(
    '/myself/:id',
    checkRoleMiddleWare(['admin', 'student']),
    StudentController.getStudentByUserId
);

export { router };
