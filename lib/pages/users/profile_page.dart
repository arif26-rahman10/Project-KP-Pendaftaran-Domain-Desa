import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../../services/api_config.dart';
import '../../services/api_helper.dart';
import '../../services/local_auth_service.dart';
import '../notifikasi/notifikasi_page.dart';
import 'informasi_instansi_page.dart';
import 'login_page.dart';
import '../../widgets/app_bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  final String fullName;
  final String username;

  const ProfilePage({
    super.key,
    required this.fullName,
    required this.username,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int idUser = 0;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String savedPassword = '';

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.fullName);
    emailController = TextEditingController();
    phoneController = TextEditingController();

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await LocalAuthService.getRegisteredUser();

    setState(() {
      idUser = int.tryParse(user['id_user'].toString()) ?? 0;
      nameController.text = user['fullName'] ?? '';
      emailController.text = user['email'] ?? '';
      phoneController.text = user['phone'] ?? '';
      savedPassword = user['password'] ?? '';
    });

    print("ID USER LOAD: $idUser");
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
    final fullName = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    print("ID USER: $idUser");

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.url(ApiConfig.updateProfile)),
        headers: await ApiHelper.headers(isJson: false),
        body: {
          'id_user': idUser.toString(),
          'name': fullName,
          'email': email,
          'no_hp': phone,
          'old_password': oldPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        await LocalAuthService.saveRegisteredUser(
          idUser: idUser,
          fullName: fullName,
          username: widget.username,
          email: email,
          phone: phone,
          password: newPassword.isEmpty ? savedPassword : newPassword,
        );

        await _loadProfile();

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Berhasil'),
            content: Text(data['message']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal update')),
        );
      }
    } catch (e) {
      print("ERROR: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal koneksi server')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          // 🔴 HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, topSafe + 16, 24, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE01925), Color(0xFF7F1118)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotifikasiPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 👤 AVATAR
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 10),

                Text(
                  widget.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // 📄 FORM
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _niceField(Icons.person, nameController, "Nama Lengkap"),
                  _niceField(Icons.email, emailController, "Email"),
                  _niceField(Icons.phone, phoneController, "No HP"),
                  _niceField(
                    Icons.lock,
                    oldPasswordController,
                    "Password Lama",
                    obscure: true,
                  ),
                  _niceField(
                    Icons.lock,
                    newPasswordController,
                    "Password Baru",
                    obscure: true,
                  ),
                  _niceField(
                    Icons.lock,
                    confirmPasswordController,
                    "Konfirmasi Password",
                    obscure: true,
                  ),

                  const SizedBox(height: 10),

                  // 🔴 BUTTON SIMPAN
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 📄 INFORMASI INSTANSI
                  _menuTile(
                    icon: Icons.info_outline,
                    text: "Informasi Instansi",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InformasiInstansiPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // 🚪 LOGOUT
                  _menuTile(
                    icon: Icons.logout,
                    text: "Keluar",
                    color: Colors.red,
                    onTap: _logout,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        fullName: nameController.text,
        username: widget.username,
      ),
    );
  }

  Widget _niceField(
    IconData icon,
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.black87),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(color: color ?? Colors.black87, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
