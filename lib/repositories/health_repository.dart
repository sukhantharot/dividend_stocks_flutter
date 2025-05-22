import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/dividend_record.dart';

class HealthRepository {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://dividend-stocks-production.up.railway.app';
  final int maxRetries = 8;
  final Duration retryDelay = const Duration(seconds: 10);

  Future<Map<String, dynamic>> checkHealth() async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/dividends/soon'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return {
            'status': 'healthy',
            'timestamp': data['timestamp'],
            'today': data['today'],
            'upcoming_dividends': data['soon'],
          };
        } else {
          throw Exception('Service returned status code ${response.statusCode}');
        }
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          return {
            'status': 'unhealthy',
            'error': e.toString(),
            'attempts': attempts,
            'last_attempt': DateTime.now().toIso8601String(),
          };
        }
        await Future.delayed(retryDelay);
      }
    }
    return {
      'status': 'unhealthy',
      'error': 'Max retries exceeded',
      'attempts': attempts,
      'last_attempt': DateTime.now().toIso8601String(),
    };
  }
} 