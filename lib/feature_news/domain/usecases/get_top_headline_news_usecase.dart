
import 'package:news/core/models/news_entity.dart';
import 'package:news/core/params/news_param.dart';
import 'package:news/feature_news/domain/repositories/news_repository.dart';

import '../../../core/resources/data_state.dart';
import '../../../core/use_cases/use_case.dart';


class GetTopHeadlineNewsUseCase extends UseCase<DataState<NewsEntity>, NewsParam>{

  NewsRepository repository;

  GetTopHeadlineNewsUseCase(this.repository);

  @override
  Future<DataState<NewsEntity>> call(NewsParam param) async {
    return await repository.getTopHeadlineNews(param);
  }



}