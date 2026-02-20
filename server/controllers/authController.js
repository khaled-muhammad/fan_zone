const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');
const User = require('../models/User');
const { success, created, badRequest, unauthorized } = require('../utils/response');

const generateToken = (id) =>
  jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '30d' });

exports.register = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return badRequest(res, errors.array().map((e) => e.msg).join(', '));
    }

    const { fullName, email, password, role, phone, position } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) return badRequest(res, 'Email already registered');

    const user = await User.create({ fullName, email, password, role, phone, position });
    const token = generateToken(user._id);

    return created(res, 'Registration successful', { user, token });
  } catch (error) {
    next(error);
  }
};

exports.login = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return badRequest(res, errors.array().map((e) => e.msg).join(', '));
    }

    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) return unauthorized(res, 'Invalid credentials');

    const isMatch = await user.comparePassword(password);
    if (!isMatch) return unauthorized(res, 'Invalid credentials');

    const token = generateToken(user._id);

    return success(res, 'Login successful', { user, token });
  } catch (error) {
    next(error);
  }
};
