
import 'package:news/core/models/news_entity.dart';

abstract class SaveArticleStatus {}

class SaveArticleSuccess extends SaveArticleStatus {
  int id;
  SaveArticleSuccess(this.id);
}

class SaveArticleNoAction extends SaveArticleStatus{}

class SaveArticleLoading extends SaveArticleStatus {}

class SaveArticleError extends SaveArticleStatus {
  String? error;
  SaveArticleError(this.error);
}
