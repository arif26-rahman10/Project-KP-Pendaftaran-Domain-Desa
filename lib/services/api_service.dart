import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      throw Exception(data['message']);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", data['token']);
    await prefs.setInt("id_user", data['user']['id_user']);

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

    print("REGISTER STATUS: ${response.statusCode}");
    print("REGISTER BODY: ${response.body}");

    if (response.body.isEmpty) {
      throw Exception("Response kosong");
    }

    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(data['message'] ?? 'Registrasi gagal');
    }
  }

  // ================= GET INSTANSI =================
  static Future<Map<String, dynamic>> getInstansi({required int idUser}) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/instansi"),
      headers: _headers(),
      body: jsonEncode({"id_user": idUser}),
    );

    print("INSTANSI STATUS: ${response.statusCode}");
    print("INSTANSI BODY: ${response.body}");

    if (response.body.isEmpty) {
      throw Exception("Response instansi kosong");
    }

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "Gagal mengambil data instansi");
    }

    return Map<String, dynamic>.from(data);
  }

  // ================= UPDATE INSTANSI =================
  static Future<Map<String, dynamic>> updateInstansi({
    required int idUser,
    required String namaDesa,
    required String namaKepalaDesa,
    required String nipKepalaDesa,
    required String noHpKepalaDesa,
    required String alamat,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/instansi/update"),
      headers: _headers(),
      body: jsonEncode({
        "id_user": idUser,
        "nama_desa": namaDesa,
        "nama_kepala_desa": namaKepalaDesa,
        "nip_kepala_desa": nipKepalaDesa,
        "no_hp_kepala_desa": noHpKepalaDesa,
        "alamat": alamat,
      }),
    );

    print("UPDATE INSTANSI STATUS: ${response.statusCode}");
    print("UPDATE INSTANSI BODY: ${response.body}");

    if (response.body.isEmpty) {
      throw Exception("Response update instansi kosong");
    }

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "Gagal menyimpan data instansi");
    }

    return Map<String, dynamic>.from(data);
  }
}