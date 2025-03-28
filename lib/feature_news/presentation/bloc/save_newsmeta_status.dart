
import 'package:news/core/models/news_entity.dart';

abstract class SaveNewsMetaStatus {}

class SaveNewsMetaSuccess extends SaveNewsMetaStatus {
  bool result;
  SaveNewsMetaSuccess(this.result);
}

class SaveNewsMetaNoAction extends SaveNewsMetaStatus{}

class SaveNewsMetaLoading extends SaveNewsMetaStatus {}

class SaveNewsMetaError extends SaveNewsMetaStatus {
  String? error;
  SaveNewsMetaError(this.error);
}
