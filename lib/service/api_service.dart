import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_config.dart';

class ApiService {
  static Uri _buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${ApiConfig.baseUrl}$normalizedPath');
  }

  /// Generic POST helper. Throws an [Exception] if the response is not 2xx.
  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = _buildUri(path);

    final response = await http.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return <String, dynamic>{};
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      'Request to $path failed with status ${response.statusCode}',
    );
  }
}
