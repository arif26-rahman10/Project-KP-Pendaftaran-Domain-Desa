import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/domain_terdaftar_model.dart';
import 'api_config.dart';

class DomainTerdaftarService {
  Future<List<DomainTerdaftar>> getData() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/domain-terdaftar'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List data = jsonData['data'];

      return data.map((e) => DomainTerdaftar.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }
}
