import 'package:flutter/material.dart';

class Intropage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/mod-image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Image.asset(
                    'images/logoRPIC.png', 
                    width: 50, 
                    height: 50,
                  ),
                  SizedBox(width: 10), 
                  Text(
                    "RPIC",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.all(50),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFF15162F),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Selamat Datang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Lakukan Reservasi PC mu..',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF61647D),
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 52, 
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login'); 
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF640EF1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
