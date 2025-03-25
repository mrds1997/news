import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:news/feature_news/domain/usecases/get_top_headline_news_by_category_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_by_source_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_usecase.dart';
import 'package:news/feature_news/domain/usecases/is_article_saved_usecase.dart';
import 'package:news/feature_news/domain/usecases/save_article_usecase.dart';
import 'package:news/feature_news/presentation/bloc/get_all_news_status.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news_by_category_status.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news_by_source_status.dart';
import 'package:news/feature_news/presentation/bloc/news_bloc.dart';
import 'package:news/feature_news/presentation/screen/news_details_screen.dart';

import '../../domain/usecases/get_news_usecase.dart';

class HomeScreen extends StatefulWidget {


  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late NewsBloc _newsBloc;

  late TextEditingController _searchController;

  int selectedIndex = -1;

  Map<String, String> categoryAndSourceIds = {};
  List<NewsMeta> newsMetas = [];
  late List<bool> selectedItem;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _newsBloc = NewsBloc(GetNewsUseCase(NewsRepositoryImpl(ApiProviderNews())),
        GetTopHeadlineNewsByCategoryUseCase(
            NewsRepositoryImpl(ApiProviderNews())),
        GetTopHeadlineNewsUseCase(NewsRepositoryImpl(ApiProviderNews())),
        GetTopHeadlineNewsBySourceUseCase(NewsRepositoryImpl(ApiProviderNews())),
        SaveArticleUseCase(LocalStorageNewsRepositoryImpl(LocalDataProviderNews())),
        IsArticleSavedUseCase(LocalStorageNewsRepositoryImpl(LocalDataProviderNews())));

    newsMetas.addAll([
      NewsMeta(name: 'Business', id: 'business', metaType: MetaType.CATEGORY),
      NewsMeta(name: 'Entertainment', id: 'entertainment', metaType: MetaType.CATEGORY),
      NewsMeta(name: 'General', id: 'general', metaType: MetaType.CATEGORY),
      NewsMeta(name: 'Health', id: 'health', metaType: MetaType.CATEGORY),
      NewsMeta(name: 'Science', id: 'science', metaType: MetaType.CATEGORY),
      NewsMeta(name: 'Sports', id: 'sports', metaType: MetaType.CATEGORY),
      NewsMeta(name: 'Technology', id: 'technology', metaType: MetaType.CATEGORY),
      NewsMeta(name: 'Al Jazeera English', id: 'al-jazeera-english', metaType: MetaType.SOURCE),
      NewsMeta(name: 'BBC News', id: 'bbc-news', metaType: MetaType.SOURCE),
      NewsMeta(name: 'ABC News', id: 'abc-news', metaType: MetaType.SOURCE),
      NewsMeta(name: 'Associated Press', id: 'associated-press', metaType: MetaType.SOURCE),

    ]);

    selectedItem = List.filled(newsMetas.length, false);
    selectedItem[0] = true;

