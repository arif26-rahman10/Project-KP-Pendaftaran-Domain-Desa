import 'package:dio/dio.dart';

import '../models/pengajuan_model.dart';
import 'api_config.dart';
import 'api_helper.dart';
import 'local_auth_service.dart';

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

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final headers = await ApiHelper.headers();
          options.headers.addAll(headers);
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  // ================= CEK DOMAIN =================
  Future<bool> checkDomain(String domain) async {
    try {
      final res = await dio.post(
        ApiConfig.checkDomain,
        data: {
          "nama_domain": domain,
        },
      );

      return res.data['available'] == true;
    } catch (e) {
      print("ERROR CHECK DOMAIN: $e");
      return false;
    }
  }

  // ================= SUBMIT PENGAJUAN =================
  Future<bool> submitPengajuan({
    required String domain,
    required Map<String, String> data,
    required Map<String, String> files,
  }) async {
    try {
      final user = await LocalAuthService.getRegisteredUser();
      final idUser = int.tryParse(user['id_user'].toString()) ?? 0;

      FormData formData = FormData();

      formData.fields.add(MapEntry("id_user", idUser.toString()));
      formData.fields.add(MapEntry("nama_domain", domain));

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
      await addFile('perda_pembentukan_desa', files['perda_pembentukan_desa']);
      await addFile('surat_kuasa', files['surat_kuasa']);
      await addFile(
        'surat_penunjukan_pejabat',
        files['surat_penunjukan_pejabat'],
      );
      await addFile('ktp_asn_pejabat', files['ktp_asn_pejabat']);

      final res = await dio.post(
        ApiConfig.submitPengajuan,
        data: formData,
      );

      print("SUBMIT RESPONSE: ${res.data}");

      return res.data['success'] == true;
    } catch (e) {
      print("ERROR SUBMIT: $e");
      return false;
    }
  }

  // ================= RIWAYAT USER / VERIFIKASI DOKUMEN =================
  Future<List<Pengajuan>> getPengajuanUser() async {
    try {
      final user = await LocalAuthService.getRegisteredUser();
      final idUser = int.tryParse(user['id_user'].toString()) ?? 0;

      final res = await dio.post(
        ApiConfig.getPengajuanUser,
        data: {
          "id_user": idUser,
        },
      );

      print("GET PENGAJUAN USER RESPONSE: ${res.data}");

      final List list = res.data['data'] ?? [];

      return list.map((e) {
        return Pengajuan.fromJson(
          Map<String, dynamic>.from(e),
        );
      }).toList();
    } catch (e) {
      print("ERROR USER LIST: $e");
      return [];
    }
  }

  // ================= ADMIN LIST =================
  Future<List<Pengajuan>> getPengajuanAdmin() async {
    try {
      final res = await dio.get(ApiConfig.getPengajuan);

      final List list = res.data['data'] ?? [];

      return list.map((e) {
        return Pengajuan.fromJson(
          Map<String, dynamic>.from(e),
        );
      }).toList();
    } catch (e) {
      print("ERROR ADMIN LIST: $e");
      return [];
    }
  }

  // ================= DETAIL ADMIN =================
  Future<Pengajuan> getDetail(int id) async {
    try {
      final res = await dio.get("/admin/pengajuan/$id");

      if (res.data['success'] == true) {
        return Pengajuan.fromJson(
          Map<String, dynamic>.from(res.data['data']),
        );
      } else {
        throw Exception("Data tidak ditemukan");
      }
    } catch (e) {
      print("ERROR DETAIL: $e");
      throw Exception("Gagal ambil detail");
    }
  }

  // ================= VERIFIKASI ADMIN =================
  Future<void> verifikasiPengajuan({
    required int id,
    required String status,
    required String catatan,
  }) async {
    try {
      final res = await dio.post(
        "${ApiConfig.verifikasi}/$id",
        data: {
          "status": status,
          "catatan": catatan,
        },
      );

      if (res.data['success'] != true) {
        throw Exception(res.data['message'] ?? "Gagal verifikasi");
      }
    } catch (e) {
      print("ERROR VERIFIKASI: $e");
      throw Exception("Gagal verifikasi");
    }
  }

  // ================= UPDATE PENGAJUAN USER =================
  Future<void> updatePengajuan({
    required int id,
    required String domain,
    required String namaDesa,
    required String telepon,
    required String faksimili,
    required String alamat,
    required String provinsi,
    required String kotaKabupaten,
    required String kecamatan,
    required String desaKelurahan,
    required String kodePos,
    required Map<String, String> files,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "nama_domain": domain,
        "nama_desa": namaDesa,
        "telepon": telepon,
        "faksimili": faksimili,
        "alamat": alamat,
        "provinsi": provinsi,
        "kota_kabupaten": kotaKabupaten,
        "kecamatan": kecamatan,
        "desa_kelurahan": desaKelurahan,
        "kode_pos": kodePos,
      });

      for (final entry in files.entries) {
        formData.files.add(
          MapEntry(
            entry.key,
            await MultipartFile.fromFile(
              entry.value,
              filename: entry.value.split('/').last,
            ),
          ),
        );
      }

      final res = await dio.post(
        "/pengajuan/update/$id",
        data: formData,
      );

      print("UPDATE PENGAJUAN RESPONSE: ${res.data}");

      if (res.data['success'] != true) {
        throw Exception(res.data['message'] ?? "Gagal update pengajuan");
      }
    } catch (e) {
      print("ERROR UPDATE PENGAJUAN: $e");
      throw Exception("Gagal update pengajuan");
    }
  }

  // ================= UPLOAD BUKTI PEMBAYARAN =================
  Future<void> uploadBuktiPembayaran({
    required int idPengajuan,
    required String filePath,
  }) async {
    try {
      FormData formData = FormData();

      formData.files.add(
        MapEntry(
          "bukti_pembayaran",
          await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          ),
        ),
      );

      final res = await dio.post(
        "/pengajuan/bukti-pembayaran/$idPengajuan",
        data: formData,
      );

      print("UPLOAD BUKTI RESPONSE: ${res.data}");

      if (res.data['success'] != true) {
        throw Exception(
          res.data['message'] ?? "Gagal upload bukti pembayaran",
        );
      }
    } catch (e) {
      print("ERROR UPLOAD BUKTI: $e");
      throw Exception("Gagal upload bukti pembayaran");
    }
  }

  // ================= AKTIVASI =================
  Future<bool> aktivasiPengajuan(int id) async {
    try {
      final res = await dio.post("${ApiConfig.aktivasi}/$id");

      return res.data['success'] == true;
    } catch (e) {
      print("ERROR AKTIVASI: $e");
      return false;
    }
  }
}