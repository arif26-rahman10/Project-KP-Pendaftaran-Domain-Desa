import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/faktur_model.dart';
import 'api_config.dart';

class FakturService {
  Future<List<FakturModel>> getData() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/admin/faktur'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List data = jsonData['data'];

      return data.map((e) => FakturModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil faktur');
    }
  }

  Future<FakturModel> getDetail(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/admin/faktur/$id'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return FakturModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Gagal mengambil detail');
    }
  }
}
