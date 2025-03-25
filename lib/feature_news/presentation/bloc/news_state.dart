part of 'news_bloc.dart';

class NewsState {
  final GetAllNewsStatus getAllNewsStatus;
  final GetTopHeadlineNewsByCategoryStatus getTopHeadlineNewsByCategoryStatus;
  final GetTopHeadlineNewsStatus getTopHeadlineNewsStatus;
  final GetTopHeadlineNewsBySourceStatus getTopHeadlineNewsBySourceStatus;
  final SaveArticleStatus saveArticleStatus;
  final IsArticleSavedStatus isArticleSavedStatus;


  NewsState({
    required this.getAllNewsStatus,
    required this.getTopHeadlineNewsByCategoryStatus,
    required this.getTopHeadlineNewsStatus,
    required this.getTopHeadlineNewsBySourceStatus,
    required this.saveArticleStatus,
    required this.isArticleSavedStatus
  });

  NewsState copyWith({
    GetAllNewsStatus? newGetAllNewsStatus,
    GetTopHeadlineNewsByCategoryStatus? newGetTopHeadlineNewsByCategoryStatus,
    GetTopHeadlineNewsStatus? newGetTopHeadlineNewsStatus,
    GetTopHeadlineNewsBySourceStatus? newGetTopHeadlineNewsBySourceStatus,
    SaveArticleStatus? newSaveArticleStatus,
    IsArticleSavedStatus? newIsArticleSavedStatus
  }) {
    return NewsState(
      getAllNewsStatus: newGetAllNewsStatus ?? getAllNewsStatus,
      getTopHeadlineNewsByCategoryStatus: newGetTopHeadlineNewsByCategoryStatus ?? getTopHeadlineNewsByCategoryStatus,
      getTopHeadlineNewsStatus: newGetTopHeadlineNewsStatus ?? getTopHeadlineNewsStatus,
      getTopHeadlineNewsBySourceStatus: newGetTopHeadlineNewsBySourceStatus ?? getTopHeadlineNewsBySourceStatus,
      saveArticleStatus: newSaveArticleStatus ?? saveArticleStatus,
      isArticleSavedStatus: newIsArticleSavedStatus ?? isArticleSavedStatus
    );
  }
}
