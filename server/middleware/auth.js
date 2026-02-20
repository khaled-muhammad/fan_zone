const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { unauthorized } = require('../utils/response');

const protect = async (req, res, next) => {
  try {
    const header = req.headers.authorization;
    if (!header || !header.startsWith('Bearer ')) {
      return unauthorized(res, 'No token provided');
    }

    const token = header.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.id).select('-password');

    if (!user) return unauthorized(res, 'User not found');

    req.user = user;
    next();
  } catch (error) {
    return unauthorized(res, 'Invalid token');
  }
};

const authorize = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return unauthorized(res, 'Not authorized for this action');
    }
    next();
  };
};

module.exports = { protect, authorize };
