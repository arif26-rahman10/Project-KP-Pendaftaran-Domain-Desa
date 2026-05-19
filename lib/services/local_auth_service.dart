import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService {
  static const String keyIdUser = 'id_user';
  static const String keyFullName = 'full_name';
  static const String keyUsername = 'username';
  static const String keyEmail = 'email';
  static const String keyPhone = 'phone';
  static const String keyRole = 'role';

  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyRememberMe = 'remember_me';

  static Future<void> saveRegisteredUser({
    required int idUser,
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(keyIdUser, idUser);
    await prefs.setString(keyFullName, fullName);
    await prefs.setString(keyUsername, username);
    await prefs.setString(keyEmail, email);
    await prefs.setString(keyPhone, phone);
    await prefs.setString(keyRole, role);
  }

  static Future<Map<String, dynamic>> getRegisteredUser() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'id_user': prefs.getInt(keyIdUser) ?? 0,
      'fullName': prefs.getString(keyFullName) ?? '',
      'username': prefs.getString(keyUsername) ?? '',
      'email': prefs.getString(keyEmail) ?? '',
      'phone': prefs.getString(keyPhone) ?? '',
      'role': prefs.getString(keyRole) ?? '',
    };
  }

  static Future<void> setLoginStatus({required bool rememberMe}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(keyIsLoggedIn, true);
    await prefs.setBool(keyRememberMe, rememberMe);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    final isLoggedIn = prefs.getBool(keyIsLoggedIn) ?? false;
    final rememberMe = prefs.getBool(keyRememberMe) ?? false;

    return isLoggedIn && rememberMe;
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(keyRememberMe) ?? false;
  }

  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(keyRememberMe, value);
  }
}
