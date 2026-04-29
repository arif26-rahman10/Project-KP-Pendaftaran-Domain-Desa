import 'package:flutter/material.dart';
import '../../widgets/admin_bottom_nav.dart';

class FakturPage extends StatelessWidget {
  const FakturPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faktur"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),

      body: const Center(child: Text("Halaman Faktur (Coming Soon)")),
    );
  }
}
