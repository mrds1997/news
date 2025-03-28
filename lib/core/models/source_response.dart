

import 'package:news/core/models/news_entity.dart';
import 'package:news/core/models/source.dart';
import 'package:news/core/models/source_entity.dart';

import 'article.dart';
import 'error_entity.dart';

class SourceResponse extends SourceEntity {

  SourceResponse({required this.status, required this.sources}) : super(status, sources);

  final String status;
  final List<Source> sources;


  factory SourceResponse.fromJson(Map<String, dynamic> json) =>
      SourceResponse(
        status : json["status"],
        sources: (json["sources"] as List<dynamic>?)
            ?.map((article) => Source.fromJson(article as Map<String, dynamic>))
            .toList()
            ?? [],
      );
}


