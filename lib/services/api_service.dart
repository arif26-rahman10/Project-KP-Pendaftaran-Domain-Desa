import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';
import 'registration_data.dart';

class ApiService {
  static Map<String, String> _headers() {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}${ApiConfig.login}");

      final response = await http.post(
        url,
        headers: _headers(),
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      print("LOGIN URL: $url");
      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      if (response.body.isEmpty) {
        throw Exception("Response kosong dari server");
      }

      dynamic decoded;

      try {
        decoded = jsonDecode(response.body);
      } catch (e) {
        throw Exception("Response server bukan JSON");
      }

      if (decoded == null || decoded is! Map) {
        throw Exception("Format response login tidak valid");
      }

      final data = Map<String, dynamic>.from(decoded);

      if (response.statusCode != 200) {
        throw Exception(data['message']?.toString() ?? "Login gagal");
      }

      final userRaw = data['user'];

      if (userRaw == null || userRaw is! Map) {
        throw Exception("Data user tidak ditemukan dari server");
      }

      final user = Map<String, dynamic>.from(userRaw);

      final prefs = await SharedPreferences.getInstance();

      final token = data['token']?.toString() ?? '';
      if (token.isNotEmpty) {
        await prefs.setString("token", token);
      }

      final idUser = int.tryParse(user['id_user'].toString()) ?? 0;
      await prefs.setInt("id_user", idUser);

      return {
        "success": data['success'] == true,
        "message": data['message']?.toString() ?? "",
        "role": data['role']?.toString() ?? "",
        "user": {
          "id_user": idUser,
          "name": user['name']?.toString() ?? "",
          "username": user['username']?.toString() ?? "",
          "email": user['email']?.toString() ?? "",
          "no_hp": user['no_hp']?.toString() ?? "",
          "desa": user['desa'],
        },
      };
    } catch (e, s) {
      print("LOGIN ERROR DETAIL: $e");
      print("STACKTRACE: $s");
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
      throw Exception(data['message']?.toString() ?? 'Registrasi gagal');
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
      headers: _headers(),
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

    print("UPDATE PROFILE STATUS: ${response.statusCode}");
    print("UPDATE PROFILE BODY: ${response.body}");

    if (response.body.isEmpty) {
      throw Exception("Response update profile kosong");
    }

    final data = Map<String, dynamic>.from(jsonDecode(response.body));

    if (response.statusCode != 200) {
      throw Exception(data['message']?.toString() ?? "Gagal memperbarui profil");
    }

    return data;
  }

  // ================= GET INSTANSI =================
  static Future<Map<String, dynamic>> getInstansi({
    required int idUser,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/instansi"),
      headers: _headers(),
      body: jsonEncode({
        "id_user": idUser,
      }),
    );

    print("INSTANSI STATUS: ${response.statusCode}");
    print("INSTANSI BODY: ${response.body}");

    if (response.body.isEmpty) {
      throw Exception("Response instansi kosong");
    }

    final data = Map<String, dynamic>.from(jsonDecode(response.body));

    if (response.statusCode != 200) {
      throw Exception(data['message']?.toString() ?? "Gagal mengambil data instansi");
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

    final data = Map<String, dynamic>.from(jsonDecode(response.body));

    if (response.statusCode != 200) {
      throw Exception(data['message']?.toString() ?? "Gagal menyimpan data instansi");
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

      Future<void> addFile(String key, String? path, String? filename) async {
        if (path != null && path.isNotEmpty) {
          formData.files.add(
            MapEntry(
              key,
              await MultipartFile.fromFile(
                path,
                filename: filename ?? path.split('/').last,
              ),
            ),
          );
        }
      }

      await addFile(
        "surat_permohonan",
        data.filePaths['surat_permohonan'],
        data.suratPermohonan,
      );

      await addFile(
        "perda_pembentukan_desa",
        data.filePaths['perda_pembentukan_desa'],
        data.perdaPembentukanDesa,
      );

      await addFile(
        "surat_kuasa",
        data.filePaths['surat_kuasa'],
        data.suratKuasa,
      );

      await addFile(
        "surat_penunjukan_pejabat",
        data.filePaths['surat_penunjukan_pejabat'],
        data.suratPenunjukan,
      );

      await addFile(
        "ktp_asn_pejabat",
        data.filePaths['ktp_asn_pejabat'],
        data.ktpAsnPejabat,
      );

      final response = await dio.post(
        "${ApiConfig.baseUrl}/pengajuan/submit",
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
          },
        ),
      );

      print("SUBMIT STATUS: ${response.statusCode}");
      print("SUBMIT BODY: ${response.data}");

      if (response.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(response.data);
      }

      return {
        "success": true,
        "message": "Pengajuan berhasil dikirim",
      };
    } on DioException catch (e) {
      print("SUBMIT ERROR: ${e.response?.data}");
      throw Exception(
        e.response?.data?['message']?.toString() ?? "Gagal mengirim data",
      );
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}