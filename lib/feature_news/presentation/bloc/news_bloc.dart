import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/core/models/article.dart';
import 'package:news/core/models/news_meta.dart';
import 'package:news/core/params/news_param.dart';
import 'package:news/feature_news/domain/usecases/get_news_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_by_category_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_usecase.dart';
import 'package:news/feature_news/presentation/bloc/get_all_news_status.dart';
import 'package:news/feature_news/presentation/bloc/get_cached_articles_status.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news_by_category_status.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news_by_source_status.dart';
import 'package:news/feature_news/presentation/bloc/save_article_status.dart';
import 'package:news/feature_news/presentation/bloc/save_newsmeta_status.dart';

import '../../../core/params/write_localstorage_param.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/utils/data_store_keys.dart';
import '../../domain/usecases/get_cache_articles_usecase.dart';
import '../../domain/usecases/get_cache_newsmetas_usecase.dart';
import '../../domain/usecases/get_sources_usecase.dart';
import '../../domain/usecases/get_top_headline_news_by_source_usecase.dart';
import '../../domain/usecases/is_article_saved_usecase.dart';
import '../../domain/usecases/read_localstorage_usecase.dart';
import '../../domain/usecases/save_article_usecase.dart';
import '../../domain/usecases/save_newsmeta_usecase.dart';
import '../../domain/usecases/write_localstorage_usecase.dart';
import 'get_cache_newsmetas_status.dart';
import 'get_sources_status.dart';
import 'is_article_saved_status.dart';

part 'news_event.dart';