    NewsParam param = NewsParam();
    param.language = 'en';
    param.category = newsMetas[0].id;
    //param.pageSize = 10;
    //param.page = 5;
    //_newsBloc.add(GetTopHeadLineNewsEvent(param));
    _newsBloc.add(GetTopHeadLineNewsByCategoryEvent(param));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocConsumer<NewsBloc, NewsState>(
          listener: (context, state) {
            /*if (state.getAllNewsStatus is GetAllNewsSuccess) {
              EasyLoading.dismiss();
            }
            if (state.getAllNewsStatus is GetAllNewsLoading) {
                EasyLoading.show(status: "Please Wait!");
            }*/
            if (state.getTopHeadlineNewsByCategoryStatus is GetTopHeadlineNewsByCategoryError) {
              GetTopHeadlineNewsByCategoryError data = state.getTopHeadlineNewsByCategoryStatus as GetTopHeadlineNewsByCategoryError;
              if (data.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(data.error!)));
              }
            }
          },
          builder: (context, state) {
            if (state.getTopHeadlineNewsByCategoryStatus is GetTopHeadlineNewsByCategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.getTopHeadlineNewsByCategoryStatus is GetTopHeadlineNewsByCategorySuccess) {
              var data = state.getTopHeadlineNewsByCategoryStatus as GetTopHeadlineNewsByCategorySuccess;
              return NewsUi(data.newsEntity.articles);
            }
            if (state.getTopHeadlineNewsBySourceStatus is GetTopHeadlineNewsBySourceLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.getTopHeadlineNewsBySourceStatus is GetTopHeadlineNewsBySourceSuccess) {
              var data = state.getTopHeadlineNewsBySourceStatus as GetTopHeadlineNewsBySourceSuccess;
              return NewsUi(data.newsEntity.articles);
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: SizedBox(),
            );
          },
        ),
      )),
    );
  }

  Widget NewsUi(List<Article> articles) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                context),
            sliver: SliverAppBar(
                expandedHeight: 0.4 * MediaQuery.of(context).size.height,
                floating: true,
                pinned: false,
                backgroundColor: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                      children: [
                        SizedBox(height: 20.h),
                        CustomTextField(hintText: 'search your latest news...',
                            controller: _searchController,
                            textInputType: TextInputType.text),
                        Container(
                          height: 0.5 * 0.3 * MediaQuery.of(context).size.height,
                          margin: const EdgeInsets.only(top: 8),
                          child: Image.asset('assets/images/img_news.jpg')/*ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              final article = articles[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, left: 8),
                                child: Container(
                                  height: 0.25 * MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                                  width: 0.5 * MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: TopNewsItem(
                                    imageUrl: article.urlToImage!,
                                    title: article.title!,
                                    source: article.source?.name,
                                    publishedAt: article.publishedAt!,),
                                ),
                              );
                            },
                          )*/,
                        ),
                      ]),)),)
        ];
      }, body: Column(
      children: [
        Container(
          height: 35.h,
          margin: EdgeInsets.only(top: 16.h),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newsMetas.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: GestureDetector(
                  onTap: () {
                    if (!selectedItem[index]) {
                      setState(() {
                        for (int i = 0; i < selectedItem.length; i++) {
                          selectedItem[i] = false;
                        }
                        selectedItem[index] = true;
                        NewsParam param = NewsParam();
                        param.language = 'en';
                        if(newsMetas[index].metaType == MetaType.SOURCE){
                          param.source = newsMetas[index].id;
                          _newsBloc.add(GetTopHeadLineNewsBySourceEvent(param));
                        } else {
                          param.category = newsMetas[index].id;
                          _newsBloc.add(GetTopHeadLineNewsByCategoryEvent(param));
                        }
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 8.h),
                    decoration: BoxDecoration(
                        color: selectedItem[index] ? Color(0xFF03009B) : Color(
                            0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(50.r)
                    ),
                    child: Center(child: Text(newsMetas[index].name,
                      style: TextStyle(color: selectedItem[index]
                          ? Colors.white
                          : Colors.black, fontWeight: FontWeight.bold),)),
                  ),

                ),
              );
            },
          ),
        ),
        SizedBox(height: 24.h,),
        Expanded(child: ListView.builder(physics: BouncingScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              Article article = articles[index];
              if(index != 0 && index % 3 == 0){
              return GestureDetector(
                onTap: (){
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => NewsDetailsScreen(article: article,)
                      ));
                },
                child: MiddleNewsItem(imageUrl: article.urlToImage,
                    title: article.title!,
                    author: article.author,
                    publishedAt: article.publishedAt!),
              );
              }
              return GestureDetector(
                onTap: (){
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => NewsDetailsScreen(article: article,)
                      ));
                },
                child: NewsItem(imageUrl: article.urlToImage,
                    title: article.title!,
                    author: article.author,
                    publishedAt: article.publishedAt!),
              );
            }))
      ],
    ),
    );
  }


}

