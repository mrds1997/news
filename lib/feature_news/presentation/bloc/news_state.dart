part of 'news_bloc.dart';

class NewsState {
  final GetAllNewsStatus getAllNewsStatus;
  final GetTopHeadlineNewsByCategoryStatus getTopHeadlineNewsByCategoryStatus;
  final GetTopHeadlineNewsStatus getTopHeadlineNewsStatus;
  final GetTopHeadlineNewsBySourceStatus getTopHeadlineNewsBySourceStatus;
  final SaveArticleStatus saveArticleStatus;
  final IsArticleSavedStatus isArticleSavedStatus;
  final GetCachedArticlesStatus getCacheArticlesStatus;
  final GetSourcesStatus getSourcesStatus;
  final SaveNewsMetaStatus saveNewsMetaStatus;
  final GetCacheNewsMetasStatus getCacheNewsMetasStatus;


  NewsState({
    required this.getAllNewsStatus,
    required this.getTopHeadlineNewsByCategoryStatus,
    required this.getTopHeadlineNewsStatus,
    required this.getTopHeadlineNewsBySourceStatus,
    required this.saveArticleStatus,
    required this.isArticleSavedStatus,
    required this.getCacheArticlesStatus,
    required this.getSourcesStatus,
    required this.saveNewsMetaStatus,
    required this.getCacheNewsMetasStatus,

  });

  NewsState copyWith({
    GetAllNewsStatus? newGetAllNewsStatus,
    GetTopHeadlineNewsByCategoryStatus? newGetTopHeadlineNewsByCategoryStatus,
    GetTopHeadlineNewsStatus? newGetTopHeadlineNewsStatus,
    GetTopHeadlineNewsBySourceStatus? newGetTopHeadlineNewsBySourceStatus,
    SaveArticleStatus? newSaveArticleStatus,
    IsArticleSavedStatus? newIsArticleSavedStatus,
    GetCachedArticlesStatus? newGetCashedArticlesStatus,
    GetSourcesStatus? newGetSourcesStatus,
    SaveNewsMetaStatus? newSaveNewsMetaStatus,
    GetCacheNewsMetasStatus? newGetCacheNewsMetasStatus,
  }) {
    return NewsState(
      getAllNewsStatus: newGetAllNewsStatus ?? getAllNewsStatus,
      getTopHeadlineNewsByCategoryStatus: newGetTopHeadlineNewsByCategoryStatus ?? getTopHeadlineNewsByCategoryStatus,
      getTopHeadlineNewsStatus: newGetTopHeadlineNewsStatus ?? getTopHeadlineNewsStatus,
      getTopHeadlineNewsBySourceStatus: newGetTopHeadlineNewsBySourceStatus ?? getTopHeadlineNewsBySourceStatus,
      saveArticleStatus: newSaveArticleStatus ?? saveArticleStatus,
      isArticleSavedStatus: newIsArticleSavedStatus ?? isArticleSavedStatus,
      getCacheArticlesStatus: newGetCashedArticlesStatus ?? getCacheArticlesStatus,
      getSourcesStatus: newGetSourcesStatus ?? getSourcesStatus,
      saveNewsMetaStatus: newSaveNewsMetaStatus ?? saveNewsMetaStatus,
      getCacheNewsMetasStatus: newGetCacheNewsMetasStatus ?? getCacheNewsMetasStatus
    );
  }
}
