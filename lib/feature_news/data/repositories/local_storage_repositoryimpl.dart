



import 'package:news/core/models/article.dart';

import '../../../core/params/write_localstorage_param.dart';
import '../../../core/resources/data_state.dart';
import '../../domain/repositories/local_storage_repository.dart';
import '../data_source/local/local_data_provider_news.dart';

class LocalStorageNewsRepositoryImpl extends LocalStorageNewsRepository {
  LocalDataProviderNews localDataProviderNews;

  LocalStorageNewsRepositoryImpl(this.localDataProviderNews);

  @override
  Future<DataState<String?>> deleteStorageData(String key) async {
    try {
      await localDataProviderNews.deleteStorage(key);
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<String>> readStorageData(String key) async {
    try {
      String data = await localDataProviderNews.readStorage(key);
      return DataSuccess(data);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<String?>> writeStorageData(
      WriteLocalStorageParam param) async {
    try {
      await localDataProviderNews.writeStorage(param.key, param.value);
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<bool>> isArticleSaved(String articleId) async {
    try{
      bool isSaved = await localDataProviderNews.isArticleSaved(articleId);
      return DataSuccess(isSaved);
    } catch(e){
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<int>> saveArticle(Article article) async {
    try{
      int id = await localDataProviderNews.saveArticle(article);
      return DataSuccess(id);
    } catch(e){
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<List<Article>>> getCashedArticles() async {
    try{
      List<Article> articles = await localDataProviderNews.getCashedArticles();
      return DataSuccess(articles);
    } catch(e){
      return DataFailed(e.toString());
    }
  }
}
