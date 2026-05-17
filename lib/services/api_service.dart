import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';
import 'api_helper.dart';
import 'registration_data.dart';

class ApiService {
  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}${ApiConfig.login}");

      final response = await http.post(
        url,
        headers: await ApiHelper.headers(),
        body: jsonEncode({"username": username, "password": password}),
      );

      print("LOGIN URL: $url");
      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      if (response.body.isEmpty) {
        throw Exception("Response kosong dari server");
      }

      final data = Map<String, dynamic>.from(jsonDecode(response.body));

      if (response.statusCode != 200) {
        throw Exception(data['message'] ?? "Login gagal");
      }

      final user = Map<String, dynamic>.from(data['user']);

      final prefs = await SharedPreferences.getInstance();

      final token = data['token']?.toString() ?? '';

      if (token.isNotEmpty) {
        await prefs.setString("token", token);
      }

      print("TOKEN TERSIMPAN: $token");

      final idUser = int.tryParse(user['id_user'].toString()) ?? 0;

      await prefs.setInt("id_user", idUser);

      return {
        "success": data['success'] == true,

        "message": data['message'] ?? "",

        "role": data['role'] ?? "",

        "user": {
          "id_user": idUser,

          "name": user['name'] ?? "",

          "username": user['username'] ?? "",

          "email": user['email'] ?? "",

          "no_hp": user['no_hp'] ?? "",

          "desa": user['desa'],
        },
      };
    } catch (e) {
      print("LOGIN ERROR: $e");
      rethrow;
    }
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

      headers: await ApiHelper.headers(),

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

    final data = Map<String, dynamic>.from(jsonDecode(response.body));

    if (response.statusCode != 201) {
      throw Exception(data['message'] ?? "Registrasi gagal");
    }
  }

  // ================= UPDATE PROFILE =================
  static Future<Map<String, dynamic>> updateProfile({
    required int idUser,
    required String name,
    required String email,
    required String noHp,
    String oldPassword = '',
    String newPassword = '',
    String confirmPassword = '',
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/profile/update"),

      headers: await ApiHelper.headers(),

      body: jsonEncode({
        "id_user": idUser,
        "name": name,
        "email": email,
        "no_hp": noHp,
        "old_password": oldPassword,
        "password": newPassword,
        "password_confirmation": confirmPassword,
      }),
    );

    final data = Map<String, dynamic>.from(jsonDecode(response.body));

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "Gagal update profile");
    }

    return data;
  }

  // ================= GET INSTANSI =================
  static Future<Map<String, dynamic>> getInstansi({required int idUser}) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/instansi"),

      headers: await ApiHelper.headers(),

      body: jsonEncode({"id_user": idUser}),
    );

    print("INSTANSI STATUS: ${response.statusCode}");

    print("INSTANSI BODY: ${response.body}");

    final data = Map<String, dynamic>.from(jsonDecode(response.body));

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "Gagal mengambil instansi");
    }

    return data;
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

      headers: await ApiHelper.headers(),

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

    final data = Map<String, dynamic>.from(jsonDecode(response.body));

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "Gagal update instansi");
    }

    return data;
  }

  // ================= SUBMIT PENDAFTARAN =================
  static Future<Map<String, dynamic>> submitPendaftaran({
    required RegistrationData data,
  }) async {
    try {
      final dio = Dio();

      FormData formData = FormData.fromMap({
        "nama_domain": data.namaDomain,

        "nama_desa": data.namaDesa,

        "telepon": data.telepon,

        "faksimili": data.faksimili,

        "alamat": data.alamat,

        "kode_pos": data.kodePos,

        "provinsi": data.provinsi,

        "kota_kabupaten": data.kotaKabupaten,

        "kecamatan": data.kecamatan,

        "desa_kelurahan": data.desaKelurahan,
      });

      final response = await dio.post(
        "${ApiConfig.baseUrl}/pengajuan/submit",

        data: formData,

        options: Options(headers: await ApiHelper.headers(isJson: false)),
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? "Gagal submit");
    }
  }
}
