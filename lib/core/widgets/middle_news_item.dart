import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MiddleNewsItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? author;
  final String publishedAt;

  MiddleNewsItem(
      {required this.imageUrl,
      required this.title,
      required this.author,
      required this.publishedAt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        height: 300.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          color: const Color(0xFF05019E)
        ),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Text(getTime(), style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 12.sp),),
                    SizedBox(width: 2.w,),
                    Icon(Icons.access_time, size: 14.h, color: Color(0xFFA8A8A8),)
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14.h,color: Color(0xFFA8A8A8)),
                    SizedBox(width: 2.w,),
                    Text(getDate(), style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 12.sp),),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h,),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis,), maxLines: 1,),
            Text(author ?? "", style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 12.sp, overflow: TextOverflow.ellipsis,), maxLines: 1,),
            SizedBox(height: 8.h,),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: imageUrl != null ?Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  
                ) : Image.asset('assets/images/img_news.jpg',fit: BoxFit.cover,
                    width: 150.w,),
              ),
            ),
          ],
        )
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

  String getTime() {
    DateTime dateTime = DateTime.parse(publishedAt).toUtc();

    String hour = dateTime.hour.toString().padLeft(2, '0'); // 10
    String minute = dateTime.minute.toString().padLeft(2, '0'); // 25

    return "$hour:$minute";
  }
}
