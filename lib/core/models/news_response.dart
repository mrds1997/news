

import 'package:news/core/models/news_entity.dart';

import 'article.dart';
import 'error_entity.dart';

class NewsResponse extends NewsEntity {

  NewsResponse({required this.status, required this.totalResults, required this.articles}) : super(status, totalResults, articles);

  final String status;
  final int totalResults;
  final List<Article> articles;


  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      NewsResponse(
        status : json["status"],
        totalResults: json["totalResults"],
        articles: (json["articles"] as List<dynamic>?)
            ?.map((article) => Article.fromJson(article as Map<String, dynamic>))
            .toList()
            ?? [],
      );
}


