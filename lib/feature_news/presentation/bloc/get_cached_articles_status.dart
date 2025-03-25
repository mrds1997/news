
import 'package:news/core/models/article.dart';
import 'package:news/core/models/news_entity.dart';

abstract class GetCachedArticlesStatus {}

class GetCachedArticlesSuccess extends GetCachedArticlesStatus {
  List<Article> articles;
  GetCachedArticlesSuccess(this.articles);
}

class GetCachedArticlesNoAction extends GetCachedArticlesStatus{}

class GetCachedArticlesLoading extends GetCachedArticlesStatus {}

class GetCachedArticlesError extends GetCachedArticlesStatus {
  String? error;
  GetCachedArticlesError(this.error);
}
