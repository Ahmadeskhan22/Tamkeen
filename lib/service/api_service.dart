// lib/service/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_config.dart';

/// Global exception thrown on any non-2xx response.
class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, {this.statusCode = 0});

  /// Arabic-friendly message shown to the user
  String get userMessage {
    switch (statusCode) {
      case 400:
        return message; // validation — show as-is (already Arabic from backend)
      case 401:
        return 'انتهت الجلسة. يرجى تسجيل الدخول مجدداً';
      case 403:
        return 'ليس لديك صلاحية لهذا الإجراء';
      case 404:
        return 'البيانات المطلوبة غير موجودة';
      case 422:
        return message;
      default:
        if (statusCode >= 500) return 'خطأ في الخادم، حاول مرة أخرى لاحقاً';
        if (message.contains('SocketException') ||
            message.contains('connection')) {
          return 'تحقق من اتصالك بالإنترنت';
        }
        return message;
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  // ─── Token helpers ───────────────────────────────────────────────────────

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConfig.tokenKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConfig.tokenKey, token);
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConfig.userKey, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(ApiConfig.userKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.tokenKey);
    await prefs.remove(ApiConfig.userKey);
  }

  // ─── Header builder ───────────────────────────────────────────────────────

  static Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (withAuth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // ─── URI builder ──────────────────────────────────────────────────────────

  static Uri _buildUri(String path, {Map<String, String>? queryParams}) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('${ApiConfig.baseUrl}$normalizedPath');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  // ─── Response handler ─────────────────────────────────────────────────────

  static dynamic _handleResponse(http.Response response) {
    final body = utf8.decode(response.bodyBytes);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body.isEmpty) return <String, dynamic>{};
      return jsonDecode(body);
    }

    String message = 'حدث خطأ غير متوقع';
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      message = json['message'] ?? json['error'] ?? message;
    } catch (_) {}

    throw ApiException(message, statusCode: response.statusCode);
  }

  // ─── HTTP verbs ───────────────────────────────────────────────────────────

  static Future<dynamic> get(
    String path, {
    bool withAuth = true,
    Map<String, String>? queryParams,
  }) async {
    try {
      final response = await http
          .get(
            _buildUri(path, queryParams: queryParams),
            headers: await _headers(withAuth: withAuth),
          )
          .timeout(ApiConfig.receiveTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('لا يوجد اتصال بالإنترنت');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  static Future<dynamic> post(
    String path,
    Map<String, dynamic> body, {
    bool withAuth = true,
  }) async {
    try {
      final response = await http
          .post(
            _buildUri(path),
            headers: await _headers(withAuth: withAuth),
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.connectTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('لا يوجد اتصال بالإنترنت');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  static Future<dynamic> put(
    String path,
    Map<String, dynamic> body, {
    bool withAuth = true,
  }) async {
    try {
      final response = await http
          .put(
            _buildUri(path),
            headers: await _headers(withAuth: withAuth),
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.connectTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('لا يوجد اتصال بالإنترنت');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  static Future<dynamic> delete(
    String path, {
    bool withAuth = true,
  }) async {
    try {
      final response = await http
          .delete(
            _buildUri(path),
            headers: await _headers(withAuth: withAuth),
          )
          .timeout(ApiConfig.connectTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException('لا يوجد اتصال بالإنترنت');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  // ─── Health check ─────────────────────────────────────────────────────────

  static Future<bool> checkHealth() async {
    try {
      final data = await get(ApiConfig.health, withAuth: false);
      return data['status'] == 'success';
    } catch (_) {
      return false;
    }
  }
}
