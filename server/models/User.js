const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: [true, 'Full name is required'],
    trim: true,
  },
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    lowercase: true,
    trim: true,
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    minlength: 6,
  },
  role: {
    type: String,
    enum: ['player', 'owner', 'admin'],
    default: 'player',
  },
  phone: {
    type: String,
    trim: true,
  },
  position: {
    type: String,
    trim: true,
  },
  goals: {
    type: Number,
    default: 0,
  },
  assists: {
    type: Number,
    default: 0,
  },
  matchesPlayed: {
    type: Number,
    default: 0,
  },
  level: {
    type: String,
    enum: ['Bronze', 'Silver', 'Gold'],
    default: 'Bronze',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

userSchema.methods.comparePassword = async function (candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

userSchema.methods.calculateLevel = function () {
  if (this.matchesPlayed >= 30) this.level = 'Gold';
  else if (this.matchesPlayed >= 10) this.level = 'Silver';
  else this.level = 'Bronze';
  return this.level;
};

userSchema.set('toJSON', {
  transform: (_doc, ret) => {
    delete ret.password;
    return ret;
  },
});

module.exports = mongoose.model('User', userSchema);
