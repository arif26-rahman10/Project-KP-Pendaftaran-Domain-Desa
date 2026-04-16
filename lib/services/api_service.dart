import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'api_config.dart';
import 'registration_data.dart';

class ApiService {
  static Map<String, String> _headers() {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}${ApiConfig.login}"),
        headers: _headers(),
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
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
        "username": data.username,
        "password": data.password,
        "name": data.name,
        "email": data.email,
        "no_hp": data.noHp,
        "role": data.role,
        "nama_desa": data.namaDesa,
        "nama_kepala_desa": data.namaKepalaDesa,
        "nip_kepala_desa": data.nipKepalaDesa,
        "klasifikasi_instansi": data.klasifikasiInstansi,
        "telepon": data.telepon,
        "faksimili": data.faksimili,
        "alamat": data.alamat,
        "kode_pos": data.kodePos,
        "provinsi": data.provinsi,
        "kota_kabupaten": data.kotaKabupaten,
        "kecamatan": data.kecamatan,
        "desa_kelurahan": data.desaKelurahan,
      });

      if ((data.filePaths['permohonan'] ?? '').isNotEmpty) {
        formData.files.add(
          MapEntry(
            "surat_permohonan",
            await MultipartFile.fromFile(
              data.filePaths['permohonan']!,
              filename: data.suratPermohonan,
            ),
          ),
        );
      }

      if ((data.filePaths['kuasa'] ?? '').isNotEmpty) {
        formData.files.add(
          MapEntry(
            "surat_kuasa",
            await MultipartFile.fromFile(
              data.filePaths['kuasa']!,
              filename: data.suratKuasa,
            ),
          ),
        );
      }

      if ((data.filePaths['penunjukan'] ?? '').isNotEmpty) {
        formData.files.add(
          MapEntry(
            "surat_penunjukan",
            await MultipartFile.fromFile(
              data.filePaths['penunjukan']!,
              filename: data.suratPenunjukan,
            ),
          ),
        );
      }

      if ((data.filePaths['pegawai'] ?? '').isNotEmpty) {
        formData.files.add(
          MapEntry(
            "kartu_pegawai",
            await MultipartFile.fromFile(
              data.filePaths['pegawai']!,
              filename: data.kartuPegawai,
            ),
          ),
        );
      }

      if ((data.filePaths['hukum'] ?? '').isNotEmpty) {
        formData.files.add(
          MapEntry(
            "dasar_hukum",
            await MultipartFile.fromFile(
              data.filePaths['hukum']!,
              filename: data.dasarHukum,
            ),
          ),
        );
      }

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
        return response.data;
      }

      return {
        "success": true,
        "message": "Pengajuan berhasil dikirim",
      };
    } on DioException catch (e) {
      print("SUBMIT ERROR: ${e.response?.data}");
      throw Exception(
        e.response?.data?['message'] ??
            "Gagal mengirim data ke server",
      );
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}