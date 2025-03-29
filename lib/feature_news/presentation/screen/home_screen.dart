import 'dart:io';


import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:news/core/models/article.dart';
import 'package:news/core/models/news_meta.dart';
import 'package:news/core/models/source.dart';
import 'package:news/core/params/news_param.dart';
import 'package:news/core/utils/meta_type.dart';
import 'package:news/core/widgets/custom_text_field.dart';
import 'package:news/core/widgets/middle_news_item.dart';
import 'package:news/core/widgets/news_item.dart';
import 'package:news/core/widgets/top_news_item.dart';
import 'package:news/feature_news/data/data_source/local/local_data_provider_news.dart';
import 'package:news/feature_news/data/data_source/remote/api_provider_news.dart';
import 'package:news/feature_news/data/repositories/local_storage_repositoryimpl.dart';
import 'package:news/feature_news/data/repositories/news_repositoryimpl.dart';
import 'package:news/feature_news/domain/usecases/get_cache_articles_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_sources_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_by_category_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_by_source_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_usecase.dart';
import 'package:news/feature_news/domain/usecases/is_article_saved_usecase.dart';
import 'package:news/feature_news/domain/usecases/save_article_usecase.dart';
import 'package:news/feature_news/presentation/bloc/get_all_news_status.dart';
import 'package:news/feature_news/presentation/bloc/get_cache_newsmetas_status.dart';
import 'package:news/feature_news/presentation/bloc/get_cached_articles_status.dart';
import 'package:news/feature_news/presentation/bloc/get_sources_status.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news_by_category_status.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news_by_source_status.dart';
import 'package:news/feature_news/presentation/bloc/news_bloc.dart';
import 'package:news/feature_news/presentation/bloc/save_newsmeta_status.dart';
import 'package:news/feature_news/presentation/screen/news_details_screen.dart';
import 'package:news/feature_news/presentation/screen/search_screen.dart';
import 'package:news/locator.dart';

