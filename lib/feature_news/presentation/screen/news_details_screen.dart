import 'dart:developer';
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

import '../../../locator.dart';
import '../../data/data_source/local/local_data_provider_news.dart';
import '../../data/repositories/local_storage_repositoryimpl.dart';
import '../../domain/usecases/get_news_usecase.dart';
import '../../domain/usecases/get_sources_usecase.dart';
import '../../domain/usecases/is_article_saved_usecase.dart';
import '../../domain/usecases/save_article_usecase.dart';

class NewsDetailsScreen extends StatefulWidget {
  final Article article;

  const NewsDetailsScreen({super.key, required this.article});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  late NewsBloc _newsBloc;
  bool _isExpanded = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _newsBloc = locator<NewsBloc>();

    //_newsBloc.add(GetTopHeadLineNewsByCategoryEvent(param));
    _newsBloc.add(IsArticleSavedEvent(widget.article.articleId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: BlocProvider(
        create: (_) => _newsBloc,
        child: BlocConsumer<NewsBloc, NewsState>(
          listener: (context, state) {
            if (state.saveArticleStatus is SaveArticleError) {
              SaveArticleError data =
                  state.saveArticleStatus as SaveArticleError;
              if (data.error != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(data.error!)));
              }
            }
          },
          builder: (context, state) {
            if (state.saveArticleStatus is SaveArticleSuccess) {
              _isSaved = !_isSaved;
              return NewsDetailsUi();
            }
            if (state.isArticleSavedStatus is IsArticleSavedSuccess) {
              var data = state.isArticleSavedStatus as IsArticleSavedSuccess;
              _isSaved = data.isSaved;
              return NewsDetailsUi();
            }
            return const SizedBox();
          },
        ),
      )),
    );
  }

  Widget NewsDetailsUi() {
    return Stack(
      children: [
        const SizedBox(
          height: double.infinity,
        ),
        widget.article.urlToImage != null
            ? Image.network(
                widget.article.urlToImage!,
                fit: BoxFit.fill,
                width: double.infinity,
                height: 0.52 * MediaQuery.of(context).size.height,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/img_news.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 0.52 * MediaQuery.of(context).size.height,
                  );
                },
              )
            : Image.asset('assets/images/img_news.jpg',
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 0.5 * MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.r),
                    topRight: Radius.circular(50.r)),
                color: Colors.white
                /*gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white
                ]
              )*/
                ),
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          getTime(),
                          style: TextStyle(
                              color: Color(0xFFA8A8A8), fontSize: 12.sp),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Icon(
                          Icons.access_time,
                          size: 14.h,
                          color: Color(0xFFA8A8A8),
                        )
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 14.h, color: Color(0xFFA8A8A8)),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          getDate(),
                          style: TextStyle(
                              color: Color(0xFFA8A8A8), fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  widget.article.title!,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(widget.article.description!,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16.sp)),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  widget.article.content ?? "",
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    _launchURL();
                  },
                  child: Text('See More'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF07039C),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      minimumSize: Size(double.infinity, 50.h)),
                )
                /* AnimatedCrossFade(
                      firstChild: Text(
                        secondPart,
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.withOpacity(
                                0.8)), // قسمت دوم با رنگ خاکستری و شفاف نمایش داده می‌شود
                      ),
                      secondChild: SizedBox.shrink(),
                      crossFadeState: _isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,

                      duration: Duration(milliseconds: 300))*/
              ],
            ),
          ),
        ),
        Positioned(
            top: 16.h,
            right: 16.w,
            child: GestureDetector(
              onTap: () {
                _newsBloc.add(SaveArticleEvent(widget.article));
              },
              child: Container(
                height: 42.h,
                width: 42.w,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Color(0xFF08022B)),
                child: _isSaved
                    ? SvgPicture.asset(
                        'assets/images/ic_remove_fav.svg',
                        color: Colors.white,
                      )
                    : SvgPicture.asset(
                        'assets/images/ic_add_fav.svg',
                        color: Colors.white,
                      ),
              ),
            )),
        Positioned(
            top: 16.h,
            right: 16.w,
            child: GestureDetector(
              onTap: () {
                _newsBloc.add(SaveArticleEvent(widget.article));
              },
              child: Container(
                height: 42.h,
                width: 42.w,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Color(0xFF08022B)),
                child: _isSaved
                    ? SvgPicture.asset(
                        'assets/images/ic_remove_fav.svg',
                        color: Colors.white,
                      )
                    : SvgPicture.asset(
                        'assets/images/ic_add_fav.svg',
                        color: Colors.white,
                      ),
              ),
            )),
        Positioned(
            top: 16.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 42.h,
                width: 42.w,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Color(0xFF08022B)),
                child: SvgPicture.asset(
                  'assets/images/ic_arrow_left.svg',
                  color: Colors.white,
                ),
              ),
            ))
      ],
    );
  }

  String getDate() {
    DateTime dateTime = DateTime.parse(widget.article.publishedAt!);
    int day = dateTime.day;
    int year = dateTime.year;
    String monthName = DateFormat('MMMM').format(dateTime);

    return "$day $monthName $year";
  }

  String getTime() {
    DateTime dateTime = DateTime.parse(widget.article.publishedAt!).toUtc();

    String hour = dateTime.hour.toString().padLeft(2, '0'); // 10
    String minute = dateTime.minute.toString().padLeft(2, '0'); // 25

    return "$hour:$minute";
  }

  /*_launchURL() async {
    //debugger();
    print('url ${widget.article.url!}');
    final Uri url = Uri.parse(widget.article.url!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }*/
  _launchURL() async {
    Uri uri = Uri.parse(widget.article.url!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // can't launch url
    }
  }
}
