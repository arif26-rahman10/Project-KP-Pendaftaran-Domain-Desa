import 'package:flutter/material.dart';
import '../main.dart';
import '../services/local_auth_service.dart';
import '../widgets/custom_field.dart';
import '../widgets/support_logo.dart';
import '../widgets/top_pattern.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak sama')),
      );
      return;
    }

    await LocalAuthService.saveRegisteredUser(
      fullName: fullName,
      username: username,
      email: email,
      phone: phone,
      password: password,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil, silakan login')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const TopPattern(),
                const SizedBox(height: 30),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width * 0.62),
                  child: const Text(
                    'Registrasi',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: kPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selamat Datang di Nama Aplikasi',
                  style: TextStyle(
                    color: kPrimary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),
                CustomField(
                  icon: Icons.edit_outlined,
                  hint: 'Masukkan Nama Lengkap',
                  controller: fullNameController,
                ),
                CustomField(
                  icon: Icons.person_outline,
                  hint: 'Masukkan Username',
                  controller: usernameController,
                ),
                CustomField(
                  icon: Icons.mail_outline,
                  hint: 'Masukkan Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomField(
                  icon: Icons.phone_outlined,
                  hint: 'Masukkan No HP',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
                CustomField(
                  icon: Icons.lock_outline,
                  hint: 'Password',
                  obscure: true,
                  controller: passwordController,
                ),
                CustomField(
                  icon: Icons.lock_outline,
                  hint: 'Konfirmasi Password',
                  obscure: true,
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kPrimary,
                          side: const BorderSide(color: kPrimary),
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Kembali'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _register,
                        child: const Text('Daftar'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                const Center(child: SupportLogo()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}