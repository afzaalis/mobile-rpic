import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tokens(id INTEGER PRIMARY KEY AUTOINCREMENT, token TEXT)',
        );
      },
    );
  }

  Future<void> insertToken(String token) async {
    final db = await database;
    await db.insert(
      'tokens',
      {'token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getTokens() async {
    final db = await database;
    final result = await db.query('tokens');
    return result.map((row) => row['token'] as String).toList();
  }

  Future<void> deleteTokens() async {
    final db = await database;
    await db.delete('tokens');
  }
}
