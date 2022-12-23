import Router, { Request, Response } from 'express';
import StudentController from '../controllers/StudentController/StudentController.js';
import { checkRoleMiddleWare } from '../middleware/CheckRoleMiddleware.js';

const router = Router();

router.get(
    '/myself/:id',
    checkRoleMiddleWare(['admin', 'student']),
    StudentController.getStudentByUserId
);

router.get(
    '/groupShedule/:group_id',
    checkRoleMiddleWare(['admin', 'dean', 'student']),
    StudentController.getGroupShedule
);

export { router };
