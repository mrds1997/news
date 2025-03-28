import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/news_meta.dart';
import 'meta_type.dart';

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
    return await openDatabase(
        join(path, 'database.db'), version: 2,
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
        urlToImage TEXT
      );
      ''');

     await db.execute('''
      CREATE TABLE NewsMeta(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        newsMetaId TEXT,
        type INTEGER
      );
      ''');

      await insertDefaultNewsMetas(db);
        });


  }


  Future<bool> insertDefaultNewsMetas(Database db) async {
    try{
      List<NewsMeta> defaultNewsMetas = [
        NewsMeta(name: 'Business', id: 'business', metaType: MetaType.CATEGORY, isSelected: true),
        NewsMeta(name: 'Entertainment', id: 'entertainment', metaType: MetaType.CATEGORY, isSelected: false),
        NewsMeta(name: 'General', id: 'general', metaType: MetaType.CATEGORY, isSelected: false),
        NewsMeta(name: 'Health', id: 'health', metaType: MetaType.CATEGORY, isSelected: false),
        NewsMeta(name: 'Science', id: 'science', metaType: MetaType.CATEGORY, isSelected: false),
        NewsMeta(name: 'Sports', id: 'sports', metaType: MetaType.CATEGORY, isSelected: false),
        NewsMeta(name: 'Technology', id: 'technology', metaType: MetaType.CATEGORY, isSelected: false),
      ];

      for(int i = 0; i < defaultNewsMetas.length; i++){
        List<Map<String, dynamic>> existingRecords = await db.query(
          'NewsMeta',
          where: 'newsMetaId = ?',
          whereArgs: [defaultNewsMetas[i].id],
        );
        if (existingRecords.isEmpty) {
          await db.insert('NewsMeta', defaultNewsMetas[i].toMap());
        }
      }

      return true;
    } catch(e){
      print('e:' + e.toString());
      return false;
    }
  }
}
