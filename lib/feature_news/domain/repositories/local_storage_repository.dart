

import 'package:news/core/models/article.dart';
import 'package:news/core/models/news_meta.dart';

import '../../../core/params/write_localstorage_param.dart';
import '../../../core/resources/data_state.dart';

abstract class LocalStorageNewsRepository {
  Future<DataState<String>> readStorageData(String key);
  Future<DataState<String?>> writeStorageData(WriteLocalStorageParam param);
  Future<DataState<String?>> deleteStorageData(String key);
  Future<DataState<int>> saveArticle(Article article);
  Future<DataState<bool>> isArticleSaved(String articleId);
  Future<DataState<List<Article>>> getCashedArticles();
  Future<DataState<bool>> saveNewsMeta(NewsMeta newsMeta);
  Future<DataState<List<NewsMeta>>> getCacheNewsMeta();
}
