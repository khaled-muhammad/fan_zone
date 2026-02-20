const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const morgan = require('morgan');
const connectDB = require('./config/db');
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: '*' } });

app.use(express.json());
app.use(require('cors')());
app.use(morgan('dev'));

connectDB();

app.use('/api/auth', require('./routes/auth'));
app.use('/api/users', require('./routes/users'));
app.use('/api/pitches', require('./routes/pitches'));
app.use('/api/bookings', require('./routes/bookings'));
app.use('/api/teams', require('./routes/teams'));
app.use('/api/leagues', require('./routes/leagues'));
app.use('/api/messages', require('./routes/messages'));

require('./socket/chat')(io);
require('./services/reminderService');

app.use(require('./middleware/errorHandler'));

app.set('io', io);

const PORT = process.env.PORT || 5000;
const IP = process.env.IP || 'localhost';
server.listen(PORT, IP, () => console.log(`Server running on http://${IP}:${PORT}`));

module.exports = { app, io };
