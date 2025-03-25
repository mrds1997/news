

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:news/core/params/news_param.dart';

import '../../../../core/utils/api_access.dart';
import '../../../../core/utils/constants.dart';

class ApiProviderNews {
  final baseUrl = Constants.baseUrl;
  final apiKey = Constants.apiKey;

 /* Future<dynamic> getSources(NewsParam param) async {
    try {
      var response = await ApiAccess.instance.makeHttpRequest("$baseUrl/top-headlines/sources", method: Method.GET, params: {
        "language": param.language,
      });
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }*/

  Future<dynamic> getAllNews(NewsParam param) async {
    try {
      var response = await ApiAccess.instance.makeHttpRequest("$baseUrl/everything", method: Method.GET, params: {
        "language": param.language,
        "q":param.query,
        "apiKey": apiKey

      });
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<dynamic> getTopHeadlineNewsByCategory(NewsParam param) async {
    try {
      var response = await ApiAccess.instance.makeHttpRequest("$baseUrl/top-headlines", method: Method.GET, params: {
        "language": param.language,
        "category": param.category,
        "apiKey": apiKey
      });
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<dynamic> getTopHeadlineNewsBySource(NewsParam param) async {
    try {
      var response = await ApiAccess.instance.makeHttpRequest("$baseUrl/top-headlines", method: Method.GET, params: {
        "language": param.language,
        "sources": param.source,
        "apiKey": apiKey,

      });
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<dynamic> getTopHeadlineNews(NewsParam param) async {
    try {
      var response = await ApiAccess.instance.makeHttpRequest("$baseUrl/top-headlines", method: Method.GET, params: {
        "language": param.language,
        "apiKey": apiKey,
        "pageSize": param.pageSize.toString(),
        "sources":"bbc-news,abc-news"
        //"page":param.page.toString()
      });
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

