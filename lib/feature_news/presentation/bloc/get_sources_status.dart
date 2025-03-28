
import 'package:news/core/models/news_entity.dart';
import 'package:news/core/models/source_entity.dart';

abstract class GetSourcesStatus {}

class GetSourcesSuccess extends GetSourcesStatus {
  SourceEntity sourceEntity;
  GetSourcesSuccess(this.sourceEntity);
}

class GetSourcesNoAction extends GetSourcesStatus{}

class GetSourcesLoading extends GetSourcesStatus {}

class GetSourcesError extends GetSourcesStatus {
  String? error;
  GetSourcesError(this.error);
}
