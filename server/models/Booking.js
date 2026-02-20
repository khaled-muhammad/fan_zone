const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  pitchId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Pitch',
    required: true,
  },
  date: {
    type: String,
    required: [true, 'Date is required'],
  },
  startTime: {
    type: String,
    required: [true, 'Start time is required'],
  },
  endTime: {
    type: String,
    required: [true, 'End time is required'],
  },
  status: {
    type: String,
    enum: ['Pending', 'Reserved', 'Checked-In', 'Completed', 'Cancelled'],
    default: 'Reserved',
  },
  paymentMethod: {
    type: String,
    default: 'Cash',
  },
  qrCodeToken: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

bookingSchema.index({ pitchId: 1, date: 1, startTime: 1 }, { unique: true });

module.exports = mongoose.model('Booking', bookingSchema);
