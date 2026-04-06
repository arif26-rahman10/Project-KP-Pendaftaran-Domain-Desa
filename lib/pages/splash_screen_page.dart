import 'dart:async';
import 'package:flutter/material.dart';
import 'users/login_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _rotateController;

  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;

  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _subtitleSlide;

  late Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.00, 0.35, curve: Curves.easeInOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.78, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
    );

    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.25, 0.60, curve: Curves.easeInOut),
      ),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.25, 0.60, curve: Curves.easeOut),
          ),
        );

    _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.45, 0.82, curve: Curves.easeInOut),
      ),
    );

    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.45, 0.82, curve: Curves.easeOut),
          ),
        );

    _footerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.68, 1.0, curve: Curves.easeIn),
      ),
    );

    _mainController.forward();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  Widget _backgroundDecoration() {
    return Stack(
      children: [
        Positioned(
          top: -70,
          right: -40,
          child: Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          top: 140,
          left: -60,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ),
        Positioned(
          bottom: 110,
          right: -55,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
      ],
    );
  }

  Widget _logoSection() {
    return FadeTransition(
      opacity: _logoOpacity,
      child: ScaleTransition(
        scale: _logoScale,
        child: RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _rotateController, curve: Curves.linear),
          ),
          child: Container(
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withOpacity(0.14),
              border: Border.all(
                color: Colors.white.withOpacity(0.20),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.language,
                  size: 42,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleSection() {
    return FadeTransition(
      opacity: _titleOpacity,
      child: SlideTransition(
        position: _titleSlide,
        child: const Text(
          'Pendaftaran\nDomain Desa',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 29,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _subtitleSection() {
    return FadeTransition(
      opacity: _subtitleOpacity,
      child: SlideTransition(
        position: _subtitleSlide,
        child: Text(
          'Layanan pengajuan dan pengelolaan\nnama domain desa secara digital',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.82),
            fontSize: 14,
            height: 1.55,
          ),
        ),
      ),
    );
  }

  Widget _footerSection() {
    return FadeTransition(
      opacity: _footerOpacity,
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            padding: const EdgeInsets.all(6),
            child: const CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Support by Diskominfotik Bengkalis',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.74),
              fontSize: 13,
              fontWeight: FontWeight.w400,
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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE01925),
                  Color(0xFFB1141E),
                  Color(0xFF7F1118),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          _backgroundDecoration(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                topSafe + 12,
                24,
                bottomSafe + 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: _logoSection()),
                  const SizedBox(height: 28),
                  Center(child: _titleSection()),
                  const SizedBox(height: 14),
                  Center(child: _subtitleSection()),
                  const Spacer(),
                  _footerSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
