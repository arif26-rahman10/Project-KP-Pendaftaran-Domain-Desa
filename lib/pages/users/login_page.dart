import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../main.dart';
import '../../services/api_service.dart';
import '../../services/local_auth_service.dart';
import '../../widgets/custom_field.dart';
import '../../widgets/support_logo.dart';
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

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  Future<void> _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Username dan password wajib diisi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.login(
        username: username,
        password: password,
      );

      if (!mounted) return;

      final user = result['user'];

      if (result['success'] == true && user != null && user is Map) {
        final idUser = int.tryParse(user['id_user'].toString()) ?? 0;
        final name = user['name']?.toString() ?? 'Pengguna';
        final uname = user['username']?.toString() ?? '-';
        final email = user['email']?.toString() ?? '';
        final phone = user['no_hp']?.toString() ?? '';
        final role = result['role']?.toString() ?? '';

        await LocalAuthService.saveRegisteredUser(
          idUser: idUser,
          fullName: name,
          username: uname,
          email: email,
          phone: phone,
          password: password,
        );

        if (!mounted) return;

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminHomePage()),
          );
        } else if (role == 'desa') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(fullName: name, username: uname),
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'Role tidak dikenali';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Username atau password salah';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/images/pattern_top.svg',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.85),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),

                  const Text(
                    'Selamat Datang di\nNama Aplikasi',
                    style: TextStyle(
                      fontSize: 34,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: kPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Silakan login untuk melanjutkan',
                    style: TextStyle(color: kPrimary, fontSize: 14),
                  ),

                  const SizedBox(height: 28),

                  /// ERROR MESSAGE
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  /// USERNAME
                  CustomField(
                    icon: Icons.person_outline,
                    hint: 'Masukkan Username',
                    controller: usernameController,
                    onChanged: (_) {
                      if (_errorMessage != null) {
                        setState(() => _errorMessage = null);
                      }
                    },
                  ),

                  /// PASSWORD
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

                  const SizedBox(height: 20),

                  /// BUTTON LOGIN
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: SafeArea(child: Center(child: SupportLogo())),
          ),
        ],
      ),
    );
  }
}
