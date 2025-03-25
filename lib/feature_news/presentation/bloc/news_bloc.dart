import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/core/params/news_param.dart';
import 'package:news/feature_news/domain/usecases/get_news_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_by_category_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_usecase.dart';
import 'package:news/feature_news/presentation/bloc/get_all_news_status.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news_by_category_status.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news_by_source_status.dart';

import '../../../core/params/write_localstorage_param.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/utils/data_store_keys.dart';
import '../../domain/usecases/get_top_headline_news_by_source_usecase.dart';
import '../../domain/usecases/read_localstorage_usecase.dart';
import '../../domain/usecases/write_localstorage_usecase.dart';

part 'news_event.dart';

part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  GetNewsUseCase getNewsUseCase;
  GetTopHeadlineNewsByCategoryUseCase getTopHeadlineNewsByCategoryUseCase;
  GetTopHeadlineNewsUseCase getTopHeadlineNewsUseCase;
  GetTopHeadlineNewsBySourceUseCase getTopHeadlineNewsBySourceUseCase;


  NewsBloc(this.getNewsUseCase,this.getTopHeadlineNewsByCategoryUseCase, this.getTopHeadlineNewsUseCase, this.getTopHeadlineNewsBySourceUseCase)
      : super(NewsState(
            getAllNewsStatus: GetAllNewsNoAction(),
            getTopHeadlineNewsStatus: GetTopHeadlineNewsNoAction(),
            getTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategoryNoAction(),
            getTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceNoAction()

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
      emit(state.copyWith(newGetTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategoryLoading()));
      DataState dataState = await getTopHeadlineNewsByCategoryUseCase(event.param);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newGetTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategorySuccess(dataState.data)));
      } else {
        emit(state.copyWith(newGetTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategoryError(dataState.error)));
      }
      emit(state.copyWith(newGetTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceNoAction()));

    });

    on<GetTopHeadLineNewsBySourceEvent>((event, emit) async {
      emit(state.copyWith(newGetTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceLoading()));
      DataState dataState = await getTopHeadlineNewsBySourceUseCase(event.param);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newGetTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceSuccess(dataState.data)));
      } else {
        emit(state.copyWith(newGetTopHeadlineNewsBySourceStatus: GetTopHeadlineNewsBySourceError(dataState.error)));
      }
      emit(state.copyWith(newGetTopHeadlineNewsByCategoryStatus: GetTopHeadlineNewsByCategoryNoAction()));
    });



  }
}
