import 'package:dio/dio.dart';
import 'api_config.dart';
import '../models/pengajuan_model.dart';

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

      return res.data['available'] == true;
    } catch (e) {
      print("Error check domain: $e");
      return false;
    }
  }

  // ================= SUBMIT (USER) =================
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

      // DEBUG (WAJIB BIAR KELIHATAN)
      print("=== DATA DIKIRIM ===");
      for (var f in formData.fields) {
        print("${f.key} = ${f.value}");
      }

      // ================= FILE =================
      Future<void> addFile(String key, String? path) async {
        if (path != null && path.isNotEmpty) {
          formData.files.add(
            MapEntry(
              key,
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
              ),
            ),
          );
          print("FILE OK: $key");
        } else {
          print("FILE KOSONG: $key");
        }
      }

      await addFile('surat_permohonan', files['surat_permohonan']);
      await addFile('surat_kuasa', files['surat_kuasa']);
      await addFile('surat_penunjukan', files['surat_penunjukan']);
      await addFile('kartu_pegawai', files['kartu_pegawai']);
      await addFile('dasar_hukum', files['dasar_hukum']);

      // ================= REQUEST =================
      final res = await dio.post(ApiConfig.submitPengajuan, data: formData);

      print("RESPONSE: ${res.data}");

      return res.data['success'] == true;
    } on DioException catch (e) {
      print("DIO ERROR: ${e.response?.data}");
      return false;
    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }

  // ================= GET LIST (ADMIN) =================
  Future<List<Pengajuan>> getPengajuanAdmin() async {
    try {
      final res = await dio.get(ApiConfig.getPengajuan);

      // DEBUG
      print("RESPONSE API: ${res.data}");

      final List list = res.data['data'];

      return list.map((e) => Pengajuan.fromJson(e)).toList();
    } catch (e) {
      print("ERROR SERVICE: $e");
      return [];
    }
  }

  // ================= FILTER STATUS =================
  Future<List<dynamic>> getByStatus(String status) async {
    try {
      final res = await dio.get(
        ApiConfig.getPengajuan,
        queryParameters: {'status': status},
      );

      return res.data['data'] ?? [];
    } catch (e) {
      print("Error filter: $e");
      return [];
    }
  }

  // ================= AKTIVASI (ADMIN) =================
  Future<bool> aktivasiPengajuan(int id) async {
    try {
      final res = await dio.post("${ApiConfig.aktivasi}/$id");

      return res.data['success'] == true;
    } on DioException catch (e) {
      print("Error aktivasi: ${e.response?.data}");
      return false;
    } catch (e) {
      print("Error aktivasi: $e");
      return false;
    }
  }

  // ================= VERIFIKASI (ADMIN) =================
  Future<bool> verifikasiPengajuan({
    required int id,
    required String status,
    required String catatan,
  }) async {
    try {
      final res = await dio.post(
        "/admin/verifikasi/$id",
        data: {"status": status, "catatan": catatan},
      );

      return res.data['success'] == true;
    } catch (e) {
      print("Error verifikasi: $e");
      return false;
    }
  }
}
