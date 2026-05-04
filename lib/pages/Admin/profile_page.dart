import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../widgets/admin_bottom_nav.dart';
import '../../services/api_config.dart';
import '../../services/api_helper.dart';
import '../../services/local_auth_service.dart';
import '../users/login_page.dart';

class AdminProfilePage extends StatefulWidget {
  final String fullName;
  final String username;

  const AdminProfilePage({
    super.key,
    required this.fullName,
    required this.username,
  });

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  int idUser = 0;

  late TextEditingController nameController;
  late TextEditingController emailController;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.fullName);
    emailController = TextEditingController();

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await LocalAuthService.getRegisteredUser();

    setState(() {
      idUser = int.tryParse(user['id_user'].toString()) ?? 0;
      nameController.text = user['fullName'] ?? '';
      emailController.text = user['email'] ?? '';
    });
  }

  Future<void> _logout() async {
    await LocalAuthService.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _saveProfile() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.url(ApiConfig.updateProfile)),
        headers: await ApiHelper.headers(isJson: false),
        body: {
          'id_user': idUser.toString(),
          'name': nameController.text,
          'email': emailController.text,
          'old_password': oldPasswordController.text,
          'password': newPasswordController.text,
          'password_confirmation': confirmPasswordController.text,
        },
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal update')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Server error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topSafe + 20, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 114, 15, 23),
                  Color.fromARGB(255, 125, 13, 13),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Admin Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.black26),
                    ],
                  ),
                  child: const Icon(Icons.admin_panel_settings, size: 50),
                ),

                const SizedBox(height: 10),

                Text(
                  widget.username,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _cardField("Informasi Akun", [
                    _input(nameController, "Nama Lengkap"),
                    _input(emailController, "Email"),
                  ]),

                  const SizedBox(height: 16),

                  _cardField("Ubah Password", [
                    _input(oldPasswordController, "Password Lama", true),
                    _input(newPasswordController, "Password Baru", true),
                    _input(
                      confirmPasswordController,
                      "Konfirmasi Password",
                      true,
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // BUTTON SAVE
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 138, 30, 48),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // LOGOUT
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: const AdminBottomNav(currentIndex: 3),
    );
  }

  Widget _cardField(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _input(TextEditingController c, String hint, [bool obscure = false]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
