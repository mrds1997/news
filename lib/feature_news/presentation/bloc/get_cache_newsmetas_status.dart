
import 'package:news/core/models/article.dart';
import 'package:news/core/models/news_entity.dart';
import 'package:news/core/models/news_meta.dart';

abstract class GetCacheNewsMetasStatus {}

class GetCacheNewsMetasSuccess extends GetCacheNewsMetasStatus {
  List<NewsMeta> newsMetas;
  GetCacheNewsMetasSuccess(this.newsMetas);
}

class GetCacheNewsMetasNoAction extends GetCacheNewsMetasStatus{}

class GetCacheNewsMetasLoading extends GetCacheNewsMetasStatus {}

class GetCacheNewsMetasError extends GetCacheNewsMetasStatus {
  String? error;
  GetCacheNewsMetasError(this.error);
}
