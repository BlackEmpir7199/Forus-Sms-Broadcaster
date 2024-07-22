import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sms_broadcaster.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE phone_numbers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone_no TEXT,
        location TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE broadcast_requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone_no TEXT,
        status TEXT,
        timestamp TEXT
      )
    ''');
  }

  // Insert a phone number
  Future<void> insertNumber(Map<String, dynamic> number) async {
    final db = await database;
    await db.insert('phone_numbers', number, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all phone numbers
  Future<List<Map<String, dynamic>>> getNumbers() async {
    final db = await database;
    return await db.query('phone_numbers');
  }

  // Delete a phone number by ID
  Future<void> deleteNumber(int id) async {
    final db = await database;
    await db.delete('phone_numbers', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all phone numbers
  Future<void> deleteAllNumbers() async {
    final db = await database;
    await db.delete('phone_numbers');
  }

  // Insert a broadcast request
  Future<void> insertBroadcastRequest(Map<String, dynamic> request) async {
    final db = await database;
    await db.insert('broadcast_requests', request, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get messages for a particular number
  Future<List<Map<String, dynamic>>> getMessagesForNumber(String phoneNo) async {
    final db = await database;
    return await db.query('broadcast_requests', where: 'phone_no = ?', whereArgs: [phoneNo]);
  }
}
