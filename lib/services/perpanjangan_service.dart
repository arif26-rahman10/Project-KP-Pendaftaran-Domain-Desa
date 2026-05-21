import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_helper.dart';

class PerpanjanganService {
  // =========================
  // USER - GET DOMAIN AKTIF
  // =========================
  static Future<List> getDomainAktif() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.url('/perpanjangan/domain')),
        headers: await ApiHelper.headers(isJson: false),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal load domain');
      }

      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } catch (e) {
      print('Error getDomainAktif: $e');
      rethrow;
    }
  }

  // =========================
  // USER - AJUKAN PERPANJANGAN
  // =========================
  static Future<Map<String, dynamic>> ajukanPerpanjangan(
    int idPengajuan,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.url('/perpanjangan/ajukan/$idPengajuan')),
        headers: await ApiHelper.headers(),
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Error ajukanPerpanjangan: $e');
      rethrow;
    }
  }

  // =========================
  // USER - UPLOAD BUKTI PEMBAYARAN
  // =========================
  static Future<Map<String, dynamic>> uploadBuktiPembayaran({
    required int idPengajuan,
    required String filePath,
  }) async {
    try {
      final headers = await ApiHelper.headers(isJson: false);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.url('/perpanjangan/upload-bukti/$idPengajuan')),
      );

      request.headers.addAll(headers);

      request.files.add(
        await http.MultipartFile.fromPath('bukti_pembayaran', filePath),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      return jsonDecode(responseBody);
    } catch (e) {
      print('Error uploadBuktiPembayaran: $e');
      rethrow;
    }
  }

  // =========================
  // USER - GET DETAIL FAKTUR
  // =========================
  static Future<Map<String, dynamic>> getDetailFaktur(int idPengajuan) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.url('/perpanjangan/detail-faktur/$idPengajuan')),
        headers: await ApiHelper.headers(),
      );

      if (response.statusCode != 200) {
        throw Exception('Faktur tidak ditemukan');
      }

      return jsonDecode(response.body);
    } catch (e) {
      print('Error getDetailFaktur: $e');
      rethrow;
    }
  }

  // =========================
  // USER - CEK REMINDER
  // =========================
  static Future<Map<String, dynamic>> cekReminder() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.url('/perpanjangan/reminder')),
        headers: await ApiHelper.headers(),
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Error cekReminder: $e');
      rethrow;
    }
  }

  // =========================
  // ADMIN - LIST REQUEST PERPANJANGAN
  // =========================
  static Future<List> getRequestPerpanjangan() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.url('/admin/perpanjangan/list')),
        headers: await ApiHelper.headers(isJson: false),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil data');
      }

      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } catch (e) {
      print('Error getRequestPerpanjangan: $e');
      rethrow;
    }
  }

  // =========================
  // ADMIN - BUAT FAKTUR PERPANJANGAN
  // =========================
  static Future<Map<String, dynamic>> buatFaktur(int idPengajuan) async {
    try {
      final response = await http.post(
        Uri.parse(
          ApiConfig.url('/admin/perpanjangan/buat-faktur/$idPengajuan'),
        ),
        headers: await ApiHelper.headers(),
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Error buatFaktur: $e');
      rethrow;
    }
  }

  // =========================
  // ADMIN - VERIFIKASI PEMBAYARAN
  // =========================
  static Future<Map<String, dynamic>> verifikasiPembayaran(
    int idPengajuan,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.url('/admin/perpanjangan/verifikasi/$idPengajuan')),
        headers: await ApiHelper.headers(),
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Error verifikasiPembayaran: $e');
      rethrow;
    }
  }

  // =========================
  // ADMIN - AKTIVASI ULANG DOMAIN
  // =========================
  static Future<Map<String, dynamic>> aktivasiPerpanjangan(
    int idPengajuan,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.url('/admin/perpanjangan/aktivasi/$idPengajuan')),
        headers: await ApiHelper.headers(),
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Error aktivasiPerpanjangan: $e');
      rethrow;
    }
  }

  // =========================
  // ADMIN - LIST FAKTUR PERPANJANGAN
  // =========================
  static Future<List> getListFaktur() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.url('/admin/perpanjangan/list-faktur')),
        headers: await ApiHelper.headers(isJson: false),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil data faktur');
      }

      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    } catch (e) {
      print('Error getListFaktur: $e');
      rethrow;
    }
  }
}
