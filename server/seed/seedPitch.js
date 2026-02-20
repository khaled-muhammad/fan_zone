const mongoose = require('mongoose');
const User = require('../models/User');
const Pitch = require('../models/Pitch');
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env') });

async function seed() {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB');

    let owner = await User.findOne({ email: 'owner@fanzone.com' });
    if (!owner) {
      owner = await User.create({
        fullName: 'Pitch Owner',
        email: 'owner@fanzone.com',
        password: 'owner123',
        role: 'owner',
        phone: '+201234567890',
      });
      console.log('Demo owner created');
    }

    const existingPitch = await Pitch.findOne({ name: 'Porto El-Seyouf' });
    if (!existingPitch) {
      await Pitch.create({
        name: 'Porto El-Seyouf',
        locationName: 'Alexandria, Egypt',
        latitude: 31.245,
        longitude: 29.968,
        pricePerHour: 400,
        images: [
          'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?w=800',
          'https://images.unsplash.com/photo-1556056504-5c7696c4c28d?w=800',
        ],
        workingHoursStart: 8,
        workingHoursEnd: 24,
        rating: 4.5,
        createdBy: owner._id,
      });
      console.log('Demo pitch "Porto El-Seyouf" created');
    } else {
      console.log('Demo pitch already exists');
    }

    await mongoose.disconnect();
    console.log('Seed complete');
    process.exit(0);
  } catch (error) {
    console.error('Seed error:', error);
    process.exit(1);
  }
}

seed();
