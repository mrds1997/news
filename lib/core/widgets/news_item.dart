import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NewsItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? author;
  final String publishedAt;

  NewsItem(
      {required this.imageUrl,
      required this.title,
      required this.author,
      required this.publishedAt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        height: 100.h,
        width: double.infinity,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: imageUrl != null ?Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: 150.w,
                height: double.infinity,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                  return Image.asset('assets/images/img_news.jpg',fit: BoxFit.cover,
                      width: 150.w,
                      height: double.infinity);
                },
              ) : Image.asset('assets/images/img_news.jpg',fit: BoxFit.cover,
                width: 150.w,
                height: double.infinity),
            ),
            SizedBox(width: 8.w,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Color(0xFF6D6D6D), fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 20.h,),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Color(0xFF6D6D6D), size: 14,),
                      SizedBox(width: 4,),
                      Text(
                        getDate(),
                        style: TextStyle(color: Color(0xFF6D6D6D), fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                    ],
                  ),
                  Text(
                    author != null ? "written by $author" : "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12.sp, color: Color(0xFF6D6D6D)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ) /*ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
              top: 8,
              left: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    source ?? "",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 14,),
                      SizedBox(width: 4,),
                      Text(
                        getDate(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white, overflow: TextOverflow.ellipsis),
                    maxLines: 2,
                  ),
                ),

*/ /*
                Row(
                  children: [
                    Text(getDate(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                )
*/ /*
              ],
            ),
          )
        ],
      ),
    )*/
        ;
  }

  String getDate() {
    DateTime dateTime = DateTime.parse(publishedAt);
    int day = dateTime.day;
    int year = dateTime.year;
    String monthName = DateFormat('MMMM').format(dateTime);

    return "$day $monthName $year";
  }
}
