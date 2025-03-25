import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class TopNewsItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? source;
  final String publishedAt;

  TopNewsItem(
      {required this.imageUrl,
      required this.title,
      required this.source,
      required this.publishedAt});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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

/*
                Row(
                  children: [
                    Text(getDate(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                )
*/
              ],
            ),
          ),
          Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    height: 32.h,
                    width: 32.w,
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Color(0xFF08022B)
                    ),
                    child: SvgPicture.asset('assets/images/ic_saved.svg', color: Colors.white),
                  ),)
        ],
      ),
    );
  }

  String getDate() {
    DateTime dateTime = DateTime.parse(publishedAt);
    int day = dateTime.day;
    int year = dateTime.year;
    String monthName = DateFormat('MMMM').format(dateTime);

    return "$day $monthName $year";
  }
}
