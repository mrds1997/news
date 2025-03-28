import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:news/core/models/news_meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/models/article.dart';
import '../../../../core/utils/database_helper.dart';
import '../../../../core/utils/meta_type.dart';

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
    Database db = await DatabaseHelper().database;
    List<Map<String, dynamic>> existingRecords = await db.query(
      'Article',
      where: 'articleId = ?',
      whereArgs: [article.articleId],
    );
    if (existingRecords.isNotEmpty) {
      return await db.delete('Article', where: 'articleId = ?', whereArgs: [article.articleId]);
    } else {
      return db.insert('Article', article.toMap());
    }
  }

  Future<bool> saveNewsMeta(NewsMeta newsMeta) async {
    try{
      Database db = await DatabaseHelper().database;
      List<Map<String, dynamic>> existingRecords = await db.query(
        'NewsMeta',
        where: 'newsMetaId = ?',
        whereArgs: [newsMeta.id],
      );
      if (existingRecords.isEmpty) {
        await db.insert('NewsMeta', newsMeta.toMap());
      }
      return true;
    } catch(e){
        print('e:' + e.toString());
        return false;
    }
  }




  Future<List<NewsMeta>> getCacheNewsMeta() async {
    Database db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('NewsMeta');
    return List.generate(maps.length, (i) {
      return NewsMeta.fromMap(maps[i]);
    });

  }

  Future<List<Article>> getCashedArticles() async {
    Database db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('Article');
    return List.generate(maps.length, (i) {
      return Article.fromMap(maps[i]);
    });

  }

}
