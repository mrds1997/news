
import 'package:news/core/models/news_entity.dart';

abstract class IsArticleSavedStatus {}

class IsArticleSavedSuccess extends IsArticleSavedStatus {
  bool isSaved;
  IsArticleSavedSuccess(this.isSaved);
}

class IsArticleSavedNoAction extends IsArticleSavedStatus{}

class IsArticleSavedLoading extends IsArticleSavedStatus {}

class IsArticleSavedError extends IsArticleSavedStatus {
  String? error;
  IsArticleSavedError(this.error);
}
