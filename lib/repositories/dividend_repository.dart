import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/dividend_record.dart';

class DividendRepository {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://dividend-stocks-production.up.railway.app';

  Future<List<DividendRecord>> getDividends(String symbol) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dividends-panphor?symbol=$symbol'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> dividends = data['dividends'];
      return dividends.map((json) => DividendRecord.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load dividends');
    }
  }

  Future<List<DividendRecord>> getDividendsPanphor(String symbol, {int force = 0}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dividends-panphor?symbol=$symbol&force=$force'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> dividends = data['dividends'];
      return dividends.map((json) => DividendRecord.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load dividends from Panphor');
    }
  }

  Future<Map<String, dynamic>> getDividendsSummary({String? year}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dividends-summary${year != null ? '?year=$year' : ''}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load dividends summary');
    }
  }

  Future<List<DividendRecord>> getUpcomingDividends() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dividends/soon'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> dividends = data['soon'];
      return dividends.map((json) => DividendRecord.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load upcoming dividends');
    }
  }
} 