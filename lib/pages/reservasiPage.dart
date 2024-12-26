import 'package:flutter/material.dart';
import 'package:rpic_mobile_beta/pages/betaPage.dart';
import 'package:rpic_mobile_beta/pages/drivingSimPage.dart';
import 'alphaPage.dart';

class Reservasipage extends StatelessWidget {
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
                    MaterialPageRoute(
                      builder: (context) => Alphapage(pcType: 'Alpha'),  // Mengirim tipe PC
                    ),
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
                    MaterialPageRoute(
                      builder: (context) => BetaPage( pcType: 'Beta'),  // Mengirim tipe PC
                    ),
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
                    MaterialPageRoute(
                      builder: (context) => DrivingPage(pcType: 'Driving Simulator'),  // Mengirim tipe PC
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
