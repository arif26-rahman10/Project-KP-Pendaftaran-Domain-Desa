import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://localhost:8000/api";

  static Map<String, String> _headers() {
    return {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    };
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: _headers(),
      body: {"username": username, "password": password},
    );

    return jsonDecode(response.body);
  }

  // --- METHOD REGISTER ---
  static Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: _headers(),
      body: {
        "name": name,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password,
        "confirmPassword": password,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      String errorMsg = data['message'] ?? 'Registrasi gagal';

      if (data['errors'] != null) {
        if (data['errors']['username'] != null) {
          errorMsg = data['errors']['username'][0];
        } else if (data['errors']['email'] != null) {
          errorMsg = data['errors']['email'][0];
        } else if (data['errors']['password'] != null) {
          errorMsg = data['errors']['password'][0];
        } else if (data['errors']['confirmPassword'] != null) {
          errorMsg = data['errors']['confirmPassword'][0];
        }
      }

      throw Exception(errorMsg);
    }

    return data;
  }
}
