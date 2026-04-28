import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'api_config.dart';
import 'registration_data.dart';

class ApiService {
  static Map<String, String> _headers() {
    return {"Accept": "application/json", "Content-Type": "application/json"};
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}${ApiConfig.login}"),
        headers: _headers(),
        body: jsonEncode({"username": username, "password": password}),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.body.isEmpty) {
        throw Exception("Response kosong dari server");
      }

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data['message'] ?? "Login gagal");
      }

      // kalau gagal login (401 / 422 dll)
      if (response.statusCode != 200) {
        throw Exception(data['message'] ?? "Login gagal");
      }

      // pastikan ada role
      if (!data.containsKey('role')) {
        throw Exception("Role tidak ditemukan di response API");
      }

      return data;
    } catch (e) {
      print("LOGIN ERROR: $e");
      rethrow;
    }
  }

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
          print("FILE OK: $key");
        } else {
          throw Exception("File $key wajib diisi");
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
        options: Options(headers: {"Accept": "application/json"}),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      print("ERROR: ${e.response?.data}");
      throw Exception(e.response?.data?['message'] ?? "Gagal mengirim data");
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}
