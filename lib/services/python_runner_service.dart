import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/code_execution_model.dart';

class PythonRunnerService {
  static const String _defaultEndpoint = 'https://ce.judge0.com/submissions?wait=true';
  static const int _pythonLanguageId = 100; // Python 3.12.5

  /// Executes Python code using the remote sandboxed CPython 3 runner with robust error handling
  Future<CodeExecutionResult> executePython({
    required String sourceCode,
    String stdin = '',
    String? customEndpoint,
    String? customApiKey,
  }) async {
    final endpoint = customEndpoint ?? _defaultEndpoint;

    if (sourceCode.trim().isEmpty) {
      return CodeExecutionResult.error('No code provided to execute.');
    }

    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (customApiKey != null && customApiKey.isNotEmpty) {
        headers['X-RapidAPI-Key'] = customApiKey;
      }

      final payload = jsonEncode({
        'source_code': sourceCode,
        'stdin': stdin,
        'language_id': _pythonLanguageId,
        'cpu_time_limit': 5,
        'wall_time_limit': 10,
        'memory_limit': 128000,
      });

      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: headers,
            body: payload,
          )
          .timeout(const Duration(seconds: 22));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return CodeExecutionResult.fromJson(data);
      } else if (response.statusCode == 429) {
        return CodeExecutionResult.error(
          'HTTP 429: Public execution rate limit reached.\nPlease wait 5-10 seconds before running again, or configure a custom runner.',
        );
      } else {
        return CodeExecutionResult.error(
          'Execution Engine Returned HTTP ${response.statusCode}\nDetails: ${response.body}',
        );
      }
    } on TimeoutException {
      return CodeExecutionResult.error(
        'Execution Timed Out (20s limit exceeded).\nPossible Causes:\n• Infinite loop (e.g. while True without break)\n• Heavy recursive call stack without memoization\n• Remote sandbox queue delay',
      );
    } on SocketException {
      return CodeExecutionResult.error(
        'Network Offline / Unreachable.\nPlease verify your internet connection to run code through the cloud sandbox.',
      );
    } catch (e) {
      // Secondary fallback attempt to Python 3.8 if default endpoint
      if (endpoint == _defaultEndpoint) {
        try {
          final fallbackPayload = jsonEncode({
            'source_code': sourceCode,
            'stdin': stdin,
            'language_id': 71,
          });

          final fbResponse = await http
              .post(
                Uri.parse(_defaultEndpoint),
                headers: {'Content-Type': 'application/json'},
                body: fallbackPayload,
              )
              .timeout(const Duration(seconds: 15));

          if (fbResponse.statusCode == 200 || fbResponse.statusCode == 201) {
            final Map<String, dynamic> fbData = jsonDecode(fbResponse.body);
            return CodeExecutionResult.fromJson(fbData);
          }
        } catch (_) {}
      }

      return CodeExecutionResult.error(
        'Sandbox Runner Error: ${e.toString()}\nPlease ensure valid syntax or retry in a moment.',
      );
    }
  }
}
