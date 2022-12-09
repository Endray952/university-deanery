import Router from 'express';

const router = Router();

router.get('/');

router.post('/:id');
router.get('/:id');
router.patch('/:id');
router.delete('/:id');
router.put('/:id');

export { router };