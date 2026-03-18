// lib/auth/auth_service.dart

import '../constants/api_config.dart';
import '../models/user_model.dart';
import '../service/api_service.dart';

class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;
  AuthService._();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ─── Register ─────────────────────────────────────────────────────────────

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    final data = await ApiService.post(
      ApiConfig.register,
      {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      },
      withAuth: false,
    );
    await _saveSession(data as Map<String, dynamic>);
    return _currentUser!;
  }

  // ─── Login ────────────────────────────────────────────────────────────────

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final data = await ApiService.post(
      ApiConfig.login,
      {'email': email, 'password': password},
      withAuth: false,
    );
    await _saveSession(data as Map<String, dynamic>);
    return _currentUser!;
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> logout() async {
    try {
      await ApiService.post(ApiConfig.logout, {});
    } catch (_) {
      // Even if the server call fails, clear local session
    }
    await ApiService.clearSession();
    _currentUser = null;
  }

  // ─── Refresh current user ─────────────────────────────────────────────────

  Future<UserModel?> fetchMe() async {
    try {
      final data = await ApiService.get(ApiConfig.me);
      _currentUser = UserModel.fromJson(
        (data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
      );
      await ApiService.saveUser(_currentUser!.toJson());
      return _currentUser;
    } catch (_) {
      return null;
    }
  }

  // ─── Update profile ───────────────────────────────────────────────────────

  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    final data = await ApiService.put(ApiConfig.updateProfile, {
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (avatar != null) 'avatar': avatar,
    });
    _currentUser = UserModel.fromJson(
      (data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
    await ApiService.saveUser(_currentUser!.toJson());
    return _currentUser!;
  }

  // ─── Change password ──────────────────────────────────────────────────────

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final data = await ApiService.put(ApiConfig.updatePassword, {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
    // Backend sends back a new token
    final token = (data as Map<String, dynamic>)['token'] as String?;
    if (token != null) await ApiService.saveToken(token);
  }

  // ─── Restore session on app start ─────────────────────────────────────────

  Future<bool> restoreSession() async {
    final saved = await ApiService.getSavedUser();
    if (saved != null) _currentUser = UserModel.fromJson(saved);

    final token = await ApiService.getToken();
    if (token == null) return false;

    // Verify the token is still valid with the server
    final user = await fetchMe();
    return user != null;
  }

  // ─── Private helpers ──────────────────────────────────────────────────────

  Future<void> _saveSession(Map<String, dynamic> data) async {
    final token = data['token'] as String;
    await ApiService.saveToken(token);
    _currentUser = UserModel.fromJson(
      data['user'] as Map<String, dynamic>,
    );
    await ApiService.saveUser(_currentUser!.toJson());
  }
}
