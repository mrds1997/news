
import 'package:news/core/models/news_entity.dart';

abstract class GetAllNewsStatus {}

class GetAllNewsSuccess extends GetAllNewsStatus {
  NewsEntity newsEntity;
  GetAllNewsSuccess(this.newsEntity);
}

class GetAllNewsNoAction extends GetAllNewsStatus{}

class GetAllNewsLoading extends GetAllNewsStatus {}

class GetAllNewsError extends GetAllNewsStatus {
  String? error;
  GetAllNewsError(this.error);
}
