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

router.get(
    '/teachers',
    checkRoleMiddleWare(['admin', 'dean']),
    DeanController.getTeachers
);

router.get(
    '/getSubjects',
    checkRoleMiddleWare(['admin', 'dean']),
    DeanController.getSubjects
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

router.post(
    '/expellStudent',
    checkRoleMiddleWare(['admin', 'dean']),
    DeanController.expellStudent.bind(DeanController)
);

router.post(
    '/enrollStudent',
    checkRoleMiddleWare(['admin', 'dean']),
    DeanController.enrollStudent.bind(DeanController)
);

router.post(
    '/transferStudent',
    checkRoleMiddleWare(['admin', 'dean']),
    DeanController.transferStudent.bind(DeanController)
);

export { router };
