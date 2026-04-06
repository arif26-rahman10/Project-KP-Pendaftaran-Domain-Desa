import 'package:flutter/material.dart';
import '../main.dart';
import '../pages/home_page.dart';
import '../pages/domain/domain_page.dart';
import '../pages/faktur/faktur_page.dart';
import '../pages/users/profile_page.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final String fullName;
  final String username;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.fullName,
    required this.username,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget page;

    switch (index) {
      case 0:
        page = HomePage(fullName: fullName, username: username);
        break;
      case 1:
        page = DomainPage(fullName: fullName, username: username);
        break;
      case 2:
        page = FakturPage(fullName: fullName, username: username);
        break;
      case 3:
        page = ProfilePage(fullName: fullName, username: username);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isActive = currentIndex == index;

    return InkWell(
      onTap: () => _onTap(context, index),
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
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(0, 12, 0, bottomSafe > 0 ? bottomSafe : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home, 'Beranda', 0),
          _navItem(context, Icons.language, 'Domain', 1),
          _navItem(context, Icons.receipt_long, 'Faktur', 2),
          _navItem(context, Icons.person_outline, 'Profil', 3),
        ],
      ),
    );
  }
}
