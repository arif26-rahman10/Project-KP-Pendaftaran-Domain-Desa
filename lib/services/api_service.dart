import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {
  static Map<String, String> _headers() {
    return {"Accept": "application/json", "Content-Type": "application/json"};
  }

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}${ApiConfig.login}"),
      headers: _headers(),
      body: jsonEncode({"username": username, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Login gagal');
    }

    return data;
  }

  // ================= REGISTER =================
  static Future<void> register({
    required String name,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}${ApiConfig.register}"),
      headers: _headers(),
      body: jsonEncode({
        "name": name,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password,
        "confirmPassword": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(data['message'] ?? 'Registrasi gagal');
    }
  }
}
