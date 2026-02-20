const cron = require('node-cron');
const Booking = require('../models/Booking');

cron.schedule('*/10 * * * *', async () => {
  try {
    const now = new Date();
    const twoHoursLater = new Date(now.getTime() + 2 * 60 * 60 * 1000);

    const today = now.toISOString().split('T')[0];
    const currentHour = now.getHours();
    const reminderHour = twoHoursLater.getHours();

    const upcomingBookings = await Booking.find({
      date: today,
      status: 'Reserved',
    }).populate('userId', 'fullName email');

    for (const booking of upcomingBookings) {
      const bookingHour = parseInt(booking.startTime.split(':')[0], 10);
      if (bookingHour >= currentHour && bookingHour <= reminderHour) {
        console.log(
          `[REMINDER] Upcoming booking for ${booking.userId.fullName} ` +
          `at ${booking.startTime} on ${booking.date}`
        );
      }
    }
  } catch (error) {
    console.error('Reminder cron error:', error.message);
  }
});

console.log('Reminder service started (every 10 minutes)');
