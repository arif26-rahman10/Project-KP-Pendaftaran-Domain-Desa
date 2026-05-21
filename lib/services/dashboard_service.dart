import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_helper.dart';

class DashboardService {
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse(ApiConfig.url(ApiConfig.adminDashboard)),
      headers: await ApiHelper.headers(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['data'] ?? {};
    } else {
      throw Exception(data['message'] ?? 'Gagal memuat dashboard');
    }
  }
}
