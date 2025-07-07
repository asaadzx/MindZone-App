// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'user_database.db');

    return await openDatabase(
      path,
      version: 2, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, 
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT UNIQUE, profilePicturePath TEXT)', // Add profilePicturePath column and UNIQUE constraint on email
    );
  }

  // Add onUpgrade method to handle database schema changes
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN profilePicturePath TEXT');
      // Add UNIQUE constraint on email if it doesn't exist (optional, but good practice)
      // Note: Adding UNIQUE constraint to an existing column with duplicate values will fail.
      // You might need more complex migration logic if duplicates are possible.
      // For simplicity, assuming email is already unique or will be handled by Firebase.
    }
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser() async {
    final db = await database;
    // Assuming we only store one user at a time in SQLite for the logged-in user
    final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateUserProfilePicture(String email, String profilePicturePath) async {
    final db = await database;
    await db.update(
      'users',
      { 'profilePicturePath': profilePicturePath },
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('users');
  }
}
