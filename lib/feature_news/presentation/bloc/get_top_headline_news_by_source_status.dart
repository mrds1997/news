
import 'package:news/core/models/news_entity.dart';

abstract class GetTopHeadlineNewsBySourceStatus {}

class GetTopHeadlineNewsBySourceSuccess extends GetTopHeadlineNewsBySourceStatus {
  NewsEntity newsEntity;
  GetTopHeadlineNewsBySourceSuccess(this.newsEntity);
}

class GetTopHeadlineNewsBySourceNoAction extends GetTopHeadlineNewsBySourceStatus{}

class GetTopHeadlineNewsBySourceLoading extends GetTopHeadlineNewsBySourceStatus {}

class GetTopHeadlineNewsBySourceError extends GetTopHeadlineNewsBySourceStatus {
  String? error;
  GetTopHeadlineNewsBySourceError(this.error);
}
