# student_support_app

HopeSteps – a humanitarian Flutter app to support underprivileged school students.

## Running the Flutter app

Make sure you have Flutter installed, then from the project root:

```bash
flutter pub get
flutter run
```

## Backend (Node.js) API

This project includes a simple Node.js/Express backend under `backend/` that the
Flutter UI uses to submit student requests (أدوات، زي، دروس، وجبات، دعم نفسي).

### Prerequisites

- Node.js (v16+ recommended)
- npm

### Install backend dependencies

From the project root:

```bash
cd backend
npm install
```

### Run the backend

```bash
cd backend
npm run dev      # or: npm start
```

By default the backend listens on `http://localhost:3000`.

For Android emulator, the Flutter app is configured to talk to
`http://10.0.2.2:3000` (see `lib/constants/api_config.dart`). Adjust this file
if you run on a different device or port.

### Main endpoints

- `POST /api/requests/supplies` – طلب أدوات مدرسية
- `POST /api/requests/meals` – طلب وجبات مدرسية
- `POST /api/requests/tutoring` – طلب دروس تطوعية
- `POST /api/requests/uniform` – طلب زي مدرسي
- `POST /api/requests/support` – طلب دعم نفسي
- `GET  /api/requests` – عرض جميع الطلبات (تجريبي، تخزين في الذاكرة فقط)
