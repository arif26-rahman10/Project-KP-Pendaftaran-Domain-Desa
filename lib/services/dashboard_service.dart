import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class DashboardService {
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse(ApiConfig.url(ApiConfig.adminDashboard)),
    );

    final data = jsonDecode(response.body);

    return data['data'];
  }
}
