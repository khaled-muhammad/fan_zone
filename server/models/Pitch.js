const mongoose = require('mongoose');

const pitchSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Pitch name is required'],
    trim: true,
  },
  locationName: {
    type: String,
    required: [true, 'Location name is required'],
    trim: true,
  },
  latitude: {
    type: Number,
    required: true,
  },
  longitude: {
    type: Number,
    required: true,
  },
  pricePerHour: {
    type: Number,
    required: [true, 'Price per hour is required'],
  },
  images: {
    type: [String],
    default: [],
  },
  workingHoursStart: {
    type: Number,
    required: true,
    default: 8,
  },
  workingHoursEnd: {
    type: Number,
    required: true,
    default: 24,
  },
  mapsUrl: {
    type: String,
    trim: true,
    default: '',
  },
  rating: {
    type: Number,
    default: 4.5,
    min: 0,
    max: 5,
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Pitch', pitchSchema);
