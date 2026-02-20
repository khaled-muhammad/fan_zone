const router = require('express').Router();
const { protect, authorize } = require('../middleware/auth');
const {
  getAllLeagues,
  getLeagueById,
  createLeague,
  registerTeam,
  recordMatch,
} = require('../controllers/leagueController');

router.get('/', protect, getAllLeagues);
router.get('/:id', protect, getLeagueById);
router.post('/', protect, authorize('owner', 'admin'), createLeague);
router.post('/:id/register', protect, registerTeam);
router.post('/:id/match', protect, authorize('owner', 'admin'), recordMatch);

module.exports = router;
