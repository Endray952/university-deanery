import Router, { Request, Response } from 'express';
import DeanController from '../controllers/DeanController/DeanController.js';
import FeedbackController from '../controllers/FeedBackController/FeedbackController.js';
import { checkRoleMiddleWare } from '../middleware/CheckRoleMiddleware.js';

const router = Router();

router.get(
    '/students',
    checkRoleMiddleWare(['admin', 'dean']),
    DeanController.getStudents
);

router.post(
    '/updateStudent',
    checkRoleMiddleWare(['admin', 'dean']),
    DeanController.updateStudent
);

router.post(
    '/createStudent',
    checkRoleMiddleWare(['admin', 'dean']),
    DeanController.createStudent.bind(DeanController)
);

router.get(
    '/getGroups/:date',
    checkRoleMiddleWare(['admin', 'dean']),
    DeanController.getGroups
);

export { router };
