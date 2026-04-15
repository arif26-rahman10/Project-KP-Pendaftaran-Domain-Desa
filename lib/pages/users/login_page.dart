import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/support_logo.dart';
import '../../widgets/top_pattern.dart';
import '../home_page.dart';
import '../admin/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool _isLoading = false;

  // 🔥 state untuk icon mata
  bool _obscurePassword = true;

  Future<void> _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan password wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.login(
        username: username,
        password: password,
      );

      if (!mounted) return;

      final user = result['user'];

      if (result['success'] == true && user != null && user is Map) {
        final name = user['name']?.toString() ?? 'Pengguna';
        final uname = user['username']?.toString() ?? '-';
        final role = result['role']?.toString() ?? '';

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login berhasil')));

        // 🔥 routing berdasarkan role
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AdminHomePage()),
          );
        } else if (role == 'desa') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(fullName: name, username: uname),
            ),
          );
        }
      } else {
        final message = result['message'] ?? 'Login gagal';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                const SizedBox(height: 28),

                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width * 0.62),
                  child: const Text(
                    'Selamat\nDatang di\nNama Aplikasi',
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      color: kPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Selamat Datang di Nama Aplikasi',
                  style: TextStyle(color: kPrimary, fontSize: 14),
                ),

                const SizedBox(height: 28),

                // 🔹 Username
                CustomField(
                  icon: Icons.person_outline,
                  hint: 'Masukkan Username',
                  controller: usernameController,
                ),

                // 🔹 Password + ICON MATA 🔥
                CustomField(
                  icon: Icons.lock_outline,
                  hint: 'Password',
                  obscure: _obscurePassword,
                  controller: passwordController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                // 🔹 Remember me
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                        activeColor: kPrimary,
                        side: BorderSide(color: Colors.grey.shade500),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Remember me',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // 🔹 Button Login
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Masuk',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
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