import '../../domain/usecases/get_news_usecase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //late NewsBloc _newsBloc;

  late TextEditingController _searchController;
  late TextEditingController _searchSourceController;

  int selectedIndex = -1;

  Map<String, String> categoryAndSourceIds = {};
  List<NewsMeta> newsMetas = [];

  List<Article> cacheArticles = [];

  late bool _isGetRemoteArticles;

  List<Source> filteredSources = [];
  List<Source> sources = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchSourceController = TextEditingController();

    _isGetRemoteArticles = true;

    BlocProvider.of<NewsBloc>(context).add(GetCacheNewsMetasEvent());

    //_searchSourceController.addListener(_filterSources);
  }

  @override
  void dispose() {
    super.dispose();
    //_searchSourceController.removeListener(_filterSources);
    _searchSourceController.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state.getTopHeadlineNewsByCategoryStatus is GetTopHeadlineNewsByCategoryError) {
            GetTopHeadlineNewsByCategoryError data = state.getTopHeadlineNewsByCategoryStatus as GetTopHeadlineNewsByCategoryError;
            print('errorrrrrrrrrrrrrrrrrr');
            if (data.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data.error!)));
            }
          }
          if (state.getCacheArticlesStatus is GetCachedArticlesSuccess) {
            var data = state.getCacheArticlesStatus as GetCachedArticlesSuccess;
            cacheArticles.clear();
            cacheArticles.addAll(data.articles);
            if (_isGetRemoteArticles) {
              NewsParam param = NewsParam();
              param.language = 'en';
              param.category = newsMetas[0].id;
              //param.pageSize = 10;
              //param.page = 5;
              //_newsBloc.add(GetTopHeadLineNewsEvent(param));
              BlocProvider.of<NewsBloc>(context)
                  .add(GetTopHeadLineNewsByCategoryEvent(param));
            }
          }
          if (state.getCacheNewsMetasStatus is GetCacheNewsMetasSuccess) {
            var data = state.getCacheNewsMetasStatus as GetCacheNewsMetasSuccess;
            newsMetas.clear();
            newsMetas.addAll(data.newsMetas);
            newsMetas[0].isSelected = true;

            BlocProvider.of<NewsBloc>(context).add(GetCacheArticlesEvent());
          }
          if (state.getSourcesStatus is GetSourcesLoading) {
            EasyLoading.show(status: "Please Wait...");
          }
          if (state.getSourcesStatus is GetSourcesSuccess) {
            EasyLoading.dismiss();
            var data = state.getSourcesStatus as GetSourcesSuccess;
            sources.clear();
            sources.addAll(data.sourceEntity.sources);
            filteredSources.clear();
            filteredSources = List.from(sources);
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState){
                    return Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Container(
                        width: double.infinity,
                        height: 0.7 * MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hintText: 'search your sources...',
                              controller: _searchSourceController,
                              textInputType: TextInputType.text,
                              onChangedValue: (query){
                                setState((){
                                  filteredSources = sources
                                      .where((source) => source.name!
                                      .toLowerCase()
                                      .contains(query.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: filteredSources.length,
                                  itemBuilder: (context, index) {
                                    Source source = filteredSources[index];
                                    return Padding(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        height: 0.1 * 0.7 * MediaQuery.of(context).size.height,
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop(
                                                      NewsMeta(
                                                          name: source.name!,
                                                          id: source.id!,
                                                          metaType:
                                                          MetaType.SOURCE,
                                                          isSelected: false));
                                                },
                                                child: Container(
                                                    width: double.infinity,
                                                    child: Text(
                                                      source.name ?? "",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    )),
                                              ),
                                              Divider(
                                                thickness: 0.2,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    );
                  });
                }).then((newsMeta) {
              if (!newsMetas.contains(newsMeta)) {
                setState(() {
                  newsMetas.add(newsMeta);
                  BlocProvider.of<NewsBloc>(context)
                      .add(SaveNewsMetaEvent(newsMeta));
                });
              }
            });
          }
          if (state.getSourcesStatus is GetSourcesError) {
            EasyLoading.dismiss();
            var data = state.getSourcesStatus as GetSourcesError;
            if (data.error != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(data.error!)));
            }
          }
        },
        builder: (context, state) {
          if (state.getTopHeadlineNewsByCategoryStatus
              is GetTopHeadlineNewsByCategoryLoading) {
            return NewsUi(null, true);
          }
          if (state.getTopHeadlineNewsByCategoryStatus
              is GetTopHeadlineNewsByCategorySuccess) {
            var data = state.getTopHeadlineNewsByCategoryStatus
                as GetTopHeadlineNewsByCategorySuccess;
            return NewsUi(data.newsEntity.articles, false);
          }
          if (state.getTopHeadlineNewsBySourceStatus
              is GetTopHeadlineNewsBySourceLoading) {
            return NewsUi(null, true);
          }
          if (state.getCacheArticlesStatus is GetCachedArticlesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.getTopHeadlineNewsBySourceStatus
              is GetTopHeadlineNewsBySourceSuccess) {
            var data = state.getTopHeadlineNewsBySourceStatus
                as GetTopHeadlineNewsBySourceSuccess;
            return NewsUi(data.newsEntity.articles, false);
          }
          return NewsUi(null, false);
        },
      )),
    );
  }

  void _filterSources() {
    String query = _searchSourceController.text.toLowerCase();
    setState(() {
      filteredSources = sources.where((source) => source.name!.toLowerCase().contains(query)).toList();
    });
  }

  Widget NewsUi(List<Article>? remoteArticles, bool isRemoteLoading) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
                expandedHeight: 0.4 * MediaQuery.of(context).size.height,
                floating: true,
                pinned: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(children: [
                    SizedBox(height: 20.h),
                    CustomTextField(
                      hintText: 'search your latest news...',
                      controller: _searchController,
                      textInputType: TextInputType.none,
                      onClicked: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => SearchScreen()))
                            .then((_) {
                          _isGetRemoteArticles = false;
                          BlocProvider.of<NewsBloc>(context).add(GetCacheArticlesEvent());
                        });
                      },
                    ),
                    Container(
                      height: 0.6 * 0.4 * MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.only(top: 8),
                      child: cacheArticles.isEmpty
                          ? Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 16.w),
                            child: ClipRRect(borderRadius: BorderRadius.circular(24.r),child:Image.asset('assets/images/img_news.jpg', width: double.infinity, fit: BoxFit.cover,),),
                          )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cacheArticles.length,
                              itemBuilder: (context, index) {
                                final article = cacheArticles[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  child: Container(
                                    height: 0.25 *
                                        MediaQuery.of(context).size.height,
                                    width:
                                        0.5 * MediaQuery.of(context).size.width,
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsDetailsScreen(
                                                      article: article,
                                                    )))
                                            .then((_) {
                                          _isGetRemoteArticles = false;
                                          BlocProvider.of<NewsBloc>(context).add(GetCacheArticlesEvent());

                                        });
                                      },
                                      child: TopNewsItem(
                                        imageUrl: article.urlToImage!,
                                        title: article.title!,
                                        source: article.source?.name,
                                        publishedAt: article.publishedAt!,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ]),
                )),
          )
        ];
      },
      body: Column(
        children: [
          Container(
              height: 35.h,
              margin: EdgeInsets.only(top: 16.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newsMetas.length + 1,
                itemBuilder: (context, index) {
                  if (index == newsMetas.length) {
                    return GestureDetector(
                      onTap: () {
                        NewsParam param = NewsParam();
                        param.language = 'en';
                        BlocProvider.of<NewsBloc>(context).add(GetSourcesEvent(param));
                        },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Row(
                          children: [
                            Text(
                              'Add source',
                              style: TextStyle(color: Colors.white),
                            ),
                            Center(
                                child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ))
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (!newsMetas[index].isSelected) {
                          setState(() {
                            for (int i = 0; i < newsMetas.length; i++) {
                              newsMetas[i].isSelected = false;
                            }
                            newsMetas[index].isSelected = true;
                            NewsParam param = NewsParam();
                            param.language = 'en';
                            if (newsMetas[index].metaType == MetaType.SOURCE) {
                              param.source = newsMetas[index].id;
                              BlocProvider.of<NewsBloc>(context).add(GetTopHeadLineNewsBySourceEvent(param));
                            } else {
                              param.category = newsMetas[index].id;
                              BlocProvider.of<NewsBloc>(context).add(GetTopHeadLineNewsByCategoryEvent(param));
                            }
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 8.h),
                        decoration: BoxDecoration(
                            color: newsMetas[index].isSelected
                                ? Color(0xFF03009B)
                                : Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(50.r)),
                        child: Center(
                            child: Text(
                          newsMetas[index].name,
                          style: TextStyle(
                              color: newsMetas[index].isSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  );
                },
              )),
          SizedBox(
            height: 24.h,
          ),
          Expanded(
              child: ConnectivityWidgetWrapper(child: isRemoteLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              ) : remoteArticles != null ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: remoteArticles?.length,
                  itemBuilder: (context, index) {
                    Article article = remoteArticles![index];
                    if (index != 0 && index % 3 == 0) {
                      return GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                              builder: (context) => NewsDetailsScreen(
                                article: article,
                              )))
                              .then((_) {
                            _isGetRemoteArticles = false;
                            BlocProvider.of<NewsBloc>(context).add(GetCacheArticlesEvent());
                          });
                        },
                        child: MiddleNewsItem(
                            imageUrl: article.urlToImage,
                            title: article.title!,
                            author: article.author,
                            publishedAt: article.publishedAt!),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                            builder: (context) => NewsDetailsScreen(
                              article: article,
                            )))
                            .then((_) {
                          _isGetRemoteArticles = false;
                          BlocProvider.of<NewsBloc>(context).add(GetCacheArticlesEvent());
                        });
                      },
                      child: NewsItem(
                          imageUrl: article.urlToImage,
                          title: article.title!,
                          author: article.author,
                          publishedAt: article.publishedAt!),
                    );
                  }):SizedBox()))
        ],
      ),
    );
  }
}
