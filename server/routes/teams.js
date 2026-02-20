const router = require('express').Router();
const { protect } = require('../middleware/auth');
const {
  getAllTeams,
  getTeamById,
  createTeam,
  joinTeam,
  leaveTeam,
} = require('../controllers/teamController');

router.get('/', protect, getAllTeams);
router.get('/:id', protect, getTeamById);
router.post('/', protect, createTeam);
router.post('/:id/join', protect, joinTeam);
router.post('/:id/leave', protect, leaveTeam);

module.exports = router;
