import '../services/api_service.dart';

class RegisterController {
  String? validate({
    required String name,
    required String username,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) {
    if (name.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return 'Semua field wajib diisi';
    }

    if (!email.contains("@")) {
      return 'Format email tidak valid';
    }

    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }

    if (password != confirmPassword) {
      return 'Konfirmasi password tidak sama';
    }

    return null;
  }

  Future<void> register({
    required String name,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    await ApiService.register(
      name: name,
      username: username,
      email: email,
      phone: phone,
      password: password,
    );
  }
}
