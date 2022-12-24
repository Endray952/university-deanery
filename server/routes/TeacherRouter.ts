import Router, { Request, Response } from 'express';
import StudentController from '../controllers/StudentController/StudentController.js';
import TeacherController from '../controllers/TeacherController/TeacherController.js';
import { checkRoleMiddleWare } from '../middleware/CheckRoleMiddleware.js';

const router = Router();

router.get(
    '/myShedule/',
    checkRoleMiddleWare(['admin', 'dean', 'teacher']),
    TeacherController.getMySheduleByUserId
);
router.get(
    '/getTeacherByUserId/',
    checkRoleMiddleWare(['admin', 'dean', 'teacher']),
    TeacherController.getTeacherByUserId
);

router.get(
    '/getLessonStudents/',
    checkRoleMiddleWare(['admin', 'dean', 'teacher']),
    TeacherController.getLessonStudents
);

export { router };
