const router = require('express').Router();
const { protect, authorize } = require('../middleware/auth');
const {
  getAllPitches,
  getMyPitches,
  getPitchById,
  createPitch,
  updatePitch,
  getSchedule,
} = require('../controllers/pitchController');

router.get('/', protect, getAllPitches);
router.get('/mine', protect, authorize('owner', 'admin'), getMyPitches);
router.get('/:id', protect, getPitchById);
router.post('/', protect, authorize('owner', 'admin'), createPitch);
router.patch('/:id', protect, authorize('owner', 'admin'), updatePitch);
router.get('/:pitchId/schedule', protect, getSchedule);

module.exports = router;
