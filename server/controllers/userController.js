const User = require('../models/User');
const { success, notFound, badRequest } = require('../utils/response');

exports.getMe = async (req, res, next) => {
  try {
    const user = await User.findById(req.user._id);
    if (!user) return notFound(res, 'User not found');
    return success(res, 'Profile retrieved', user);
  } catch (error) {
    next(error);
  }
};

exports.updateMe = async (req, res, next) => {
  try {
    const allowedFields = ['fullName', 'phone', 'position'];
    const updates = {};
    for (const field of allowedFields) {
      if (req.body[field] !== undefined) updates[field] = req.body[field];
    }

    if (Object.keys(updates).length === 0) {
      return badRequest(res, 'No valid fields to update');
    }

    const user = await User.findByIdAndUpdate(req.user._id, updates, {
      new: true,
      runValidators: true,
    });

    return success(res, 'Profile updated', user);
  } catch (error) {
    next(error);
  }
};

exports.getUserStats = async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id).select(
      'fullName position goals assists matchesPlayed level'
    );
    if (!user) return notFound(res, 'User not found');
    return success(res, 'User stats retrieved', user);
  } catch (error) {
    next(error);
  }
};
