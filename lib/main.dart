import 'package:flutter/material.dart';
import 'pages/splash_screen_page.dart';

const Color kPrimary = Color(0xFFBE202E);
const Color kBg = Color.fromARGB(255, 255, 253, 253);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pendaftaran Domain Desa',
      theme: ThemeData(scaffoldBackgroundColor: kBg),
      home: const SplashScreenPage(),
    );
  }
}
