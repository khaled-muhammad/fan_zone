const router = require('express').Router();
const { protect } = require('../middleware/auth');
const { getTeamMessages, sendMessage } = require('../controllers/messageController');

router.get('/:teamId', protect, getTeamMessages);
router.post('/', protect, sendMessage);

module.exports = router;
