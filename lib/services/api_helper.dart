import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static Future<Map<String, String>> headers({bool isJson = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    return {
      "Accept": "application/json",
      if (isJson) "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}
