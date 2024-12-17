import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  // Singleton instance
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  // Database instance
  static Database? _database;

  // Database getter
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  // Create tables
  Future<void> _createTables(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        preferences TEXT
      )
    ''');

    // Events table
    await db.execute('''
      CREATE TABLE Events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT,
        description TEXT,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE
      )
    ''');

    // Gifts table
    await db.execute('''
      CREATE TABLE Gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        event_id INTEGER,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE
      )
    ''');

    // Friends table
    await db.execute('''
      CREATE TABLE Friends (
        user_id INTEGER,
        friend_id INTEGER,
        PRIMARY KEY (user_id, friend_id),
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
        FOREIGN KEY (friend_id) REFERENCES Users (id) ON DELETE CASCADE
      )
    ''');
  }

  // Insert User
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('Users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert Event
  Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    return await db.insert('Events', event, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert Gift
  Future<int> insertGift(Map<String, dynamic> gift) async {
    final db = await database;
    return await db.insert('Gifts', gift, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert Friend
  Future<int> insertFriend(Map<String, dynamic> friend) async {
    final db = await database;
    return await db.insert('Friends', friend, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get Users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('Users');
  }

  // Get Events by User ID
  Future<List<Map<String, dynamic>>> getEventsByUser(int userId) async {
    final db = await database;
    return await db.query('Events', where: 'user_id = ?', whereArgs: [userId]);
  }

  // Get Gifts by Event ID
  Future<List<Map<String, dynamic>>> getGiftsByEvent(int eventId) async {
    final db = await database;
    return await db.query('Gifts', where: 'event_id = ?', whereArgs: [eventId]);
  }

  // Get Friends of a User
  Future<List<Map<String, dynamic>>> getFriends(int userId) async {
    final db = await database;
    return await db.query('Friends', where: 'user_id = ?', whereArgs: [userId]);
  }

  // Delete User
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('Users', where: 'id = ?', whereArgs: [id]);
  }

  // Delete Event
  Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db.delete('Events', where: 'id = ?', whereArgs: [id]);
  }

  // Delete Gift
  Future<int> deleteGift(int id) async {
    final db = await database;
    return await db.delete('Gifts', where: 'id = ?', whereArgs: [id]);
  }

  // Delete Friend
  Future<int> deleteFriend(int userId, int friendId) async {
    final db = await database;
    return await db.delete(
      'Friends',
      where: 'user_id = ? AND friend_id = ?',
      whereArgs: [userId, friendId],
    );
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
