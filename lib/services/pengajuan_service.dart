import 'package:dio/dio.dart';
import '../models/pengajuan_model.dart';
import 'api_config.dart';

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

  // ================= SUBMIT =================
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
          formData.files.add(
            MapEntry(
              key,
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
              ),
            ),
          );
        }
      }

      await addFile('surat_permohonan', files['surat_permohonan']);
      await addFile('surat_kuasa', files['surat_kuasa']);
      await addFile(
        'surat_penunjukan_pejabat',
        files['surat_penunjukan_pejabat'],
      );
      await addFile('ktp_asn_pejabat', files['ktp_asn_pejabat']);
      await addFile('perda_pembentukan_desa', files['perda_pembentukan_desa']);

      final res = await dio.post(ApiConfig.submitPengajuan, data: formData);

      return res.data['success'] == true;
    } catch (e) {
      print("ERROR submit: $e");
      return false;
    }
  }

  // ================= GET LIST =================
  Future<List<Pengajuan>> getPengajuanAdmin() async {
    try {
      final res = await dio.get(ApiConfig.getPengajuan);

      final List list = res.data['data'];

      return list.map((e) => Pengajuan.fromJson(e)).toList();
    } catch (e) {
      print("ERROR LIST: $e");
      return [];
    }
  }

  // ================= GET DETAIL (FIX UTAMA) =================
  Future<Pengajuan> getDetail(int id) async {
    try {
      final res = await dio.get("/admin/pengajuan/$id");

      if (res.data['success']) {
        return Pengajuan.fromJson(res.data['data']);
      } else {
        throw Exception("Data tidak ditemukan");
      }
    } catch (e) {
      print("ERROR DETAIL: $e");
      throw Exception("Gagal ambil detail");
    }
  }

  // ================= VERIFIKASI =================
  Future<void> verifikasiPengajuan({
    required int id,
    required String status,
    required String catatan,
  }) async {
    try {
      final res = await dio.post(
        "/pengajuan/verifikasi/$id",
        data: {"status": status, "catatan": catatan},
      );

      if (res.data['success'] != true) {
        throw Exception(res.data['message']);
      }
    } catch (e) {
      print("ERROR VERIFIKASI: $e");
      throw Exception("Gagal verifikasi");
    }
  }

  // ================= AKTIVASI =================
  Future<bool> aktivasiPengajuan(int id) async {
    try {
      final res = await dio.post("${ApiConfig.aktivasi}/$id");
      return res.data['success'] == true;
    } catch (e) {
      print("Error aktivasi: $e");
      return false;
    }
  }
}
