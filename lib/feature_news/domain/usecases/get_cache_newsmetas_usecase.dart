
import 'package:news/core/models/article.dart';
import 'package:news/core/models/news_entity.dart';
import 'package:news/core/models/news_meta.dart';
import 'package:news/core/params/news_param.dart';
import 'package:news/feature_news/domain/repositories/local_storage_repository.dart';
import 'package:news/feature_news/domain/repositories/news_repository.dart';

import '../../../core/resources/data_state.dart';
import '../../../core/use_cases/use_case.dart';


class GetCacheNewsMetasUseCase extends NoParamUseCase<DataState<List<NewsMeta>>>{

  LocalStorageNewsRepository repository;

  GetCacheNewsMetasUseCase(this.repository);

  @override
  Future<DataState<List<NewsMeta>>> call() async {
   return await repository.getCacheNewsMeta();
  }

}