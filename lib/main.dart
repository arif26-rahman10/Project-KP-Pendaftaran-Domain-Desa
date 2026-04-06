import 'package:flutter/material.dart';
import 'pages/splash_screen_page.dart';
import 'services/token_service.dart';

const Color kPrimary = Color(0xFFBE202E);
const Color kBg = Color.fromARGB(255, 255, 253, 253);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLogin = await TokenService.isLoggedIn();

  runApp(MyApp(isLogin: isLogin));
}

class MyApp extends StatelessWidget {
  final bool isLogin;

  const MyApp({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pendaftaran Domain Desa',
      theme: ThemeData(scaffoldBackgroundColor: kBg),

      // 🔥 langsung tentukan halaman awal
      home: isLogin
          ? const SplashScreenPage() // nanti bisa ke Home
          : const SplashScreenPage(), // atau Login
    );
  }
}
