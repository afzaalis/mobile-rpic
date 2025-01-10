import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_profile.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName); // Menggunakan nama variabel dbName untuk path
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE user_profiles (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT,
      profileImage BLOB
    )
    ''');
  }

  // Fungsi untuk menyimpan profil dan gambar
  Future<int> saveUserProfile(String name, String email, File? imageFile) async {
    final db = await instance.database;
    List<int>? imageBytes;

    if (imageFile != null) {
      imageBytes = await imageFile.readAsBytes();
    }

    final data = {
      'name': name,
      'email': email,
      'profileImage': imageBytes,
    };

    return await db.insert('user_profiles', data);
  }

  // Fungsi untuk mengambil profil dan gambar
  Future<Map<String, dynamic>?> getUserProfile() async {
    final db = await instance.database;
    final result = await db.query('user_profiles', limit: 1);
    if (result.isNotEmpty) {
      final user = result.first;
      return {
        'name': user['name'],
        'email': user['email'],
        'profileImage': user['profileImage'],
      };
    }
    return null;
  }
}
