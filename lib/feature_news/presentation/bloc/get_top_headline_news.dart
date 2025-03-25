
import 'package:news/core/models/news_entity.dart';

abstract class GetTopHeadlineNewsStatus {}

class GetTopHeadlineNewsSuccess extends GetTopHeadlineNewsStatus {
  NewsEntity newsEntity;
  GetTopHeadlineNewsSuccess(this.newsEntity);
}

class GetTopHeadlineNewsNoAction extends GetTopHeadlineNewsStatus{}

class GetTopHeadlineNewsLoading extends GetTopHeadlineNewsStatus {}

class GetTopHeadlineNewsError extends GetTopHeadlineNewsStatus {
  String? error;
  GetTopHeadlineNewsError(this.error);
}
