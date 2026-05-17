import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/domain_model.dart';
import 'api_config.dart';
import 'api_helper.dart';

class PerpanjanganService {
  // ================= USER LIST DOMAIN =================
  static Future<List<DomainModel>> getDomain(int idUser) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/perpanjangan/domain?id_user=$idUser'),

      headers: await ApiHelper.headers(isJson: false),
    );

    print(response.statusCode);

    print(response.body);

    final data = jsonDecode(response.body);

    List list = data['data'];

    return list.map((e) => DomainModel.fromJson(e)).toList();
  }

  // ================= USER AJUKAN =================
  static Future<bool> ajukanPerpanjangan(int id) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/perpanjangan/ajukan/$id'),

      headers: await ApiHelper.headers(isJson: false),
    );

    print(response.statusCode);

    print(response.body);

    final data = jsonDecode(response.body);

    return data['success'];
  }

  // ================= ADMIN LIST =================
  static Future<List<dynamic>> adminList() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/admin/perpanjangan'),

      headers: await ApiHelper.headers(isJson: false),
    );

    print(response.statusCode);

    print(response.body);

    final data = jsonDecode(response.body);

    return data['data'];
  }

  // ================= GENERATE FAKTUR =================
  static Future<bool> generateFaktur(int id) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/admin/perpanjangan/faktur/$id'),

      headers: await ApiHelper.headers(isJson: false),
    );

    print(response.statusCode);

    print(response.body);

    final data = jsonDecode(response.body);

    return data['success'];
  }

  // ================= AKTIVASI =================
  static Future<bool> aktivasi(int id) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/admin/perpanjangan/aktivasi/$id'),

      headers: await ApiHelper.headers(isJson: false),
    );

    print(response.statusCode);

    print(response.body);

    final data = jsonDecode(response.body);

    return data['success'];
  }
}
