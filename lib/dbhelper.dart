import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'activity_database.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activityName TEXT,
        durationInSeconds INTEGER,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertActivity(Map<String, dynamic> activity) async {
    Database db = await instance.database;
    return await db.insert('activities', activity);
  }

  Future<List<Map<String, dynamic>>> getAllActivities() async {
    Database db = await instance.database;
    return await db.query('activities', orderBy: 'timestamp DESC');
  }

  Future<int> deleteActivity(int id) async {
    Database db = await instance.database;
    return await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }
}
