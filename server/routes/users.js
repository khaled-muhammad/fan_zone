const router = require('express').Router();
const { protect } = require('../middleware/auth');
const { getMe, updateMe, getUserStats } = require('../controllers/userController');

router.get('/me', protect, getMe);
router.patch('/me', protect, updateMe);
router.get('/:id/stats', protect, getUserStats);

module.exports = router;
