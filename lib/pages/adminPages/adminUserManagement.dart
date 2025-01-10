import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rpic/pages/login.dart'; 
class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<dynamic>> _users;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _users = _fetchUsers();
  }

  Future<List<dynamic>> _fetchUsers() async {
    final url = "http://10.0.2.2:3000/api/users/users";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Fungsi logout
  Future<void> _logout() async {
    await _secureStorage.delete(key: 'userId');
    await _secureStorage.delete(key: 'role');
    
    // Arahkan ke halaman login setelah logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05051E),
      appBar: AppBar(
        title: const Text(
          'Registered Users',
          style: TextStyle(color: Colors.white),
        ),
         backgroundColor: Color(0xFF2C2D59),
        actions: [
          // Tombol logout di sebelah kanan AppBar
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
          iconTheme: IconThemeData(color: Colors.white), 
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: const Icon(Icons.person, color: Colors.blueAccent),
                  ),
                  title: Text(user['name'] ?? 'Unknown User'),
                  subtitle: Text(user['email'] ?? 'No Email'),
                  trailing: Text(
                    'ID: ${user['id']}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
