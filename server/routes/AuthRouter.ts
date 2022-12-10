import { Router } from 'express';
import controller from '../controllers/AuthContoller/AuthController.js';
import { authMiddleware } from '../middleware/AuthMiddleware.js';
import { checkRoleMiddleWare } from '../middleware/CheckRoleMiddleware.js';

const router = Router();

router.post(
    '/registration',
    checkRoleMiddleWare(['admin']),
    controller.registration.bind(controller)
);
router.post('/login', controller.login.bind(controller));
router.get('/auth', authMiddleware, controller.check);
//router.get('/auth', controller.auth);
//router.get('/users', controller.getUsers);

//router.get('/login', controller.isUserLoginExists);

export { router };
