const router = require('express').Router();
const { protect, authorize } = require('../middleware/auth');
const {
  createBooking,
  getMyBookings,
  getPitchBookings,
  getOwnerStats,
  getTodayBookingsForOwner,
  cancelBooking,
  verifyBooking,
  completeBooking,
} = require('../controllers/bookingController');

router.post('/', protect, createBooking);
router.get('/my', protect, getMyBookings);
router.get('/owner/stats', protect, authorize('owner', 'admin'), getOwnerStats);
router.get('/owner/today', protect, authorize('owner', 'admin'), getTodayBookingsForOwner);
router.get('/pitch/:pitchId', protect, authorize('owner', 'admin'), getPitchBookings);
router.patch('/:id/cancel', protect, cancelBooking);
router.post('/verify', protect, authorize('owner', 'admin'), verifyBooking);
router.patch('/:id/complete', protect, authorize('owner', 'admin'), completeBooking);

module.exports = router;
