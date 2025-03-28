import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:news/feature_news/data/data_source/remote/api_provider_news.dart';
import 'package:news/feature_news/data/repositories/local_storage_repositoryimpl.dart';
import 'package:news/feature_news/data/repositories/news_repositoryimpl.dart';
import 'package:news/feature_news/domain/repositories/local_storage_repository.dart';
import 'package:news/feature_news/domain/repositories/news_repository.dart';
import 'package:news/feature_news/domain/usecases/get_cache_newsmetas_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_news_usecase.dart';
import 'package:news/feature_news/domain/usecases/save_newsmeta_usecase.dart';
import 'package:news/feature_news/presentation/bloc/news_bloc.dart';

import 'feature_news/data/data_source/local/local_data_provider_news.dart';
import 'feature_news/domain/usecases/get_cache_articles_usecase.dart';
import 'feature_news/domain/usecases/get_sources_usecase.dart';
import 'feature_news/domain/usecases/get_top_headline_news_by_category_usecase.dart';
import 'feature_news/domain/usecases/get_top_headline_news_by_source_usecase.dart';
import 'feature_news/domain/usecases/get_top_headline_news_usecase.dart';
import 'feature_news/domain/usecases/is_article_saved_usecase.dart';
import 'feature_news/domain/usecases/save_article_usecase.dart';

GetIt locator = GetIt.instance;

setupNewsFeature() async {
  locator.registerSingleton<ApiProviderNews>(ApiProviderNews());

  locator.registerSingleton<NewsRepository>(NewsRepositoryImpl(locator()));

  locator.registerSingleton<GetNewsUseCase>(GetNewsUseCase(locator()));
  locator.registerSingleton<GetTopHeadlineNewsByCategoryUseCase>(
      GetTopHeadlineNewsByCategoryUseCase(locator()));
  locator.registerSingleton<GetTopHeadlineNewsUseCase>(
      GetTopHeadlineNewsUseCase(locator()));
  locator.registerSingleton<GetTopHeadlineNewsBySourceUseCase>(
      GetTopHeadlineNewsBySourceUseCase(locator()));
  locator.registerSingleton<GetSourcesUseCase>(GetSourcesUseCase(locator()));

  locator.registerSingleton<LocalDataProviderNews>(LocalDataProviderNews());
  locator.registerSingleton<LocalStorageNewsRepository>(
      LocalStorageNewsRepositoryImpl(locator()));
  locator.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(locator()));
  locator.registerSingleton<IsArticleSavedUseCase>(
      IsArticleSavedUseCase(locator()));
  locator.registerSingleton<GetCacheArticlesUseCase>(
      GetCacheArticlesUseCase(locator()));
  locator
      .registerSingleton<SaveNewsMetaUseCase>(SaveNewsMetaUseCase(locator()));
  locator.registerSingleton<GetCacheNewsMetasUseCase>(
      GetCacheNewsMetasUseCase(locator()));

  locator.registerSingleton<NewsBloc>(NewsBloc(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator()));
}
