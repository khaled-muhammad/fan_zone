const errorHandler = (err, req, res, _next) => {
  console.error(err.stack);

  if (err.name === 'ValidationError') {
    const messages = Object.values(err.errors).map((e) => e.message);
    return res.status(400).json({ success: false, message: messages.join(', ') });
  }

  if (err.code === 11000) {
    const field = Object.keys(err.keyValue).join(', ');
    return res.status(409).json({ success: false, message: `Duplicate value for: ${field}` });
  }

  if (err.name === 'CastError') {
    return res.status(400).json({ success: false, message: 'Invalid ID format' });
  }

  return res.status(err.statusCode || 500).json({
    success: false,
    message: err.message || 'Internal server error',
  });
};

module.exports = errorHandler;
