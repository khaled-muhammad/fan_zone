const Pitch = require('../models/Pitch');
const Booking = require('../models/Booking');
const { success, created, notFound, badRequest } = require('../utils/response');

exports.getAllPitches = async (req, res, next) => {
  try {
    const pitches = await Pitch.find().populate('createdBy', 'fullName');
    return success(res, 'Pitches retrieved', pitches);
  } catch (error) {
    next(error);
  }
};

exports.getPitchById = async (req, res, next) => {
  try {
    const pitch = await Pitch.findById(req.params.id).populate('createdBy', 'fullName');
    if (!pitch) return notFound(res, 'Pitch not found');
    return success(res, 'Pitch retrieved', pitch);
  } catch (error) {
    next(error);
  }
};

exports.getMyPitches = async (req, res, next) => {
  try {
    const pitches = await Pitch.find({ createdBy: req.user._id });
    return success(res, 'Your pitches retrieved', pitches);
  } catch (error) {
    next(error);
  }
};

exports.updatePitch = async (req, res, next) => {
  try {
    const pitch = await Pitch.findById(req.params.id);
    if (!pitch) return notFound(res, 'Pitch not found');

    if (pitch.createdBy.toString() !== req.user._id.toString()) {
      return badRequest(res, 'Not authorized to update this pitch');
    }

    const allowedFields = [
      'name', 'locationName', 'latitude', 'longitude',
      'pricePerHour', 'images', 'workingHoursStart', 'workingHoursEnd', 'mapsUrl',
    ];
    for (const field of allowedFields) {
      if (req.body[field] !== undefined) pitch[field] = req.body[field];
    }
    await pitch.save();
    return success(res, 'Pitch updated', pitch);
  } catch (error) {
    next(error);
  }
};

exports.createPitch = async (req, res, next) => {
  try {
    const pitch = await Pitch.create({
      ...req.body,
      createdBy: req.user._id,
    });
    return created(res, 'Pitch created', pitch);
  } catch (error) {
    next(error);
  }
};

exports.getSchedule = async (req, res, next) => {
  try {
    const { pitchId } = req.params;
    const { date } = req.query;

    if (!date) return badRequest(res, 'Date query parameter is required');

    const pitch = await Pitch.findById(pitchId);
    if (!pitch) return notFound(res, 'Pitch not found');

    const bookings = await Booking.find({
      pitchId,
      date,
      status: { $nin: ['Cancelled'] },
    });

    const bookedTimes = new Set(bookings.map((b) => b.startTime));
    const slots = [];

    for (let hour = pitch.workingHoursStart; hour < pitch.workingHoursEnd; hour++) {
      const time = `${String(hour).padStart(2, '0')}:00`;
      slots.push({
        time,
        available: !bookedTimes.has(time),
      });
    }

    return success(res, 'Schedule retrieved', slots);
  } catch (error) {
    next(error);
  }
};
