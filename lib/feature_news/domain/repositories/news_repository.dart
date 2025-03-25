import 'package:firebase_auth/firebase_auth.dart';
import 'package:news/core/models/news_entity.dart';




import '../../../core/params/news_param.dart';
import '../../../core/resources/data_state.dart';

abstract class NewsRepository{
  Future<DataState<NewsEntity>> getAllNews(NewsParam param);
  Future<DataState<NewsEntity>> getTopHeadlineNewsByCategory(NewsParam param);
  Future<DataState<NewsEntity>> getTopHeadlineNewsBySource(NewsParam param);
  Future<DataState<NewsEntity>> getTopHeadlineNews(NewsParam param);
}