part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  GetNewsUseCase getNewsUseCase;
  GetTopHeadlineNewsByCategoryUseCase getTopHeadlineNewsByCategoryUseCase;
  GetTopHeadlineNewsUseCase getTopHeadlineNewsUseCase;
  GetTopHeadlineNewsBySourceUseCase getTopHeadlineNewsBySourceUseCase;
  SaveArticleUseCase saveArticleUseCase;
  IsArticleSavedUseCase isArticleSavedUseCase;
  GetCacheArticlesUseCase getCashedArticlesUseCase;
  GetSourcesUseCase getSourcesUseCase;
  SaveNewsMetaUseCase saveNewsMetaUseCase;
  GetCacheNewsMetasUseCase getCacheNewsMetasUseCase;

  NewsBloc(this.getNewsUseCase,
      this.getTopHeadlineNewsByCategoryUseCase,
      this.getTopHeadlineNewsUseCase,
      this.getTopHeadlineNewsBySourceUseCase,
      this.saveArticleUseCase,
      this.isArticleSavedUseCase,
      this.getCashedArticlesUseCase,
      this.getSourcesUseCase,
      this.saveNewsMetaUseCase,
      this.getCacheNewsMetasUseCase)
      : super(NewsState(
            getAllNewsStatus: GetAllNewsNoAction(),
            getTopHeadlineNewsStatus: GetTopHeadlineNewsNoAction(),
            getTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategoryNoAction(),
            getTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceNoAction(),
            saveArticleStatus: SaveArticleNoAction(),
            isArticleSavedStatus: IsArticleSavedNoAction(),
            getCacheArticlesStatus: GetCachedArticlesNoAction(),
            getSourcesStatus: GetSourcesNoAction(),
            saveNewsMetaStatus: SaveNewsMetaNoAction(),
            getCacheNewsMetasStatus: GetCacheNewsMetasNoAction()
  )) {

    on<GetAllNewsEvent>((event, emit) async {
      emit(state.copyWith(newGetAllNewsStatus: GetAllNewsLoading()));
      DataState dataState = await getNewsUseCase(event.param);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newGetAllNewsStatus: GetAllNewsSuccess(dataState.data)));
      } else {
        emit(state.copyWith(newGetAllNewsStatus: GetAllNewsError(dataState.error)));
      }
    });

    on<GetTopHeadLineNewsByCategoryEvent>((event, emit) async {
      emit(state.copyWith(newGetCashedArticlesStatus: GetCachedArticlesNoAction()));
      emit(state.copyWith(newGetTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceNoAction()));
      emit(state.copyWith(newGetTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategoryLoading()));
      DataState dataState = await getTopHeadlineNewsByCategoryUseCase(event.param);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newGetTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategorySuccess(dataState.data)));
      } else {
        print('error category event');
        emit(state.copyWith(newGetTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategoryError(dataState.error)));
        emit(state.copyWith(newGetTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategoryNoAction()));
      }
    });

    on<GetTopHeadLineNewsBySourceEvent>((event, emit) async {
      emit(state.copyWith(newGetTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategoryNoAction()));
      emit(state.copyWith(newGetTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceLoading()));
      DataState dataState = await getTopHeadlineNewsBySourceUseCase(event.param);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newGetTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceSuccess(dataState.data)));
      } else {
        emit(state.copyWith(newGetTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceError(dataState.error)));
        emit(state.copyWith(newGetTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceNoAction()));
      }
    });

    on<SaveArticleEvent>((event, emit) async {
      DataState dataState = await saveArticleUseCase(event.param);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newSaveArticleStatus: SaveArticleSuccess(dataState.data)));
      } else {
        emit(state.copyWith(newSaveArticleStatus: SaveArticleError(dataState.error)));
      }
      emit(state.copyWith(newIsArticleSavedStatus: IsArticleSavedNoAction()));
    });

    on<IsArticleSavedEvent>((event, emit) async {
      emit(state.copyWith(newIsArticleSavedStatus: IsArticleSavedLoading()));
      DataState dataState = await isArticleSavedUseCase(event.param);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newIsArticleSavedStatus: IsArticleSavedSuccess(dataState.data)));
      } else {
        emit(state.copyWith(newIsArticleSavedStatus: IsArticleSavedError(dataState.error)));
      }
    });

    on<GetCacheArticlesEvent>((event, emit) async {
      emit(state.copyWith(newGetCashedArticlesStatus: GetCachedArticlesLoading()));
      DataState dataState = await getCashedArticlesUseCase();
      if (dataState is DataSuccess) {
        emit(state.copyWith(newGetCashedArticlesStatus: GetCachedArticlesSuccess(dataState.data)));
      } else {
        emit(state.copyWith(newGetCashedArticlesStatus: GetCachedArticlesError(dataState.error)));
      }
    });

    on<GetSourcesEvent>((event, emit) async {
      emit(state.copyWith(newGetSourcesStatus: GetSourcesLoading()));
      DataState dataState = await getSourcesUseCase(event.param);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newGetSourcesStatus: GetSourcesSuccess(dataState.data)));
      } else {
        emit(state.copyWith(newGetSourcesStatus: GetSourcesError(dataState.error)));
      }
      emit(state.copyWith(newGetSourcesStatus: GetSourcesNoAction()));
    });

    on<SaveNewsMetaEvent>((event, emit) async {
      emit(state.copyWith(newSaveNewsMetaStatus: SaveNewsMetaLoading()));
      DataState dataState = await saveNewsMetaUseCase(event.param);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newSaveNewsMetaStatus: SaveNewsMetaSuccess(dataState.data)));
      } else {
        emit(state.copyWith(newSaveNewsMetaStatus: SaveNewsMetaError(dataState.error)));
      }
      emit(state.copyWith(newSaveNewsMetaStatus: SaveNewsMetaNoAction()));
    });

    on<GetCacheNewsMetasEvent>((event, emit) async {
      emit(state.copyWith(newGetCacheNewsMetasStatus: GetCacheNewsMetasLoading()));
      DataState dataState = await getCacheNewsMetasUseCase();
      if (dataState is DataSuccess) {
        emit(state.copyWith(newGetCacheNewsMetasStatus: GetCacheNewsMetasSuccess(dataState.data)));
      } else {
        emit(state.copyWith(newGetCacheNewsMetasStatus: GetCacheNewsMetasError(dataState.error)));
      }
      emit(state.copyWith(newGetCacheNewsMetasStatus: GetCacheNewsMetasNoAction()));
    });
  }
}
