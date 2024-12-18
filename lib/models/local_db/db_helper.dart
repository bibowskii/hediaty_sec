import 'package:hediaty_sec/models/data/collections.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteService {
  static final SQLiteService _instance = SQLiteService._internal();
  factory SQLiteService() => _instance;
  SQLiteService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE ${collections().user} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        preferences TEXT
      )
    '''
    );

    // Events table
    await db.execute('''
      CREATE TABLE ${collections().event} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT,
        description TEXT,
        user_id TEXT,
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE
      )
    '''
    );

    // Gifts table
    await db.execute('''
      CREATE TABLE ${collections().gifts} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        event_id TEXT,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE
      )
    '''
    );

    // Friends table
    await db.execute('''
      CREATE TABLE ${collections().friends} (
        user_id TEXT,
        friend_id TEXT,
        PRIMARY KEY (user_id, friend_id),
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
        FOREIGN KEY (friend_id) REFERENCES Users (id) ON DELETE CASCADE
      )
    '''
    );
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
}
