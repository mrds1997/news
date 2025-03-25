part of 'news_bloc.dart';

class NewsState {
  final GetAllNewsStatus getAllNewsStatus;
  final GetTopHeadlineNewsByCategoryStatus getTopHeadlineNewsByCategoryStatus;
  final GetTopHeadlineNewsStatus getTopHeadlineNewsStatus;
  final GetTopHeadlineNewsBySourceStatus getTopHeadlineNewsBySourceStatus;

  NewsState({
    required this.getAllNewsStatus,
    required this.getTopHeadlineNewsByCategoryStatus,
    required this.getTopHeadlineNewsStatus,
    required this.getTopHeadlineNewsBySourceStatus
  });

  NewsState copyWith({
    GetAllNewsStatus? newGetAllNewsStatus,
    GetTopHeadlineNewsByCategoryStatus? newGetTopHeadlineNewsByCategoryStatus,
    GetTopHeadlineNewsStatus? newGetTopHeadlineNewsStatus,
    GetTopHeadlineNewsBySourceStatus? newGetTopHeadlineNewsBySourceStatus
  }) {
    return NewsState(
      getAllNewsStatus: newGetAllNewsStatus ?? getAllNewsStatus,
      getTopHeadlineNewsByCategoryStatus: newGetTopHeadlineNewsByCategoryStatus ?? getTopHeadlineNewsByCategoryStatus,
      getTopHeadlineNewsStatus: newGetTopHeadlineNewsStatus ?? getTopHeadlineNewsStatus,
      getTopHeadlineNewsBySourceStatus: newGetTopHeadlineNewsBySourceStatus ?? getTopHeadlineNewsBySourceStatus
        );
  }
}
