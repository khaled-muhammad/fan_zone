module.exports = (io) => {
  io.on('connection', (socket) => {
    console.log(`Socket connected: ${socket.id}`);

    socket.on('joinTeam', (teamId) => {
      socket.join(`team_${teamId}`);
      console.log(`Socket ${socket.id} joined team_${teamId}`);
    });

    socket.on('leaveTeam', (teamId) => {
      socket.leave(`team_${teamId}`);
      console.log(`Socket ${socket.id} left team_${teamId}`);
    });

    socket.on('sendMessage', (data) => {
      io.to(`team_${data.teamId}`).emit('newMessage', data);
    });

    socket.on('disconnect', () => {
      console.log(`Socket disconnected: ${socket.id}`);
    });
  });
};
