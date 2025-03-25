import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(join(path, 'database.db'), version: 5,
        onCreate: (Database db, int version) async {
          await db.execute('''
        CREATE TABLE Article(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          articleId TEXT,
          title TEXT,
          description TEXT,
          content TEXT,
          publishAt TEXT,
          source TEXT,
          url TEXT,
          author TEXT,
          urlToImage TEXT,
          )
      ''');
        });
  }
}
