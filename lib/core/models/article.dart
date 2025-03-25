import 'package:news/core/models/source.dart';

class Article {
  final Source? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  Article(
      {this.source,
        this.author,
        this.title,
        this.description,
        this.url,
        this.urlToImage,
        this.publishedAt,
        this.content,
        });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'title': title,
      'description': description,
      'content': content,
      'publishAt': publishedAt,
      'source': source != null ? source?.name : "",
      'url': url,
      'author': author,
      'urlToImage': urlToImage,
    };
  }

  String get articleId {
    return source != null ? publishedAt!+source!.name! : publishedAt!;
  }
}