import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pesan_model.dart';
import 'api_config.dart';
import 'api_helper.dart';

class NotifikasiService {
  static Future<List<PesanModel>> getNotif() async {
    final response = await http.get(
      Uri.parse(ApiConfig.url('/notifikasi')),

      headers: await ApiHelper.headers(isJson: false),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List list = data['data'];

      return list.map((e) => PesanModel.fromJson(e)).toList();
    }

    return [];
  }
}
