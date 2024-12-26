import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'adminBetaPage.dart';
import 'adminAlphaPage.dart';
import 'adminDrivingPage.dart';
import 'package:rpic_mobile_beta/main.dart';
import '../login.dart';

class AdminMainPage extends StatelessWidget {
  // Fungsi logout
  void _logout(BuildContext context) {
    MyApp.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF05051E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 18.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select your PC",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0XFF15162F),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Gambar alpha
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminAlphaPage()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 156,
                    child: Center(
                      child: Image.asset(
                        "images/imgPagePC/alpha.png",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width - 32,
                        height: 156,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),

                // Gambar beta
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminBetaPage()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 156,
                    child: Center(
                      child: Image.asset(
                        "images/imgPagePC/beta.png",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width - 32,
                        height: 156,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),

                // Gambar drive simulator
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDrivingSimulatorPage()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 156,
                    child: Center(
                      child: Image.asset(
                        "images/imgPagePC/drivesimulator.png",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width - 32,
                        height: 156,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Tombol logout di bawah
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _logout(context); // Memanggil fungsi logout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: Text(
                        "Logout",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
