import 'dart:convert';
import 'dart:developer';

//import 'package:dio/dio.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;
import 'package:news/core/models/news_entity.dart';
import 'package:news/core/models/news_response.dart';
import 'package:news/core/models/source_entity.dart';
import 'package:news/core/models/source_response.dart';
import 'package:news/core/params/news_param.dart';
import 'package:news/core/resources/data_state.dart';
import 'package:news/feature_news/domain/repositories/news_repository.dart';

import '../../../core/models/error_response.dart';
import '../../../core/utils/constants.dart';
import '../data_source/remote/api_provider_news.dart';


class NewsRepositoryImpl extends NewsRepository {
  ApiProviderNews apiProviderNews;

  NewsRepositoryImpl(this.apiProviderNews);


  @override
  Future<DataState<NewsEntity>> getAllNews(NewsParam param) async{
    try{
      http.Response response = await apiProviderNews.getAllNews(param);
      if (response.statusCode == 200) {
        return DataSuccess(NewsResponse.fromJson(jsonDecode(response.body)));
      } else {
        return DataFailed(response.body.isEmpty ? "Error" : ErrorResponseModel.fromJson(jsonDecode(response.body)).message!);
      }
    } catch(e){
      print('Error getAllNews: ${e.toString()}');
      return DataFailed(Constants.apiExceptionMsg);
    }
  }

  @override
  Future<DataState<NewsEntity>> getTopHeadlineNewsByCategory(NewsParam param) async {
    try{
      http.Response response = await apiProviderNews.getTopHeadlineNewsByCategory(param);
      if (response.statusCode == 200) {
        return DataSuccess(NewsResponse.fromJson(jsonDecode(response.body)));
      } else {
        return DataFailed(response.body.isEmpty ? "Error" : ErrorResponseModel.fromJson(jsonDecode(response.body)).message!);
      }
    } catch(e){
      print('Error getAllNews: ${e.toString()}');
      return DataFailed(Constants.apiExceptionMsg);
    }
  }

  @override
  Future<DataState<NewsEntity>> getTopHeadlineNewsBySource(NewsParam param) async {
    try{
      http.Response response = await apiProviderNews.getTopHeadlineNewsBySource(param);
      if (response.statusCode == 200) {
        return DataSuccess(NewsResponse.fromJson(jsonDecode(response.body)));
      } else {
        return DataFailed(response.body.isEmpty ? "Error" : ErrorResponseModel.fromJson(jsonDecode(response.body)).message!);
      }
    } catch(e){
      print('Error getTopHeadlineNewsBySource: ${e.toString()}');
      return DataFailed(Constants.apiExceptionMsg);
    }
  }

  @override
  Future<DataState<NewsEntity>> getTopHeadlineNews(NewsParam param) async {
    try{
      http.Response response = await apiProviderNews.getTopHeadlineNews(param);
      if (response.statusCode == 200) {
        return DataSuccess(NewsResponse.fromJson(jsonDecode(response.body)));
      } else {
        return DataFailed(response.body.isEmpty ? "Error" : ErrorResponseModel.fromJson(jsonDecode(response.body)).message!);
      }
    } catch(e){
      print('Error getTopHeadlineNews: ${e.toString()}');
      return DataFailed(Constants.apiExceptionMsg);
    }
  }

  @override
  Future<DataState<SourceEntity>> getSources(NewsParam param) async {
    try{
      http.Response response = await apiProviderNews.getSources(param);
      if (response.statusCode == 200) {
        return DataSuccess(SourceResponse.fromJson(jsonDecode(response.body)));
      } else {
        return DataFailed(response.body.isEmpty ? "Error" : ErrorResponseModel.fromJson(jsonDecode(response.body)).message!);
      }
    } catch(e){
      print('Error getTopHeadlineNews: ${e.toString()}');
      return DataFailed(Constants.apiExceptionMsg);
    }
  }
}
