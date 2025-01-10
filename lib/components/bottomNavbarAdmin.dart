import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:rpic/pages/adminPages/adminHistory.dart';
import 'package:rpic/pages/adminPages/adminUserManagement.dart';
import 'package:rpic/pages/adminPages/mainPageAdmin.dart';

class MainPageAdmin extends StatefulWidget {
  @override
  _MainPageAdminState createState() => _MainPageAdminState();
}

class _MainPageAdminState extends State<MainPageAdmin> {
  int _activeIndex = 1; // Default index untuk halaman Home

  @override
  Widget build(BuildContext context) {
    // Daftar halaman untuk navigasi
    final List<Widget> _pages = [
      UserListPage(),
      AdminHomePage(),
      AdminHistoryPage(),
    ];

    // Scaffold untuk menampung halaman dan bottom navbar
    return Scaffold(
      backgroundColor: const Color(0xFF05051E),
      body: _pages.isNotEmpty ? _pages[_activeIndex] : const Center(child: Text("Page Not Found")),
      bottomNavigationBar: CircleNavBar(
        activeIndex: _activeIndex,
        activeIcons: const [
          Icon(Icons.person, color: Colors.white), // Ikon aktif User Management
          Icon(Icons.home, color: Colors.white), // Ikon aktif Home
          Icon(Icons.history, color: Colors.white), // Ikon aktif History
        ],
        inactiveIcons: const [
          Text("User", style: TextStyle(color: Colors.black)),
          Text("Home", style: TextStyle(color: Colors.black)),
          Text("History", style: TextStyle(color: Colors.black)),
        ],
        color: Colors.white,
        circleColor: Colors.blueAccent, // Warna lingkaran
        height: 60,
        circleWidth: 60,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Colors.black,
        circleShadowColor: Colors.deepPurple,
        elevation: 10,
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue, Colors.red],
        ),
        circleGradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue, Colors.red],
        ),
        onTap: (index) {
          // Perbarui halaman aktif saat navbar ditekan
          setState(() {
            _activeIndex = index;
          });
        },
      ),
    );
  }
}
