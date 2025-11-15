import 'dart:async';
import 'dart:developer';
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
import 'package:news/core/params/news_param.dart';
import 'package:news/core/utils/meta_type.dart';
import 'package:news/core/widgets/custom_text_field.dart';
import 'package:news/core/widgets/middle_news_item.dart';
import 'package:news/core/widgets/news_item.dart';
import 'package:news/core/widgets/top_news_item.dart';
import 'package:news/feature_news/data/data_source/remote/api_provider_news.dart';
import 'package:news/feature_news/data/repositories/news_repositoryimpl.dart';
import 'package:news/feature_news/domain/usecases/get_cache_articles_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_by_category_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_by_source_usecase.dart';
import 'package:news/feature_news/domain/usecases/get_top_headline_news_usecase.dart';
import 'package:news/feature_news/presentation/bloc/get_all_news_status.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news_by_category_status.dart';
import 'package:news/feature_news/presentation/bloc/get_top_headline_news_by_source_status.dart';
import 'package:news/feature_news/presentation/bloc/is_article_saved_status.dart';
import 'package:news/feature_news/presentation/bloc/news_bloc.dart';
import 'package:news/feature_news/presentation/bloc/save_article_status.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../locator.dart';
import '../../../data/data_source/local/local_data_provider_news.dart';
import '../../../data/repositories/local_storage_repositoryimpl.dart';
import '../../../domain/usecases/get_news_usecase.dart';
import '../../../domain/usecases/get_sources_usecase.dart';
import '../../../domain/usecases/is_article_saved_usecase.dart';
import '../../../domain/usecases/save_article_usecase.dart';
import '../details/news_details_screen.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  //late NewsBloc _newsBloc;

  late TextEditingController _controller;

  List<String> topics = [];

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    //_newsBloc = locator<NewsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white38,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Your Interest'),
        ),
        body: ConnectivityScreenWrapper(
          child: SafeArea(
              child: BlocConsumer<NewsBloc, NewsState>(
            listener: (context, state) {
              /*if (state.getAllNewsStatus is GetAllNewsError) {
              GetAllNewsError data = state.getAllNewsStatus as GetAllNewsError;
              if (data.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(data.error!)));
              }
            }*/
            },
            builder: (context, state) {
              /*if (state.getAllNewsStatus is GetAllNewsLoading) {
                return const Center(child: CircularProgressIndicator(),);
              }*/
              /*if(state.getAllNewsStatus is GetAllNewsSuccess){
              var data = state.getAllNewsStatus as GetAllNewsSuccess;
              return SearchUi(data.newsEntity.articles);
            }*/
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: 'Enter your interest topics',
                            controller: _controller,
                            textInputType: TextInputType.text,
                            autoFocus: true,
                            onChangedValue: (content) {
                              if (content.isNotEmpty) {}
                            },
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            if(_controller.text.isNotEmpty && _controller.text.length > 3){
                              setState(() {
                                topics.add(_controller.text);
                                _controller.text = "";
                              });
                            }
                          },
                          child: Expanded(
                            child: Container(
                              height: double.infinity,
                              padding: EdgeInsets.all(4),
                              width: 50.w,
                              margin: EdgeInsets.only(right: 16.w, top: 20.h, bottom: 20.h),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.black)
                                                
                              ),
                              child: SvgPicture.asset('assets/images/ic_add.svg',),
                            ),
                          ),
                        )
                    
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: List.generate(
                        topics.length,
                        (index) => Chip(
                          label: Text(
                            topics[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFF464D60),
                          deleteIcon: const Icon(Icons.close,
                              color: Colors.white, size: 18),
                          onDeleted: () {
                            setState(() {
                              topics.removeAt(index);
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          )),
        ));
  }

  /*Widget SearchUi(List<Article> articles) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 16.w,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  'assets/images/ic_arrow_left.svg',
                  width: 24.w,
                  height: 24.h,
                )),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: CustomTextField(
                hintText: 'search your latest news...',
                controller: _searchController,
                textInputType: TextInputType.text,
                onChangedValue: (content) {
                  if (content.isNotEmpty) {
                    NewsParam param = NewsParam();
                    param.language = 'en';
                    param.query = content;
                    debounce(
                        const Duration(milliseconds: 200),
                        BlocProvider.of<NewsBloc>(context).add,
                        [GetAllNewsEvent(param)]);
                  }
                },
              ),
            ),
          ],
        ),
        Expanded(
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  Article article = articles[index];
                  return GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (context) => NewsDetailsScreen(
                                    article: article,
                                  )));
                    },
                    child: NewsItem(
                        imageUrl: article.urlToImage,
                        title: article.title!,
                        author: article.author,
                        publishedAt: article.publishedAt!),
                  );
                }))
      ],
    );
  }*/

  Map<Function, Timer> _timeouts = {};

  void debounce(Duration timeout, Function target,
      [List arguments = const []]) {
    if (_timeouts.containsKey(target)) {
      _timeouts[target]?.cancel();
    }

    Timer timer = Timer(timeout, () {
      Function.apply(target, arguments);
    });

    _timeouts[target] = timer;
  }
}
