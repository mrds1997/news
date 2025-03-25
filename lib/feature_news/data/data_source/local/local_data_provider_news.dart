import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/models/article.dart';
import '../../../../core/utils/database_helper.dart';

class LocalDataProviderNews {
  /*final SharedPreferences _storage;
  LocalDataProviderLogin(this._storage);*/
  SharedPreferences? _storage;

  Future<dynamic> readStorage(String key) async {
    _storage ??= await SharedPreferences.getInstance();
    String? value = _storage?.getString(key);
    return value ?? "";
  }

  Future<dynamic> deleteStorage(String key) async {
    _storage ??= await SharedPreferences.getInstance();
    await _storage?.remove(key);
    return;
  }

  Future<dynamic> writeStorage(String key, String value) async {
    _storage ??= await SharedPreferences.getInstance();
    await _storage?.setString(key, value);
    return;
  }

  Future<dynamic> deleteAllStorage() async {
    _storage ??= await SharedPreferences.getInstance();
    await _storage?.clear();
    return;
  }

  Future<bool> isArticleSaved(String articleId) async {
    Database db = await DatabaseHelper().database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM Article WHERE articleId = ?',
      [articleId],
    );
    int? count = Sqflite.firstIntValue(result);
    return count != null && count > 0;
  }

  Future<int> saveArticle(Article article) async {
    /*Database db = await DatabaseHelper().database;
    return await db.insert('RemindedHoliday', remindedHolidayModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);*/
    Database db = await DatabaseHelper().database;

    // Check if a record with the same holidayId exists
    List<Map<String, dynamic>> existingRecords = await db.query(
      'Article',
      where: 'articleId = ?',
      whereArgs: [article.articleId],
    );
    //debugger();
    if (existingRecords.isNotEmpty) {
      return await db.delete('Article', where: 'articleId = ?', whereArgs: [article.articleId]);
    } else {
      return db.insert('Article', article.toMap());

        /*await db.rawInsert(
          'INSERT INTO Article(articleId, title, description, content, publishAt, source, url) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416])*/;
    }

  }

}
