const mongoose = require('mongoose');

const teamSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Team name is required'],
    trim: true,
    unique: true,
  },
  captainId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  players: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  }],
  maxPlayers: {
    type: Number,
    default: 10,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

teamSchema.virtual('isComplete').get(function () {
  return this.players.length >= this.maxPlayers;
});

teamSchema.set('toJSON', { virtuals: true });
teamSchema.set('toObject', { virtuals: true });

module.exports = mongoose.model('Team', teamSchema);
