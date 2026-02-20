# FAN ZONE

Soccer Pitch Booking & Social Platform — a cross-platform mobile app built with Flutter and a Node.js Express backend.

Players can discover pitches, book time slots with zero double-booking risk, check in via QR code, build teams, chat in real time, and compete in leagues. Pitch owners get a dedicated dashboard to manage their venues and verify bookings.

---

## Tech Stack

### Mobile (Flutter)

| Concern | Library |
|---|---|
| State / DI / Routing | GetX |
| HTTP | Dio |
| Real-time chat | socket_io_client |
| QR generation | qr_flutter |
| QR scanning | mobile_scanner |
| Maps | google_maps_flutter |
| Secure storage | flutter_secure_storage |
| Deep links / URLs | url_launcher |
| Image caching | cached_network_image |
| Dates | intl |
| Loading skeletons | shimmer |

### Backend (Node.js)

| Concern | Library |
|---|---|
| Framework | Express |
| Database / ODM | MongoDB + Mongoose |
| Auth | JWT + bcryptjs |
| Real-time | Socket.io |
| Scheduling | node-cron |
| Validation | express-validator |
| Logging | morgan |

---

## Features

### Player Mode

- Register / login with JWT auth
- Browse available pitches with details, pricing, and Google Maps link
- Book time slots on a visual red/green schedule grid
- Receive a unique QR code per booking
- View and cancel upcoming bookings
- Automatic player leveling (Bronze → Silver → Gold) based on matches played
- Create or join teams (up to max capacity)
- Real-time team chat via Socket.io
- Browse leagues, standings, and match results
- Profile with player stats (goals, assists, matches)
- Dark / light theme toggle

### Owner Mode

- Dedicated owner dashboard with live stats (pitches, bookings, check-ins)
- Create, edit, and manage pitches (price, hours, images, Google Maps URL)
- View bookings per pitch with status filtering
- Scan player QR codes to verify check-in
- Mark bookings as completed (triggers player level recalculation)
- Owner-specific profile with business stats

### Automation

- **No double booking** — unique compound index on `(pitchId + date + startTime)`
- **QR verification** — UUID token generated per booking, validated on scan
- **Player leveling** — auto-calculated when booking completes (≥30 matches → Gold, ≥10 → Silver)
- **Reminders** — cron job checks for upcoming bookings every 10 minutes (FCM-ready)

---

## Project Structure

```
fan_zone/
├── lib/
│   ├── core/
│   │   ├── constants/       # API endpoints, colors
│   │   ├── network/         # Dio client, exceptions
│   │   ├── routes/          # Route names and GetPage definitions
│   │   ├── theme/           # Dark and light ThemeData
│   │   └── utils/           # Secure storage service
│   ├── features/
│   │   ├── auth/            # Login, register, JWT handling
│   │   ├── pitches/         # Pitch listing and details
│   │   ├── booking/         # Schedule grid, booking flow
│   │   ├── qr/              # QR code display and scanner
│   │   ├── profile/         # Player / owner profile
│   │   ├── teams/           # Team CRUD, roster
│   │   ├── chat/            # Real-time team chat
│   │   ├── leagues/         # League listing, standings, matches
│   │   └── owner/           # Owner dashboard, pitch management
│   ├── shared/
│   │   ├── services/        # Theme service
│   │   └── widgets/         # Buttons, text fields, loading, error
│   └── main.dart
├── server/
│   ├── config/              # DB connection
│   ├── controllers/         # Route handlers
│   ├── middleware/           # Auth, error handling
│   ├── models/              # Mongoose schemas
│   ├── routes/              # Express route definitions
│   ├── seed/                # Demo data seeder
│   ├── services/            # Reminder cron service
│   ├── socket/              # Socket.io chat handler
│   ├── utils/               # Response helpers
│   └── server.js            # Entry point
├── assets/
│   └── app_icon.png
└── pubspec.yaml
```

---

## Getting Started

### Prerequisites

- Flutter SDK (stable, ≥ 3.10)
- Node.js (≥ 18)
- MongoDB Atlas cluster (or local MongoDB)
- Android Studio / Xcode for emulators

### 1. Clone

```bash
git clone <repo-url>
cd fan_zone
```

### 2. Backend Setup

```bash
cd server
npm install
```

Create a `.env` file in `server/`:

```
PORT=4000
IP=0.0.0.0
MONGODB_URI=mongodb+srv://<user>:<password>@<cluster>.mongodb.net/<db>
JWT_SECRET=your_secret_here
```

Seed demo data and start:

```bash
npm run seed
npm run dev
```

The API will be running at `http://<IP>:<PORT>`.

### 3. Flutter Setup

From the project root:

```bash
flutter pub get
```

Update the base URL in `lib/core/constants/api_constants.dart` to point to your backend:

```dart
static const String baseUrl = 'http://<YOUR_IP>:4000/api';
```

### 4. Run

```bash
flutter run
```

### Optional: Google Maps

To enable the map preview on pitch details, add your Google Maps API key:

- **Android**: `android/app/src/main/AndroidManifest.xml` → `com.google.android.geo.API_KEY`
- **iOS**: `ios/Runner/AppDelegate.swift` → `GMSServices.provideAPIKey`

Then set the flag in `lib/core/constants/api_constants.dart`:

```dart
static const bool googleMapsEnabled = true;
```

---

## API Endpoints

| Group | Base Path | Key Routes |
|---|---|---|
| Auth | `/api/auth` | `POST /register`, `POST /login` |
| Users | `/api/users` | `GET /me`, `PATCH /me`, `PATCH /me/stats` |
| Pitches | `/api/pitches` | `GET /`, `GET /:id`, `GET /:id/schedule`, `POST /`, `PATCH /:id`, `GET /mine` |
| Bookings | `/api/bookings` | `POST /`, `GET /my`, `POST /verify`, `GET /owner/stats`, `GET /owner/today`, `GET /pitch/:pitchId` |
| Teams | `/api/teams` | `GET /`, `POST /`, `GET /:id`, `POST /:id/join`, `POST /:id/leave` |
| Leagues | `/api/leagues` | `GET /`, `GET /:id`, `POST /:id/register` |
| Messages | `/api/messages` | `GET /:teamId`, `POST /` |

---

## Demo Accounts

After running `npm run seed`, a demo pitch owner and pitch are created:

- **Pitch**: Porto El-Seyouf, Alexandria — 400 EGP/hr

Register new player or owner accounts through the app to explore both modes.

---

## License

Private — all rights reserved.
