import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class ApiConfig {
  // ✅ هذا هو الرابط الفعلي للسيرفر تبعك (لاحظ إنه بينتهي بـ .dev)
  static const String _renderUrl =
      'https://c32f123d-d954-4621-9d77-eac0252166b3-00-vgqwdfdy9utr.pike.replit.dev';
  static String get baseUrl {
    return _renderUrl;
  }

  // --- API Endpoints ---
  static const String health = '/api/health';
  static const String register =
      '/api/auth/register'; // تم إضافة السلاش في البداية لتوحيد الشكل
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String me = '/api/auth/me';
  static const String updateProfile = '/api/auth/update-profile';
  static const String updatePassword = '/api/auth/updatepassword';

  static const String requests = '/api/requests';
  static const String myRequests = '/api/requests/my';
  static const String notifications = '/api/notifications';

  static const String students = '/api/students';
  static const String myStudent = '/api/students/me';

  // Storage keys
  static const String tokenKey = 'hopesteps_token';
  static const String userKey = 'hopesteps_user';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
