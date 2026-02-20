const { v4: uuidv4 } = require('uuid');
const Booking = require('../models/Booking');
const User = require('../models/User');
const { success, created, notFound, badRequest, conflict, unauthorized } = require('../utils/response');

exports.createBooking = async (req, res, next) => {
  try {
    const { pitchId, date, startTime, endTime } = req.body;

    const existingBooking = await Booking.findOne({
      pitchId,
      date,
      startTime,
      status: { $nin: ['Cancelled'] },
    });

    if (existingBooking) {
      return conflict(res, 'This time slot is already booked');
    }

    const qrCodeToken = uuidv4();

    const booking = await Booking.create({
      userId: req.user._id,
      pitchId,
      date,
      startTime,
      endTime,
      qrCodeToken,
      status: 'Reserved',
    });

    const populated = await booking.populate([
      { path: 'pitchId', select: 'name locationName pricePerHour' },
      { path: 'userId', select: 'fullName email' },
    ]);

    return created(res, 'Booking created successfully', populated);
  } catch (error) {
    next(error);
  }
};

exports.getPitchBookings = async (req, res, next) => {
  try {
    const { pitchId } = req.params;
    const { date, status } = req.query;

    const filter = { pitchId };
    if (date) filter.date = date;
    if (status) filter.status = status;

    const bookings = await Booking.find(filter)
      .populate('userId', 'fullName email phone')
      .populate('pitchId', 'name locationName')
      .sort({ date: -1, startTime: 1 });

    return success(res, 'Pitch bookings retrieved', bookings);
  } catch (error) {
    next(error);
  }
};

exports.getOwnerStats = async (req, res, next) => {
  try {
    const Pitch = require('../models/Pitch');
    const pitches = await Pitch.find({ createdBy: req.user._id });
    const pitchIds = pitches.map((p) => p._id);

    const today = new Date().toISOString().split('T')[0];

    const totalBookings = await Booking.countDocuments({ pitchId: { $in: pitchIds } });
    const todayBookings = await Booking.countDocuments({
      pitchId: { $in: pitchIds },
      date: today,
      status: { $nin: ['Cancelled'] },
    });
    const checkedIn = await Booking.countDocuments({
      pitchId: { $in: pitchIds },
      date: today,
      status: 'Checked-In',
    });
    const completed = await Booking.countDocuments({
      pitchId: { $in: pitchIds },
      status: 'Completed',
    });

    return success(res, 'Owner stats retrieved', {
      totalPitches: pitches.length,
      totalBookings,
      todayBookings,
      checkedIn,
      completed,
    });
  } catch (error) {
    next(error);
  }
};

exports.getTodayBookingsForOwner = async (req, res, next) => {
  try {
    const Pitch = require('../models/Pitch');
    const pitches = await Pitch.find({ createdBy: req.user._id });
    const pitchIds = pitches.map((p) => p._id);

    const today = new Date().toISOString().split('T')[0];

    const bookings = await Booking.find({
      pitchId: { $in: pitchIds },
      date: today,
      status: { $nin: ['Cancelled'] },
    })
      .populate('userId', 'fullName phone')
      .populate('pitchId', 'name')
      .sort({ startTime: 1 });

    return success(res, 'Today bookings retrieved', bookings);
  } catch (error) {
    next(error);
  }
};

exports.getMyBookings = async (req, res, next) => {
  try {
    const bookings = await Booking.find({ userId: req.user._id })
      .populate('pitchId', 'name locationName pricePerHour')
      .sort({ createdAt: -1 });

    return success(res, 'Bookings retrieved', bookings);
  } catch (error) {
    next(error);
  }
};

exports.cancelBooking = async (req, res, next) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) return notFound(res, 'Booking not found');

    if (booking.userId.toString() !== req.user._id.toString()) {
      return unauthorized(res, 'Not authorized to cancel this booking');
    }

    if (booking.status === 'Cancelled') {
      return badRequest(res, 'Booking is already cancelled');
    }

    booking.status = 'Cancelled';
    await booking.save();

    return success(res, 'Booking cancelled', booking);
  } catch (error) {
    next(error);
  }
};

exports.verifyBooking = async (req, res, next) => {
  try {
    const { bookingId, qrCodeToken } = req.body;

    if (!bookingId || !qrCodeToken) {
      return badRequest(res, 'bookingId and qrCodeToken are required');
    }

    const booking = await Booking.findById(bookingId).populate('pitchId');
    if (!booking) return notFound(res, 'Booking not found');

    if (booking.qrCodeToken !== qrCodeToken) {
      return badRequest(res, 'Invalid QR code');
    }

    if (booking.status !== 'Reserved') {
      return badRequest(res, `Cannot verify booking with status: ${booking.status}`);
    }

    booking.status = 'Checked-In';
    await booking.save();

    return success(res, 'Booking verified - Checked In', booking);
  } catch (error) {
    next(error);
  }
};

exports.completeBooking = async (req, res, next) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) return notFound(res, 'Booking not found');

    if (booking.status !== 'Checked-In') {
      return badRequest(res, 'Only checked-in bookings can be completed');
    }

    booking.status = 'Completed';
    await booking.save();

    const user = await User.findById(booking.userId);
    if (user) {
      user.matchesPlayed += 1;
      user.calculateLevel();
      await user.save();
    }

    return success(res, 'Booking completed, player stats updated', booking);
  } catch (error) {
    next(error);
  }
};
