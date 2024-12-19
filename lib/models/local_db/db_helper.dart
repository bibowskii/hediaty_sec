import 'package:hediaty_sec/models/data/collections.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_users.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Check if tables already exist, create if not
    await _createUserTable(db);
    await _createEventTable(db);
    await _createGiftsTable(db);
    await _createFriendsTable(db);
  }

  Future<void> _createUserTable(Database db) async {
    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS ${collections().user} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        preferences TEXT
      )
    ''');
  }

  Future<void> _createEventTable(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON;'); // Enable foreign key constraints

    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS ${collections().event} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT,
        description TEXT,
        UserID TEXT,
        category TEXT
      )
    ''');
  }

  Future<void> _createGiftsTable(Database db) async {
    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS ${collections().gifts} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        event_id TEXT,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createFriendsTable(Database db) async {
    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS ${collections().friends} (
        user_id TEXT,
        friend_id TEXT,
        PRIMARY KEY (user_id, friend_id),
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
        FOREIGN KEY (friend_id) REFERENCES Users (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle upgrades if needed in the future
    // You can add logic for migrations here
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> queryById(String table, String id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> update(String table, String id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String table, String id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> queryByAttribute(
      String table,
      String attribute,
      dynamic value,
      ) async {
    final db = await database;
    return await db.query(
      table,
      where: '$attribute = ?',
      whereArgs: [value],
    );
  }

  Future<void> deleteByAttributes(
      String table,
      Map<String, dynamic> conditions,
      ) async {
    final db = await database;
    String whereClause = conditions.keys.map((key) => '$key = ?').join(' AND ');
    List<dynamic> whereArgs = conditions.values.toList();
    await db.delete(
      table,
      where: whereClause,
      whereArgs: whereArgs,
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }

  Future<void> deleteTable(String tableName) async {
    // Get a reference to the database
    final Database db = await database;

    // Delete the table
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }
}
