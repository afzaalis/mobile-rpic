import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/user_provider.dart'; 
import '../model/user.dart';
import './signup.dart';
import '../components/bottom_nav_bar.dart';
import 'adminPages/mainPageAdmin.dart'; 

// Instansiasi FlutterSecureStorage
final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  // Fungsi login
  Future<void> _login() async {
    final String url = 'http://10.0.2.2:3000/api/auth/login'; 

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    // Log response untuk debugging
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody); // Log respons untuk melihat apakah ada error detailnya

      final user = responseBody['user'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome back, ${user['name']}')),
      );

      // Menyimpan data pengguna ke UserProvider
      Provider.of<UserProvider>(context, listen: false).setUser(User(
        id: user['id'],
        name: user['name'],
        email: user['email'],
        role: user['role'],
      ));

      // Simpan userId dan role ke SharedPreferences atau flutter_secure_storage
      await _secureStorage.write(key: 'userId', value: user['id'].toString());
      await _secureStorage.write(key: 'role', value: user['role']);

      // Periksa role user dan arahkan ke halaman yang sesuai
      if (user['role'] == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminMainPage()),
        );
      } else if (user['role'] == 'customer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid user role.')),
        );
      }
    } else {
      final responseBody = json.decode(response.body);
      String message = responseBody['message'] ?? 'Invalid email or password.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // Periksa status login saat aplikasi dimulai
  Future<void> _checkLoginStatus() async {
    final userId = await _secureStorage.read(key: 'userId');
    final role = await _secureStorage.read(key: 'role');

    if (userId != null && role != null) {
      // Jika sudah login, arahkan ke halaman yang sesuai berdasarkan role
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminMainPage()),
        );
      } else if (role == 'customer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();  
  }

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
        child: Center(
          child: Container(
            width: 345,
            height: 478,
            decoration: BoxDecoration(
              color: Color(0xFF15162F),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Email/Username',
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login, // Memanggil fungsi login saat tombol ditekan
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
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: Text(
                      'Don\'t Have Account? Click here',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
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
