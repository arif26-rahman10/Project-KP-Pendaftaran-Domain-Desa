import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pesan_model.dart';
import 'api_config.dart';
import 'api_helper.dart';

class AdminNotifikasiService {
  static Future<List<PesanModel>> getNotif() async {
    try {
      final headers = await ApiHelper.headers();

      final response = await http.get(
        Uri.parse(ApiConfig.url(ApiConfig.adminNotif)),
        headers: headers,
      );

      final json = jsonDecode(response.body);

      if (json['success'] == true) {
        return List<PesanModel>.from(
          json['data'].map((x) => PesanModel.fromJson(x)),
        );
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
