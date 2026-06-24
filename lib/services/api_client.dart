import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vitalis_app/config/app_config.dart';
import 'package:vitalis_app/services/firebase_auth_service.dart';

class ApiCallResult {
  const ApiCallResult({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final Object? body;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiClient {
  ApiClient({
    FirebaseAuthService? authService,
    String? baseUrl,
    http.Client? httpClient,
  }) : _authService = authService ?? FirebaseAuthService(),
       _baseUrl = baseUrl ?? AppConfig.apiBaseUrl,
       _httpClient = httpClient ?? http.Client();

  final FirebaseAuthService _authService;
  final String _baseUrl;
  final http.Client _httpClient;

  Future<ApiCallResult> getAuthMe() {
    return _get('/api/auth/me');
  }

  Future<ApiCallResult> getUsersMe() {
    return _get('/api/users/me');
  }

  Future<ApiCallResult> _get(String path) async {
    final idToken = await _authService.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw StateError('Nenhum usuário autenticado no Firebase.');
    }

    final response = await _httpClient.get(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );

    return ApiCallResult(
      statusCode: response.statusCode,
      body: _decodeBody(response.body),
    );
  }

  Object? _decodeBody(String responseBody) {
    if (responseBody.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(responseBody);
    } on FormatException {
      return responseBody;
    }
  }
}
