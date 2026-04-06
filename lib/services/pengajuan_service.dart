import 'package:dio/dio.dart';
import 'api_config.dart';

class PengajuanService {
  late Dio dio;

  PengajuanService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl, // 🔥 ambil dari config
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

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

  Future<bool> submitPengajuan({
    required String domain,
    required Map<String, String> data,
    required Map<String, String> files,
  }) async {
    try {
      FormData formData = FormData();

      formData.fields.add(MapEntry('nama_domain', domain));

      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      Future<void> addFile(String key, String? path) async {
        if (path != null && path.isNotEmpty) {
          formData.files.add(MapEntry(key, await MultipartFile.fromFile(path)));
        }
      }

      await addFile('surat_permohonan', files['permohonan']);
      await addFile('surat_kuasa', files['kuasa']);
      await addFile('surat_penunjukan', files['penunjukan']);
      await addFile('kartu_pegawai', files['pegawai']);
      await addFile('dasar_hukum', files['hukum']);

      final res = await dio.post(ApiConfig.submitPengajuan, data: formData);

      return res.data['success'];
    } catch (e) {
      print("Error submit: $e");
      return false;
    }
  }
}
