const Message = require('../models/Message');
const { success, created } = require('../utils/response');

exports.getTeamMessages = async (req, res, next) => {
  try {
    const messages = await Message.find({ teamId: req.params.teamId })
      .populate('senderId', 'fullName')
      .sort({ createdAt: 1 });
    return success(res, 'Messages retrieved', messages);
  } catch (error) {
    next(error);
  }
};

exports.sendMessage = async (req, res, next) => {
  try {
    const { teamId, message } = req.body;
    const newMessage = await Message.create({
      teamId,
      senderId: req.user._id,
      message,
    });

    const populated = await newMessage.populate('senderId', 'fullName');

    const io = req.app.get('io');
    if (io) {
      io.to(`team_${teamId}`).emit('newMessage', populated);
    }

    return created(res, 'Message sent', populated);
  } catch (error) {
    next(error);
  }
};
