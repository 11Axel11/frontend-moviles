import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String path, [Map<String, String>? queryParameters]) {
    final base = AppConfig.apiBaseUrl.endsWith('/')
        ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1)
        : AppConfig.apiBaseUrl;
    return Uri.parse('$base$path').replace(queryParameters: queryParameters);
  }

  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final response = await _send(() => _client.get(_uri(path, queryParameters)));
    return _decode(response);
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final response = await _send(
      () => _client.post(
        _uri(path),
        headers: _jsonHeaders,
        body: body == null ? null : jsonEncode(body),
      ),
    );
    return _decode(response);
  }

  Future<dynamic> patch(String path, {Object? body}) async {
    final response = await _send(
      () => _client.patch(
        _uri(path),
        headers: _jsonHeaders,
        body: body == null ? null : jsonEncode(body),
      ),
    );
    return _decode(response);
  }

  Map<String, String> get _jsonHeaders => const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(const Duration(seconds: 15));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          _errorMessage(response),
          statusCode: response.statusCode,
        );
      }
      return response;
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        'No se pudo conectar con el servidor. Verifica la API y tu conexión.',
      );
    }
  }

  dynamic _decode(http.Response response) {
    if (response.body.trim().isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } catch (_) {
      throw const ApiException('El servidor devolvió una respuesta inválida.');
    }
  }

  String _errorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'];
        if (message is List) return message.join(', ');
        if (message is String && message.isNotEmpty) return message;
      }
    } catch (_) {
      // Usa el mensaje genérico cuando la respuesta no es JSON.
    }
    return 'La API respondió con el código ${response.statusCode}.';
  }

  void dispose() => _client.close();
}
