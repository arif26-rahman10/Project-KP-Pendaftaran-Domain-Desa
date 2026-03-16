import 'package:flutter/material.dart';
import 'pages/splash_screen_page.dart';

const Color kPrimary = Color(0xFFAF252B);
const Color kBg = Color(0xFFF3F3F3);

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
      theme: ThemeData(
        scaffoldBackgroundColor: kBg,
      ),
      home: const SplashScreenPage(),
    );
  }
}