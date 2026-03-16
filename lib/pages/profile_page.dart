import 'package:flutter/material.dart';
import '../main.dart';
import '../services/local_auth_service.dart';
import 'domain_page.dart';
import 'home_page.dart';
import 'informasi_instansi_page.dart';
import 'login_page.dart';
import 'faktur_page.dart';
import '../widgets/app_bottom_nav.dart';

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
  int currentIndex = 3;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String savedPassword = '';

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.fullName);
    emailController = TextEditingController();
    phoneController = TextEditingController();

    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = await LocalAuthService.getRegisteredUser();

    if (!mounted) return;

    setState(() {
      nameController.text = user['fullName'] ?? widget.fullName;
      emailController.text = user['email'] ?? '';
      phoneController.text = user['phone'] ?? '';
      savedPassword = user['password'] ?? '';
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await LocalAuthService.logout();

    if (!mounted) return;

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

    if (fullName.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama, email, dan nomor HP wajib diisi')),
      );
      return;
    }

    String finalPassword = savedPassword;

    if (newPassword.isNotEmpty ||
        confirmPassword.isNotEmpty ||
        oldPassword.isNotEmpty) {
      if (oldPassword != savedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password lama tidak sesuai')),
        );
        return;
      }

      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konfirmasi password tidak sama')),
        );
        return;
      }

      if (newPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password baru tidak boleh kosong')),
        );
        return;
      }

      finalPassword = newPassword;
    }

    await LocalAuthService.saveRegisteredUser(
      fullName: fullName,
      username: widget.username,
      email: email,
      phone: phone,
      password: finalPassword,
    );

    savedPassword = finalPassword;

    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan profil berhasil disimpan')),
    );
  }

  void _onTapNav(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            fullName: nameController.text.trim().isEmpty
                ? widget.fullName
                : nameController.text.trim(),
            username: widget.username,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DomainPage(
            fullName: nameController.text.trim().isEmpty
                ? widget.fullName
                : nameController.text.trim(),
            username: widget.username,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FakturPage(
            fullName: nameController.text.trim().isEmpty
                ? widget.fullName
                : nameController.text.trim(),
            username: widget.username,
          ),
        ),
      );
    } else if (index == 3) {
      setState(() {
        currentIndex = 3;
      });
    }
  }

  Widget _profileField({
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade600),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: kPrimary),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = currentIndex == index;

    return InkWell(
      onTap: () => _onTapNav(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? kPrimary : Colors.grey, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? kPrimary : Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, topSafe + 12, 24, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE01925), Color(0xFF7F1118)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
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
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.black87,
                          size: 22,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifikasi belum tersedia'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 44,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
              child: Column(
                children: [
                  _profileField(
                    icon: Icons.person_outline,
                    controller: nameController,
                    hint: 'Nama Lengkap',
                  ),
                  _profileField(
                    icon: Icons.mail_outline,
                    controller: emailController,
                    hint: 'Email',
                  ),
                  _profileField(
                    icon: Icons.phone_outlined,
                    controller: phoneController,
                    hint: 'No HP',
                  ),
                  _profileField(
                    icon: Icons.lock_outline,
                    controller: oldPasswordController,
                    hint: 'Password Lama',
                    obscure: true,
                  ),
                  _profileField(
                    icon: Icons.lock_outline,
                    controller: newPasswordController,
                    hint: 'Password Baru',
                    obscure: true,
                  ),
                  _profileField(
                    icon: Icons.lock_outline,
                    controller: confirmPasswordController,
                    hint: 'Konfirmasi Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _saveProfile,
                      child: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InformasiInstansiPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey.shade700,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Informasi Instansi',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _logout,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red, size: 18),
                          SizedBox(width: 10),
                          Text(
                            'Keluar',
                            style: TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        fullName: nameController.text.trim().isEmpty
            ? widget.fullName
            : nameController.text.trim(),
        username: widget.username,
      ),
    );
  }
}
