import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService {
  static const String keyFullName = 'full_name';
  static const String keyUsername = 'username';
  static const String keyEmail = 'email';
  static const String keyPhone = 'phone';
  static const String keyPassword = 'password';

  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyRememberMe = 'remember_me';

  // Informasi Instansi
  static const String keyNamaDesa = 'nama_desa';
  static const String keyNamaKepalaDesa = 'nama_kepala_desa';
  static const String keyNipKepalaDesa = 'nip_kepala_desa';
  static const String keyNoHpKepalaDesa = 'no_hp_kepala_desa';
  static const String keyAlamatKantorDesa = 'alamat_kantor_desa';

  static Future<void> saveRegisteredUser({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyFullName, fullName);
    await prefs.setString(keyUsername, username);
    await prefs.setString(keyEmail, email);
    await prefs.setString(keyPhone, phone);
    await prefs.setString(keyPassword, password);
  }

  static Future<Map<String, String?>> getRegisteredUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'fullName': prefs.getString(keyFullName),
      'username': prefs.getString(keyUsername),
      'email': prefs.getString(keyEmail),
      'phone': prefs.getString(keyPhone),
      'password': prefs.getString(keyPassword),
    };
  }

  static Future<bool> hasRegisteredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(keyUsername);
    final password = prefs.getString(keyPassword);
    return username != null && password != null;
  }

  static Future<bool> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final savedUsername = prefs.getString(keyUsername);
    final savedPassword = prefs.getString(keyPassword);

    if (savedUsername == username && savedPassword == password) {
      await prefs.setBool(keyIsLoggedIn, true);
      await prefs.setBool(keyRememberMe, rememberMe);
      return true;
    }

    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLoggedIn, false);
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

  // =========================
  // INFORMASI INSTANSI
  // =========================

  static Future<void> saveInstitutionInfo({
    required String namaDesa,
    required String namaKepalaDesa,
    required String nipKepalaDesa,
    required String noHpKepalaDesa,
    required String alamatKantorDesa,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyNamaDesa, namaDesa);
    await prefs.setString(keyNamaKepalaDesa, namaKepalaDesa);
    await prefs.setString(keyNipKepalaDesa, nipKepalaDesa);
    await prefs.setString(keyNoHpKepalaDesa, noHpKepalaDesa);
    await prefs.setString(keyAlamatKantorDesa, alamatKantorDesa);
  }

  static Future<Map<String, String>> getInstitutionInfo() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'namaDesa': prefs.getString(keyNamaDesa) ?? 'Teluk Lancar',
      'namaKepalaDesa': prefs.getString(keyNamaKepalaDesa) ?? 'Arif Rahman',
      'nipKepalaDesa': prefs.getString(keyNipKepalaDesa) ?? '14039233232005',
      'noHpKepalaDesa': prefs.getString(keyNoHpKepalaDesa) ?? '+628221090876',
      'alamatKantorDesa':
          prefs.getString(keyAlamatKantorDesa) ?? 'Jl. Kelapapati Tengah',
    };
  }
}
