part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetAllNewsEvent extends NewsEvent {
  NewsParam param;
  GetAllNewsEvent(this.param);
}
class GetTopHeadLineNewsByCategoryEvent extends NewsEvent {
  NewsParam param;
  GetTopHeadLineNewsByCategoryEvent(this.param);
}
class GetTopHeadLineNewsBySourceEvent extends NewsEvent {
  NewsParam param;
  GetTopHeadLineNewsBySourceEvent(this.param);
}
class GetTopHeadLineNewsEvent extends NewsEvent {
  NewsParam param;
  GetTopHeadLineNewsEvent(this.param);
}
class SaveArticleEvent extends NewsEvent {
  Article param;
  SaveArticleEvent(this.param);
}
class IsArticleSavedEvent extends NewsEvent {
  String param;
  IsArticleSavedEvent(this.param);
}

