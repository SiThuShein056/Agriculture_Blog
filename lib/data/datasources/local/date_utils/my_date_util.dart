import 'package:flutter/material.dart';

class MyDateUtil {
  static String getPostedTime(
      {required BuildContext context, required String time}) {
    final DateTime postedTime =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == postedTime.day &&
        now.month == postedTime.month &&
        now.year == postedTime.year) {
      return TimeOfDay.fromDateTime(postedTime).format(context);
    }

    return "${postedTime.day} ${_getMonth(postedTime)} , ${postedTime.year}";
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";

      default:
        return "NA";
    }
  }
}
