import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class Utils{
  static String formatNumber(num number) {
    if (number >= 1000000) {
      return '${_removeTrailingZeros((number / 1000000).toStringAsFixed(1))}M'; //
    } else if (number >= 1000) {
      return '${_removeTrailingZeros((number / 1000).toStringAsFixed(1))}K'; //
    } else {
      return number.toString(); //
    }
  }
  static String _removeTrailingZeros(String numberStr) {
    if (numberStr.contains('.')) {
      numberStr = numberStr.replaceAll(RegExp(r"0+$"), ''); //
      numberStr = numberStr.replaceAll(RegExp(r"\.$"), ''); //
    }
    return numberStr;
  }

  static String timePassedSince(String inputDate) {
    // Define the format of the input date
    print('inputDate : ${inputDate}');
    if(inputDate == ''){
      return 'UnKnown';
    }
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");

    // Parse the input date string to a DateTime object
    DateTime pastDate = format.parse(inputDate);
    DateTime today = DateTime.now();

    // Calculate the difference in days
    Duration diff = today.difference(pastDate);

    int yearsPassed = today.year - pastDate.year;
    int monthsPassed = (today.year * 12 + today.month) - (pastDate.year * 12 + pastDate.month); // Total months difference
    int weeksPassed = (diff.inDays / 7).floor();  // Convert days to weeks
    int daysPassed = diff.inDays;  // Total days passed

    // Construct the output based on the largest time unit
    if (yearsPassed >= 1) {
      return "$yearsPassed ${yearsPassed == 1 ? 'year' : 'years'} ago";
    } else if (monthsPassed >= 1) {
      return "$monthsPassed ${monthsPassed == 1 ? 'month' : 'months'} ago";
    } else if (weeksPassed >= 1) {
      return "$weeksPassed ${weeksPassed == 1 ? 'week' : 'weeks'} ago";
    } else if (daysPassed >= 1) {
      return "$daysPassed ${daysPassed == 1 ? 'day' : 'days'} ago";
    } else {
      return "Today";
    }
  }
}