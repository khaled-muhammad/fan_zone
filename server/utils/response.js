const sendResponse = (res, statusCode, success, message, data = null) => {
  const response = { success, message };
  if (data !== null) response.data = data;
  return res.status(statusCode).json(response);
};

const success = (res, message, data = null, statusCode = 200) =>
  sendResponse(res, statusCode, true, message, data);

const created = (res, message, data = null) =>
  sendResponse(res, 201, true, message, data);

const badRequest = (res, message) =>
  sendResponse(res, 400, false, message);

const unauthorized = (res, message = 'Unauthorized') =>
  sendResponse(res, 401, false, message);

const notFound = (res, message = 'Resource not found') =>
  sendResponse(res, 404, false, message);

const conflict = (res, message) =>
  sendResponse(res, 409, false, message);

module.exports = { success, created, badRequest, unauthorized, notFound, conflict };
