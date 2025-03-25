
import 'package:news/core/models/news_entity.dart';

abstract class GetTopHeadlineNewsByCategoryStatus {}

class GetTopHeadlineNewsByCategorySuccess extends GetTopHeadlineNewsByCategoryStatus {
  NewsEntity newsEntity;
  GetTopHeadlineNewsByCategorySuccess(this.newsEntity);
}

class GetTopHeadlineNewsByCategoryNoAction extends GetTopHeadlineNewsByCategoryStatus{}

class GetTopHeadlineNewsByCategoryLoading extends GetTopHeadlineNewsByCategoryStatus {}

class GetTopHeadlineNewsByCategoryError extends GetTopHeadlineNewsByCategoryStatus {
  String? error;
  GetTopHeadlineNewsByCategoryError(this.error);
}
