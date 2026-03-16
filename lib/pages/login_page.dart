import 'package:flutter/material.dart';
import '../main.dart';
import '../services/local_auth_service.dart';
import '../widgets/custom_field.dart';
import '../widgets/support_logo.dart';
import '../widgets/top_pattern.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
    _checkLoginStatus();
  }

  Future<void> _loadRememberMe() async {
    final savedRememberMe = await LocalAuthService.getRememberMe();
    if (!mounted) return;
    setState(() {
      rememberMe = savedRememberMe;
    });
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await LocalAuthService.isLoggedIn();
    if (!mounted) return;

    if (isLoggedIn) {
      final user = await LocalAuthService.getRegisteredUser();
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            fullName: user['fullName'] ?? 'Pengguna',
            username: user['username'] ?? '-',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan password wajib diisi')),
      );
      return;
    }

    final hasAccount = await LocalAuthService.hasRegisteredUser();
    if (!hasAccount) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akun belum terdaftar. Silakan registrasi dulu'),
        ),
      );
      return;
    }

    final success = await LocalAuthService.login(
      username: username,
      password: password,
      rememberMe: rememberMe,
    );

    if (!mounted) return;

    if (success) {
      final user = await LocalAuthService.getRegisteredUser();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login berhasil')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            fullName: user['fullName'] ?? 'Pengguna',
            username: user['username'] ?? '-',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau password salah')),
      );
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
                CustomField(
                  icon: Icons.person_outline,
                  hint: 'Masukkan Username',
                  controller: usernameController,
                ),
                CustomField(
                  icon: Icons.lock_outline,
                  hint: 'Password',
                  obscure: true,
                  controller: passwordController,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: rememberMe,
                        onChanged: (value) async {
                          final newValue = value ?? false;
                          setState(() {
                            rememberMe = newValue;
                          });
                          await LocalAuthService.setRememberMe(newValue);
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
                    onPressed: _login,
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Belum punya akun? ',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Daftar',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
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
