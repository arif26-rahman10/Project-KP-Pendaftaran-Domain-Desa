import 'package:dio/dio.dart';
import 'api_config.dart';
import 'dart:io';

class PengajuanService {
  late Dio dio;

  PengajuanService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  // ================= CEK DOMAIN =================
  Future<bool> checkDomain(String domain) async {
    try {
      final res = await dio.post(
        ApiConfig.checkDomain,
        data: {'nama_domain': domain},
      );

      return res.data['available'];
    } catch (e) {
      print("Error check domain: $e");
      return false;
    }
  }

  // ================= SUBMIT =================
  Future<bool> submitPengajuan({
    required String domain,
    required Map<String, String> data,
    required Map<String, String> files,
  }) async {
    try {
      FormData formData = FormData();

      // ================= TEXT =================
      formData.fields.add(MapEntry('nama_domain', domain));

      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      // ================= FILE =================
      Future<void> addFile(String key, String? path) async {
        if (path != null && path.isNotEmpty) {
          formData.files.add(
            MapEntry(
              key,
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last, // 🔥 penting
              ),
            ),
          );
        }
      }

      // 🔥 WAJIB SAMA DENGAN LARAVEL
      await addFile('surat_permohonan', files['surat_permohonan']);
      await addFile('surat_kuasa', files['surat_kuasa']);
      await addFile('surat_penunjukan', files['surat_penunjukan']);
      await addFile('kartu_pegawai', files['kartu_pegawai']);
      await addFile('dasar_hukum', files['dasar_hukum']);

      // ================= REQUEST =================
      final res = await dio.post(
        ApiConfig.submitPengajuan,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      print("RESPONSE: ${res.data}");

      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");
      return false;
    } catch (e) {
      print("Error submit: $e");
      return false;
    }
  }
}
