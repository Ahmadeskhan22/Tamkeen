// lib/constants/api_config.dart

class ApiConfig {
  // ─── Base URL ────────────────────────────────────────────────────────────
  // Android Emulator  → http://10.0.2.2:5000
  // iOS Simulator     → http://localhost:5000
  // Real Device (WiFi)→ http://192.168.X.X:5000  ← change to your LAN IP
  // Production        → https://your-domain.com
  //static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const String baseUrl = 'http://localhost:3000/api';
  // ─── API Endpoints ────────────────────────────────────────────────────────
  static const String health = '/api/health';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String updateProfile = '/auth/update-profile';
  static const String updatePassword = '/auth/update-password';

  // Requests  (all request types go to /api/requests — differentiated by `type`)
  static const String requests = '/requests';
  static const String myRequests = '/requests/my';

  // Notifications
  static const String notifications = '/notifications';
  static const String readAll = '/notifications/read-all';

  // Students / Volunteers / Donors
  static const String students = '/students';
  static const String myStudent = '/students/me';
  static const String volunteers = '/volunteers';
  static const String donors = '/donors';

  // Admin
  static const String adminDashboard = '/admin/dashboard';

  // ─── Storage keys ─────────────────────────────────────────────────────────
  static const String tokenKey = 'hopesteps_token';
  static const String userKey = 'hopesteps_user';

  // ─── Timeouts ─────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
