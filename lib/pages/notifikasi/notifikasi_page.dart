import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_config.dart';
import 'detail_notifikasi_page.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  List<dynamic> notifikasi = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getNotifikasi();
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("token") ?? "";
  }

  Future<void> getNotifikasi() async {
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifikasi'),

        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("NOTIF STATUS: ${response.statusCode}");
      print("NOTIF BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          notifikasi = data['data'] ?? [];

          isLoading = false;
        });
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      print("NOTIF ERROR: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,

            padding: EdgeInsets.fromLTRB(16, topSafe + 10, 16, 14),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE01925), Color(0xFF8E121A)],

                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),

            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },

                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),

                const SizedBox(width: 12),

                const Text(
                  'Notifikasi',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ================= CONTENT =================
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : notifikasi.isEmpty
                ? const Center(child: Text("Belum ada notifikasi"))
                : RefreshIndicator(
                    onRefresh: getNotifikasi,

                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),

                      itemCount: notifikasi.length,

                      itemBuilder: (context, index) {
                        final item = notifikasi[index];

                        return _notificationCard(
                          title: item['judul'] ?? '-',

                          subtitle: item['isi'] ?? '-',

                          onTap: () async {
                            final result = await Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => DetailNotifikasiPage(
                                  title: item['judul'] ?? '-',

                                  message: item['isi'] ?? '-',

                                  idPengajuan: item['id_pengajuan'],
                                ),
                              ),
                            );

                            // refresh setelah buat faktur
                            if (result == true) {
                              getNotifikasi();
                            }
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _notificationCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),

      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(14),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              title,

              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),

            const SizedBox(height: 10),

            Text(
              subtitle,

              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
