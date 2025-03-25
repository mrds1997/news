import 'package:equatable/equatable.dart';

import 'article.dart';


class NewsEntity extends Equatable{
  final String status;
  final int totalResults;
  final List<Article> articles;


  const NewsEntity(this.status, this.totalResults, this.articles);

  @override
  List<Object?> get props => [status, totalResults, articles];

}