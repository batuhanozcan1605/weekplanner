import 'package:intl/intl.dart';

class Utils {

  static String toDate(DateTime dateTime) {
    final date = DateFormat.MMMEd().format(dateTime);

    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return '$time';
  }

  static DateTime roundOffMinute(DateTime dateTime) {
    int roundedMinute = dateTime.minute < 30 ? 30 : 0;
    final newDateTime = dateTime.subtract(Duration(minutes: dateTime.minute % 30)).add(Duration(minutes: roundedMinute));
    return DateTime(
      newDateTime.year,
      newDateTime.month,
      newDateTime.day,
      newDateTime.hour,
      roundedMinute,
    );
  }

}