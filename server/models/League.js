const mongoose = require('mongoose');

const matchSchema = new mongoose.Schema({
  homeTeam: { type: mongoose.Schema.Types.ObjectId, ref: 'Team' },
  awayTeam: { type: mongoose.Schema.Types.ObjectId, ref: 'Team' },
  homeScore: { type: Number, default: 0 },
  awayScore: { type: Number, default: 0 },
  played: { type: Boolean, default: false },
  date: Date,
});

const standingSchema = new mongoose.Schema({
  team: { type: mongoose.Schema.Types.ObjectId, ref: 'Team' },
  played: { type: Number, default: 0 },
  won: { type: Number, default: 0 },
  drawn: { type: Number, default: 0 },
  lost: { type: Number, default: 0 },
  goalsFor: { type: Number, default: 0 },
  goalsAgainst: { type: Number, default: 0 },
  points: { type: Number, default: 0 },
});

const leagueSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'League name is required'],
    trim: true,
  },
  pitchId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Pitch',
  },
  startDate: {
    type: Date,
    required: true,
  },
  maxTeams: {
    type: Number,
    default: 8,
  },
  teams: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Team',
  }],
  matches: [matchSchema],
  standings: [standingSchema],
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('League', leagueSchema);
