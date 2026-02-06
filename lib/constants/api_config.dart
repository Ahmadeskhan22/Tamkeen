class ApiConfig {
  /// Base URL of the backend API.
  ///
  /// On Android emulator, 10.0.2.2 points to the host machine (where Node runs).
  /// You can change this to 'http://localhost:3000' when running on web/desktop.
  static const String baseUrl = 'http://10.0.2.2:3000';
}
